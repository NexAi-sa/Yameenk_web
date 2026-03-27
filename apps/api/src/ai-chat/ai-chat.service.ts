import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Anthropic from '@anthropic-ai/sdk';
import { SupabaseService } from '../supabase/supabase.service';
import { ConsentService } from '../privacy/consent.service';
import { AuditService } from '../privacy/audit.service';
import { anonymizePatient, type AnonymizedPatient } from '../privacy/anonymizer.util';

@Injectable()
export class AiChatService {
  private anthropic: Anthropic;

  constructor(
    private supabase: SupabaseService,
    private config: ConfigService,
    private consentService: ConsentService,
    private auditService: AuditService,
  ) {
    this.anthropic = new Anthropic({
      apiKey: this.config.getOrThrow('ANTHROPIC_API_KEY'),
    });
  }

  async sendMessage(patientId: string, userId: string, userMessage: string) {
    // ✅ PDPL: التحقق من موافقة تحليل الذكاء الاصطناعي
    await this.consentService.requireConsent(userId, 'ai_analysis');

    // 1. Build anonymized patient context
    const context = await this.buildPatientContext(patientId);

    // 2. Fetch recent chat history
    const { data: history } = await this.supabase.db
      .from('chat_messages')
      .select('role, content')
      .eq('patient_id', patientId)
      .order('created_at', { ascending: false })
      .limit(10);

    const messages: Anthropic.MessageParam[] = [
      ...(history ?? [])
        .reverse()
        .map((m) => ({ role: m.role as 'user' | 'assistant', content: m.content })),
      { role: 'user', content: userMessage },
    ];

    // 3. Call Claude with ANONYMIZED patient-aware system prompt
    const response = await this.anthropic.messages.create({
      model: 'claude-sonnet-4-6',
      max_tokens: 1024,
      system: this.buildSystemPrompt(context),
      messages,
    });

    const assistantMessage =
      response.content[0].type === 'text' ? response.content[0].text : '';

    // 4. Save both messages to DB
    await this.supabase.db.from('chat_messages').insert([
      { patient_id: patientId, user_id: userId, role: 'user', content: userMessage },
      { patient_id: patientId, user_id: userId, role: 'assistant', content: assistantMessage },
    ]);

    // ✅ PDPL: تسجيل النشاط في سجل التدقيق
    await this.auditService.log({
      userId,
      action: 'ai_chat_message',
      resourceType: 'chat_message',
      resourceId: patientId,
      metadata: { message_length: userMessage.length },
    });

    return { message: assistantMessage };
  }

  /**
   * System Prompt مع بيانات مجهولة الهوية
   * ✅ PDPL: لا يتم إرسال الاسم أو الهوية أو رقم الجوال لـ Claude
   */
  private buildSystemPrompt(context: AnonymizedPatientContext): string {
    const { anonymizedPatient, medications, lastReadings } = context;

    const medsText =
      medications.length > 0
        ? medications.map((m) => `  - ${m.name} ${m.dosage} (${m.frequency})`).join('\n')
        : '  - لا توجد أدوية مسجلة';

    const readingsText =
      lastReadings.length > 0
        ? lastReadings
            .slice(0, 5)
            .map(
              (r) =>
                `  - ${this.readingTypeAr(r.type)}: ${r.value_1}${r.value_2 ? `/${r.value_2}` : ''} ${r.unit} (${this.timeAgo(r.recorded_at)})`,
            )
            .join('\n')
        : '  - لا توجد قراءات مسجلة';

    return `أنت "يمينك" — مساعد ذكاء اصطناعي متخصص في طب كبار السن (Geriatrics) في المملكة العربية السعودية.
دورك هو تحليل السجلات الطبية، تقديم رؤى صحية، ومساعدة مقدمي الرعاية والمرضى في رعاية كبار السن.

⚠️ ملاحظة خصوصية: تم إخفاء هوية المريض وفقاً لنظام حماية البيانات الشخصية (PDPL).

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

معلومات المريض الحالي:
- المريض: ${anonymizedPatient.alias}
- الفئة العمرية: ${anonymizedPatient.age_range}
- الأمراض المزمنة: ${anonymizedPatient.chronic_conditions?.join('، ') || 'لا يوجد'}
- الحساسية: ${anonymizedPatient.allergies?.join('، ') || 'لا يوجد'}

الأدوية الحالية:
${medsText}

آخر القراءات الصحية:
${readingsText}

حدود القراءات الطبيعية لهذا المريض:
- السكر: ${anonymizedPatient.sugar_min}–${anonymizedPatient.sugar_max} mg/dL
- الضغط: أقل من ${anonymizedPatient.bp_systolic_max}/${anonymizedPatient.bp_diastolic_max} mmHg

## قواعد التفاعل:
1. **ابقَ ضمن تخصصك فقط** — طب كبار السن. لا تجب على أسئلة خارج هذا المجال
2. **ارجع دائماً للسجل الطبي** قبل الإجابة على أي سؤال. استند إلى البيانات المتوفرة
3. إذا احتجت **معلومات إضافية** عن المريض قبل الإجابة بشكل صحيح، اطلبها صراحة
4. عندما يقدم المستخدم **معلومات جديدة** عن المريض، قيّم إذا كانت مفيدة لإضافتها للسجل وأشر لذلك
5. **لا تفترض** معلومات غير موجودة في السجل الطبي
6. قدّم توصيات **مبنية على الأدلة** ومناسبة لكبار السن
7. أجب بالعربية — واضح ولطيف ومناسب لكبار السن وأسرهم
8. لا تشخّص أبداً — قدّم إرشادات عامة ووجّه للطبيب أو الطوارئ عند الضرورة
9. إذا سأل عن قراءة حديثة، استشهد بالأرقام الفعلية
10. لا تذكر اسم المريض الحقيقي أبداً — استخدم "حضرتك" أو "والدك/والدتك"

## التنبؤ بالأمراض الصامتة:
- ارتفاع ضغط مستمر + سكري → خطر كلوي (Creatinine + eGFR)
- وزن ينخفض بدون سبب → فحص غدة درقية + استبعاد أورام
- قراءات متذبذبة بشدة → عدم انتظام بالأدوية أو مشكلة امتصاص
- ضغط منخفض مفاجئ → جرعة زائدة أو جفاف
- سكر صباحي مرتفع مع طبيعي مسائي → ظاهرة الفجر
- نقص وزن + ضعف شهية + إرهاق → فقر دم أو سوء تغذية
- دوخة متكررة + ضغط منخفض → خطر سقوط عالي

## تنسيق الإجابة:
قدّم إجابتك متضمنة عند الحاجة:
- 🚨 **تنبيه** — حالة طارئة تتطلب اهتماماً فورياً
- 🔮 **تنبؤ** — مخاطر أمراض صامتة مكتشفة
- ❓ **معلومات مطلوبة** — تحتاج تفاصيل إضافية
- 📋 **اقتراح تحديث السجل** — معلومات جديدة يجب حفظها`;
  }

  /**
   * بناء سياق المريض مع إخفاء الهوية
   * ✅ PDPL: يتم إزالة المعرفات الشخصية قبل بناء prompt
   */
  private async buildPatientContext(patientId: string): Promise<AnonymizedPatientContext> {
    const [{ data: patient }, { data: medications }, { data: lastReadings }] = await Promise.all([
      this.supabase.db.from('patients').select('*').eq('id', patientId).single(),
      this.supabase.db
        .from('medications')
        .select('name, dosage, frequency')
        .eq('patient_id', patientId)
        .eq('is_active', true),
      this.supabase.db
        .from('health_readings')
        .select('type, value_1, value_2, unit, recorded_at')
        .eq('patient_id', patientId)
        .order('recorded_at', { ascending: false })
        .limit(10),
    ]);

    // ✅ PDPL: إخفاء الهوية
    const anonymizedPatient = anonymizePatient(patient!);

    return {
      anonymizedPatient,
      medications: medications ?? [],
      lastReadings: lastReadings ?? [],
    };
  }

  private readingTypeAr(type: string): string {
    const map: Record<string, string> = {
      blood_sugar: 'السكر',
      blood_pressure: 'الضغط',
      weight: 'الوزن',
      temperature: 'الحرارة',
    };
    return map[type] ?? type;
  }

  private timeAgo(dateStr: string): string {
    const diff = Date.now() - new Date(dateStr).getTime();
    const hours = Math.floor(diff / 3600000);
    if (hours < 1) return 'منذ قليل';
    if (hours < 24) return `منذ ${hours} ساعة`;
    return `منذ ${Math.floor(hours / 24)} يوم`;
  }
}

interface AnonymizedPatientContext {
  anonymizedPatient: AnonymizedPatient;
  medications: any[];
  lastReadings: any[];
}

