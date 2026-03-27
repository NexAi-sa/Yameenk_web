import Link from "next/link";

export default function Header() {
  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-100">
      <div className="container mx-auto px-4 h-20 flex items-center justify-between">
        <div className="flex items-center gap-8">
          <Link href="/" className="text-2xl font-bold text-brand-blue">
            يمينك
          </Link>
          <nav className="hidden md:flex items-center gap-6 text-slate-600 font-medium">
            <Link href="/" className="hover:text-brand-teal transition-colors">الرئيسية</Link>
            <Link href="#features" className="hover:text-brand-teal transition-colors">المميزات</Link>
            <Link href="#how-it-works" className="hover:text-brand-teal transition-colors">كيف يعمل</Link>
            <Link href="/contact" className="hover:text-brand-teal transition-colors">تواصل معنا</Link>
          </nav>
        </div>
        <button className="bg-brand-blue text-white px-6 py-2.5 rounded-full font-bold hover:bg-slate-800 transition-all shadow-lg shadow-slate-200">
          حمل التطبيق
        </button>
      </div>
    </header>
  );
}
