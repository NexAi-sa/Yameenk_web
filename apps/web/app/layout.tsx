import type { Metadata } from "next";
import { Vazirmatn } from "next/font/google";
import "./globals.css";

const vazirmatn = Vazirmatn({ subsets: ["arabic"], variable: "--font-vazirmatn" });

export const metadata: Metadata = {
  title: "يمينك | نظام تشغيل الرعاية المتكامل لكبار السن",
  description: "سندك الذكي لرعاية من تحب.. طمأنينة لك، وعناية تليق بهم. نظام تشغيل متكامل يربط بينك وبين والديك، يتنبأ باحتياجاتهم الصحية، ويوفر أفضل خدمات الرعاية المنزلية والنقل المتخصص.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ar" dir="rtl">
      <body className={`${vazirmatn.variable} font-sans antialiased`}>
        {children}
      </body>
    </html>
  );
}
