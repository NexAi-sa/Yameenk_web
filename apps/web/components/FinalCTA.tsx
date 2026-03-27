import { Heart } from "lucide-react";

export default function FinalCTA() {
  return (
    <section className="py-24 bg-brand-blue relative overflow-hidden">
      <div className="absolute top-0 right-0 w-96 h-96 bg-brand-teal/10 blur-[120px] rounded-full -mr-48 -mt-48" />
      <div className="absolute bottom-0 left-0 w-96 h-96 bg-white/5 blur-[120px] rounded-full -ml-48 -mb-48" />
      
      <div className="container mx-auto px-4 text-center relative z-10 space-y-10">
        <div className="w-20 h-20 bg-brand-teal/20 backdrop-blur-xl rounded-2xl flex items-center justify-center mx-auto mb-8 animate-bounce">
          <Heart className="w-10 h-10 text-brand-teal fill-brand-teal" />
        </div>
        
        <h2 className="text-4xl md:text-5xl font-black text-white leading-tight">
          لا تترك رعايتهم للصدفة.. <br />
          <span className="text-brand-teal">كن بجانبهم حتى وأنت بعيد.</span>
        </h2>
        
        <p className="text-xl text-slate-300 max-w-2xl mx-auto">
          انضم إلى قائمة الانتظار وكن أول من يستمتع بتجربة الرعاية المبتكرة مع يمينك.
        </p>
        
        <div className="flex flex-col sm:flex-row items-center justify-center gap-6">
          <button className="w-full sm:w-auto bg-brand-teal text-white px-12 py-5 rounded-2xl font-bold text-xl hover:bg-teal-700 transition-all shadow-2xl shadow-teal-900/40">
            احجز مكانك الآن
          </button>
          <button className="w-full sm:w-auto text-white border-b-2 border-white/20 hover:border-white transition-all pb-1 font-bold text-lg">
            تحدث مع فريقنا
          </button>
        </div>
      </div>
    </section>
  );
}
