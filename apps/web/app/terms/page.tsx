import Header from "@/components/Header";
import Footer from "@/components/Footer";

export default function TermsPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <Header />
      <div className="pt-32 pb-20">
        <div className="container mx-auto px-4 max-w-4xl">
          <div className="bg-white rounded-3xl p-8 md:p-12 shadow-sm border border-slate-100">
            <h1 className="text-3xl font-black text-brand-blue mb-8">شروط الاستخدام</h1>
            
            <div className="prose prose-slate prose-lg max-w-none space-y-8 text-slate-600">
              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">1. مقدمة</h2>
                <p>مرحباً بكم في يمينك. باستخدامكم لهذا التطبيق أو الموقع الإلكتروني، فإنكم توافقون على الالتزام بالشروط والأحكام التالية. يرجى قراءتها بعناية.</p>
              </section>

              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">2. طبيعة الخدمة</h2>
                <p>يمينك هو منصة وسيطة تربط بين طالبي الرعاية (المستخدمين) ومقدمي خدمات الرعاية الصحية والمنزلية. نحن نسعى لضمان جودة مقدمي الخدمة ولكننا لا نقدم الرعاية الطبية بشكل مباشر.</p>
              </section>

              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">3. حساب المستخدم</h2>
                <p>يجب تقديم معلومات دقيقة وصحيحة عند إنشاء الحساب. المستخدم مسؤول تماماً عن الحفاظ على سرية بيانات الدخول الخاصة به وعن كافة الأنشطة التي تتم من خلال حسابه.</p>
              </section>

              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">4. سياسة الحجز والإلغاء</h2>
                <p>تخضع جميع الحجوزات لمدى توفر مقدمي الخدمة. قد يتم فرض رسوم إلغاء في حال تم إلغاء الموعد قبل وقت قصير من موعد التنفيذ المتفق عليه.</p>
              </section>

              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">5. المسؤولية</h2>
                <p>بينما نبذل قصارى جهدنا لضمان دقة البيانات الطبية الموثقة، إلا أن المستخدم يقر بأن يمينك ليس بديلاً عن الاستشارة الطبية المتخصصة في حالات الطوارئ القصوى.</p>
              </section>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </main>
  );
}
