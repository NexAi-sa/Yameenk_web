-- يمينك — Subscriptions & Health Reports Migration
-- Yameenak Plus + AI-Generated Reports

-- ============================================
-- SUBSCRIPTIONS — اشتراكات يمينك بلس
-- ============================================
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan VARCHAR(20) NOT NULL DEFAULT 'free' CHECK (plan IN ('free', 'monthly_plus', 'yearly_plus')),
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ,
  payment_id VARCHAR(100),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status, expires_at);

ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_subscription" ON subscriptions
  USING (user_id = auth.uid());

-- ============================================
-- HEALTH REPORTS — التقارير الصحية المولّدة بالذكاء الاصطناعي
-- ============================================
CREATE TABLE health_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  title VARCHAR(200) NOT NULL,
  period VARCHAR(50),
  summary JSONB NOT NULL DEFAULT '{}',
  generated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE report_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id UUID NOT NULL REFERENCES health_reports(id) ON DELETE CASCADE,
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  type VARCHAR(20) NOT NULL CHECK (type IN ('positive', 'warning', 'info')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_reports_patient ON health_reports(patient_id, generated_at DESC);
CREATE INDEX idx_insights_report ON report_insights(report_id);

ALTER TABLE health_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE report_insights ENABLE ROW LEVEL SECURITY;

-- العائلة تشوف تقارير مرضاها
CREATE POLICY "family_access_reports" ON health_reports
  USING (
    patient_id IN (
      SELECT patient_id FROM family_patients WHERE family_user_id = auth.uid()
    )
  );

CREATE POLICY "family_access_insights" ON report_insights
  USING (
    report_id IN (
      SELECT id FROM health_reports WHERE patient_id IN (
        SELECT patient_id FROM family_patients WHERE family_user_id = auth.uid()
      )
    )
  );

-- Auto-update timestamps
CREATE TRIGGER trg_subscriptions_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
