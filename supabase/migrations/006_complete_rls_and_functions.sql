-- ────────────────────────────────────────────────────────────────────
-- Migration 006: Complete RLS Policies + Extended Consent Types + Triggers + RPC
-- تكملة سياسات RLS الناقصة + توسيع أنواع الموافقات + triggers + دوال المصادقة
-- ────────────────────────────────────────────────────────────────────

-- ══════════════════════════════════════════════════════════════════
-- 1. سياسات RLS الناقصة
-- Migration 001 تفعّل RLS على 7 جداول لكن تعرّف سياسة لـ 2 فقط
-- ══════════════════════════════════════════════════════════════════

-- ── family_patients: المستخدم يرى ربطاته فقط ──
CREATE POLICY "family_own_links" ON family_patients
  USING (family_user_id = auth.uid());

-- ── health_readings: الأسرة ترى قراءات مرضاها ──
CREATE POLICY "family_access_readings" ON health_readings
  USING (
    patient_id IN (
      SELECT patient_id FROM family_patients
      WHERE family_user_id = auth.uid()
    )
  );

-- ── chat_messages: الأسرة ترى محادثات مرضاها ──
CREATE POLICY "family_access_chat" ON chat_messages
  USING (
    patient_id IN (
      SELECT patient_id FROM family_patients
      WHERE family_user_id = auth.uid()
    )
  );

-- ── medications: الأسرة ترى أدوية مرضاها ──
CREATE POLICY "family_access_medications" ON medications
  USING (
    patient_id IN (
      SELECT patient_id FROM family_patients
      WHERE family_user_id = auth.uid()
    )
  );

-- ── bookings: المستخدم يرى حجوزاته فقط ──
CREATE POLICY "users_own_bookings" ON bookings
  USING (family_user_id = auth.uid());

-- ══════════════════════════════════════════════════════════════════
-- 2. توسيع CHECK constraint لجدول user_consents
-- Edge Function analyze-reading يستخدم 'predictive_health_monitoring'
-- Migration 005 وثّقت الأنواع الجديدة لكن لم تُحدّث الـ CHECK
-- ══════════════════════════════════════════════════════════════════

-- حذف القيد القديم وإضافة قيد موسّع
ALTER TABLE user_consents DROP CONSTRAINT IF EXISTS user_consents_consent_type_check;

ALTER TABLE user_consents ADD CONSTRAINT user_consents_consent_type_check
  CHECK (
    consent_type IN (
      -- الأنواع الأصلية (Migration 002)
      'health_data_collection',
      'ai_analysis',
      'whatsapp_notifications',
      'push_notifications',
      'analytics',
      'marketing',
      -- الأنواع الجديدة (Migration 005 + Edge Functions)
      'predictive_health_monitoring',    -- التنبؤ بالأمراض الصامتة
      'cross_border_ai_transfer',        -- نقل بيانات لخارج المملكة (PDPL المادة 29)
      'medical_records_retention',       -- احتفاظ بالسجلات 10 سنوات (التزام قانوني)
      'emergency_family_access'          -- وصول الأسرة في حالات الطوارئ
    )
  );

-- ══════════════════════════════════════════════════════════════════
-- 3. Triggers ناقصة — updated_at لجداول users, patients, bookings
-- الدالة update_updated_at() موجودة من Migration 002
-- ══════════════════════════════════════════════════════════════════

CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_patients_updated_at
  BEFORE UPDATE ON patients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_bookings_updated_at
  BEFORE UPDATE ON bookings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ══════════════════════════════════════════════════════════════════
-- 4. RPC Functions — المصادقة عبر OTP
-- يُستدعى عبر PostgREST: POST /rpc/request_otp, POST /rpc/verify_otp
-- ══════════════════════════════════════════════════════════════════

-- ── طلب رمز OTP ──
CREATE OR REPLACE FUNCTION request_otp(p_phone VARCHAR)
RETURNS JSON AS $$
DECLARE
  v_token VARCHAR(6);
BEGIN
  -- توليد رمز عشوائي من 6 أرقام
  v_token := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

  -- إلغاء الرموز السابقة غير المستخدمة
  UPDATE otp_tokens
  SET used = true
  WHERE phone = p_phone AND used = false;

  -- إدخال الرمز الجديد (صلاحية 10 دقائق)
  INSERT INTO otp_tokens (phone, token, expires_at)
  VALUES (p_phone, v_token, NOW() + INTERVAL '10 minutes');

  -- ملاحظة: إرسال SMS يتم عبر webhook أو Edge Function منفصلة
  RETURN json_build_object(
    'success', true,
    'message', 'OTP sent',
    'expires_in', 600
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ── التحقق من رمز OTP ──
CREATE OR REPLACE FUNCTION verify_otp(p_phone VARCHAR, p_code VARCHAR)
RETURNS JSON AS $$
DECLARE
  v_otp RECORD;
  v_user RECORD;
BEGIN
  -- البحث عن الرمز الصالح
  SELECT * INTO v_otp
  FROM otp_tokens
  WHERE phone = p_phone
    AND token = p_code
    AND used = false
    AND expires_at > NOW()
  ORDER BY created_at DESC
  LIMIT 1;

  IF v_otp IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'error', 'invalid_or_expired_otp'
    );
  END IF;

  -- تعليم الرمز كمُستخدَم
  UPDATE otp_tokens SET used = true WHERE id = v_otp.id;

  -- البحث عن المستخدم أو إنشاء جديد
  SELECT * INTO v_user
  FROM users
  WHERE phone = p_phone
  LIMIT 1;

  IF v_user IS NULL THEN
    INSERT INTO users (phone, name, role)
    VALUES (p_phone, '', 'family')
    RETURNING * INTO v_user;
  END IF;

  -- تسجيل في سجل التدقيق
  INSERT INTO audit_logs (user_id, action, resource_type, resource_id)
  VALUES (v_user.id, 'login', 'user', v_user.id);

  RETURN json_build_object(
    'success', true,
    'user', json_build_object(
      'id', v_user.id,
      'phone', v_user.phone,
      'name', v_user.name,
      'role', v_user.role
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ══════════════════════════════════════════════════════════════════
-- 5. RLS للجداول التي لم تُفعّل بعد
-- notification_logs و otp_tokens و providers و reading_schedules
-- ══════════════════════════════════════════════════════════════════

-- providers — مفتوح للقراءة (سوق الخدمات عام)
ALTER TABLE providers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "providers_public_read" ON providers
  FOR SELECT USING (true);

-- reading_schedules — الأسرة ترى جداول مرضاها
ALTER TABLE reading_schedules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "family_access_schedules" ON reading_schedules
  USING (
    patient_id IN (
      SELECT patient_id FROM family_patients
      WHERE family_user_id = auth.uid()
    )
  );

-- notification_logs — المستخدم يرى إشعاراته فقط
ALTER TABLE notification_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "users_own_notifications" ON notification_logs
  USING (user_id = auth.uid());

-- otp_tokens — لا أحد يقرأ عبر PostgREST (فقط RPC functions بـ SECURITY DEFINER)
ALTER TABLE otp_tokens ENABLE ROW LEVEL SECURITY;
-- لا سياسة مطلوبة — الوصول فقط عبر دوال RPC

-- ══════════════════════════════════════════════════════════════════
-- 6. تحديث RoPA — تسجيل أنشطة المعالجة الجديدة
-- ══════════════════════════════════════════════════════════════════

INSERT INTO data_processing_registry (process_name, process_name_ar, purpose, purpose_ar, data_categories, legal_basis, retention_period, recipients)
VALUES
  (
    'predictive_health_monitoring',
    'التنبؤ بالأمراض الصامتة',
    'Analyze health reading trends to predict silent health conditions (e.g., kidney risk from combined hypertension + diabetes). PII is stripped.',
    'تحليل أنماط القراءات الصحية للتنبؤ بالأمراض الصامتة (مثل خطر الكلى عند وجود ضغط + سكري). تُزال المعرفات الشخصية.',
    ARRAY['anonymized_readings', 'chronic_conditions', 'medications'],
    'consent',
    'Analysis results: 1 year. Raw data: session only',
    ARRAY['gemini_api']
  ),
  (
    'cross_border_ai_transfer',
    'نقل البيانات عبر الحدود للذكاء الاصطناعي',
    'Transfer anonymized health data to AI providers (Google Gemini) outside Saudi Arabia for real-time health analysis. Governed by PDPL Article 29.',
    'نقل بيانات صحية مجهولة الهوية لمزودي الذكاء الاصطناعي (Google Gemini) خارج المملكة للتحليل الصحي الفوري. يخضع للمادة 29 من PDPL.',
    ARRAY['anonymized_readings', 'chronic_conditions', 'medications', 'allergies'],
    'consent',
    'Session only — not retained by AI provider',
    ARRAY['google_gemini_api']
  )
ON CONFLICT DO NOTHING;
