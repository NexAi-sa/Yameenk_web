-- ────────────────────────────────────────────────────────────────────
-- Migration 005: Medical Data Agency + Extended Consent Types
-- وكالة البيانات الطبية + الأساس القانوني لمتابعة المريض والتنبؤ بالأمراض
--
-- الحل القانوني لـ PDPL:
-- بدلاً من تجاوز القانون، نُوثّق الأساس القانوني الصريح لكل عملية معالجة
-- المادة 6 من PDPL تُبيح المعالجة بدون موافقة في حالات الضرورة الطبية
-- المادة 29 تُبيح نقل البيانات بموافقة صريحة مستقلة
-- ────────────────────────────────────────────────────────────────────

-- ══════════════════════════════════════════════════════════════════
-- وكالة البيانات الطبية
-- وثيقة قانونية: المريض (أو وليّه) يُخوّل فرد الأسرة إدارة بياناته الصحية
-- ══════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS medical_data_agencies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- المريض صاحب البيانات
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,

  -- من وقّع الوكالة (قد يكون المريض نفسه أو وليّه القانوني)
  granted_by_user_id UUID NOT NULL REFERENCES users(id),

  -- الوكيل المُخوَّل (فرد الأسرة الذي يتابع)
  agent_user_id UUID NOT NULL REFERENCES users(id),

  -- طبيعة العلاقة
  relationship VARCHAR(50) NOT NULL,           -- 'son' | 'daughter' | 'spouse' | 'sibling' | 'legal_guardian'

  -- الأهلية القانونية للموقّع
  legal_capacity VARCHAR(50) NOT NULL,
  -- 'patient_self'       : المريض يوقّع بنفسه (مدرك، أهل للتصرف)
  -- 'legal_guardian'     : وليّ الأمر (طفل أو محجور)
  -- 'power_of_attorney'  : وكالة رسمية موثقة بالعدل

  -- رقم الوكالة الرسمية إن وجدت (من وزارة العدل)
  legal_document_ref VARCHAR(100),

  -- نطاق الوكالة — ما يُسمح به تحديداً
  agency_scope TEXT[] NOT NULL DEFAULT ARRAY[
    'health_monitoring',      -- متابعة القراءات
    'anomaly_alerts',         -- تلقي تنبيهات الشذوذ
    'ai_analysis',            -- تحليل الذكاء الاصطناعي
    'predictive_health',      -- التنبؤ بالأمراض الصامتة
    'family_dashboard_access' -- لوحة تحكم الأسرة
  ],

  -- الأساس القانوني PDPL المستند إليه لكل نطاق
  -- يُسجَّل لإثبات المشروعية عند أي مراجعة قانونية
  legal_basis JSONB NOT NULL DEFAULT '{
    "health_monitoring":      {"article": "6(2)", "justification": "الضرورة الطبية — حماية حياة المريض"},
    "anomaly_alerts":         {"article": "6(1)", "justification": "المصالح الحيوية للمريض"},
    "ai_analysis":            {"article": "6(2)+consent", "justification": "ضرورة طبية + موافقة صريحة"},
    "predictive_health":      {"article": "6(2)", "justification": "الكشف المبكر يمنع الضرر الصحي"},
    "family_dashboard_access":{"article": "contract", "justification": "تنفيذ عقد الخدمة المتفق عليه"}
  }',

  -- توثيق الحدث
  granted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '1 year'),  -- تجديد سنوي
  ip_address VARCHAR(50),
  device_info TEXT,          -- نوع الجهاز + نظام التشغيل للإثبات
  signature_hash TEXT,       -- HMAC للتحقق من عدم التلاعب بالسجل

  -- حالة الوكالة
  is_active BOOLEAN NOT NULL DEFAULT true,
  revoked_at TIMESTAMPTZ,
  revocation_reason TEXT,
  revoked_by_user_id UUID REFERENCES users(id),

  UNIQUE(patient_id, agent_user_id)
);

-- فهرس للبحث السريع
CREATE INDEX IF NOT EXISTS idx_agency_patient    ON medical_data_agencies(patient_id) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_agency_agent      ON medical_data_agencies(agent_user_id) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_agency_expiry     ON medical_data_agencies(expires_at) WHERE is_active = true;

-- ══════════════════════════════════════════════════════════════════
-- سجل نقل البيانات عبر الحدود (PDPL المادة 29)
-- يُوثّق كل عملية إرسال بيانات لخارج المملكة
-- ══════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS cross_border_transfers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id),
  transferred_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- الجهة المستقبِلة
  recipient_service VARCHAR(100) NOT NULL,   -- 'gemini_api' | 'claude_api'
  recipient_country VARCHAR(50) NOT NULL,    -- 'US'
  recipient_org VARCHAR(100) NOT NULL,       -- 'Google LLC' | 'Anthropic PBC'

  -- ما تم نقله (دائماً مجهول الهوية)
  data_categories TEXT[] NOT NULL,           -- ['health_readings', 'chronic_conditions', 'medications']
  anonymization_applied BOOLEAN NOT NULL DEFAULT true,
  anonymization_method TEXT DEFAULT 'pdpl_anonymizer_v1',

  -- الأساس القانوني
  legal_basis VARCHAR(50) NOT NULL DEFAULT 'explicit_consent',  -- PDPL المادة 29
  user_consent_id UUID,                      -- مرجع لسجل الموافقة

  -- ضمانات المستقبِل
  recipient_adequacy_mechanism VARCHAR(100), -- 'standard_contractual_clauses' | 'binding_corporate_rules'
  data_deleted_after_processing BOOLEAN DEFAULT true
);

-- ══════════════════════════════════════════════════════════════════
-- تحديث user_consents — إضافة أنواع الموافقة الجديدة
-- ══════════════════════════════════════════════════════════════════

-- ملاحظة: الجدول موجود من migration 002
-- نضيف القيود والتوثيق للأنواع الجديدة فقط

COMMENT ON TABLE user_consents IS
'سجل الموافقات الصريحة — يشمل الأنواع التالية:
  health_data_collection      : جمع البيانات الصحية [مطلوب]
  ai_analysis                 : تحليل الذكاء الاصطناعي [مطلوب لخاصية الشات]
  predictive_health_monitoring: التنبؤ بالأمراض الصامتة [مطلوب للتحليل الأسبوعي]
  cross_border_ai_transfer    : نقل بيانات مجهولة لخارج المملكة [مطلوب لـ Gemini/Claude]
  medical_records_retention   : احتفاظ بالسجلات الطبية 10 سنوات [التزام قانوني - وزارة الصحة]
  emergency_family_access     : وصول الأسرة في حالات الطوارئ بدون إشعار مسبق [اختياري]
  whatsapp_notifications      : إشعارات واتساب [اختياري]
  push_notifications          : إشعارات التطبيق [اختياري]
  analytics                   : التحليلات [اختياري]
  marketing                   : التسويق [اختياري]';

-- ══════════════════════════════════════════════════════════════════
-- RLS لجدول الوكالات
-- ══════════════════════════════════════════════════════════════════
ALTER TABLE medical_data_agencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE cross_border_transfers ENABLE ROW LEVEL SECURITY;

-- المريض يرى وكالاته
CREATE POLICY "patient_views_own_agencies" ON medical_data_agencies
  FOR SELECT USING (
    granted_by_user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM patients p WHERE p.id = patient_id AND p.user_id = auth.uid()
    )
  );

-- الوكيل يرى صلاحياته
CREATE POLICY "agent_views_own_grants" ON medical_data_agencies
  FOR SELECT USING (agent_user_id = auth.uid());

-- فقط المريض أو وليّه يُنشئ وكالة
CREATE POLICY "patient_creates_agency" ON medical_data_agencies
  FOR INSERT WITH CHECK (granted_by_user_id = auth.uid());

-- فقط المريض أو وليّه يلغي الوكالة
CREATE POLICY "patient_revokes_agency" ON medical_data_agencies
  FOR UPDATE USING (granted_by_user_id = auth.uid());

-- سجل نقل البيانات — القراءة للمريض فقط
CREATE POLICY "patient_views_transfers" ON cross_border_transfers
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM patients p WHERE p.id = patient_id AND p.user_id = auth.uid()
    )
  );

-- ══════════════════════════════════════════════════════════════════
-- دالة للتحقق التلقائي من انتهاء الوكالات
-- ══════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION deactivate_expired_agencies()
RETURNS void AS $$
  UPDATE medical_data_agencies
  SET
    is_active = false,
    revoked_at = NOW(),
    revocation_reason = 'انتهت مدة الوكالة تلقائياً'
  WHERE
    is_active = true AND
    expires_at < NOW();
$$ LANGUAGE sql SECURITY DEFINER;
