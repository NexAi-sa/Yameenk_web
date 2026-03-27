-- يمينك — Initial Schema Migration
-- Run: supabase db push

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS
-- ============================================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('family', 'patient', 'provider', 'admin')),
  whatsapp_id VARCHAR(100),
  fcm_token TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- PATIENTS (Unified Medical Profile)
-- ============================================
CREATE TABLE patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  full_name VARCHAR(100) NOT NULL,
  national_id VARCHAR(20),
  date_of_birth DATE,
  gender VARCHAR(10) CHECK (gender IN ('male', 'female')),
  emergency_contact VARCHAR(20),
  photo_url TEXT,

  -- Medical data
  chronic_conditions TEXT[] DEFAULT '{}',
  allergies TEXT[] DEFAULT '{}',
  blood_type VARCHAR(5),
  notes TEXT,

  -- Reading limits (customizable per patient)
  sugar_min FLOAT DEFAULT 80,
  sugar_max FLOAT DEFAULT 140,
  bp_systolic_max INT DEFAULT 140,
  bp_diastolic_max INT DEFAULT 90,
  bp_systolic_min INT DEFAULT 90,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- FAMILY ↔ PATIENT RELATIONSHIP
-- ============================================
CREATE TABLE family_patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  family_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  relationship VARCHAR(50),
  is_primary_caregiver BOOLEAN DEFAULT false,
  notify_whatsapp BOOLEAN DEFAULT true,
  notify_push BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(family_user_id, patient_id)
);

-- ============================================
-- MEDICATIONS
-- ============================================
CREATE TABLE medications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  dosage VARCHAR(50),
  frequency VARCHAR(50),
  times TEXT[] DEFAULT '{}',
  instructions TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- HEALTH READINGS (Time-Series)
-- ============================================
CREATE TABLE health_readings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  type VARCHAR(30) NOT NULL CHECK (type IN ('blood_sugar', 'blood_pressure', 'weight', 'temperature', 'oxygen', 'heart_rate')),
  value_1 FLOAT NOT NULL,
  value_2 FLOAT,
  unit VARCHAR(20),
  context VARCHAR(30) CHECK (context IN ('fasting', 'after_meal', 'before_sleep', 'random', 'morning', 'evening')),
  is_anomaly BOOLEAN DEFAULT false,
  anomaly_notified BOOLEAN DEFAULT false,
  notes TEXT,
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_readings_patient_time ON health_readings (patient_id, recorded_at DESC);
CREATE INDEX idx_readings_anomaly ON health_readings (patient_id, is_anomaly) WHERE is_anomaly = true;

-- ============================================
-- READING SCHEDULES
-- ============================================
CREATE TABLE reading_schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  reading_type VARCHAR(30) NOT NULL,
  scheduled_time TIME NOT NULL,
  days_of_week INT[] DEFAULT '{1,2,3,4,5,6,7}',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- PROVIDERS (Service Marketplace)
-- ============================================
CREATE TABLE providers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  name_ar VARCHAR(100),
  category VARCHAR(50) NOT NULL CHECK (category IN ('nursing', 'transport', 'doctor', 'therapy', 'companion', 'pharmacy')),
  description TEXT,
  description_ar TEXT,
  phone VARCHAR(20),
  whatsapp VARCHAR(20),
  price_from FLOAT,
  price_to FLOAT,
  rating FLOAT DEFAULT 5.0,
  reviews_count INT DEFAULT 0,
  coverage_cities TEXT[] DEFAULT '{}',
  logo_url TEXT,
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- BOOKINGS
-- ============================================
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id),
  family_user_id UUID NOT NULL REFERENCES users(id),
  provider_id UUID NOT NULL REFERENCES providers(id),
  service_type VARCHAR(100),
  scheduled_at TIMESTAMPTZ NOT NULL,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled')),
  address TEXT,
  notes TEXT,
  total_price FLOAT,
  payment_status VARCHAR(20) DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'paid', 'refunded')),
  moyasar_payment_id VARCHAR(100),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- AI CHAT MESSAGES
-- ============================================
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id),
  role VARCHAR(10) NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_chat_patient ON chat_messages (patient_id, created_at DESC);

-- ============================================
-- NOTIFICATION LOGS
-- ============================================
CREATE TABLE notification_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id),
  user_id UUID REFERENCES users(id),
  type VARCHAR(50) NOT NULL,
  channel VARCHAR(20) NOT NULL CHECK (channel IN ('whatsapp', 'push', 'sms')),
  content TEXT,
  delivered BOOLEAN DEFAULT false,
  sent_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- OTP TOKENS (Auth)
-- ============================================
CREATE TABLE otp_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone VARCHAR(20) NOT NULL,
  token VARCHAR(6) NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_otp_phone ON otp_tokens (phone, created_at DESC);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE family_patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE health_readings ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE medications ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- Users can only read/update their own profile
CREATE POLICY "users_own_profile" ON users
  USING (id = auth.uid());

-- Family can access their linked patients
CREATE POLICY "family_access_patients" ON patients
  USING (
    id IN (
      SELECT patient_id FROM family_patients
      WHERE family_user_id = auth.uid()
    )
    OR user_id = auth.uid()
  );
