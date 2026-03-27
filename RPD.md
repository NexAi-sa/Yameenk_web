# يمينك — Road to Product Development (RPD)
> خارطة طريق المنتج من الصفر لأول 1000 مستخدم

---

## الفلسفة: Ship Fast, Learn Faster

```
الأولوية الوحيدة في V1:
"هل الأسرة تشعر بالطمأنينة؟"

إذا أجابت الأسرة بـ "نعم" → المنتج نجح
كل ميزة لا تخدم هذا الهدف → مؤجلة
```

---

## Phase 0: التأسيس (أسبوع 1-2)

### ماذا تبني؟
بيئة التطوير الكاملة وهيكل المشروع فقط.

### المهام:

**يوم 1-3: الإعداد**
```bash
# 1. Monorepo Setup
npx create-turbo@latest yameenak
cd yameenak

# 2. Mobile App (React Native + Expo)
npx create-expo-app apps/mobile --template

# 3. Backend (NestJS)
nest new apps/api

# 4. Supabase Project
# → supabase.com → New Project → Bahrain region
supabase init
supabase db push  # Run migrations

# 5. Environment Setup
# .env.local files for each app
```

**يوم 4-7: قاعدة البيانات**
- كتابة الـ migrations (Schema من ARCHITECTURE.md)
- إعداد Supabase RLS policies
- Seed data: 5 مزودي خدمة حقيقيين (مبادر، عضيد، نعاون، يسر، همم)

**أسبوع 2: البنية التحتية**
- إعداد Auth (OTP عبر Unifonic)
- Claude API integration test
- WhatsApp Business API account setup + template approval

### Deliverable:
- [ ] كل الخدمات تعمل locally
- [ ] DB schema جاهز
- [ ] OTP login يعمل
- [ ] Claude يرد على رسالة اختبارية

---

## Phase 1: MVP — "الطمأنينة" (أسبوع 3-8) ← **الأهم**

### الهدف: أول 50 مستخدم حقيقي

### الميزات المطلوبة (بالترتيب):

---

### 1.1 ملف المريض الموحد (أسبوع 3)
**للمستخدم:** الأسرة تُنشئ ملف المسن

```
Screens:
1. CreatePatient → الاسم، العمر، رقم الجوال
2. AddConditions → اختيار من قائمة (سكري، ضغط، زهايمر...)
3. AddMedications → اسم الدواء، الجرعة، التوقيت
4. SetLimits → تخصيص حدود القراءات (أو إبقاء الافتراضي)
5. InviteFamily → إرسال رابط للأسرة

API Endpoints:
POST /patients
POST /patients/:id/medications
POST /patients/:id/family-invite
```

**تقدير التطوير:** 4 أيام (mobile) + 2 يوم (API)

---

### 1.2 تسجيل القراءات اليومية (أسبوع 4)
**للمستخدم:** المسن يسجل قراءاته ببساطة

```
Mobile Screen (Patient):
- شاشة بسيطة: "سجّل قراءتك"
- حقل رقم واحد (أو اثنين للضغط)
- زر "سجّل" كبير (كبار السن → UI بسيط جداً)
- تأكيد فوري: "✅ تم التسجيل"

Schedule Engine (Backend):
- تلقائياً بناءً على حالة المريض:
  سكري → تنبيهين/يوم (8ص + 8م)
  ضغط → مرة/يوم (9ص)
- تنبيه للمسن إذا نسي (Push Notification)

API:
POST /readings → triggers anomaly check immediately
```

**تقدير التطوير:** 3 أيام (mobile) + 3 أيام (API + scheduler)

---

### 1.3 تنبيهات الانحراف عبر WhatsApp (أسبوع 5) ← القلب
**للمستخدم:** الأسرة تتلقى تنبيهاً فورياً عند خطورة

```
Flow:
Reading Saved
  → Anomaly Detection (compare vs patient limits)
  → If anomaly: push to Redis queue
  → Worker: check quiet hours (10pm-7am = defer)
  → Send WhatsApp template to all family members
  → Log to notification_logs

Rules:
✅ سكر > 200 أو < 60 → تنبيه فوري
✅ ضغط > 140/90 → تنبيه فوري
✅ نسي 2+ قراءات متتالية → تذكير للأسرة
❌ قراءة طبيعية → لا شيء يُرسَل

Quiet Hours: 10pm-7am → defer to 7am
```

**تقدير التطوير:** 4 أيام

---

### 1.4 الشات الصحي بالذكاء الاصطناعي (أسبوع 6)
**للمستخدم:** المسن والأسرة يسألون بلغة طبيعية

```
Context Builder:
1. Load patient profile (conditions, meds, limits)
2. Load last 7 days readings
3. Load last 5 messages (conversation history)
4. Build system prompt
5. Send to Claude API → Stream response

UI:
- Chat interface (Arabic RTL)
- Quick questions: "هل قراءتي طبيعية؟" "نسيت دوائي"
- Typing indicator while Claude responds
- Save to chat_messages
```

**تقدير التطوير:** 3 أيام (mobile) + 2 يوم (API)

---

### 1.5 لوحة الاتجاهات الأسبوعية (أسبوع 7)
**للمستخدم:** الأسرة تفهم الصورة الكاملة

```
Dashboard Screens (Family):
1. Overview Card: "هذا الأسبوع: 6/7 قراءات طبيعية"
2. Line Chart: قراءات السكر آخر 7 أيام
3. AI Summary: نص تلقائي من Claude
4. Medication Adherence: "6 من 7 أيام ✅"

Weekly Report (WhatsApp):
- كل أحد الساعة 8 صباحاً
- Auto-generated via Reports Service + Claude

Charts Library: Victory Native XL (React Native)
```

**تقدير التطوير:** 4 أيام

---

### 1.6 سوق الخدمات البسيط (أسبوع 8)
**للمستخدم:** حجز خدمة بضغطة زر

```
V1: Simple Catalog (no complex backend)
- قائمة مزودين (Static + DB)
- Filter: تمريض / نقل / طبيب
- Provider Card: الاسم، التقييم، السعر من، رقم التواصل
- Booking Form: الخدمة + التاريخ + ملاحظات
- Confirm → WhatsApp template للأسرة

V1 Commission Flow:
- اليوم الأول: التواصل المباشر مع المزود (manually)
- لاحقاً: Moyasar integration + automated booking

API:
GET /providers?category=nursing
POST /bookings
```

**تقدير التطوير:** 3 أيام

---

### Phase 1 Timeline

```
Week 3  ████████ Patient Profile
Week 4  ████████ Health Readings
Week 5  ████████ WhatsApp Alerts ← Critical
Week 6  ████████ AI Chat
Week 7  ████████ Trends Dashboard
Week 8  ████████ Marketplace

Total: 6 weeks → MVP Ready
```

### Phase 1 Deliverable:
- [ ] أول مستخدم حقيقي يسجّل قراءة
- [ ] أسرة تتلقى تنبيه WhatsApp حقيقي
- [ ] الشات يجيب بوعي بحالة المريض
- [ ] 50 مستخدم (25 عائلة × 2 أفراد أسرة)

---

## Phase 2: Product-Market Fit (شهر 3-4)

### الهدف: 300 مستخدم + أول إيراد حقيقي

### ما تبنيه:

**2.1 نظام الاشتراكات (Moyasar)**
```
Plans:
- مجاني: 1 مريض، آخر 7 أيام فقط، 5 رسائل شات/يوم
- أساسي (99 ريال/شهر): 1 مريض، تاريخ كامل، شات غير محدود
- عائلي (149 ريال/شهر): 3 مرضى، كل الميزات

Integration:
Moyasar Checkout → Webhook → Update subscription in DB
```

**2.2 دعم أجهزة القياس الذكية**
```
Integrations:
- Xiaomi/Huawei Smart Scale → Bluetooth → Auto-record weight
- Omron BP Monitor → Bluetooth → Auto-record BP
- Continuous Glucose Monitor → API (if available)

Reduces friction for elderly → More readings → Better data
```

**2.3 تسجيل الأدوية اليومي**
```
Feature:
- تنبيه "هل أخذت دواءك؟" → المسن يرد ✅ أو ❌
- Adherence tracking
- تنبيه للأسرة عند إهمال الدواء 2+ أيام
```

**2.4 Web Dashboard (Next.js)**
```
For family members on desktop:
- Full health history with charts
- Document upload (medical reports)
- Booking management
- Provider invoices
```

---

## Phase 3: Scale (شهر 5-8)

### الهدف: 2000 مستخدم + B2B

**3.1 B2B: برنامج مزايا الموظفين**
```
Corporate Package:
- Companies buy subscriptions for employees' parents
- Admin dashboard for HR
- Bulk pricing
- Pilot: 5 شركات × 50 موظف = 250 مشترك فوري
```

**3.2 Provider Dashboard**
```
For nursing companies, transport providers:
- Accept/manage bookings
- Caregiver profiles + ratings
- Earnings dashboard
- Calendar management
```

**3.3 AI Predictive Alerts**
```
Beyond anomaly detection:
- "معدل سكر والدك يرتفع تدريجياً آخر 3 أيام"
- "لم يسجّل قراءة منذ يومين — هل هو بخير؟"
- Medication refill reminders (based on dosage × days)
```

**3.4 Wearable Integration**
```
Apple Watch / Samsung Health API
Auto-sync: steps, heart rate, sleep quality
Low-effort monitoring for elderly
```

**3.5 Insurance Integration**
```
Partner with Tawuniya / Bupa Arabia
Data sharing with consent → Premium reduction
Health reports for insurance claims
```

---

## Team Requirements

### MVP Team (Phase 0-1):

| Role | Count | Notes |
|---|---|---|
| Full-Stack Developer | 1-2 | NestJS + React Native |
| UI/UX Designer | 1 | Arabic RTL, elderly-friendly |
| Product Manager | 1 | You |

### Phase 2 Team:
Add: DevOps (AWS), QA, 1 more developer

---

## Tech Costs (شهرياً)

| Service | Cost (USD) | Notes |
|---|---|---|
| Supabase Pro | $25 | DB + Auth + Storage |
| Claude API | ~$50-200 | Depends on chat volume |
| WhatsApp Business | ~$50 | Per conversation pricing |
| AWS Bahrain | ~$50 | EC2 t3.small + ALB |
| Unifonic (SMS OTP) | ~$30 | 1000 OTPs |
| Upstash Redis | $10 | Queue + Cache |
| **Total MVP** | **~$215/mo** | |

Break-even: 3 مشتركين بالباقة الأساسية (99 ريال)

---

## Launch Strategy: أول 50 مستخدم

```
Week 1 (Pre-launch):
→ 10 أسر من الدائرة المقربة (Friends & Family)
→ اطلب منهم: سجّلوا مريضاً حقيقياً، استخدموا الشات، راقبوا التنبيهات
→ احجز مكالمة أسبوعية لجمع الملاحظات

Week 2-3:
→ نشر في مجموعات واتساب ذوي كبار السن
→ تواصل مع مستشفى/مركز صحي → "ابحثوا عن حلول لأسر مرضى الأمراض المزمنة"
→ LinkedIn post: قصة شخصية عن مشكلة الرعاية

Week 4-6:
→ كل مستخدم راضٍ = مصدر لـ 3-5 مستخدمين جدد (oral society)
→ WhatsApp referral: "شارك يمينك مع أسرتك"
→ هدف: 50 مستخدم نشط بنهاية الشهر
```

---

## Success Metrics (V1)

| Metric | Target (Month 1) | Target (Month 3) |
|---|---|---|
| Daily Active Users | 20 | 150 |
| Readings Recorded / Day | 30 | 200 |
| WhatsApp Messages Sent | 50/week | 400/week |
| Chat Messages | 100 | 800 |
| Bookings | 5 | 40 |
| MRR | 0 | 5,000 SAR |
| Retention (Week 4) | 60% | 70% |

---

## الاختبار الحقيقي الوحيد

```
بعد أسبوع من الاستخدام الحقيقي، اسأل الأسرة سؤالاً واحداً:

"هل تشعر بطمأنينة أكثر تجاه والدك/والدتك
منذ بدأت تستخدم يمينك؟"

إذا كانت الإجابة "نعم" بنسبة 70%+ → استمر واستثمر
إذا كانت "لا" → اكتشف السبب قبل أي شيء آخر
```
