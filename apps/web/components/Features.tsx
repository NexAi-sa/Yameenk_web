import { Activity, ShieldCheck, ClipboardList, ShoppingCart } from "lucide-react";

const features = [
  {
    title: "الملف الطبي الموحد",
    description: "ذاكرة مركزية للأسرة تحفظ الأمراض المزمنة والأدوية وتشاركها مع مقدمي الرعاية.",
    icon: ClipboardList,
    color: "blue",
  },
  {
    title: "المتابعة الصحية الذكية",
    description: "جدول يومي لقراءات السكر والضغط مع سياسة (اللا ضجيج) - نرسل لك تنبيهات واتساب فورية فقط عند الخطر.",
    icon: Activity,
    color: "teal",
  },
  {
    title: "تقارير الطمأنينة الأسبوعية",
    description: "ملخص أسبوعي مبسط يوضح اتجاهات الحالة الصحية لوالديك.",
    icon: ShieldCheck,
    color: "blue",
  },
  {
    title: "سوق الرعاية الموثوق",
    description: "احجز خدمات التمريض المنزلي، النقل الطبي للمقعدين، والمرافق المدرب بضغطة زر.",
    icon: ShoppingCart,
    color: "teal",
  },
];

export default function Features() {
  return (
    <section id="features" className="py-24 bg-white">
      <div className="container mx-auto px-4">
        <div className="text-center max-w-3xl mx-auto mb-16 space-y-4">
          <h2 className="text-3xl md:text-4xl font-black text-brand-blue">رعاية متكاملة بذكاء واهتمام</h2>
          <p className="text-lg text-slate-600">صممنا يمينك ليكون الحل الشامل لكل احتياجات كبار السن وذوي الاحتياجات الخاصة.</p>
        </div>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {features.map((feature, index) => (
            <div 
              key={index} 
              className="p-8 rounded-3xl border border-slate-100 hover:border-brand-teal/20 hover:shadow-2xl hover:shadow-teal-50 transition-all group"
            >
              <div className={`w-14 h-14 rounded-2xl flex items-center justify-center mb-6 transition-transform group-hover:scale-110 ${
                feature.color === "teal" ? "bg-teal-50 text-brand-teal" : "bg-blue-50 text-brand-blue"
              }`}>
                <feature.icon className="w-8 h-8" />
              </div>
              <h3 className="text-xl font-bold text-brand-blue mb-3">{feature.title}</h3>
              <p className="text-slate-600 leading-relaxed">{feature.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
