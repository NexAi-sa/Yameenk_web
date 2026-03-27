import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "يمينك | Yameenak",
  description: "نظام تشغيل الرعاية المتكامل لكبار السن",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return children;
}
