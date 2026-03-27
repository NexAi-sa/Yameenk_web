import Header from "@/components/Header";
import Footer from "@/components/Footer";
import { MessageCircle, Mail, Phone, Send } from "lucide-react";

export default function ContactPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <Header />
      <div className="pt-32 pb-20">
        <div className="container mx-auto px-4 max-w-6xl">
          <div className="text-center mb-16 space-y-4">
            <h1 className="text-4xl font-black text-brand-blue">تواصل معنا</h1>
            <p className="text-lg text-slate-600">نحن هنا للإجابة على استفساراتكم وتقديم الدعم اللازم.</p>
          </div>

          <div className="grid lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2 bg-white rounded-3xl p-8 md:p-12 shadow-sm border border-slate-100">
              <form className="space-y-6">
                <div className="grid md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <label className="text-slate-700 font-bold px-1">الاسم بالكامل</label>
                    <input type="text" className="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-brand-teal transition-all outline-none" placeholder="نورة ..." />
                  </div>
                  <div className="space-y-2">
                    <label className="text-slate-700 font-bold px-1">رقم الجوال</label>
                    <input type="tel" className="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-brand-teal transition-all outline-none" placeholder="05xxxxxxxx" />
                  </div>
                </div>
                <div className="space-y-2">
                  <label className="text-slate-700 font-bold px-1">الرسالة</label>
                  <textarea rows={5} className="w-full px-6 py-4 rounded-2xl bg-slate-50 border-none focus:ring-2 focus:ring-brand-teal transition-all outline-none" placeholder="كيف يمكننا مساعدتك؟"></textarea>
                </div>
                <button type="button" className="w-full bg-brand-blue text-white px-8 py-4 rounded-2xl font-bold text-lg hover:bg-slate-800 transition-all flex items-center justify-center gap-2">
                  <Send className="w-5 h-5" />
                  إرسال الرسالة
                </button>
              </form>
            </div>

            <div className="space-y-6">
              <div className="bg-brand-teal text-white rounded-3xl p-8 shadow-xl shadow-teal-100 space-y-6">
                <h3 className="text-2xl font-black">قنوات اتصال مباشرة</h3>
                <div className="space-y-6">
                  <a href="https://wa.me/966500000000" className="flex items-center gap-4 group">
                    <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform">
                      <MessageCircle className="w-6 h-6" />
                    </div>
                    <div>
                      <p className="text-teal-100 font-medium text-sm">واتساب</p>
                      <p className="font-bold">تحدث معنا مباشرة</p>
                    </div>
                  </a>
                  <a href="mailto:yameenkapp@nexai-sa.com" className="flex items-center gap-4 group">
                    <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform">
                      <Mail className="w-6 h-6" />
                    </div>
                    <div>
                      <p className="text-teal-100 font-medium text-sm">البريد الإلكتروني</p>
                      <p className="font-bold">yameenkapp@nexai-sa.com</p>
                    </div>
                  </a>
                </div>
              </div>
              
              <div className="bg-white rounded-3xl p-8 border border-slate-100 space-y-4">
                <h4 className="font-bold text-brand-blue">ساعات العمل</h4>
                <p className="text-slate-600">متاحون لخدمتكم على مدار الساعة من خلال قنوات الدعم الرقمية.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </main>
  );
}
