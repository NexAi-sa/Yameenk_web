import Header from "@/components/Header";
import Hero from "@/components/Hero";
import SocialProof from "@/components/SocialProof";
import Features from "@/components/Features";
import HowItWorks from "@/components/HowItWorks";
import FinalCTA from "@/components/FinalCTA";
import Footer from "@/components/Footer";
import { getDictionary, type Locale } from "@/lib/dictionaries";

export default function Home({ params }: { params: { lang: string } }) {
  const lang = (params.lang === "en" ? "en" : "ar") as Locale;
  const dict = getDictionary(lang);

  return (
    <main className="min-h-screen selection:bg-brand-teal selection:text-white">
      <Header dict={dict} lang={lang} />
      <Hero dict={dict} lang={lang} />
      <SocialProof dict={dict} />
      <Features dict={dict} />
      <HowItWorks dict={dict} />
      <FinalCTA dict={dict} />
      <Footer dict={dict} lang={lang} />
    </main>
  );
}
