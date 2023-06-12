<script setup>
import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import hasPermission from '@/permissions'
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';

</script>

<template>
    <Head title="Garagens" />

    <FrotaLayout>

        <template #currentPage>
            <BreadCrumbs :breadCrumbs="[{ label: 'Garagens', link: '' }]">
            </BreadCrumbs>
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                <Link
                    v-if="hasPermission(
                            $page.props.auth.permissions, ['Garagem Criar']) || hasPermission($page.props.auth.roles, ['Super Admin'])"
                    class="flex gap-1 max-w-max hover:text-gray-700 dark:hover:text-green-100 p-1.5 border m-0.5 mb-1 rounded"
                    :href="route('garages.create')" title="Relatórios">
                <mdicon name="home-plus" />
                <div>
                    Nova Garagem
                </div>
                </Link>

                <div class="p-2 rounded-lg overflow-y-auto" :class="$page.props.app.settingsStyles.main.innerSection">
                    <table class="min-w-full">
                        <thead>
                            <tr>
                                <th v-for=" (value, index) in ['Cod.', 'Nome', 'Ativa', 'Ações']" :key="index + '' + value"
                                    class="px-3 py-1.5 md:px-6 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider"
                                    :class="$page.props.app.settingsStyles.main.container">
                                    {{ value }}
                                </th>
                            </tr>
                        </thead>
                        <tbody :class="$page.props.app.settingsStyles.main.body">
                            <tr v-for="( g, i ) in  $page.props.garage " :key="i">
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
                                        <Link :href="route('garages.show', g.id)" title="Ver"
                                            v-if="hasPermission(
                                                $page.props.auth.permissions, ['Garagem Editar', 'Garagem Ver', 'Garagem Criar', 'Garagem Apagar']) || hasPermission($page.props.auth.roles, ['Super Admin'])">
                                        <mdicon name="home-search" />
                                        </Link>
                                        <Link :href="route('garages.edit', g.id)" title="Editar"
                                            v-if="hasPermission(
                                                    $page.props.auth.permissions, ['Garagem Editar', 'Garagem Ver', 'Garagem Criar', 'Garagem Apagar']) || hasPermission($page.props.auth.roles, ['Super Admin'])">
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

    </FrotaLayout>
</template>
