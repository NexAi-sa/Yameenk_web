import { MessageCircle, ArrowLeft } from "lucide-react";

export default function Hero() {
  return (
    <section className="pt-32 pb-20 overflow-hidden">
      <div className="container mx-auto px-4">
        <div className="max-w-4xl mx-auto text-center space-y-8">
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-brand-teal/10 text-brand-teal font-bold text-sm mb-4">
            <span className="relative flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-brand-teal opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-brand-teal"></span>
            </span>
            أول نظام تشغيل للرعاية في السعودية
          </div>
          
          <h1 className="text-4xl md:text-6xl font-black text-brand-blue leading-tight text-balance">
            سندك الذكي لرعاية من تحب.. <span className="text-brand-teal">طمأنينة لك، وعناية تليق بهم</span>
          </h1>
          
          <p className="text-xl text-slate-600 leading-relaxed max-w-2xl mx-auto text-balance">
            نظام تشغيل متكامل يربط بينك وبين والديك، يتنبأ باحتياجاتهم الصحية، ويوفر أفضل خدمات الرعاية المنزلية والنقل المتخصص.
          </p>
          
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-4">
            <button className="w-full sm:w-auto bg-brand-teal text-white px-8 py-4 rounded-2xl font-bold text-lg hover:bg-teal-700 transition-all shadow-xl shadow-teal-100 flex items-center justify-center gap-2">
              سجل في قائمة الانتظار
              <ArrowLeft className="w-5 h-5" />
            </button>
            <button className="w-full sm:w-auto bg-white border-2 border-slate-100 text-slate-700 px-8 py-4 rounded-2xl font-bold text-lg hover:bg-slate-50 transition-all flex items-center justify-center gap-2">
              <MessageCircle className="w-5 h-5 text-[#25D366]" />
              تواصل معنا عبر واتساب
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
