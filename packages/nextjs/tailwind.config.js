/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,ts,jsx,tsx}", "./components/**/*.{js,ts,jsx,tsx}", "./utils/**/*.{js,ts,jsx,tsx}"],
  plugins: [require("daisyui")],
  darkTheme: "dark",
  darkMode: ["selector", "[data-theme='dark']"],
  // DaisyUI theme colors
  daisyui: {
    themes: [
      {
        light: {
          primary: "#007AFF",
          "primary-content": "#FFFFFF",
          secondary: "#F2F2F7",
          "secondary-content": "#1C1C1E",
          neutral: "#1C1C1E",
          "neutral-content": "#FFFFFF",
          "base-100": "#FFFFFF",
          "base-200": "#F2F2F7",
          "base-300": "#E5E5EA",
          "base-content": "#1C1C1E",
          info: "#0A84FF",
          success: "#34C759",
          warning: "#FF9500",
          error: "#FF3B30",

          "--rounded-btn": "9999rem",

          ".tooltip": {
            "--tooltip-tail": "6px",
          },
          ".link": {
            textUnderlineOffset: "2px",
          },
          ".link:hover": {
            opacity: "80%",
          },
        },
      },
      {
        dark: {
          primary: "#0A84FF",
          "primary-content": "#FFFFFF",
          secondary: "#1C1C1E",
          "secondary-content": "#FFFFFF",
          neutral: "#FFFFFF",
          "neutral-content": "#1C1C1E",
          "base-100": "#000000",
          "base-200": "#1C1C1E",
          "base-300": "#2C2C2E",
          "base-content": "#FFFFFF",
          info: "#0A84FF",
          success: "#32D74B",
          warning: "#FF9F0A",
          error: "#FF453A",

          "--rounded-btn": "9999rem",

          ".tooltip": {
            "--tooltip-tail": "6px",
            "--tooltip-color": "oklch(var(--p))",
          },
          ".link": {
            textUnderlineOffset: "2px",
          },
          ".link:hover": {
            opacity: "80%",
          },
        },
      },
    ],
  },
  theme: {
    extend: {
      boxShadow: {
        center: "0 0 12px -2px rgb(0 0 0 / 0.05)",
      },
      animation: {
        "pulse-fast": "pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite",
      },
    },
  },
};
