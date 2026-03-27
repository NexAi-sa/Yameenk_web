-- يمينك — Migration 007: Medical Profile Enhancements
-- إضافة أعمدة الطول والوزن + جدول جهات الطوارئ + تفضيلات الإشعارات

-- ============================================
-- إضافة height و weight لجدول patients
-- ============================================
ALTER TABLE patients ADD COLUMN IF NOT EXISTS height FLOAT;
ALTER TABLE patients ADD COLUMN IF NOT EXISTS weight FLOAT;

-- ============================================
-- EMERGENCY CONTACTS (جهات الطوارئ)
-- ============================================
CREATE TABLE IF NOT EXISTS emergency_contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  relation VARCHAR(50),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_emergency_patient ON emergency_contacts (patient_id);

ALTER TABLE emergency_contacts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "emergency_contacts_via_patient" ON emergency_contacts
  USING (
    patient_id IN (
      SELECT patient_id FROM family_patients WHERE family_user_id = auth.uid()
      UNION
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- ============================================
-- NOTIFICATION PREFERENCES (تفضيلات الإشعارات)
-- ============================================
CREATE TABLE IF NOT EXISTS notification_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE UNIQUE,
  daily_follow_up BOOLEAN DEFAULT false,
  emergency_only BOOLEAN DEFAULT true,
  weekly_report BOOLEAN DEFAULT false,
  vital_signs_reminder BOOLEAN DEFAULT false,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "notif_prefs_via_patient" ON notification_preferences
  USING (
    patient_id IN (
      SELECT patient_id FROM family_patients WHERE family_user_id = auth.uid()
      UNION
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );
