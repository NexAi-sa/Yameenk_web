import Header from "@/components/Header";
import Footer from "@/components/Footer";

export default function PrivacyPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <Header />
      <div className="pt-32 pb-20">
        <div className="container mx-auto px-4 max-w-4xl">
          <div className="bg-white rounded-3xl p-8 md:p-12 shadow-sm border border-slate-100">
            <h1 className="text-3xl font-black text-brand-blue mb-8">سياسة الخصوصية</h1>
            
            <div className="prose prose-slate prose-lg max-w-none space-y-8 text-slate-600">
              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">1. حماية البيانات</h2>
                <p>في يمينك، نولي خصوصية بياناتكم الصحية أهمية قصوى. يتم تشفير جميع المعلومات الطبية والحساسة وتخزينها وفقاً لأعلى معايير الأمن السيبراني المعمول بها في المملكة العربية السعودية.</p>
              </section>

              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">2. نظام حماية البيانات الشخصية (PDPL)</h2>
                <p>نلتزم بشكل كامل بنظام حماية البيانات الشخصية السعودي. لا يتم مشاركة بياناتكم مع أي طرف ثالث دون موافقة صريحة منكم، وفقط لغرض تقديم خدمة الرعاية المطلوبة.</p>
              </section>

              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">3. المعلومات التي نجمعها</h2>
                <p>نجمع المعلومات الضرورية فقط لتقديم الخدمة، بما في ذلك: الاسم، رقم الهاتف، الموقع الجغرافي، والتاريخ الطبي اللازم لمقدم الرعاية.</p>
              </section>

              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">4. حقوق المستخدم</h2>
                <p>لديك الحق في الوصول إلى بياناتك، تصحيحها، أو طلب مسحها في أي وقت من خلال إعدادات التطبيق أو التواصل مع فريق الدعم.</p>
              </section>

              <section>
                <h2 className="text-xl font-bold text-brand-blue mb-4">5. التحديثات</h2>
                <p>قد نقوم بتحديث سياسة الخصوصية بشكل دوري لمواكبة التطورات التقنية والتشريعية. سيتم إخطاركم بأي تغييرات جوهرية.</p>
              </section>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </main>
  );
}
