// يمينك — Analyze Reading Edge Function
// كشف القراءات غير الطبيعية + تنبؤ بالمشاكل الصامتة
// يُستدعى تلقائياً عند كل قراءة جديدة

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY")!;
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}`;

interface AnalysisResult {
  is_anomaly: boolean;
  severity: "normal" | "attention" | "urgent" | "emergency";
  alert_message: string | null;
  prediction: string | null;
}

// ──── Rule Engine: قواعد طبية مبنية على الحدود الشخصية ────
// الحدود الحرجة (emergency) تأتي من الذكاء الاصطناعي في calibrate-thresholds
// الحدود الافتراضية تُستخدم فقط قبل أول معايرة للمريض
function ruleBasedCheck(
  type: string,
  value1: number,
  value2: number | null,
  patient: any
): { is_anomaly: boolean; severity: string; message: string | null } {
  if (type === "blood_sugar") {
    const criticalHigh = patient?.sugar_critical_high ?? 300;
    const criticalLow  = patient?.sugar_critical_low  ?? 60;

    if (value1 >= criticalHigh) return { is_anomaly: true, severity: "emergency", message: "⚠️ سكر مرتفع جداً! راجع الطوارئ فوراً" };
    if (value1 <= criticalLow)  return { is_anomaly: true, severity: "emergency", message: "⚠️ انخفاض حاد بالسكر! تناول سكر فوراً" };
    if (value1 > (patient?.sugar_max ?? 140)) return { is_anomaly: true, severity: "attention", message: "قراءة سكر مرتفعة عن المعدل الطبيعي" };
    if (value1 < (patient?.sugar_min ?? 80)) return { is_anomaly: true, severity: "attention", message: "قراءة سكر منخفضة" };
  }

  if (type === "blood_pressure" && value2) {
    const criticalSystolic  = patient?.bp_critical_systolic  ?? 180;
    const criticalDiastolic = patient?.bp_critical_diastolic ?? 120;

    if (value1 >= criticalSystolic || value2 >= criticalDiastolic) return { is_anomaly: true, severity: "emergency", message: "⚠️ أزمة ضغط! راجع الطوارئ فوراً" };
    if (value1 > (patient?.bp_systolic_max ?? 140)) return { is_anomaly: true, severity: "attention", message: "ضغط الدم مرتفع" };
    if (value1 < (patient?.bp_systolic_min ?? 90)) return { is_anomaly: true, severity: "attention", message: "ضغط الدم منخفض — تحقق من جرعة الدواء" };
  }

  if (type === "temperature") {
    if (value1 > 39) return { is_anomaly: true, severity: "urgent", message: "حرارة مرتفعة — استشر الطبيب" };
    if (value1 < 35) return { is_anomaly: true, severity: "urgent", message: "انخفاض حرارة — راقب الوضع" };
  }

  if (type === "oxygen") {
    if (value1 < 90) return { is_anomaly: true, severity: "emergency", message: "⚠️ نقص أكسجين حاد! راجع الطوارئ" };
    if (value1 < 94) return { is_anomaly: true, severity: "attention", message: "مستوى الأكسجين منخفض — راقب" };
  }

  return { is_anomaly: false, severity: "normal", message: null };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Methods": "POST", "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type" } });
  }

  try {
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const { reading_id, patient_id, type, value_1, value_2, agent_user_id } = await req.json();

    // ──── 0. التحقق من الموافقة أو الوكالة الطبية (PDPL) ────
    // يقبل: موافقة صريحة على predictive_health_monitoring
    //        أو وكالة بيانات طبية نشطة تشمل نطاق health_monitoring
    const { data: patientUser } = await supabase
      .from("patients")
      .select("user_id")
      .eq("id", patient_id)
      .single();

    const subjectUserId = patientUser?.user_id;
    const checkUserId = agent_user_id ?? subjectUserId;

    if (checkUserId) {
      // تحقق من موافقة مباشرة
      const { data: directConsent } = await supabase
        .from("user_consents")
        .select("granted")
        .eq("user_id", checkUserId)
        .eq("consent_type", "predictive_health_monitoring")
        .single();

      if (!directConsent?.granted) {
        // تحقق من وكالة بيانات طبية
        const { data: agency } = await supabase
          .from("medical_data_agencies")
          .select("id")
          .eq("patient_id", patient_id)
          .eq("agent_user_id", checkUserId)
          .eq("is_active", true)
          .gt("expires_at", new Date().toISOString())
          .contains("agency_scope", ["health_monitoring"])
          .single();

        if (!agency) {
          return new Response(
            JSON.stringify({ error: "consent_or_agency_required" }),
            { status: 403, headers: { "Content-Type": "application/json" } },
          );
        }
      }
    }

    // ──── 1. Rule Engine ────
    const { data: patient } = await supabase
      .from("patients")
      .select("chronic_conditions, sugar_min, sugar_max, bp_systolic_max, bp_diastolic_max, bp_systolic_min")
      .eq("id", patient_id)
      .single();

    const ruleResult = ruleBasedCheck(type, value_1, value_2, patient);

    // تحديث القراءة
    if (reading_id) {
      await supabase
        .from("health_readings")
        .update({ is_anomaly: ruleResult.is_anomaly })
        .eq("id", reading_id);
    }

    // ──── 2. Trend Analysis (إذا مو طوارئ) ────
    let prediction: string | null = null;

    if (ruleResult.severity !== "emergency") {
      const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
      const { data: recentReadings } = await supabase
        .from("health_readings")
        .select("type, value_1, value_2, recorded_at, is_anomaly")
        .eq("patient_id", patient_id)
        .gte("recorded_at", weekAgo)
        .order("recorded_at", { ascending: true });

      const anomalyCount = recentReadings?.filter((r: any) => r.is_anomaly).length ?? 0;

      // إذا أكثر من 3 قراءات غير طبيعية في أسبوع → تحليل AI
      if (anomalyCount >= 3 && recentReadings && recentReadings.length >= 5) {
        const { data: medications } = await supabase
          .from("medications")
          .select("name, dosage, frequency")
          .eq("patient_id", patient_id)
          .eq("is_active", true);

        const trendContext = `
أنت متخصص في طب كبار السن (Geriatrics). حلل بيانات هذا المريض المسن وابحث عن أمراض صامتة:

المريض: أمراضه المزمنة: ${patient?.chronic_conditions?.join("، ") || "غير محدد"}
أدويته الحالية: ${medications?.map((m: any) => `${m.name} ${m.dosage}`).join("، ") || "غير محدد"}

قراءاته خلال الأسبوع (${recentReadings.length} قراءة، ${anomalyCount} غير طبيعية):
${recentReadings.map((r: any) => `${r.type}: ${r.value_2 ? `${r.value_1}/${r.value_2}` : r.value_1} ${r.is_anomaly ? "⚠️" : "✅"} — ${new Date(r.recorded_at).toLocaleDateString("ar-SA")}`).join("\n")}

ابحث تحديداً عن هذه الأنماط:
- ارتفاع ضغط مستمر + سكري → خطر كلوي (Creatinine + eGFR)
- سكر صباحي مرتفع مع طبيعي مسائي → ظاهرة الفجر
- وزن ينخفض + ضعف شهية → فقر دم أو سوء تغذية
- قراءات متذبذبة → عدم انتظام بالأدوية أو مشكلة امتصاص
- ضغط منخفض + دوخة → خطر سقوط + مراجعة جرعة الدواء
- تداخلات دوائية محتملة بين الأدوية المذكورة

أعطني تنبؤ واحد مختصر (جملة أو جملتين) عن مشكلة صحية صامتة محتملة إن وجدت.
إذا ما في مشكلة واضحة قل "لا توجد أنماط مقلقة حالياً".
`;

        try {
          const geminiRes = await fetch(GEMINI_URL, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              contents: [{ role: "user", parts: [{ text: trendContext }] }],
              generationConfig: { temperature: 0.3, maxOutputTokens: 200 },
            }),
          });

          const geminiData = await geminiRes.json();
          prediction = geminiData.candidates?.[0]?.content?.parts?.[0]?.text || null;
        } catch {
          console.error("Gemini prediction failed, continuing without AI");
        }
      }
    }

    // ──── 3. تسجيل التنبيه ────
    if (ruleResult.is_anomaly && ruleResult.message) {
      await supabase.from("notification_logs").insert({
        patient_id,
        type: "anomaly_alert",
        channel: "push",
        content: ruleResult.message + (prediction ? `\n📊 ${prediction}` : ""),
      });
    }

    const result: AnalysisResult = {
      is_anomaly: ruleResult.is_anomaly,
      severity: ruleResult.severity as AnalysisResult["severity"],
      alert_message: ruleResult.message,
      prediction,
    };

    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
    });
  } catch (error) {
    console.error("Analysis error:", error);
    return new Response(JSON.stringify({ error: "Internal server error" }), { status: 500, headers: { "Content-Type": "application/json" } });
  }
});
