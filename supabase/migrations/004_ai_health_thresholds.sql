-- ────────────────────────────────────────────────────────────────────
-- Migration 004: AI-Calibrated Personal Health Thresholds
-- الحدود الطارئة الشخصية يحددها الذكاء الاصطناعي لكل مريض
-- بدلاً من أرقام ثابتة عالمية (300، 60، 180، 120)
-- ────────────────────────────────────────────────────────────────────

ALTER TABLE patients
  -- حدود السكر الحرجة الشخصية (يحددها الذكاء الاصطناعي)
  ADD COLUMN IF NOT EXISTS sugar_critical_high FLOAT DEFAULT 300,
  ADD COLUMN IF NOT EXISTS sugar_critical_low  FLOAT DEFAULT 60,

  -- حدود الضغط الحرجة الشخصية (يحددها الذكاء الاصطناعي)
  ADD COLUMN IF NOT EXISTS bp_critical_systolic  INT DEFAULT 180,
  ADD COLUMN IF NOT EXISTS bp_critical_diastolic INT DEFAULT 120,

  -- توقيت آخر معايرة بالذكاء الاصطناعي
  ADD COLUMN IF NOT EXISTS thresholds_calibrated_at TIMESTAMPTZ,

  -- ملاحظة من الذكاء الاصطناعي توضح سبب الحدود المختارة
  ADD COLUMN IF NOT EXISTS thresholds_ai_note TEXT;

-- تعليق توضيحي على الحقول
COMMENT ON COLUMN patients.sugar_critical_high IS
  'حد السكر الحرج العلوي الشخصي — يحدده الذكاء الاصطناعي بناءً على العمر والأمراض المزمنة والأدوية';
COMMENT ON COLUMN patients.sugar_critical_low IS
  'حد السكر الحرج السفلي الشخصي — يحدده الذكاء الاصطناعي';
COMMENT ON COLUMN patients.bp_critical_systolic IS
  'حد ضغط الانقباض الحرج الشخصي — يحدده الذكاء الاصطناعي';
COMMENT ON COLUMN patients.bp_critical_diastolic IS
  'حد ضغط الانبساط الحرج الشخصي — يحدده الذكاء الاصطناعي';
