import Link from "next/link";

export default function Footer() {
  const currentYear = new Date().getFullYear();
  
  return (
    <footer className="bg-white pt-20 pb-10 border-t border-slate-100">
      <div className="container mx-auto px-4">
        <div className="grid md:grid-cols-4 gap-12 mb-16">
          <div className="space-y-6">
            <Link href="/" className="text-3xl font-black text-brand-blue">
              يمينك
            </Link>
            <p className="text-slate-500 leading-relaxed">
              سندك الذكي لرعاية من تحب.. طمأنينة لك، وعناية تليق بهم.
            </p>
          </div>
          
          <div>
            <h4 className="font-bold text-brand-blue mb-6">روابط سريعة</h4>
            <ul className="space-y-4 text-slate-600">
              <li><Link href="/" className="hover:text-brand-teal transition-colors">الرئيسية</Link></li>
              <li><Link href="/#features" className="hover:text-brand-teal transition-colors">المميزات</Link></li>
              <li><Link href="/#how-it-works" className="hover:text-brand-teal transition-colors">كيف يعمل</Link></li>
            </ul>
          </div>
          
          <div>
            <h4 className="font-bold text-brand-blue mb-6">قانوني</h4>
            <ul className="space-y-4 text-slate-600">
              <li><Link href="/terms" className="hover:text-brand-teal transition-colors">شروط الاستخدام</Link></li>
              <li><Link href="/privacy" className="hover:text-brand-teal transition-colors">سياسة الخصوصية</Link></li>
            </ul>
          </div>
          
          <div>
            <h4 className="font-bold text-brand-blue mb-6">تواصل معنا</h4>
            <ul className="space-y-4 text-slate-600">
              <li><Link href="/contact" className="hover:text-brand-teal transition-colors">مركز المساعدة</Link></li>
              <li><a href="mailto:yameenkapp@nexai-sa.com" className="hover:text-brand-teal transition-colors">yameenkapp@nexai-sa.com</a></li>
            </ul>
          </div>
        </div>
        
        <div className="pt-10 border-t border-slate-50 text-center text-slate-400 font-medium">
          <p>© {currentYear} يمينك - جميع الحقوق محفوظة لشكة نكساي للتقنية</p>
        </div>
      </div>
    </footer>
  );
}
