-- يمينك — PDPL Compliance Migration
-- نظام حماية البيانات الشخصية (سدايا)
-- Run: supabase db push

-- ============================================
-- 1. USER CONSENTS — إدارة الموافقات
-- ============================================
CREATE TABLE user_consents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  consent_type VARCHAR(50) NOT NULL CHECK (
    consent_type IN (
      'health_data_collection',   -- جمع البيانات الصحية (أساسي)
      'ai_analysis',              -- تحليل الذكاء الاصطناعي
      'whatsapp_notifications',   -- إشعارات واتساب
      'push_notifications',       -- إشعارات التطبيق
      'analytics',                -- التحليلات والتحسين
      'marketing'                 -- التسويق
    )
  ),
  granted BOOLEAN NOT NULL DEFAULT false,
  granted_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ,
  ip_address VARCHAR(45),
  consent_version VARCHAR(10) DEFAULT '1.0',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, consent_type)
);

CREATE INDEX idx_consents_user ON user_consents(user_id);
CREATE INDEX idx_consents_type ON user_consents(consent_type, granted);

-- ============================================
-- 2. AUDIT LOGS — سجل التدقيق
-- ============================================
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action VARCHAR(100) NOT NULL CHECK (
    action IN (
      'login',
      'view_patient',
      'create_patient',
      'update_patient',
      'record_reading',
      'view_readings',
      'ai_chat_message',
      'view_chat_history',
      'create_booking',
      'grant_consent',
      'revoke_consent',
      'export_data',
      'delete_account',
      'view_audit_log'
    )
  ),
  resource_type VARCHAR(50) CHECK (
    resource_type IN ('patient', 'health_reading', 'chat_message', 'booking', 'consent', 'user')
  ),
  resource_id UUID,
  metadata JSONB DEFAULT '{}',
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_audit_user_time ON audit_logs(user_id, created_at DESC);
CREATE INDEX idx_audit_action ON audit_logs(action, created_at DESC);
CREATE INDEX idx_audit_resource ON audit_logs(resource_type, resource_id);

-- ============================================
-- 3. DATA PROCESSING REGISTRY — سجل أنشطة المعالجة (RoPA)
-- ============================================
CREATE TABLE data_processing_registry (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  process_name VARCHAR(100) NOT NULL,
  process_name_ar VARCHAR(100) NOT NULL,
  purpose TEXT NOT NULL,
  purpose_ar TEXT NOT NULL,
  data_categories TEXT[] NOT NULL,
  legal_basis VARCHAR(50) NOT NULL CHECK (
    legal_basis IN ('consent', 'legitimate_interest', 'legal_obligation', 'vital_interest', 'public_interest')
  ),
  retention_period VARCHAR(50) NOT NULL,
  recipients TEXT[] DEFAULT '{}',
  cross_border_transfer BOOLEAN DEFAULT false,
  transfer_safeguards TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 4. DATA DELETION REQUESTS — طلبات حذف البيانات
-- ============================================
CREATE TABLE data_deletion_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  status VARCHAR(20) DEFAULT 'pending' CHECK (
    status IN ('pending', 'processing', 'completed', 'cancelled')
  ),
  requested_at TIMESTAMPTZ DEFAULT NOW(),
  scheduled_purge_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  backup_reference VARCHAR(100)
);

CREATE INDEX idx_deletion_user ON data_deletion_requests(user_id);
CREATE INDEX idx_deletion_status ON data_deletion_requests(status);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================
ALTER TABLE user_consents ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE data_deletion_requests ENABLE ROW LEVEL SECURITY;

-- المستخدم يرى موافقاته فقط
CREATE POLICY "users_manage_own_consents" ON user_consents
  USING (user_id = auth.uid());

-- المستخدم يرى سجل التدقيق الخاص به فقط
CREATE POLICY "users_view_own_audit" ON audit_logs
  USING (user_id = auth.uid());

-- المستخدم يرى طلبات الحذف الخاصة به فقط
CREATE POLICY "users_own_deletion_requests" ON data_deletion_requests
  USING (user_id = auth.uid());

-- ============================================
-- SEED: RoPA — تسجيل أنشطة المعالجة الأساسية
-- ============================================
INSERT INTO data_processing_registry (process_name, process_name_ar, purpose, purpose_ar, data_categories, legal_basis, retention_period, recipients) VALUES
  (
    'health_readings_collection',
    'جمع القراءات الصحية',
    'Collect and store patient vital signs (blood sugar, blood pressure, etc.) for health monitoring and anomaly alerts',
    'جمع وتخزين القراءات الحيوية للمريض (السكر، الضغط، إلخ) لمراقبة الحالة الصحية وتنبيهات الانحراف',
    ARRAY['blood_sugar', 'blood_pressure', 'weight', 'temperature', 'heart_rate', 'oxygen'],
    'consent',
    '3 years or until account deletion',
    ARRAY['family_members', 'treating_physicians']
  ),
  (
    'ai_health_analysis',
    'تحليل الذكاء الاصطناعي الصحي',
    'Send anonymized health data to Claude AI for conversational health guidance. PII is stripped before transmission.',
    'إرسال بيانات صحية مجهولة الهوية إلى Claude AI للإرشاد الصحي التفاعلي. تُزال المعرفات الشخصية قبل الإرسال.',
    ARRAY['anonymized_readings', 'chronic_conditions', 'medications', 'allergies'],
    'consent',
    'Session only — not retained by AI provider',
    ARRAY['anthropic_claude_api']
  ),
  (
    'whatsapp_notifications',
    'إشعارات واتساب',
    'Send health anomaly alerts and weekly reports to family members via WhatsApp Business API',
    'إرسال تنبيهات الانحراف الصحي والتقارير الأسبوعية لأفراد الأسرة عبر واتساب',
    ARRAY['patient_first_name', 'reading_type', 'reading_value', 'alert_level'],
    'consent',
    '90 days',
    ARRAY['meta_whatsapp_business_api', 'family_members']
  ),
  (
    'user_authentication',
    'المصادقة وتسجيل الدخول',
    'Verify user identity via OTP SMS for account access',
    'التحقق من هوية المستخدم عبر رمز OTP للوصول للحساب',
    ARRAY['phone_number', 'otp_token'],
    'legitimate_interest',
    'OTP: 10 minutes. Phone: until account deletion',
    ARRAY['unifonic_sms_provider']
  );

-- ============================================
-- AUTO-UPDATE TIMESTAMPS
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_consents_updated_at
  BEFORE UPDATE ON user_consents
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_processing_registry_updated_at
  BEFORE UPDATE ON data_processing_registry
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
