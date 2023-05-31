<script setup>
import { ref } from 'vue';

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

                <div class="hidden sm:block text-sm md:text-md text-black dark:text-white">Primeiro Nome</div>
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
                <mdicon name="chart-pie" />
                <div>
                    Painel
                </div>
            </div>
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <mdicon name="calendar-check" />
                <div>
                    Tarefas
                </div>
            </div>
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <mdicon name="account-multiple" />
                <div>
                    Motoristas
                </div>
            </div>
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <mdicon name="car-multiple" />
                <div>
                    Veículos
                </div>
            </div>
            <div
                class="hover:ml-4 w-full text-white hover:text-purple-500 dark:hover:text-blue-500 bg-[#1E293B] p-2 pl-8 rounded-full transform ease-in-out duration-300 flex flex-row items-center space-x-3">
                <mdicon name="chart-bar" />
                <div>
                    Relatórios
                </div>
            </div>
        </div>
        <!-- MINI SIDEBAR-->
        <div ref="miniSidebar" class="mt-20 flex flex-col space-y-2 w-full h-[calc(100vh)]">
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <mdicon name="chart-pie" />
            </div>
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <mdicon name="calendar-check" />
            </div>
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <mdicon name="account-multiple" />
            </div>
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <mdicon name="car-multiple" />
            </div>
            <div
                class="hover:ml-4 justify-end pr-5 text-white hover:text-purple-500 dark:hover:text-blue-500 w-full bg-[#1E293B] p-3 rounded-full transform ease-in-out duration-300 flex">
                <mdicon name="chart-bar" />
            </div>
        </div>

    </aside>
    <!-- CONTENT -->
    <div ref="content" class="ml-12 transform ease-in-out duration-500 pt-20 px-2 md:px-5 pb-4 ">
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
                            class="ml-1 text-sm font-medium text-gray-700 hover:text-gray-900 md:ml-2 dark:text-gray-400 dark:hover:text-white">Página
                            Atual</a>
                    </div>
                </li>
            </ol>
        </nav>
        <div class="flex flex-wrap my-5 -mx-2">
            <div class="w-full lg:w-1/3 p-2">
                <div
                    class="flex items-center flex-row w-full bg-gradient-to-r dark:from-cyan-500 dark:to-blue-500 from-indigo-500 via-purple-500 to-pink-500 rounded-md p-3">
                    <div
                        class="flex text-indigo-500 dark:text-white items-center bg-white dark:bg-[#0F172A] p-2 rounded-md flex-none w-8 h-8 md:w-12 md:h-12 ">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5}
                            stroke="currentColor" class="object-scale-down transition duration-500">
                            <path strokeLinecap="round" strokeLinejoin="round"
                                d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z" />
                        </svg>
                    </div>
                    <div class="flex flex-col justify-around flex-grow ml-5 text-white">
                        <div class="text-xs whitespace-nowrap">
                            Motoristas Disponíveis
                        </div>
                        <div class="">
                            100
                        </div>
                    </div>
                    <div class=" flex items-center flex-none text-white">
                        <mdicon name="chevron-right" />
                    </div>
                </div>
            </div>
            <div class="w-full md:w-1/2 lg:w-1/3 p-2 ">
                <div
                    class="flex items-center flex-row w-full bg-gradient-to-r dark:from-cyan-500 dark:to-blue-500 from-indigo-500 via-purple-500 to-pink-500 rounded-md p-3">
                    <div
                        class="flex text-indigo-500 dark:text-white items-center bg-white dark:bg-[#0F172A] p-2 rounded-md flex-none w-8 h-8 md:w-12 md:h-12 ">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5}
                            stroke="currentColor" class="object-scale-down transition duration-500 ">
                            <path strokeLinecap="round" strokeLinejoin="round"
                                d="M8.25 18.75a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 01-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 00-3.213-9.193 2.056 2.056 0 00-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 00-10.026 0 1.106 1.106 0 00-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12" />
                        </svg>
                    </div>
                    <div class="flex flex-col justify-around flex-grow ml-5 text-white">
                        <div class="text-xs whitespace-nowrap">
                            Carros Disponíveis
                        </div>
                        <div class="">
                            100
                        </div>
                    </div>
                    <div class=" flex items-center flex-none text-white">
                        <mdicon name="chevron-right" />
                    </div>
                </div>
            </div>
            <div class="w-full md:w-1/2 lg:w-1/3 p-2">
                <div
                    class="flex items-center flex-row w-full bg-gradient-to-r dark:from-cyan-500 dark:to-blue-500 from-indigo-500 via-purple-500 to-pink-500 rounded-md p-3">
                    <div
                        class="flex text-indigo-500 dark:text-white items-center bg-white dark:bg-[#0F172A] p-2 rounded-md flex-none w-8 h-8 md:w-12 md:h-12 ">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5}
                            stroke="currentColor" class="object-scale-down transition duration-500">
                            <path strokeLinecap="round" strokeLinejoin="round"
                                d="M3.75 3v11.25A2.25 2.25 0 006 16.5h2.25M3.75 3h-1.5m1.5 0h16.5m0 0h1.5m-1.5 0v11.25A2.25 2.25 0 0118 16.5h-2.25m-7.5 0h7.5m-7.5 0l-1 3m8.5-3l1 3m0 0l.5 1.5m-.5-1.5h-9.5m0 0l-.5 1.5m.75-9l3-3 2.148 2.148A12.061 12.061 0 0116.5 7.605" />
                        </svg>
                    </div>
                    <div class="flex flex-col justify-around flex-grow ml-5 text-white">
                        <div class="text-xs whitespace-nowrap">
                            Agendas Previstas
                        </div>
                        <div class="">
                            500
                        </div>
                    </div>
                    <div class=" flex items-center flex-none text-white">
                        <mdicon name="chevron-right" />
                    </div>
                </div>
            </div>
        </div>
        <div class="p-4 mb-4 text-sm text-blue-700 bg-blue-100 rounded-lg dark:bg-blue-200 dark:text-blue-800" role="alert">
            <span class="font-medium">Info alert!</span> Change a few things up and try submitting again.
        </div>
        <div class="p-4 mb-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800" role="alert">
            <span class="font-medium">Danger alert!</span> Change a few things up and try submitting again.
        </div>
        <div class="p-4 mb-4 text-sm text-green-700 bg-green-100 rounded-lg dark:bg-green-200 dark:text-green-800"
            role="alert">
            <span class="font-medium">Success alert!</span> Change a few things up and try submitting again.
        </div>
    </div>
</template>