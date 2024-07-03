<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import hasPermission from '@/permissions'
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import SubSection from '@/Components/Admin/SubSection.vue';

</script>

<template>

    <Head title="Motoristas" />

    <AuthenticatedLayout>
        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Sobre o Recurso
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                    <Link
                        v-if="hasPermission(
                            $page.props.auth.permissions, ['Motorista Criar']) || hasPermission($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max hover:text-gray-700 dark:hover:text-green-100 p-1.5 border m-0.5 mb-1 rounded"
                        :href="route('frota.drivers.create')" title="Novo Motorista">
                    <mdicon name="account-multiple-plus" />
                    <div>
                        Novo Motorista
                    </div>
                    </Link>

                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <table class="min-w-full">
                            <thead>
                                <tr>
                                    <th v-for=" (value, index) in ['Nome', 'Garagem', 'Carro Favorito', 'Servidor?'
                                        , 'Matrícula', 'Ativo', 'Ações']" :key="index + '' + value"
                                        class="px-3 py-1.5 md:px-6 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider"
                                        :class="$page.props.app.settingsStyles.main.container">
                                        {{ value }}
                                    </th>
                                </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
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
                                        {{ d.deleted_at ? 'Não' : 'Sim' }}
                                    </td>
                                    <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        <div class="flex justify-center gap-1">
                                            <Link :href="route('frota.drivers.show', d.user.id)" title="Ver"
                                                v-if="hasPermission(
                                                    $page.props.auth.permissions, ['Motorista Editar', 'Motorista Ver', 'Motorista Criar', 'Motorista Apagar']) || hasPermission($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="account-eye" />
                                            </Link>
                                            <Link :href="route('frota.drivers.edit', d.user.id)" title="Editar"
                                                v-if="hasPermission(
                                                    $page.props.auth.permissions, ['Motorista Editar', 'Motorista Apagar']) || hasPermission($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="account-edit" />
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
