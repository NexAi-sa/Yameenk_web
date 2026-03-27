import type { Dictionary } from "@/lib/dictionaries";

export default function SocialProof({ dict }: { dict: Dictionary }) {
  const partners = ["يسر", "نعاون", "عضيد", "مبادر", "فقيه"];

  return (
    <section className="py-12 bg-slate-50 border-y border-slate-100">
      <div className="container mx-auto px-4">
        <p className="text-center text-slate-500 font-bold mb-8">{dict.socialProof.title}</p>
        <div className="flex flex-wrap justify-center items-center gap-8 md:gap-16 opacity-60">
          {partners.map((partner) => (
            <div key={partner} className="text-2xl font-black text-slate-400 grayscale hover:grayscale-0 transition-all cursor-default">
              {partner}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
