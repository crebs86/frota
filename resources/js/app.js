import "./bootstrap";
import "../css/app.css";

import { createApp, h } from "vue";
import { createInertiaApp } from "@inertiajs/vue3";
import { resolvePageComponent } from "laravel-vite-plugin/inertia-helpers";
import { ZiggyVue } from "../../vendor/tightenco/ziggy";

import PrimeVue from "primevue/config";
import Aura from "@primeuix/themes/aura";

import "vue-toast-notification/dist/theme-sugar.css";

import mdiVue from "mdi-vue/v3";
import * as mdijs from "@mdi/js";

const appName = import.meta.env.VITE_APP_NAME || "BaseApps";

createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) =>
        resolvePageComponent(
            `./Pages/${name}.vue`,
            import.meta.glob("./Pages/**/*.vue")
        ),
    setup({ el, App, props, plugin }) {
        return createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(ZiggyVue)
            .use(mdiVue, {
                icons: mdijs,
            })
            .use(PrimeVue, {
                theme: {
                    preset: Aura,
                },
                locale: {
                    monthNames: ['Janeiro', 'Fevereiro', 'Março' ,'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'],
                    dayNamesMin: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'],
                    dateFormat: 'dd/mm/yy'
                }
            })
            .mount(el);
    },
    progress: {
        color: "#F00",
        includeCSS: true,
        showSpinner: true,
    },
});
