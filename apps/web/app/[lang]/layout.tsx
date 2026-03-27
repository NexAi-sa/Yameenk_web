import type { Metadata } from "next";
import { Vazirmatn } from "next/font/google";
import "../globals.css";

const vazirmatn = Vazirmatn({ subsets: ["arabic"], variable: "--font-vazirmatn" });

export const metadata: Metadata = {
  title: "يمينك | نظام تشغيل الرعاية المتكامل لكبار السن",
  description: "سندك الذكي لرعاية من تحب.. طمأنينة لك، وعناية تليق بهم.",
};

export function generateStaticParams() {
  return [{ lang: "ar" }, { lang: "en" }];
}

export default function LangLayout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: { lang: string };
}) {
  const isAr = params.lang !== "en";
  return (
    <html lang={isAr ? "ar" : "en"} dir={isAr ? "rtl" : "ltr"}>
      <body className={`${vazirmatn.variable} font-sans antialiased`}>
        {children}
      </body>
    </html>
  );
}
