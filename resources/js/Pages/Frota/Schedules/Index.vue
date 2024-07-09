<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, Link } from '@inertiajs/vue3';
import hasPermission from '@/permissions';

</script>

<template>

    <Head title="Agendas" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Garagens
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                    <Link
                        v-if="hasPermission(
                            $page.props.auth.permissions, ['Agenda Criar']) || hasPermission($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max hover:text-gray-700 dark:hover:text-green-100 p-1.5 border m-0.5 mb-1 rounded"
                        :href="route('frota.schedules.create')" title="Nova Agenda">
                    <mdicon name="car-arrow-right" />
                    <div>
                        Nova Agenda
                    </div>
                    </Link>

                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <table class="min-w-full">
                            <thead>
                                <tr>
                                    <th v-for=" (value, index) in ['Motorista', 'Ações']" :key="index + '' + value"
                                        class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider"
                                        :class="$page.props.app.settingsStyles.main.container">
                                        {{ value }}
                                    </th>
                                </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                                <tr v-for="( s, i ) in $page.props.schedule " :key="i">
                                    <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ s.driver_name.user.name }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-left">
                                        <div class="flex gap-1">

                                            <Link :href="route('frota.schedules.show', s.driver)" title="Ver"
                                                v-if="hasPermission(
                                                    $page.props.auth.permissions, ['Carros Editar', 'Carros Apagar', 'Carros Ver']) || hasPermission($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="car-search" />
                                            </Link>

                                            <Link :href="route('frota.schedules.edit', s.driver)" title="Editar"
                                                v-if="hasPermission(
                                                    $page.props.auth.permissions, ['Carros Editar', 'Carros Apagar']) || hasPermission($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="car-wrench" />
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
