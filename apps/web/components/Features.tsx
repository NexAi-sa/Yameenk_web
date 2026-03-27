import { Activity, ShieldCheck, ClipboardList, ShoppingCart } from "lucide-react";
import type { Dictionary } from "@/lib/dictionaries";

const icons = [ClipboardList, Activity, ShieldCheck, ShoppingCart];
const colors = ["blue", "teal", "blue", "teal"];

export default function Features({ dict }: { dict: Dictionary }) {
  return (
    <section id="features" className="py-24 bg-white">
      <div className="container mx-auto px-4">
        <div className="text-center max-w-3xl mx-auto mb-16 space-y-4">
          <h2 className="text-3xl md:text-4xl font-black text-brand-blue">{dict.features.title}</h2>
          <p className="text-lg text-slate-600">{dict.features.subtitle}</p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {dict.features.items.map((feature, index) => {
            const Icon = icons[index];
            const color = colors[index];
            return (
              <div
                key={index}
                className="p-8 rounded-3xl border border-slate-100 hover:border-brand-teal/20 hover:shadow-2xl hover:shadow-teal-50 transition-all group"
              >
                <div className={`w-14 h-14 rounded-2xl flex items-center justify-center mb-6 transition-transform group-hover:scale-110 ${
                  color === "teal" ? "bg-teal-50 text-brand-teal" : "bg-blue-50 text-brand-blue"
                }`}>
                  <Icon className="w-8 h-8" />
                </div>
                <h3 className="text-xl font-bold text-brand-blue mb-3">{feature.title}</h3>
                <p className="text-slate-600 leading-relaxed">{feature.description}</p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
