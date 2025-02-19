<script setup>
import MainMenu from '@/Components/Admin/Menus/Frota/FrotaMainMenu.vue';
import moment from 'moment';

</script>

<template>
    <div class="bg-teal-100 text-teal-900 dark:bg-slate-700 dark:text-slate-100">
        <div class="h-full flex flex-col shadow-xl overflow-y-scroll mb-0.5 pb-4 bg-teal-50 dark:bg-slate-600">
            <MainMenu />
            <!-- Page Content -->
            <slot name="inner_menu" />
            <div class="container mx-auto mt-1 text-justify px-0 md:px-3 rounded-lg bg-teal-100 dark:bg-slate-700">
                <div class="p-2 md:p-4">
                    <slot />
                </div>
            </div>
        </div>
        <footer class="p-4 rounded-lg shadow md:px-6 md:py-8" :class="$page.props.app.settingsStyles.main.footer">
            <div class="sm:flex sm:items-center sm:justify-between">
            </div>
            <hr class="my-6 border-gray-200 sm:mx-auto dark:border-gray-800 lg:my-8">
            <span class="block text-sm sm:text-center">
                © 2022-{{ moment().format('YYYY') }} Rodando com <a href="https://crebs.dev"
                    :class="$page.props.app.settingsStyles.main.footerLinks">
                    BaseApp v{{ $page.props.app.version }}
                </a>, desenvolvido por
                <a :class="$page.props.app.settingsStyles.main.footerLinks" href="https://crebs.dev" target="_blank">
                    CrebsDev
                </a>. Todos os direitos reservados.
            </span>
        </footer>
    </div>
</template>