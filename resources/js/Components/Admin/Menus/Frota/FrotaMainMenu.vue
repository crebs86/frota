<script setup>
import {Link, usePage} from '@inertiajs/vue3';
import {onMounted} from 'vue';
import has from '@/arrayHelpers';
import {
    Collapse,
    Dropdown,
    initTWE,
} from "tw-elements";

onMounted(() => {
    initTWE({Collapse, Dropdown});
})

const props = usePage().props.app.settingsStyles.mainMenu

function linksStyles(active) {
    let l = active ? props.iconsActive.split(" ") : props.icons.split(" ")

    let wvl = setNewColorText(l[0].substr(0, l[0].indexOf(l[0].substr(-3))), parseInt(l[0].substr(-3)), '', active)
    let dvl = setNewColorText(l[1].substr(0, l[1].indexOf(l[1].substr(-3))), parseInt(l[1].substr(-3)), 'dark:', active)
    /*     console.log(active
            ? 'border-b-2 ' + wvl + ' ' + dvl + ' ' + props.icons
            : 'hover:border-b-2 ' + wvl + ' ' + dvl + ' ' + props.icons) */

    return active
        ? 'border-b-2 ' + wvl + ' ' + dvl + ' ' + props.icons
        : 'hover:border-b-2 ' + wvl + ' ' + dvl + ' ' + props.icons
}

function setNewColorText(color, value, mode = '', active) {
    let textColor = color.split('-')
    return mode + 'border-' + textColor[1] + '-' + value
}

</script>
<template>
    <!-- Main navigation container -->
    <nav
        class="flex-no-wrap relative flex w-full items-center justify-between py-2 shadow-dark-mild md:flex-wrap md:justify-start md:py-4"
        :class="$page.props.app.settingsStyles.mainMenu.body">
        <div class="flex w-full flex-wrap items-center justify-between px-3">
            <!-- Hamburger button for mobile view -->
            <button
                class="block border-0 bg-transparent px-2 text-black/50 hover:no-underline hover:shadow-none focus:no-underline focus:shadow-none focus:outline-none focus:ring-0 dark:text-neutral-200 md:hidden"
                type="button" data-twe-collapse-init data-twe-target="#navbarSupportedContent1"
                aria-controls="navbarSupportedContent1" aria-expanded="false" aria-label="Toggle navigation">
                <!-- Hamburger icon -->
                <span class="[&>svg]:w-7 [&>svg]:stroke-black/50 dark:[&>svg]:stroke-neutral-200">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                        <path fill-rule="evenodd"
                              d="M3 6.75A.75.75 0 013.75 6h16.5a.75.75 0 010 1.5H3.75A.75.75 0 013 6.75zM3 12a.75.75 0 01.75-.75h16.5a.75.75 0 010 1.5H3.75A.75.75 0 013 12zm0 5.25a.75.75 0 01.75-.75h16.5a.75.75 0 010 1.5H3.75a.75.75 0 01-.75-.75z"
                              clip-rule="evenodd"/>
                    </svg>
                </span>
            </button>

            <!-- Collapsible navigation container -->
            <div class="!visible hidden flex-grow basis-[100%] items-center md:!flex md:basis-auto"
                 id="navbarSupportedContent1" data-twe-collapse-item>
                <!-- Logo -->
                <a class="mb-4 me-5 ms-2 mt-3 flex items-center text-neutral-900 hover:text-neutral-900 focus:text-neutral-900 dark:text-neutral-200 dark:hover:text-neutral-400 dark:focus:text-neutral-400 lg:mb-0 lg:mt-0"
                   href="/">
                    <img src="/favicons/verde/routes.svg" style="height: 35px; color:green;" alt="Frota Inteligente"
                         loading="lazy"/>
                </a>
                <!-- Left navigation links -->
                <ul class="list-style-none me-auto flex flex-col ps-0 md:flex-row" data-twe-navbar-nav-ref>
                    <!--                     <li class="md:min-w-16 py-1.5 mb-1.5 lg:mb-0 mx-0.5 text-center" data-twe-nav-item-ref
                        :class="linksStyles(route().current('dashboard'))">
                        <Link
                            class="transition duration-200 hover:ease-in-out motion-reduce:transition-none md:px-2 w-full flex justify-center"
                            :href="route('dashboard')" data-twe-nav-link-ref>
                        Painel
                        </Link>
                    </li> -->

                    <li class="md:min-w-16 py-1.5 mb-1.5 lg:mb-0 mx-0.5 text-center" data-twe-nav-item-ref
                        :class="linksStyles(route().current('frota.*'))" v-if="has(usePage().props.auth.permissions,
                            [
                                'Motorista Editar', 'Motorista Ver', 'Motorista Criar', 'Motorista Apagar',
                                'Carro Editar', 'Carro Ver', 'Carro Criar', 'Carro Apagar',
                                'Ocorrencia Editar', 'Ocorrencia Ver', 'Ocorrencia Criar', 'Ocorrencia Apagar',
                                'Solicitacao Editar', 'Solicitacao Ver', 'Solicitacao Criar', 'Solicitacao Apagar',
                                'Tarefa Editar', 'Tarefa Ver', 'Tarefa Criar', 'Tarefa Apagar', 'Liberador'])
                            || has(usePage().props.auth.roles, ['Super Admin'])">
                        <Link
                            class="transition duration-200 hover:ease-in-out motion-reduce:transition-none md:px-2 w-full flex justify-center"
                            :href="route('frota.home')" :active="route().current('frota.*')" data-twe-nav-link-ref>
                            Frota
                        </Link>
                    </li>

                    <li class="md:min-w-16 py-1.5 mb-1.5 lg:mb-0 mx-0.5 text-center" data-twe-nav-item-ref
                        :class="linksStyles(route().current('admin.acl.*'))" v-if="has(usePage().props.auth.permissions, ['ACL Editar', 'ACL Ver', 'ACL Criar', 'ACL Apagar', 'Usuario Editar', 'Usuario Ver', 'Usuario Criar', 'Usuario Apagar'])
                            || has(usePage().props.auth.roles, ['Super Admin'])">
                        <Link
                            class="transition duration-200 hover:ease-in-out motion-reduce:transition-none md:px-2 w-full flex justify-center"
                            :href="route('admin.acl.acl')" :active="route().current('admin.acl.*')"
                            data-twe-nav-link-ref>
                            Acesso
                        </Link>
                    </li>

                    <li class="md:min-w-16 py-1.5 mb-1.5 lg:mb-0 mx-0.5 text-center" data-twe-nav-item-ref
                        :class="linksStyles(route().current('clients.*'))" v-if="has(usePage().props.auth.permissions, ['Cliente Editar', 'Cliente Ver', 'Cliente Criar', 'Cliente Apagar'])
                            || has(usePage().props.auth.roles, ['Super Admin'])">
                        <Link
                            class="transition duration-200 hover:ease-in-out motion-reduce:transition-none md:px-2 w-full flex justify-center"
                            :href="route('clients.index')" :active="route().current('clients.*')" data-twe-nav-link-ref>
                            Clientes
                        </Link>
                    </li>

                    <li class="md:min-w-16 py-1.5 mb-1.5 lg:mb-0 mx-0.5 text-center" data-twe-nav-item-ref
                        :class="linksStyles(route().current('branches.*'))" v-if="has(usePage().props.auth.permissions, ['Unidade Editar', 'Unidade Ver', 'Unidade Criar', 'Unidade Apagar'])
                            || has(usePage().props.auth.roles, ['Super Admin'])">
                        <Link
                            class="transition duration-200 hover:ease-in-out motion-reduce:transition-none md:px-2 w-full flex justify-center"
                            :href="route('branches.index')"
                            :active="route().current('branches.*') || route().current('nova-unidade')"
                            data-twe-nav-link-ref>
                            Unidades
                        </Link>
                    </li>

                    <li class="md:min-w-16 py-1.5 mb-1.5 lg:mb-0 mx-0.5 text-center" data-twe-nav-item-ref
                        :class="linksStyles(route().current('settings.*'))"
                        v-if="has(usePage().props.auth.roles, ['Super Admin'])">
                        <Link
                            class="transition duration-200 hover:ease-in-out motion-reduce:transition-none md:px-2 w-full flex justify-center"
                            :href="route('settings.index')" :active="route().current('settings.*')"
                            data-twe-nav-link-ref>
                            Configurar
                        </Link>
                    </li>

                    <li class="md:min-w-16 py-1.5 mb-1.5 lg:mb-0 mx-0.5 text-center" data-twe-nav-item-ref
                        :class="linksStyles(route().current('audit.*'))"
                        v-if="has(usePage().props.auth.roles, ['Super Admin'])">
                        <Link
                            class="transition duration-200 hover:ease-in-out motion-reduce:transition-none md:px-2 w-full flex justify-center"
                            :href="route('audit.index')" :active="route().current('audit.*')" data-twe-nav-link-ref>
                            Auditar
                        </Link>
                    </li>

                    <li class="md:min-w-16 py-1.5 mb-1.5 lg:mb-0 mx-0.5 text-center" data-twe-nav-item-ref
                        :class="linksStyles(route().current('user.*'))">
                        <Link
                            class="transition duration-200 hover:ease-in-out motion-reduce:transition-none md:px-2 w-full flex justify-center"
                            :href="route('user.account')" :active="route().current('user.*')" data-twe-nav-link-ref>
                            Conta
                        </Link>
                    </li>
                </ul>
                <!-- Left links -->
            </div>

            <!-- Right elements -->
            <div class="relative flex items-center">
                <!-- Icon -->
                <!-- <a class="me-4 text-neutral-600 dark:text-white" href="#">
                    <span class="[&>svg]:w-5">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                            <path
                                d="M2.25 2.25a.75.75 0 000 1.5h1.386c.17 0 .318.114.362.278l2.558 9.592a3.752 3.752 0 00-2.806 3.63c0 .414.336.75.75.75h15.75a.75.75 0 000-1.5H5.378A2.25 2.25 0 017.5 15h11.218a.75.75 0 00.674-.421 60.358 60.358 0 002.96-7.228.75.75 0 00-.525-.965A60.864 60.864 0 005.68 4.509l-.232-.867A1.875 1.875 0 003.636 2.25H2.25zM3.75 20.25a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0zM16.5 20.25a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0z" />
                        </svg>
                    </span>
                </a> -->

                <p class="me-4">
                    {{ usePage().props.auth.user.name }}
                </p>

                <!--                 <!-- First dropdown container
                <div class="relative" data-twe-dropdown-ref data-twe-dropdown-alignment="end">
                    <!-- First dropdown trigger
                    <a class="me-4 flex items-center text-neutral-600 dark:text-white" href="#" id="dropdownMenuButton1"
                        role="button" data-twe-dropdown-toggle-ref aria-expanded="false">
                        <!-- Dropdown trigger icon
                        <span class="[&>svg]:w-5">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                                <path fill-rule="evenodd"
                                    d="M5.25 9a6.75 6.75 0 0113.5 0v.75c0 2.123.8 4.057 2.118 5.52a.75.75 0 01-.297 1.206c-1.544.57-3.16.99-4.831 1.243a3.75 3.75 0 11-7.48 0 24.585 24.585 0 01-4.831-1.244.75.75 0 01-.298-1.205A8.217 8.217 0 005.25 9.75V9zm4.502 8.9a2.25 2.25 0 104.496 0 25.057 25.057 0 01-4.496 0z"
                                    clip-rule="evenodd" />
                            </svg>
                        </span>
                        <!-- Notification counter
                        <span
                            class="absolute -mt-4 ms-2.5 rounded-full bg-danger px-[0.35em] py-[0.15em] text-[0.6rem] font-bold leading-none text-white">1</span>
                    </a>
                    <!-- First dropdown menu
                    <ul class="absolute z-[1000] float-left m-0 hidden min-w-max list-none overflow-hidden rounded-lg border-none bg-white bg-clip-padding text-left text-base shadow-lg data-[twe-dropdown-show]:block dark:bg-surface-dark"
                        aria-labelledby="dropdownMenuButton1" data-twe-dropdown-menu-ref>
                        <!-- First dropdown menu items
                        <li>
                            <a class="block w-full whitespace-nowrap bg-white px-4 py-2 text-sm font-normal text-neutral-700 hover:bg-zinc-200/60 focus:bg-zinc-200/60 focus:outline-none active:bg-zinc-200/60 active:no-underline dark:bg-surface-dark dark:text-white dark:hover:bg-neutral-800/25 dark:focus:bg-neutral-800/25 dark:active:bg-neutral-800/25"
                                href="#" data-twe-dropdown-item-ref>Action</a>
                        </li>
                        <li>
                            <a class="block w-full whitespace-nowrap bg-white px-4 py-2 text-sm font-normal text-neutral-700 hover:bg-zinc-200/60 focus:bg-zinc-200/60 focus:outline-none active:bg-zinc-200/60 active:no-underline dark:bg-surface-dark dark:text-white dark:hover:bg-neutral-800/25 dark:focus:bg-neutral-800/25 dark:active:bg-neutral-800/25"
                                href="#" data-twe-dropdown-item-ref>Another action</a>
                        </li>
                        <li>
                            <a class="block w-full whitespace-nowrap bg-white px-4 py-2 text-sm font-normal text-neutral-700 hover:bg-zinc-200/60 focus:bg-zinc-200/60 focus:outline-none active:bg-zinc-200/60 active:no-underline dark:bg-surface-dark dark:text-white dark:hover:bg-neutral-800/25 dark:focus:bg-neutral-800/25 dark:active:bg-neutral-800/25"
                                href="#" data-twe-dropdown-item-ref>Something else here</a>
                        </li>
                    </ul>
                </div> -->

                <!-- Second dropdown container -->
                <div class="relative" data-twe-dropdown-ref data-twe-dropdown-alignment="end">
                    <!-- Second dropdown trigger -->
                    <a class="flex items-center whitespace-nowrap transition duration-150 ease-in-out motion-reduce:transition-none"
                       href="#" id="dropdownMenuButton2" role="button" data-twe-dropdown-toggle-ref
                       aria-expanded="false">
                        <!-- User avatar -->
                        <img :src="$page.props.auth.avatar" class="rounded-full max-w-10" alt="avatar" loading="lazy"
                             v-if="$page.props.auth.avatar"/>
                        <img alt="avatar" src="/logos/default_avatar.webp" class="rounded-full max-w-10" v-else/>
                    </a>
                    <!-- Second dropdown menu -->
                    <ul class="absolute z-[1000] float-left m-0 hidden min-w-max list-none overflow-hidden rounded-lg border-none bg-white bg-clip-padding text-left text-base shadow-lg data-[twe-dropdown-show]:block dark:bg-surface-dark"
                        aria-labelledby="dropdownMenuButton2" data-twe-dropdown-menu-ref>
                        <!-- Second dropdown menu items -->
                        <li>
                            <Link :href="route('logout')" method="post"
                                  class="block w-full whitespace-nowrap bg-white px-4 py-2 text-sm font-normal text-neutral-700 hover:bg-zinc-200/60 focus:bg-zinc-200/60 focus:outline-none active:bg-zinc-200/60 active:no-underline dark:bg-surface-dark dark:text-white dark:hover:bg-neutral-800/25 dark:focus:bg-neutral-800/25 dark:active:bg-neutral-800/25"
                                  href="#" data-twe-dropdown-item-ref>Sair
                            </Link>
                        </li>

                    </ul>
                </div>
            </div>
            <!-- Right elements -->
        </div>
    </nav>
</template>
