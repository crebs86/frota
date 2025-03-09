<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import {Head, Link, router} from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from "moment";
import {TailwindPagination} from "laravel-vue-pagination";

function loadMaintenance(page = 1) {
    router.get(route('frota.maintenance.show', route().params.car) + '?page=' + page);
}

</script>

<template>

    <Head title="Manutenção"/>

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu/>
        </template>
        <SubSection>
            <template #header>
                Manutenção
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Manutenção Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('frota.garages.create')" title="Nova Programação">
                        <img src="/icons/add.svg" alt="Nova Programação de Manutenção" class="w-6">
                    </Link>

                    <div class="p-2 rounded-lg overflow-y-auto"
                         :class="$page.props.app.settingsStyles.main.innerSection">
                        <table class="min-w-full"
                               :class="$page.props.app.settingsStyles.main.body">
                            <thead>
                            <tr>
                                <th v-for=" (value, index) in ['Cod.', 'Data', 'Hora', 'Tipo', 'Km de Chegada', 'Km de Saída', 'Data de Entrada', 'Data de Saída', 'Local', 'Mecânico', 'Substituições', 'Custo', 'Obs', 'Ações']"
                                    :key="index + '' + value"
                                    class="px-3 py-1.5 md:px-6 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider">
                                    {{ value }}
                                </th>
                            </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                            <tr v-for="( m, i ) in $page.props.maintenance.data " :key="i">
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.id }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ moment(m.date).format('DD/MM/YYYY') }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.time }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.type === 1 ? 'Preventiva' : 'Corretiva' }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.km_departure }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.km_arrival }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.date_departure }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.date_arrival }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.place }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.mechanic }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.replaces }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.costechanic }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ m.obs }}
                                </td>

                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    <div class="flex justify-center gap-3">
                                        <Link :href="route('frota.garages.show', m.id)" title="Ver"
                                              v-if="has(
                                                    $page.props.auth.permissions, ['Manutenção Editar', 'Manutenção Ver', 'Manutenção Criar', 'Manutenção Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/ver_2.svg" alt="Ver Manutenção"
                                                 class="min-w-9 w-9 hover:opacity-75">
                                        </Link>
                                        <Link :href="route('frota.garages.edit', m.id)" title="Editar"
                                              v-if="has(
                                                    $page.props.auth.permissions, ['Manutenção Editar', 'Manutenção Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/editar.svg" alt="Editar Manutenção"
                                                 class="min-w-9 w-9 hover:opacity-75">
                                        </Link>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <div class="my-3 grid col-span-2 place-content-center overflow-x-auto">
                            <TailwindPagination
                                :item-classes="['bg-blue-100 text-gray-500 border-gray-400 hover:bg-white dark:bg-gray-600 dark:text-gray-100 dark:border-gray-300 dark:hover:bg-gray-800']"
                                :active-classes="['bg-white border-gray-600 text-blue-600 dark:bg-gray-300 dark:border-gray-500 dark:text-blue-500']"
                                :data="$page.props.maintenance"
                                :limit="1"
                                @pagination-change-page="loadMaintenance"
                            />
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
