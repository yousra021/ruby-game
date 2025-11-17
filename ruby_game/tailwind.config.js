/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.{html.erb,html}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  safelist: [
    "font-black",
    "tracking-[0.3em]",
    "text-[64px]",
    "uppercase",
    "text-center",
    "text-white",
  ],
  theme: {
    extend: {
      fontFamily: {
        retro: ['"Press Start 2P"', 'monospace'],
        sans: ['"Inter"', 'sans-serif'],
      },
      colors: {
        zombie: "#cebd96", // ton existant
        sand: "#dccdaa",   // texte clair
        dirt: "#1e1e1e",   // bloc foncé
        coal: "#121212",   // fond général
        steel: "#2f2f2f",  // barres & encarts
        rust: "#5c5343",   // hover accent
      },
    },
  },
  plugins: [],
};
