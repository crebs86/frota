<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import {Head, Link} from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';

</script>

<template>

    <Head title="Carros"/>


    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu/>
        </template>
        <SubSection>
            <template #header>
                Carros
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Carro Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('frota.cars.create')" title="Novo Carro">
                        <img src="/icons/add.svg" alt="Novo Carro" class="w-6">
                        <!--<div>
                                Novo Carro
                             </div>-->
                    </Link>

                    <div class="p-2 rounded-lg overflow-y-auto"
                         :class="$page.props.app.settingsStyles.main.innerSection">
                        <table class="min-w-full" :class="$page.props.app.settingsStyles.main.body">
                            <thead>
                            <tr>
                                <th v-for=" (value, index) in ['Marca', 'Modelo', 'Placa', 'Próprio?'
                                        , 'Nº Patrimônio', 'Garagem', 'Ativo', 'Ações']" :key="index + '' + value"
                                    class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider">
                                    {{ value }}
                                </th>
                            </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                            <tr v-for="( c, i ) in $page.props.cars " :key="i">
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ c.marca }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ c.modelo }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ c.placa }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ c.patrimonio ? 'Sim' : 'Não' }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ c.tombo }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ c.garage?.branch.name }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    {{ c.deleted_at ? 'Não' : 'Sim' }}
                                </td>
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                    <div class="flex justify-center gap-3">
                                        <Link :href="route('frota.cars.show', c.id)" title="Ver"
                                              v-if="has(
                                                    $page.props.auth.permissions, ['Carro Editar', 'Carro Ver', 'Carro Criar', 'Carro Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/ver_2.svg" alt="Ver Carro"
                                                 class="min-w-9 w-9 hover:opacity-75">
                                        </Link>
                                        <Link :href="route('frota.cars.edit', c.id)" title="Editar"
                                              v-if="has(
                                                    $page.props.auth.permissions, ['Carro Editar', 'Carro Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/editar.svg" alt="Editar Carro"
                                                 class="min-w-9 w-9 hover:opacity-75">
                                        </Link>
                                        <Link
                                            :href="route('frota.load-history-fill', [c.id]) + '?de=' + moment().subtract('15', 'days').format('YYYY-MM-DD')"
                                            title="Histórico de Abastecimento"
                                            v-if="has(
                                                    $page.props.auth.permissions, ['Combustivel Editar', 'Combustivel Apagar', 'Combustivel Ver', 'Combustivel Criar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/bomba_gas_3.svg" alt="Histórico de Abastecimento"
                                                 class="min-w-9 w-9 hover:opacity-75">
                                        </Link>
                                        <Link
                                            :href="route('frota.maintenance.show', [c.id])"
                                            title="Manutenção"
                                            v-if="has(
                                                    $page.props.auth.permissions, ['Manutencao Editar', 'Manutencao Apagar', 'Manutencao Ver', 'Manutencao Criar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/carro_reparado.svg" alt="Manutenção"
                                                 class="min-w-9 w-9 hover:opacity-75">
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
