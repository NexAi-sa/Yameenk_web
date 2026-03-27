"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import type { Dictionary } from "@/lib/dictionaries";

export default function Header({ dict, lang }: { dict: Dictionary; lang: string }) {
  const pathname = usePathname();
  const switchLang = lang === "ar" ? "en" : "ar";
  const switchPath = pathname.replace(`/${lang}`, `/${switchLang}`);

  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-100">
      <div className="container mx-auto px-4 h-20 flex items-center justify-between">
        <div className="flex items-center gap-8">
          <Link href={`/${lang}`} className="text-2xl font-bold text-brand-blue">
            يمينك
          </Link>
          <nav className="hidden md:flex items-center gap-6 text-slate-600 font-medium">
            <Link href={`/${lang}`} className="hover:text-brand-teal transition-colors">{dict.header.home}</Link>
            <Link href={`/${lang}#features`} className="hover:text-brand-teal transition-colors">{dict.header.features}</Link>
            <Link href={`/${lang}#how-it-works`} className="hover:text-brand-teal transition-colors">{dict.header.howItWorks}</Link>
            <Link href={`/${lang}/contact`} className="hover:text-brand-teal transition-colors">{dict.header.contactUs}</Link>
          </nav>
        </div>
        <div className="flex items-center gap-4">
          <Link href={switchPath} className="text-sm font-bold text-brand-teal hover:underline transition-all">
            {dict.langSwitch}
          </Link>
          <button className="bg-brand-blue text-white px-6 py-2.5 rounded-full font-bold hover:bg-slate-800 transition-all shadow-lg shadow-slate-200">
            {dict.header.downloadApp}
          </button>
        </div>
      </div>
    </header>
  );
}
