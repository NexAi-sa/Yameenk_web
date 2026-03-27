// يمينك — Calibrate Personal Health Thresholds Edge Function
// يُستدعى عند إنشاء ملف المريض أو تحديث بياناته الطبية
// مهمته: سؤال الذكاء الاصطناعي عن الحدود الحرجة الشخصية
// بناءً على العمر، الأمراض المزمنة، الأدوية، والحالة الصحية العامة

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY")!;
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}`;

interface CalibratedThresholds {
  sugar_critical_high: number;
  sugar_critical_low: number;
  bp_critical_systolic: number;
  bp_critical_diastolic: number;
  ai_note: string;
}

const CALIBRATION_PROMPT = `أنت طبيب متخصص في طب كبار السن (Geriatrics). مهمتك تحديد الحدود الطارئة الشخصية لمريض بعينه.

الحدود الطارئة هي القيم التي إذا تجاوزها المريض، يحتاج إلى طوارئ فورية — وهي تختلف من مريض لآخر.

أجب بـ JSON فقط:
{
  "sugar_critical_high": number,   // mg/dL — حد السكر المرتفع الطارئ
  "sugar_critical_low": number,    // mg/dL — حد السكر المنخفض الطارئ
  "bp_critical_systolic": number,  // mmHg — حد ضغط الانقباض الطارئ
  "bp_critical_diastolic": number, // mmHg — حد ضغط الانبساط الطارئ
  "ai_note": "string"              // جملة توضح سبب الحدود المختارة بالعربية
}

قواعد التفكير:
- مريض عنده فشل كلوي: sugar_critical_high أقل (مثل 250 بدل 300) لأن الجسم أقل تحملاً
- مريض مسن (>80 سنة): bp_critical_systolic أعلى قليلاً (مثل 190) لأن الضغط المرتفع أكثر شيوعاً
- مريض بدون أمراض مزمنة: الحدود الافتراضية (300, 60, 180, 120)
- مريض عنده داء السكري النوع 1: sugar_critical_low أعلى (مثل 70) لأنه أكثر حساسية
- الأدوية المُخفِّضة للضغط قد تجعل sugar_critical_low أعلى (خطر التفاعل)`;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const { patient_id } = await req.json();

    if (!patient_id) {
      return new Response(JSON.stringify({ error: "patient_id required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    // ──── 1. جلب الملف الطبي الكامل ────
    const { data: patient, error: patientError } = await supabase
      .from("patients")
      .select(`
        date_of_birth, gender,
        chronic_conditions, allergies,
        sugar_min, sugar_max,
        bp_systolic_max, bp_diastolic_max
      `)
      .eq("id", patient_id)
      .single();

    if (patientError || !patient) {
      return new Response(JSON.stringify({ error: "Patient not found" }), {
        status: 404,
        headers: { "Content-Type": "application/json" },
      });
    }

    const { data: medications } = await supabase
      .from("medications")
      .select("name, dosage, frequency")
      .eq("patient_id", patient_id)
      .eq("is_active", true);

    // ──── 2. حساب العمر ────
    const age = patient.date_of_birth
      ? Math.floor(
          (Date.now() - new Date(patient.date_of_birth).getTime()) /
            (365.25 * 24 * 60 * 60 * 1000),
        )
      : null;

    // ──── 3. بناء السياق الطبي ────
    const medicalContext = `
معلومات المريض:
- العمر: ${age ? `${age} سنة` : "غير محدد"}
- الجنس: ${patient.gender === "male" ? "ذكر" : "أنثى"}
- الأمراض المزمنة: ${patient.chronic_conditions?.join("، ") || "لا يوجد"}
- الحساسية: ${patient.allergies?.join("، ") || "لا يوجد"}

الأدوية الحالية:
${medications?.map((m: { name: string; dosage: string; frequency: string }) => `- ${m.name} ${m.dosage} (${m.frequency})`).join("\n") || "لا توجد أدوية"}

حدود القراءات الطبيعية المضبوطة:
- السكر الطبيعي: ${patient.sugar_min}-${patient.sugar_max} mg/dL
- الضغط الطبيعي: أقل من ${patient.bp_systolic_max}/${patient.bp_diastolic_max} mmHg

حدد الحدود الحرجة الطارئة الشخصية لهذا المريض تحديداً.`;

    // ──── 4. استدعاء الذكاء الاصطناعي ────
    const geminiRes = await fetch(GEMINI_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        system_instruction: { parts: [{ text: CALIBRATION_PROMPT }] },
        contents: [{ role: "user", parts: [{ text: medicalContext }] }],
        generationConfig: {
          temperature: 0.1, // منخفض جداً — قرارات طبية تحتاج ثبات
          maxOutputTokens: 300,
          responseMimeType: "application/json",
        },
      }),
    });

    const geminiData = await geminiRes.json();
    const rawText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!rawText) {
      throw new Error("Gemini returned empty response");
    }

    let thresholds: CalibratedThresholds;
    try {
      thresholds = JSON.parse(rawText);
    } catch {
      throw new Error(`Invalid JSON from Gemini: ${rawText}`);
    }

    // ──── 5. التحقق من معقولية القيم (ضمان السلامة) ────
    // الذكاء الاصطناعي لا يُعطى صلاحية ضبط حدود غير آمنة
    const validated: CalibratedThresholds = {
      sugar_critical_high: Math.min(Math.max(thresholds.sugar_critical_high, 200), 400),
      sugar_critical_low: Math.min(Math.max(thresholds.sugar_critical_low, 40), 80),
      bp_critical_systolic: Math.min(Math.max(thresholds.bp_critical_systolic, 160), 210),
      bp_critical_diastolic: Math.min(Math.max(thresholds.bp_critical_diastolic, 100), 140),
      ai_note: thresholds.ai_note || "تم ضبط الحدود بناءً على الملف الطبي",
    };

    // ──── 6. حفظ الحدود في ملف المريض ────
    const { error: updateError } = await supabase
      .from("patients")
      .update({
        sugar_critical_high: validated.sugar_critical_high,
        sugar_critical_low: validated.sugar_critical_low,
        bp_critical_systolic: validated.bp_critical_systolic,
        bp_critical_diastolic: validated.bp_critical_diastolic,
        thresholds_calibrated_at: new Date().toISOString(),
        thresholds_ai_note: validated.ai_note,
      })
      .eq("id", patient_id);

    if (updateError) throw updateError;

    return new Response(JSON.stringify(validated), {
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
    });
  } catch (error) {
    console.error("Calibration error:", error);
    return new Response(JSON.stringify({ error: "Calibration failed" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
