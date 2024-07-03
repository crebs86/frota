import './bootstrap';
import '../css/app.css';

import { createApp, h } from 'vue';
import { createInertiaApp } from '@inertiajs/vue3'
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { ZiggyVue } from '../../vendor/tightenco/ziggy/dist/vue.m';

import 'vue-toast-notification/dist/theme-sugar.css';
import 'vue-multiselect/dist/vue-multiselect.css';

import mdiVue from 'mdi-vue/v3';
import * as mdijs from '@mdi/js';

const appName = window.document.getElementsByTagName('title')[0]?.innerText || 'BaseApps';

createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) => resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({ el, App, props, plugin }) {
        return createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(ZiggyVue, Ziggy)
            .use(mdiVue, {
                icons: mdijs
            })
            .mount(el);
    },
    progress: {
        color: '#F00',
        includeCSS: true,
        showSpinner: true
    }
});
