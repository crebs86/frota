<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import {Head, Link} from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import SubSection from '@/Components/Admin/SubSection.vue';

</script>

<template>

    <Head title="Motoristas"/>

    <AuthenticatedLayout>
        <template #inner_menu>
            <FrotaMenu/>
        </template>
        <SubSection>
            <template #header>
                Motoristas
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Motorista Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('frota.drivers.create')" title="Novo Motorista">
                        <img src="/icons/add.svg" alt="Novo Motorista" class="w-6">
                        <!--<div>
                                Novo Motorista
                            </div>-->
                    </Link>

                    <div class="p-2 rounded-lg overflow-y-auto"
                         :class="$page.props.app.settingsStyles.main.innerSection">
                        <table class="min-w-full" :class="$page.props.app.settingsStyles.main.body">
                            <thead>
                            <tr>
                                <th v-for=" (value, index) in ['Nome', 'Garagem', 'Carro Favorito', 'Servidor?'
                                        , 'Matrícula', 'Ativo', 'Ações']" :key="index + '' + value"
                                    class="px-3 py-1.5 md:px-6 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider">
                                    {{ value }}
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr v-for="( d, i ) in $page.props.drivers " :key="i">
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ d.user.name }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ d.garage?.branch?.name }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ d.car?.modelo }} - {{ d.car?.placa }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ d.proprio ? 'Sim' : 'Não' }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ d.matricula }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    <div class="text-center rounded-md border"
                                         :class="d.deleted_at ? 'border-red-600 bg-red-500' : 'border-green-700 bg-green-500'">
                                        {{ d.deleted_at ? 'Não' : 'Sim' }}
                                    </div>
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    <div class="flex justify-center gap-3">
                                        <Link :href="route('frota.drivers.show', d.user.id)" title="Ver"
                                              v-if="has(
                                                    $page.props.auth.permissions, ['Motorista Editar', 'Motorista Ver', 'Motorista Criar', 'Motorista Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/ver_2.svg" alt="Ver Motorista" class="min-w-9 w-9 hover:opacity-75">
                                        </Link>
                                        <Link :href="route('frota.drivers.edit', d.user.id)" title="Editar"
                                              v-if="has(
                                                    $page.props.auth.permissions, ['Motorista Editar', 'Motorista Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/editar.svg" alt="Editar Motorista" class="min-w-9 w-9 hover:opacity-75">
                                        </Link>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
