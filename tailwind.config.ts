import { type Config } from "tailwindcss";

export default {
  content: [
    "./{routes,islands,components, utils}/**/*.{ts,tsx,js,jsx}",
  ],
  daisyui: {
    themes: [
      "autumn", // ライト
      "halloween", // ダーク
    ],
    darkTheme: "halloween",
    defaultTheme: "autumn",
  },
} satisfies Config;
