import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          blue: "#0F172A", // Deep Trust Blue
          teal: "#0D9488", // Calming Teal
          light: "#F8FAFC",
        },
      },
      fontFamily: {
        sans: ["var(--font-vazirmatn)", "ui-sans-serif", "system-ui"],
      },
    },
  },
  plugins: [],
};
export default config;
