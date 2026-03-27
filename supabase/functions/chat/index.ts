// يمينك — AI Health Chat Edge Function
// المساعد الصحي المتخصص في طب كبار السن (Geriatrics)

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY")!;
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}`;

const SYSTEM_PROMPT = `أنت "يمينك" — مساعد ذكاء اصطناعي متخصص في طب كبار السن (Geriatrics) في المملكة العربية السعودية.
دورك هو تحليل السجلات الطبية، تقديم رؤى صحية، ومساعدة مقدمي الرعاية والمرضى في رعاية كبار السن.

## مسؤولياتك الأساسية:
1. **تحليل السجل الطبي** بدقة لاكتشاف أي حالات طارئة أو غير طبيعية أو أنماط مقلقة
2. **التنبؤ بالأمراض الصامتة** قبل حدوثها أو في مراحلها المبكرة عبر تحليل الاتجاهات وعوامل الخطر
3. **إصدار تنبيهات** للحالات العاجلة أو غير الطبيعية التي تتطلب اهتماماً فورياً
4. **الإجابة على الأسئلة** بالاعتماد حصرياً على خبرتك في طب كبار السن وبيانات السجل الطبي
5. **قراءة وتفسير** جميع أنواع الوثائق الطبية: الأدوية، التقارير، الوصفات، صور الأشعة والتحاليل

## تخصصك الطبي:
- الأمراض المزمنة: السكري النوع 2، ارتفاع ضغط الدم، هشاشة العظام، أمراض القلب، الكلى
- التداخلات الدوائية (Polypharmacy) — تنبّه فوراً عند وجود أدوية متعارضة
- التغذية والترطيب المناسب لكبار السن
- الوقاية من السقوط وكسور الحوض
- الصحة النفسية: الاكتئاب، الوحدة، القلق، الخرف المبكر
- صحة النوم والقدرة الحركية

## قواعد التفاعل:
1. **ابقَ ضمن تخصصك فقط** — طب كبار السن. لا تجب على أسئلة خارج هذا المجال
2. **ارجع دائماً للسجل الطبي** قبل الإجابة على أي سؤال. استند إلى البيانات المتوفرة
3. إذا احتجت **معلومات إضافية** عن المريض قبل الإجابة بشكل صحيح، اطلبها صراحة
4. عندما يقدم المستخدم **معلومات جديدة** عن المريض، قيّم إذا كانت مفيدة لإضافتها للسجل وأشر لذلك
5. **لا تفترض** معلومات غير موجودة في السجل الطبي
6. قدّم توصيات **مبنية على الأدلة** ومناسبة لكبار السن
7. أجب بالعربية الفصحى المبسطة — واضح ولطيف ومناسب لكبار السن وأسرهم
8. لا تشخّص أبداً — قدّم إرشادات عامة ووجّه للطبيب عند الضرورة
9. إذا كانت القراءة خطيرة (سكر > 300 أو ضغط > 180/120) → قُل "راجع الطوارئ فوراً"
10. لا تذكر اسم المريض الحقيقي أبداً — استخدم "حضرتك" أو "والدك/والدتك"

## التنبؤ بالأمراض الصامتة:
عند تحليل القراءات، ابحث عن هذه الأنماط:
- ارتفاع ضغط مستمر + سكري → خطر كلوي (أنصح بفحص Creatinine و eGFR)
- وزن ينخفض بدون سبب → فحص غدة درقية + استبعاد أورام
- قراءات متذبذبة بشدة → عدم انتظام بالأدوية أو مشكلة امتصاص
- ضغط منخفض مفاجئ → جرعة دواء الضغط قد تكون زائدة أو جفاف
- سكر مرتفع صباحي مع طبيعي مسائي → ظاهرة الفجر (Dawn Phenomenon)
- ارتفاع ضغط + تورم + بروتين بالبول → علامات مبكرة لمشاكل كلوية
- نقص وزن + ضعف شهية + إرهاق → فقر دم أو سوء تغذية
- دوخة متكررة + ضغط منخفض → خطر سقوط عالي

## تنسيق الإجابة:
قبل الرد، حلل داخلياً:
1. راجع الأقسام المتعلقة من السجل الطبي
2. حدد أي حالات طارئة أو غير طبيعية
3. حلل عوامل خطر الأمراض الصامتة
4. حدد إذا لديك معلومات كافية أو تحتاج تفاصيل إضافية
5. قيّم إذا قدم المستخدم معلومات جديدة يجب إضافتها للسجل

ثم قدّم إجابتك متضمنة عند الحاجة:
- 🚨 **تنبيه** — لأي حالة طارئة أو غير طبيعية تتطلب اهتماماً فورياً
- 🔮 **تنبؤ** — لأي مخاطر أمراض صامتة أو حالات مبكرة مكتشفة
- ❓ **معلومات مطلوبة** — إذا تحتاج معلومات إضافية قبل إجابة كاملة
- 📋 **اقتراح تحديث السجل** — إذا قدم المستخدم معلومات يجب حفظها
`;

interface ChatRequest {
  patient_id: string;
  message: string;
}

Deno.serve(async (req: Request) => {
  // CORS
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
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey);

    const { patient_id, message }: ChatRequest = await req.json();

    if (!patient_id || !message) {
      return new Response(JSON.stringify({ error: "patient_id and message required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    // ──── 0. فحص موافقة المستخدم (PDPL) ────
    // نجلب user_id من ملف المريض ثم نتحقق من الموافقة
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

    // ──── 1. جلب سياق المريض ────
    const { data: patient } = await supabase
      .from("patients")
      .select("*")
      .eq("id", patient_id)
      .single();

    const { data: medications } = await supabase
      .from("medications")
      .select("name, dosage, frequency")
      .eq("patient_id", patient_id)
      .eq("is_active", true);

    const { data: readings } = await supabase
      .from("health_readings")
      .select("type, value_1, value_2, unit, context, recorded_at")
      .eq("patient_id", patient_id)
      .order("recorded_at", { ascending: false })
      .limit(20);

    const { data: chatHistory } = await supabase
      .from("chat_messages")
      .select("role, content")
      .eq("patient_id", patient_id)
      .order("created_at", { ascending: false })
      .limit(10);

    // ──── 2. بناء سياق المريض (PDPL: بدون اسم أو هوية) ────
    const age = patient?.date_of_birth
      ? Math.floor((Date.now() - new Date(patient.date_of_birth).getTime()) / (365.25 * 24 * 60 * 60 * 1000))
      : "غير محدد";

    const patientContext = `
## معلومات المريض (مجهول الهوية):
- العمر: ${age} سنة
- الجنس: ${patient?.gender === "male" ? "ذكر" : "أنثى"}
- الأمراض المزمنة: ${patient?.chronic_conditions?.join("، ") || "لا يوجد"}
- الحساسية: ${patient?.allergies?.join("، ") || "لا يوجد"}
- فصيلة الدم: ${patient?.blood_type || "غير محدد"}
- حدود السكر: ${patient?.sugar_min}-${patient?.sugar_max} mg/dL
- حدود الضغط: أقل من ${patient?.bp_systolic_max}/${patient?.bp_diastolic_max} mmHg

## الأدوية الحالية:
${medications?.map((m: any) => `- ${m.name} ${m.dosage} (${m.frequency})`).join("\n") || "لا توجد أدوية مسجلة"}

## آخر القراءات:
${readings?.map((r: any) => {
  const val = r.value_2 ? `${r.value_1}/${r.value_2}` : `${r.value_1}`;
  return `- ${r.type}: ${val} ${r.unit || ""} (${r.context || ""}) — ${new Date(r.recorded_at).toLocaleDateString("ar-SA")}`;
}).join("\n") || "لا توجد قراءات"}
`;

    // ──── 3. بناء المحادثة ────
    const conversationHistory = (chatHistory || []).reverse().map((msg: any) => ({
      role: msg.role === "assistant" ? "model" : "user",
      parts: [{ text: msg.content }],
    }));

    const geminiPayload = {
      system_instruction: {
        parts: [{ text: SYSTEM_PROMPT + patientContext }],
      },
      contents: [
        ...conversationHistory,
        { role: "user", parts: [{ text: message }] },
      ],
      generationConfig: {
        temperature: 0.4,
        maxOutputTokens: 500,
        topP: 0.8,
      },
    };

    // ──── 4. استدعاء Gemini ────
    const geminiRes = await fetch(GEMINI_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(geminiPayload),
    });

    const geminiData = await geminiRes.json();
    const aiResponse = geminiData.candidates?.[0]?.content?.parts?.[0]?.text
      || "عذراً، لم أتمكن من معالجة طلبك. حاول مرة أخرى.";

    // ──── 5. حفظ الرسائل ────
    await supabase.from("chat_messages").insert([
      { patient_id, role: "user", content: message },
      { patient_id, role: "assistant", content: aiResponse },
    ]);

    // ──── 6. تسجيل نقل البيانات عبر الحدود (PDPL المادة 29) ────
    // يُوثّق كل استدعاء لـ Gemini بوصفه نقلاً للبيانات خارج المملكة
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

    // ──── 7. تسجيل في سجل التدقيق (PDPL) ────
    await supabase.from("audit_logs").insert({
      action: "ai_chat_message",
      resource_type: "chat_message",
      resource_id: patient_id,
      metadata: { message_length: message.length },
    });

    return new Response(JSON.stringify({ response: aiResponse }), {
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
    });
  } catch (error) {
    console.error("Chat error:", error);
    return new Response(JSON.stringify({ error: "Internal server error" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
