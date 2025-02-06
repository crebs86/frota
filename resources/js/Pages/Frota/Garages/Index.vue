<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'

</script>

<template>

    <Head title="Garagens" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Garagens
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Garagem Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('frota.garages.create')" title="Relatórios">
                    <mdicon name="home-plus" />
                    <div>
                        Nova Garagem
                    </div>
                    </Link>

                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <table class="min-w-full"
                                        :class="$page.props.app.settingsStyles.main.body">
                            <thead>
                                <tr>
                                    <th v-for=" (value, index) in ['Cod.', 'Nome', 'Ativa', 'Ações']"
                                        :key="index + '' + value"
                                        class="px-3 py-1.5 md:px-6 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider">
                                        {{ value }}
                                    </th>
                                </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                                <tr v-for="( g, i ) in $page.props.garage " :key="i">
                                    <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ g.id }}
                                    </td>
                                    <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ g.branch.name }}
                                    </td>
                                    <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ g.deleted_at ? 'Não' : 'Sim' }}
                                    </td>
                                    <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        <div class="flex justify-center gap-1">
                                            <Link :href="route('frota.garages.show', g.id)" title="Ver"
                                                v-if="has(
                                                    $page.props.auth.permissions, ['Garagem Editar', 'Garagem Ver', 'Garagem Criar', 'Garagem Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="home-search" />
                                            </Link>
                                            <Link :href="route('frota.garages.edit', g.id)" title="Editar"
                                                v-if="has(
                                                    $page.props.auth.permissions, ['Garagem Editar', 'Garagem Ver', 'Garagem Criar', 'Garagem Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="home-edit" />
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
