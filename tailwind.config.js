import defaultTheme from "tailwindcss/defaultTheme";
import forms from "@tailwindcss/forms";
import typography from "@tailwindcss/typography";
import tw from "tw-elements/plugin.cjs";

/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php",
        "./vendor/laravel/jetstream/**/*.blade.php",
        "./storage/framework/views/*.php",
        "./resources/views/**/*.blade.php",
        "./resources/js/**/*.vue",
        "./node_modules/tw-elements/js/**/*.js",
    ],
    safelist: [
        {
            pattern:
                /bg-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(50|100|200|300|400|500|600|700|800|900)|bg-(inherit|current|transparent|white|black)/,
            variants: ["hover", "dark", "focus"],
        },
        {
            pattern:
                /text-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(50|100|200|300|400|500|600|700|800|900)|text-(inherit|current|transparent|white|black)/,
            variants: ["hover", "dark", "focus", "dark:hover"],
        },
        {
            pattern:
                /border-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(50|100|200|300|400|500|600|700|800|900)|text-(inherit|current|transparent|white|black)/,
            variants: ["hover", "dark", "dark:hover"],
        },
        {
            pattern: /grid-cols-(1|2|3|4|5|6|7|8|9|10|11|12|none)/,
        },
    ],
    theme: {
        extend: {
            fontFamily: {
                sans: ["Figtree", ...defaultTheme.fontFamily.sans],
            },
        },
    },

    plugins: [forms, typography, tw],
};
