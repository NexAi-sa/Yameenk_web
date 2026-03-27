import Link from "next/link";
import type { Dictionary } from "@/lib/dictionaries";

export default function Footer({ dict, lang }: { dict: Dictionary; lang: string }) {
  return (
    <footer className="bg-white pt-20 pb-10 border-t border-slate-100">
      <div className="container mx-auto px-4">
        <div className="grid md:grid-cols-4 gap-12 mb-16">
          <div className="space-y-6">
            <Link href={`/${lang}`} className="text-3xl font-black text-brand-blue">
              يمينك
            </Link>
            <p className="text-slate-500 leading-relaxed">{dict.footer.tagline}</p>
          </div>

          <div>
            <h4 className="font-bold text-brand-blue mb-6">{dict.footer.quickLinks}</h4>
            <ul className="space-y-4 text-slate-600">
              <li><Link href={`/${lang}`} className="hover:text-brand-teal transition-colors">{dict.header.home}</Link></li>
              <li><Link href={`/${lang}#features`} className="hover:text-brand-teal transition-colors">{dict.header.features}</Link></li>
              <li><Link href={`/${lang}#how-it-works`} className="hover:text-brand-teal transition-colors">{dict.header.howItWorks}</Link></li>
            </ul>
          </div>

          <div>
            <h4 className="font-bold text-brand-blue mb-6">{dict.footer.legal}</h4>
            <ul className="space-y-4 text-slate-600">
              <li><Link href={`/${lang}/terms`} className="hover:text-brand-teal transition-colors">{dict.footer.terms}</Link></li>
              <li><Link href={`/${lang}/privacy`} className="hover:text-brand-teal transition-colors">{dict.footer.privacy}</Link></li>
            </ul>
          </div>

          <div>
            <h4 className="font-bold text-brand-blue mb-6">{dict.footer.contactTitle}</h4>
            <ul className="space-y-4 text-slate-600">
              <li><Link href={`/${lang}/contact`} className="hover:text-brand-teal transition-colors">{dict.footer.helpCenter}</Link></li>
              <li><a href="mailto:yameenkapp@nexai-sa.com" className="hover:text-brand-teal transition-colors">yameenkapp@nexai-sa.com</a></li>
            </ul>
          </div>
        </div>

        <div className="pt-10 border-t border-slate-50 text-center text-slate-400 font-medium">
          <p>{dict.footer.copyright}</p>
        </div>
      </div>
    </footer>
  );
}
