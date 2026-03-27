import Header from "@/components/Header";
import Footer from "@/components/Footer";
import { getDictionary, type Locale } from "@/lib/dictionaries";

export default function PrivacyPage({ params }: { params: { lang: string } }) {
  const lang = (params.lang === "en" ? "en" : "ar") as Locale;
  const dict = getDictionary(lang);

  const sections = lang === "en" ? [
    { title: "1. Data Protection", content: "At Yameenak, we take the privacy of your health data very seriously. All medical and sensitive information is encrypted and stored according to the highest cybersecurity standards in the Kingdom of Saudi Arabia." },
    { title: "2. Personal Data Protection Law (PDPL)", content: "We fully comply with the Saudi Personal Data Protection Law. Your data is never shared with third parties without your explicit consent, and only for the purpose of providing the requested care service." },
    { title: "3. Information We Collect", content: "We collect only the information necessary to provide our services, including: name, phone number, geographic location, and medical history required for the care provider." },
    { title: "4. User Rights", content: "You have the right to access, correct, or request deletion of your data at any time through the app settings or by contacting our support team." },
    { title: "5. Updates", content: "We may update the privacy policy periodically to keep pace with technical and legislative developments. You will be notified of any significant changes." },
  ] : [
    { title: "1. حماية البيانات", content: "في يمينك، نولي خصوصية بياناتكم الصحية أهمية قصوى. يتم تشفير جميع المعلومات الطبية والحساسة وتخزينها وفقاً لأعلى معايير الأمن السيبراني المعمول بها في المملكة العربية السعودية." },
    { title: "2. نظام حماية البيانات الشخصية (PDPL)", content: "نلتزم بشكل كامل بنظام حماية البيانات الشخصية السعودي. لا يتم مشاركة بياناتكم مع أي طرف ثالث دون موافقة صريحة منكم، وفقط لغرض تقديم خدمة الرعاية المطلوبة." },
    { title: "3. المعلومات التي نجمعها", content: "نجمع المعلومات الضرورية فقط لتقديم الخدمة، بما في ذلك: الاسم، رقم الهاتف، الموقع الجغرافي، والتاريخ الطبي اللازم لمقدم الرعاية." },
    { title: "4. حقوق المستخدم", content: "لديك الحق في الوصول إلى بياناتك، تصحيحها، أو طلب مسحها في أي وقت من خلال إعدادات التطبيق أو التواصل مع فريق الدعم." },
    { title: "5. التحديثات", content: "قد نقوم بتحديث سياسة الخصوصية بشكل دوري لمواكبة التطورات التقنية والتشريعية. سيتم إخطاركم بأي تغييرات جوهرية." },
  ];

  return (
    <main className="min-h-screen bg-slate-50">
      <Header dict={dict} lang={lang} />
      <div className="pt-32 pb-20">
        <div className="container mx-auto px-4 max-w-4xl">
          <div className="bg-white rounded-3xl p-8 md:p-12 shadow-sm border border-slate-100">
            <h1 className="text-3xl font-black text-brand-blue mb-8">{dict.privacyPage.title}</h1>
            <div className="prose prose-slate prose-lg max-w-none space-y-8 text-slate-600">
              {sections.map((s, i) => (
                <section key={i}>
                  <h2 className="text-xl font-bold text-brand-blue mb-4">{s.title}</h2>
                  <p>{s.content}</p>
                </section>
              ))}
            </div>
          </div>
        </div>
      </div>
      <Footer dict={dict} lang={lang} />
    </main>
  );
}
