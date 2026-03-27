# يمينك (Yameenak) — System Architecture
> نظام تشغيل الرعاية المتكاملة للمسنين

---

## 1. Stack Overview (التقنيات المُطبّقة)

| Layer | Technology | Why |
|---|---|---|
| Mobile App | **Flutter (Dart)** + Material 3 | Cross-platform (iOS/Android), RTL-first, single codebase |
| State Management | **Riverpod** (flutter_riverpod) | Compile-safe, testable, provider-based |
| Navigation | **GoRouter** | Declarative, deep-linking, ShellRoute support |
| Backend | **Supabase** (PostgREST + Edge Functions) | Zero server ops, RLS, real-time, auth built-in |
| Database | **PostgreSQL** (Supabase managed) | RLS for patient privacy, JSONB, arrays |
| AI Functions | **Supabase Edge Functions** (Deno + Gemini) | Geriatric health chat, reports, anomaly detection |
| Push Notifications | **Firebase FCM** | iOS/Android push |
| HTTP Client | **Dio** | Interceptors, JWT auto-injection |
| Secure Storage | **flutter_secure_storage** | JWT tokens, sensitive data |
| Charts | **fl_chart** | Health readings sparklines and trends |
| Font | **Cairo** (Regular, SemiBold, Bold) | Arabic-optimized typography |
| Design System | **Material 3** + Stitch AI tokens | Tonal surfaces, glassmorphism, ambient shadows |

---

## 2. System Architecture Diagram

```
┌──────────────────────────────────────────────────────┐
│                   CLIENT LAYER                        │
│           Flutter Mobile App (iOS + Android)          │
│                                                       │
│   ┌─────────────┐  ┌────────────┐  ┌──────────────┐ │
│   │ Auth Flow    │  │ Patient    │  │ Family       │ │
│   │ (Login/OTP)  │  │ (مسن)     │  │ (أسرة)      │ │
│   └──────┬──────┘  └──────┬─────┘  └──────┬───────┘ │
│          │                │                │          │
│   ┌──────┴────────────────┴────────────────┴───────┐ │
│   │         Riverpod Providers Layer                │ │
│   │  chat · patient · medical_profile · reports     │ │
│   │  services · subscription                        │ │
│   └──────────────────────┬──────────────────────────┘ │
│                          │                             │
│   ┌──────────────────────┴──────────────────────────┐ │
│   │              ApiService (Dio)                    │ │
│   │         PostgREST + Edge Functions               │ │
│   └──────────────────────┬──────────────────────────┘ │
└──────────────────────────┼───────────────────────────┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
┌─────────────────────┐   ┌──────────────────────────┐
│  Supabase PostgREST │   │  Supabase Edge Functions  │
│  (REST API)         │   │  (Deno + Gemini AI)       │
│                     │   │                            │
│  • Auth (OTP)       │   │  • /chat                  │
│  • Patients CRUD    │   │    شات صحي متخصص          │
│  • Health Readings  │   │                            │
│  • Medications      │   │  • /generate-report        │
│  • Bookings         │   │    تقارير أسبوعية AI       │
│  • Consent APIs     │   │                            │
│  • Privacy APIs     │   │  • /analyze-reading        │
│                     │   │    كشف الشذوذ الاستباقي    │
└────────┬────────────┘   └─────────────┬──────────────┘
         │                              │
         └──────────────┬───────────────┘
                        ▼
┌──────────────────────────────────────────────────────┐
│               PostgreSQL (Supabase)                   │
│               Row-Level Security (RLS)                │
│                                                       │
│  23+ Tables across 6 migrations:                      │
│  ┌─────────────────┐ ┌──────────────────────────────┐│
│  │ Core            │ │ PDPL Compliance              ││
│  │ • users         │ │ • user_consents              ││
│  │ • patients      │ │ • audit_logs                 ││
│  │ • family_patients│ │ • data_processing_registry  ││
│  │ • medications   │ │ • data_deletion_requests     ││
│  │ • health_readings│ └──────────────────────────────┘│
│  │ • reading_schedules│ ┌────────────────────────────┐│
│  │ • providers     │ │ Subscriptions & Reports      ││
│  │ • bookings      │ │ • subscriptions              ││
│  │ • chat_messages │ │ • health_reports             ││
│  │ • notification_logs│ │ • report_insights         ││
│  │ • otp_tokens    │ └────────────────────────────────┘│
│  └─────────────────┘                                  │
└──────────────────────────────────────────────────────┘
```

---

## 3. Project Structure (Monorepo — Turborepo)

```
yameenak/                          # يمينك monorepo
├── apps/
│   ├── mobile/                    # Flutter Mobile App
│   │   ├── lib/
│   │   │   ├── main.dart          # Entry point + orientation logic
│   │   │   ├── app/
│   │   │   │   ├── router.dart    # GoRouter (11 routes)
│   │   │   │   ├── theme.dart     # Material 3 design system
│   │   │   │   └── app_images.dart
│   │   │   ├── screens/
│   │   │   │   ├── auth/
│   │   │   │   │   └── login_screen.dart
│   │   │   │   ├── patient/       # مسارات المسن
│   │   │   │   │   ├── record_reading_screen.dart
│   │   │   │   │   ├── medical_profile_screen.dart
│   │   │   │   │   ├── profile_setup_screen.dart
│   │   │   │   │   └── health_reports_screen.dart
│   │   │   │   ├── family/        # مسارات الأسرة
│   │   │   │   │   ├── dashboard_screen.dart
│   │   │   │   │   └── chat_screen.dart
│   │   │   │   ├── privacy/       # PDPL compliance
│   │   │   │   │   ├── consent_screen.dart
│   │   │   │   │   └── privacy_settings_screen.dart
│   │   │   │   ├── services/
│   │   │   │   │   └── services_marketplace_screen.dart
│   │   │   │   └── subscription/
│   │   │   │       └── yameenak_plus_screen.dart
│   │   │   ├── providers/         # Riverpod state management
│   │   │   │   ├── chat_provider.dart
│   │   │   │   ├── medical_profile_provider.dart
│   │   │   │   ├── patient_provider.dart
│   │   │   │   ├── reports_provider.dart
│   │   │   │   ├── services_provider.dart
│   │   │   │   └── subscription_provider.dart
│   │   │   ├── models/
│   │   │   │   ├── patient.dart
│   │   │   │   ├── reading.dart
│   │   │   │   ├── medical_profile.dart
│   │   │   │   ├── health_report.dart
│   │   │   │   ├── health_service.dart
│   │   │   │   └── message.dart
│   │   │   ├── services/
│   │   │   │   ├── api_service.dart      # Supabase REST + Edge Functions
│   │   │   │   └── consent_service.dart  # PDPL consent management
│   │   │   ├── widgets/           # Shared UI components
│   │   │   │   ├── app_logo.dart
│   │   │   │   ├── error_state.dart
│   │   │   │   ├── plus_gate.dart
│   │   │   │   ├── reading_sparkline.dart
│   │   │   │   ├── shimmer_box.dart
│   │   │   │   ├── status_badge.dart
│   │   │   │   ├── success_overlay.dart
│   │   │   │   └── typing_indicator.dart
│   │   │   └── core/              # Responsive utilities
│   │   │       ├── responsive_utils.dart
│   │   │       └── responsive_scaffold.dart
│   │   ├── test/
│   │   │   └── widgets/           # Widget tests
│   │   ├── assets/
│   │   │   ├── fonts/             # Cairo font family
│   │   │   └── images/
│   │   └── pubspec.yaml
│   │
│   └── api/                       # (Placeholder — migrated to Supabase)
│       ├── src/
│       ├── package.json
│       └── Dockerfile.dev
│
├── supabase/
│   ├── migrations/
│   │   ├── 001_initial_schema.sql      # 11 core tables + RLS
│   │   ├── 002_pdpl_compliance.sql     # 4 PDPL tables + RoPA seed
│   │   ├── 003_subscriptions_and_reports.sql  # 3 tables
│   │   ├── 004_ai_health_thresholds.sql     # حدود طارئة شخصية بالذكاء الاصطناعي
│   │   ├── 005_medical_data_agency.sql      # وكالة البيانات الطبية + نقل عبر الحدود
│   │   └── 006_complete_rls_and_functions.sql # تكملة RLS + RPC + triggers
│   ├── functions/
│   │   ├── chat/                  # AI health chat (Gemini)
│   │   ├── generate-report/       # Weekly AI reports
│   │   └── analyze-reading/       # Anomaly detection
│   ├── seed.sql
│   └── config.toml
│
├── ARCHITECTURE.md     # ← أنت هنا
├── DPIA.md             # تقييم أثر الخصوصية
├── PRIVACY_POLICY.md   # سياسة الخصوصية
├── RPD.md              # سجل أنشطة المعالجة
├── docker-compose.yml
├── turbo.json
└── package.json
```

---

## 4. Routing (GoRouter)

```
/login                     → LoginScreen
/consent                   → ConsentScreen (PDPL — إلزامية)
/privacy-settings          → PrivacySettingsScreen

ShellRoute:
  /family                  → FamilyDashboardScreen
  /family/chat             → ChatScreen (AI)
  /patient/profile         → MedicalProfileScreen
  /patient/profile/setup   → ProfileSetupScreen
  /patient/reports         → HealthReportsScreen
  /patient/record?type=... → RecordReadingScreen
  /services                → ServicesMarketplaceScreen
  /plus                    → YameenakPlusScreen
```

---

## 5. Database Schema (23+ Tables)

### Migration 001 — Core Schema

```sql
-- المستخدمون
users (id, phone, name, role, whatsapp_id, fcm_token, timestamps)
  → role: 'family' | 'patient' | 'provider' | 'admin'

-- الملف الطبي الموحد
patients (id, user_id, full_name, national_id, dob, gender, photo_url,
          chronic_conditions[], allergies[], blood_type, notes,
          sugar_min/max, bp_systolic_min/max, bp_diastolic_max, timestamps)

-- ربط الأسرة بالمريض
family_patients (id, family_user_id, patient_id, relationship,
                 is_primary_caregiver, notify_whatsapp, notify_push)

-- الأدوية
medications (id, patient_id, name, dosage, frequency, times[], instructions, is_active)

-- القراءات الصحية
health_readings (id, patient_id, type, value_1, value_2, unit, context,
                 is_anomaly, anomaly_notified, notes, recorded_at)
  → type: 'blood_sugar' | 'blood_pressure' | 'weight' | 'temperature' | 'oxygen' | 'heart_rate'
  → context: 'fasting' | 'after_meal' | 'before_sleep' | 'random' | 'morning' | 'evening'

-- جداول القراءات
reading_schedules (id, patient_id, reading_type, scheduled_time, days_of_week[])

-- مزودو الخدمة
providers (id, name, name_ar, category, description, phone, whatsapp,
           price_from, price_to, rating, coverage_cities[], logo_url, is_verified)

-- الحجوزات
bookings (id, patient_id, family_user_id, provider_id, service_type,
          scheduled_at, status, address, total_price, payment_status, moyasar_payment_id)

-- محادثات الشات
chat_messages (id, patient_id, user_id, role, content, created_at)

-- سجل الإشعارات
notification_logs (id, patient_id, user_id, type, channel, content, delivered)

-- رموز OTP
otp_tokens (id, phone, token, expires_at, used)
```

### Migration 002 — PDPL Compliance

```sql
-- إدارة الموافقات
user_consents (id, user_id, consent_type, granted, granted_at, revoked_at,
               ip_address, consent_version)
  → types: health_data_collection | ai_analysis | whatsapp_notifications |
           push_notifications | analytics | marketing

-- سجل التدقيق
audit_logs (id, user_id, action, resource_type, resource_id, metadata, ip_address)

-- سجل أنشطة المعالجة (RoPA)
data_processing_registry (id, process_name, purpose, data_categories[],
                          legal_basis, retention_period, recipients[])

-- طلبات حذف البيانات
data_deletion_requests (id, user_id, status, requested_at, scheduled_purge_at)
```

### Migration 003 — Subscriptions & Reports

```sql
-- اشتراكات يمينك بلس
subscriptions (id, user_id, plan, status, started_at, expires_at, payment_id)
  → plan: 'free' | 'monthly_plus' | 'yearly_plus'

-- التقارير الصحية المولّدة بالذكاء الاصطناعي
health_reports (id, patient_id, title, period, summary, generated_at)

-- رؤى التقارير
report_insights (id, report_id, title, description, type)
  → type: 'positive' | 'warning' | 'info'
```

### Migration 004 — AI-Calibrated Thresholds

```sql
-- حدود طارئة شخصية يحددها الذكاء الاصطناعي لكل مريض
ALTER TABLE patients ADD COLUMN
  sugar_critical_high FLOAT DEFAULT 300,
  sugar_critical_low  FLOAT DEFAULT 60,
  bp_critical_systolic  INT DEFAULT 180,
  bp_critical_diastolic INT DEFAULT 120,
  thresholds_calibrated_at TIMESTAMPTZ,
  thresholds_ai_note TEXT
```

### Migration 005 — Medical Data Agency

```sql
-- وكالة البيانات الطبية
medical_data_agencies (id, patient_id, granted_by_user_id, agent_user_id,
                       relationship, legal_capacity, legal_document_ref,
                       agency_scope[], legal_basis JSONB, granted_at, expires_at,
                       is_active, revoked_at, revocation_reason)

-- سجل نقل البيانات عبر الحدود (PDPL المادة 29)
cross_border_transfers (id, patient_id, transferred_at, recipient_service,
                        recipient_country, recipient_org, data_categories[],
                        anonymization_applied, legal_basis)
```

### Migration 006 — Complete RLS + Functions

```sql
-- تكملة RLS Policies لـ 9 جداول
-- توسيع user_consents CHECK (4 أنواع جديدة)
-- triggers لـ updated_at (users, patients, bookings)
-- RPC: request_otp(phone), verify_otp(phone, code)
-- RoPA: تسجيل أنشطة predictive_health + cross_border
```

### Row-Level Security (RLS)

| Table | Policy |
|---|---|
| `users` | المستخدم يرى ملفه فقط |
| `patients` | الأسرة ترى مرضاها المربوطين |
| `health_readings` | عبر ربط family_patients |
| `chat_messages` | عبر ربط family_patients |
| `user_consents` | المستخدم يدير موافقاته فقط |
| `audit_logs` | المستخدم يرى سجله فقط |
| `subscriptions` | المستخدم يرى اشتراكه فقط |
| `health_reports` | الأسرة ترى تقارير مرضاها |
| `family_patients` | المستخدم يرى ربطاته فقط |
| `medications` | الأسرة ترى أدوية مرضاها |
| `bookings` | المستخدم يرى حجوزاته فقط |
| `providers` | مفتوح للقراءة (سوق عام) |
| `reading_schedules` | الأسرة ترى جداول مرضاها |
| `notification_logs` | المستخدم يرى إشعاراته فقط |
| `otp_tokens` | ممنوع — فقط عبر RPC functions |

---

## 6. AI Architecture (Edge Functions + Gemini)

```
User Message (from ChatScreen)
     │
     ▼
┌─────────────────────────────────────────────────┐
│          ApiService._fnDio.post('/chat')         │
│          Authorization: Bearer <supabase_key>    │
└────────────────────────┬────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────┐
│       Supabase Edge Function: /chat              │
│                                                   │
│  1. Fetch patient profile (conditions, meds)     │
│  2. Fetch last 7 days health readings            │
│  3. Fetch conversation history                   │
│  4. Strip PII (PDPL compliance)                  │
│  5. Build geriatric-specialized system prompt    │
│  6. Call Gemini AI                               │
│  7. Save response to chat_messages               │
│  8. Return response                              │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│   Supabase Edge Function: /generate-report       │
│                                                   │
│  1. Fetch readings for period (7d/30d)           │
│  2. Calculate trends and averages                │
│  3. Send anonymized data to Gemini               │
│  4. Generate insights (positive/warning/info)    │
│  5. Save to health_reports + report_insights     │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│   Supabase Edge Function: /analyze-reading       │
│                                                   │
│  1. Receive new reading (type, value)            │
│  2. Compare against patient-specific limits      │
│  3. Flag anomaly if out of range                 │
│  4. Generate AI recommendation via Gemini        │
│  5. Trigger notification if anomaly detected     │
└─────────────────────────────────────────────────┘
```

---

## 7. Design System ("The Digital Sanctuary")

| Token | Value |
|---|---|
| **Primary** | `#00386C` (أزرق بحري سعودي) |
| **Secondary** | `#006491` (أزرق ثقة) |
| **Tertiary** | `#552E00` (ذهبي صحراوي) |
| **Surface** | `#F7F9FF` (أبيض مزرق) |
| **Font** | Cairo (Arabic-optimized) |
| **Card Radius** | 16px (lg) |
| **Button Radius** | 100px (full rounded) |
| **Shadows** | Ambient (Primary @ 6% opacity, blur 40) |
| **Effects** | Glassmorphism via BackdropFilter |
| **Spacing** | 4px baseline (xs=4, sm=8, md=16, lg=20, xl=24, xxl=32) |

### Design Principles (Stitch-derived)
- **No-Line Rule**: Dividers are transparent, separation via tonal surfaces
- **Ghost Borders**: 15% opacity outlineVariant, only when needed
- **Ambient Shadows**: Primary-tinted, not black
- **Glassmorphism**: BackdropFilter for floating elements
- **Tonal Layering**: surface → surfaceContainerLow → surfaceContainer → surfaceContainerHigh

---

## 8. API Endpoints (ApiService)

### PostgREST (REST API)

```
AUTH
POST /auth/otp/request          # إرسال OTP
POST /auth/otp/verify           # التحقق + JWT

PATIENTS
GET  /patients/:id              # ملف المريض

READINGS
POST /readings                  # تسجيل قراءة جديدة
GET  /readings?patient_id=&days= # تاريخ القراءات

PRIVACY (PDPL)
GET    /privacy/consents         # قراءة الموافقات
POST   /privacy/consents/batch   # تحديث الموافقات
DELETE /privacy/consents/:type   # سحب موافقة
GET    /privacy/my-data          # تصدير البيانات
DELETE /privacy/account          # حذف الحساب
```

### Edge Functions (AI)

```
POST /functions/v1/chat            # شات ذكي (Gemini)
POST /functions/v1/generate-report # تقرير أسبوعي AI
POST /functions/v1/analyze-reading # تحليل قراءة + كشف شذوذ
```

---

## 9. Security & Compliance (PDPL)

| Requirement | Implementation |
|---|---|
| Explicit Consent | شاشة `ConsentScreen` إلزامية بعد أول تسجيل دخول |
| Consent Management | جدول `user_consents` مع 6 أنواع موافقة |
| Right to Access | API `/privacy/my-data` لتصدير البيانات |
| Right to Erasure | API `/privacy/account` + جدول `data_deletion_requests` |
| Audit Trail | جدول `audit_logs` مع 14 نوع حدث |
| RoPA | جدول `data_processing_registry` مع 4 أنشطة مسجلة |
| PII Protection | إزالة المعرفات الشخصية قبل إرسال البيانات للذكاء الاصطناعي |
| Data at Rest | Supabase AES-256 encryption |
| API Auth | JWT via flutter_secure_storage + Dio interceptor |
| RLS | كل الجداول الحساسة محمية بـ Row-Level Security |
| Documentation | DPIA.md + PRIVACY_POLICY.md + RPD.md |

---

## 10. Responsive Design

| Feature | Implementation |
|---|---|
| Breakpoint Detection | `responsive_utils.dart` — `isTablet(context)` @ 600px |
| Layout Constraint | `ResponsiveScaffold` — max-width containers |
| Orientation | Portrait-only on phone, all orientations on tablet |
| Adaptive Spacing | `AppSpacing.screenPadding` vs `tabletScreenPadding` |
| Grid Layouts | All 11 screens adapt to tablet/landscape |

---

## 11. Dependencies (pubspec.yaml)

| Package | Purpose |
|---|---|
| `flutter_riverpod: ^2.5.1` | State management |
| `go_router: ^14.2.0` | Navigation |
| `dio: ^5.4.3` | HTTP client |
| `flutter_secure_storage: ^9.2.2` | JWT secure storage |
| `fl_chart: ^0.68.0` | Health charts |
| `firebase_messaging: ^15.1.0` | Push notifications |
| `flutter_local_notifications: ^17.2.0` | Local notifications |
| `intl: ^0.20.0` | Localization |
| `shared_preferences: ^2.3.0` | Simple preferences |
| `cached_network_image: ^3.3.1` | Image caching |
