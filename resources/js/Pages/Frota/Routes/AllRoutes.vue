<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link } from '@inertiajs/vue3';
import moment from 'moment';

</script>

<template>

    <Head title="Rotas do Dia" />

    <AuthenticatedLayout>
        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Rotas do Dia
            </template>
            <template #content>
                <div class="flex flex-wrap my-5 -mx-2 height justify-center">
                    <div class="w-11/12 p-2 overflow-x-auto">
                        <table class="min-w-full">
                            <thead>
                                <tr>
                                    <th v-for=" (value, index) in ['Local Destino', 'Hora Agendada', 'Motorista', 'Duração', 'Iniciada', 'Finalizada', 'Ações']"
                                        :key="index + '' + value"
                                        class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider"
                                        :class="$page.props.app.settingsStyles.main.container">
                                        {{ value }}
                                    </th>
                                </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                                <tr v-for="(m, i) in $page.props.allRoutes" :key="i + '_allroutes'">
                                    <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center"
                                        :class="m.to === 1 ? 'underline underline-offset-8' : ''">
                                        <span>{{ m.branch }}</span>
                                        <mdicon name="circle" class="float-right text-red-500" v-if="m.to === 1" />
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        {{ m.time }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        {{ m.name }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        {{ m.duration }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                            :class="m.started_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                            {{ m.started_at ? moment(m.started_at).format('DD/MM/YY HH:mm') : '-' }}
                                        </p>
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                            :class="m.ended_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                            {{ m.ended_at ? moment(m.ended_at).format('DD/MM/YY HH:mm') : '-' }}
                                        </p>
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        <Link :href="route('frota.routes.driver.edit', [m.date, m.driver])">
                                        <mdicon name="car-clock" title="Abrir agenda do motorista" />
                                        </Link>
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
<style scoped>
.height {
    min-height: calc(100vh - 415px);
}
</style>