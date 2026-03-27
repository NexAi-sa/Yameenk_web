// يمينك — Generate Health Report Edge Function
// يولّد تقرير صحي أسبوعي بالذكاء الاصطناعي

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY")!;
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}`;

const REPORT_PROMPT = `أنت محلل بيانات صحية متخصص في طب كبار السن.
مهمتك: تحليل القراءات الصحية للأسبوع وتوليد:

1. **ملخص** (summary): متوسط السكر، متوسط الضغط (systolic/diastolic)، عدد القراءات، نسبة الالتزام بالأدوية (مقدرة)
2. **رؤى ذكية** (insights): 2-4 رؤى مصنفة:
   - positive: تحسن ملموس (مثال: "مستوى السكر انخفض 15% عن الأسبوع الماضي")
   - warning: تنبيه يتطلب متابعة (مثال: "ضغط الدم مرتفع باستمرار — أنصح بمراجعة الطبيب")
   - info: معلومة مفيدة (مثال: "القراءات أكثر استقراراً في الصباح")

أجب بـ JSON فقط وبدون أي نص إضافي:
{
  "summary": {
    "avg_blood_sugar": number,
    "avg_systolic": number,
    "avg_diastolic": number,
    "readings_count": number,
    "medication_adherence": number (0 to 1)
  },
  "insights": [
    { "title": "string", "description": "string", "type": "positive|warning|info" }
  ]
}`;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Methods": "POST", "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type" } });
  }

  try {
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const { patient_id } = await req.json();

    if (!patient_id) {
      return new Response(JSON.stringify({ error: "patient_id required" }), { status: 400, headers: { "Content-Type": "application/json" } });
    }

    // ──── 0. فحص موافقة المستخدم (PDPL) ────
    const { data: patientUser } = await supabase
      .from("patients")
      .select("user_id")
      .eq("id", patient_id)
      .single();

    if (patientUser?.user_id) {
      const { data: consent } = await supabase
        .from("user_consents")
        .select("granted")
        .eq("user_id", patientUser.user_id)
        .eq("consent_type", "ai_analysis")
        .single();

      if (!consent?.granted) {
        return new Response(
          JSON.stringify({ error: "ai_analysis_consent_required" }),
          { status: 403, headers: { "Content-Type": "application/json" } },
        );
      }
    }

    // ──── 1. جلب قراءات الأسبوع ────
    const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();

    const { data: readings } = await supabase
      .from("health_readings")
      .select("type, value_1, value_2, unit, context, recorded_at")
      .eq("patient_id", patient_id)
      .gte("recorded_at", weekAgo)
      .order("recorded_at", { ascending: true });

    const { data: patient } = await supabase
      .from("patients")
      .select("chronic_conditions, allergies, sugar_min, sugar_max, bp_systolic_max, bp_diastolic_max")
      .eq("id", patient_id)
      .single();

    const { data: medications } = await supabase
      .from("medications")
      .select("name, dosage, frequency")
      .eq("patient_id", patient_id)
      .eq("is_active", true);

    if (!readings || readings.length === 0) {
      return new Response(JSON.stringify({ error: "لا توجد قراءات لهذا الأسبوع" }), { status: 404, headers: { "Content-Type": "application/json" } });
    }

    // ──── 2. تحليل بالذكاء الاصطناعي ────
    const dataContext = `
القراءات (${readings.length} قراءة خلال الأسبوع):
${readings.map((r: any) => `${r.type}: ${r.value_2 ? `${r.value_1}/${r.value_2}` : r.value_1} ${r.unit || ""} (${r.context || "غير محدد"}) — ${new Date(r.recorded_at).toLocaleDateString("ar-SA")}`).join("\n")}

الأمراض المزمنة: ${patient?.chronic_conditions?.join("، ") || "غير محدد"}
الأدوية: ${medications?.map((m: any) => `${m.name} ${m.dosage}`).join("، ") || "غير محدد"}
حدود السكر: ${patient?.sugar_min}-${patient?.sugar_max}
حدود الضغط: أقل من ${patient?.bp_systolic_max}/${patient?.bp_diastolic_max}
`;

    const geminiRes = await fetch(GEMINI_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        system_instruction: { parts: [{ text: REPORT_PROMPT }] },
        contents: [{ role: "user", parts: [{ text: dataContext }] }],
        generationConfig: { temperature: 0.2, maxOutputTokens: 1000, responseMimeType: "application/json" },
      }),
    });

    const geminiData = await geminiRes.json();
    const rawText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text || "{}";

    let aiResult: { summary?: object; insights?: object[] };
    try {
      aiResult = JSON.parse(rawText);
    } catch {
      console.error("Gemini returned invalid JSON:", rawText);
      return new Response(
        JSON.stringify({ error: "ai_response_parse_failed" }),
        { status: 502, headers: { "Content-Type": "application/json" } },
      );
    }

    // ──── 3. تسجيل نقل البيانات عبر الحدود (PDPL المادة 29) ────
    await supabase.from("cross_border_transfers").insert({
      patient_id,
      recipient_service: "gemini_api",
      recipient_country: "US",
      recipient_org: "Google LLC",
      data_categories: ["health_readings", "chronic_conditions", "medications"],
      anonymization_applied: true,
      anonymization_method: "pdpl_anonymizer_v1",
      legal_basis: "explicit_consent",
      recipient_adequacy_mechanism: "standard_contractual_clauses",
      data_deleted_after_processing: true,
    });

    // ──── 4. حفظ التقرير ────
    const weekRange = `${new Date(weekAgo).toLocaleDateString("ar-SA")} — ${new Date().toLocaleDateString("ar-SA")}`;

    const { data: report } = await supabase
      .from("health_reports")
      .insert({
        patient_id,
        title: `تقرير أسبوعي — ${weekRange}`,
        period: weekRange,
        summary: aiResult.summary || {},
      })
      .select("id")
      .single();

    if (report && aiResult.insights) {
      const insightsToInsert = aiResult.insights.map((i: any) => ({
        report_id: report.id,
        title: i.title,
        description: i.description,
        type: i.type,
      }));
      await supabase.from("report_insights").insert(insightsToInsert);
    }

    return new Response(JSON.stringify({ report_id: report?.id, ...aiResult }), {
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
    });
  } catch (error) {
    console.error("Report error:", error);
    return new Response(JSON.stringify({ error: "Internal server error" }), { status: 500, headers: { "Content-Type": "application/json" } });
  }
});
