import type { Dictionary } from "@/lib/dictionaries";

export default function HowItWorks({ dict }: { dict: Dictionary }) {
  return (
    <section id="how-it-works" className="py-24 bg-slate-50">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16 space-y-4">
          <h2 className="text-3xl md:text-4xl font-black text-brand-blue">{dict.howItWorks.title}</h2>
          <p className="text-lg text-slate-600 max-w-2xl mx-auto">{dict.howItWorks.subtitle}</p>
        </div>

        <div className="grid md:grid-cols-3 gap-12 max-w-5xl mx-auto">
          {dict.howItWorks.steps.map((step, index) => (
            <div key={index} className="relative text-center space-y-6">
              <div className="w-20 h-20 bg-white shadow-2xl shadow-slate-200 rounded-3xl mx-auto flex items-center justify-center text-3xl font-black text-brand-teal relative z-10 border-2 border-slate-50">
                {index + 1}
              </div>
              {index < dict.howItWorks.steps.length - 1 && (
                <div className="hidden md:block absolute top-10 left-1/2 w-full h-[2px] bg-slate-200 -z-0" />
              )}
              <h3 className="text-2xl font-bold text-brand-blue">{step.title}</h3>
              <p className="text-slate-600 leading-relaxed">{step.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
