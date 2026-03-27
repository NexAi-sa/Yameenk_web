import Header from "@/components/Header";
import Footer from "@/components/Footer";
import { getDictionary, type Locale } from "@/lib/dictionaries";

export default function TermsPage({ params }: { params: { lang: string } }) {
  const lang = (params.lang === "en" ? "en" : "ar") as Locale;
  const dict = getDictionary(lang);

  const sections = lang === "en" ? [
    { title: "1. Introduction", content: "Welcome to Yameenak. By using this application or website, you agree to comply with the following terms and conditions. Please read them carefully." },
    { title: "2. Nature of Service", content: "Yameenak is an intermediary platform connecting care seekers (users) with healthcare and home care service providers. We strive to ensure the quality of service providers but do not directly provide medical care." },
    { title: "3. User Account", content: "Accurate and correct information must be provided when creating an account. The user is fully responsible for maintaining the confidentiality of their login credentials and all activities conducted through their account." },
    { title: "4. Booking and Cancellation Policy", content: "All bookings are subject to service provider availability. Cancellation fees may apply if the appointment is cancelled shortly before the agreed execution time." },
    { title: "5. Liability", content: "While we do our utmost to ensure the accuracy of documented medical data, the user acknowledges that Yameenak is not a substitute for specialized medical consultation in extreme emergencies." },
  ] : [
    { title: "1. مقدمة", content: "مرحباً بكم في يمينك. باستخدامكم لهذا التطبيق أو الموقع الإلكتروني، فإنكم توافقون على الالتزام بالشروط والأحكام التالية. يرجى قراءتها بعناية." },
    { title: "2. طبيعة الخدمة", content: "يمينك هو منصة وسيطة تربط بين طالبي الرعاية (المستخدمين) ومقدمي خدمات الرعاية الصحية والمنزلية. نحن نسعى لضمان جودة مقدمي الخدمة ولكننا لا نقدم الرعاية الطبية بشكل مباشر." },
    { title: "3. حساب المستخدم", content: "يجب تقديم معلومات دقيقة وصحيحة عند إنشاء الحساب. المستخدم مسؤول تماماً عن الحفاظ على سرية بيانات الدخول الخاصة به وعن كافة الأنشطة التي تتم من خلال حسابه." },
    { title: "4. سياسة الحجز والإلغاء", content: "تخضع جميع الحجوزات لمدى توفر مقدمي الخدمة. قد يتم فرض رسوم إلغاء في حال تم إلغاء الموعد قبل وقت قصير من موعد التنفيذ المتفق عليه." },
    { title: "5. المسؤولية", content: "بينما نبذل قصارى جهدنا لضمان دقة البيانات الطبية الموثقة، إلا أن المستخدم يقر بأن يمينك ليس بديلاً عن الاستشارة الطبية المتخصصة في حالات الطوارئ القصوى." },
  ];

  return (
    <main className="min-h-screen bg-slate-50">
      <Header dict={dict} lang={lang} />
      <div className="pt-32 pb-20">
        <div className="container mx-auto px-4 max-w-4xl">
          <div className="bg-white rounded-3xl p-8 md:p-12 shadow-sm border border-slate-100">
            <h1 className="text-3xl font-black text-brand-blue mb-8">{dict.terms.title}</h1>
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
