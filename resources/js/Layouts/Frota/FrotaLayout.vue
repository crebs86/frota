<script setup>
import { ref, useSlots } from 'vue';
import { Link } from '@inertiajs/vue3';

const sidebar = ref(null);
const maxSidebar = ref(null);
const miniSidebar = ref(null);
const maxToolbar = ref(null);
const logo = ref(null);
const content = ref(null);

function openNav() {
    if (sidebar.value.classList.contains('-translate-x-48')) {
        // max sidebar 
        sidebar.value.classList.remove("-translate-x-48")
        sidebar.value.classList.add("translate-x-none")
        maxSidebar.value.classList.remove("hidden")
        maxSidebar.value.classList.add("flex")
        miniSidebar.value.classList.remove("flex")
        miniSidebar.value.classList.add("hidden")
        maxToolbar.value.classList.add("translate-x-0")
        maxToolbar.value.classList.remove("translate-x-24", "scale-x-0")
        logo.value.classList.remove("ml-12")
        content.value.classList.remove("ml-12")
        content.value.classList.add("ml-12", "md:ml-60")
    } else {
        // mini sidebar
        sidebar.value.classList.add("-translate-x-48")
        sidebar.value.classList.remove("translate-x-none")
        maxSidebar.value.classList.add("hidden")
        maxSidebar.value.classList.remove("flex")
        miniSidebar.value.classList.add("flex")
        miniSidebar.value.classList.remove("hidden")
        maxToolbar.value.classList.add("translate-x-24", "scale-x-0")
        maxToolbar.value.classList.remove("translate-x-0")
        logo.value.classList.add('ml-12')
        content.value.classList.remove("ml-12", "md:ml-60")
        content.value.classList.add("ml-12")

    }

}
</script>
<template>
    <div class="fixed w-full z-30 flex bg-white dark:bg-[#0F172A] p-2 items-center justify-center h-16 px-10">
        <div ref="logo"
            class="ml-12 dark:text-white  transform ease-in-out duration-500 flex-none h-full flex items-center justify-center">
            Frota Inteligente
        </div>
        <!-- SPACER -->
        <div class="grow h-full flex items-center justify-center"></div>
        <div class="flex-none h-full text-center flex items-center justify-center">

            <div class="flex space-x-3 items-center px-3">
                <div class="flex-none flex justify-center">
                    <div class="w-8 h-8 flex ">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShta_GXR2xdnsxSzj_GTcJHcNykjVKrCBrZ9qouUl0usuJWG2Rpr_PbTDu3sA9auNUH64&usqp=CAU"
                            alt="profile" class="shadow rounded-full object-cover" />
                    </div>
                </div>

                <div class="hidden sm:block text-sm md:text-md text-black dark:text-white">{{ $page.props.auth.user.name }}
                </div>
            </div>

        </div>
    </div>
    <aside ref="sidebar"
        class="w-60 -translate-x-48 fixed transition transform ease-in-out duration-1000 z-50 flex h-screen bg-[#1E293B] ">
        <!-- open sidebar button -->
        <div ref="maxToolbar"
            class="translate-x-24 scale-x-0 w-full -right-6 transition transform ease-in duration-300 flex items-center justify-between border-4 border-white dark:border-[#0F172A] bg-[#1E293B]  absolute top-2 rounded-full h-12">

            <div class="flex pl-4 items-center space-x-2 "></div>
            <div
                class="flex items-center space-x-3 group bg-gradient-to-r dark:from-cyan-500 dark:to-blue-500 from-indigo-500 via-purple-500 to-purple-500  pl-10 pr-2 py-1 rounded-full text-white  ">
                <div class="transform ease-in-out duration-300 mr-12">
                    Frota Inteligente
                </div>
            </div>
        </div>
        <div @click="openNav()"
            class="-right-6 transition transform ease-in-out duration-500 flex border-4 border-white dark:border-[#0F172A] bg-[#1E293B] dark:hover:bg-blue-500 hover:bg-purple-500 absolute top-2 p-3 rounded-full text-white hover:rotate-45">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={3} stroke="currentColor"
                class="w-4 h-4">
                <path strokeLinecap="round" strokeLinejoin="round"
                    d="M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6a2.25 2.25 0 01-2.25-2.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18a2.25 2.25 0 01-2.25 2.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25a2.25 2.25 0 01-2.25-2.25V6zM13.5 15.75a2.25 2.25 0 012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z" />
            </svg>
        </div>
        <!-- MAX SIDEBAR-->
        <div ref="maxSidebar" class="hidden text-white mt-20 flex-col space-y-2 w-full h-[calc(100vh)]">
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <Link class="flex gap-4" :href="route('home')">
                <mdicon name="chart-pie" />
                <div>
                    Painel
                </div>
                </Link>
            </div>
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <Link class="flex gap-4" :href="route('tasks.index')">
                <mdicon name="calendar-check" />
                <div>
                    Tarefas
                </div>
                </Link>
            </div>
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <Link class="flex gap-4" :href="route('drivers.index')">
                <mdicon name="account-multiple" />
                <div>
                    Motoristas
                </div>
                </link>
            </div>
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <Link class="flex gap-4" :href="route('cars.index')">
                <mdicon name="car-multiple" />
                <div>
                    Veículos
                </div>
                </Link>
            </div>
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <Link class="flex gap-4" :href="route('reports.index')">
                <mdicon name="chart-bar" />
                <div>
                    Relatórios
                </div>
                </Link>
            </div>
        </div>
        <!-- MINI SIDEBAR-->
        <div ref="miniSidebar" class="mt-20 flex flex-col space-y-2 w-full h-[calc(100vh)]">
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <Link class="flex gap-4" :href="route('home')">
                <mdicon name="chart-pie" />
                </Link>
            </div>
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <Link class="flex gap-4" :href="route('tasks.index')">
                <mdicon name="calendar-check" />
                </Link>
            </div>
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <Link class="flex gap-4" :href="route('drivers.index')">
                <mdicon name="account-multiple" />
                </Link>
            </div>
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <Link class="flex gap-4" :href="route('cars.index')">
                <mdicon name="car-multiple" />
                </Link>
            </div>
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <Link class="flex gap-4" :href="route('tasks.index')">
                <mdicon name="chart-bar" />
                </Link>
            </div>
        </div>

    </aside>
    <!-- CONTENT -->
    <div ref="content" class="ml-12 transform ease-in-out duration-500 pt-20 px-2 md:px-5 pb-4"
        :class="$page.props.app.settingsStyles.main.container">
        <nav class="flex px-5 py-3 text-gray-700  rounded-lg bg-gray-50 dark:bg-[#1E293B] " aria-label="Breadcrumb">
            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                <li class="inline-flex items-center">
                    <a href="#"
                        class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white">
                        <mdicon class="text-gray-400" name="home" />
                    </a>
                </li>
                <li>
                    <div class="flex items-center">
                        <mdicon class="text-gray-400" name="chevron-right" />
                        <a href="#"
                            class="ml-1 text-sm font-medium text-gray-700 hover:text-gray-900 md:ml-2 dark:text-gray-400 dark:hover:text-white">
                            <slot name="currentPage" />
                        </a>
                    </div>
                </li>
            </ol>
        </nav>
        <div :class="$page.props.app.settingsStyles.main.container">
            <div v-show="useSlots().contentTop" class="my-2 p-2 rounded-md"
                :class="$page.props.app.settingsStyles.main.subSection">
                <slot name="contentTop" />
            </div>
            <div class="my-2 p-2 rounded-md overflow-x-auto" :class="$page.props.app.settingsStyles.main.subSection">
                <slot name="contentMain" />
            </div>
        </div>
    </div>
</template>