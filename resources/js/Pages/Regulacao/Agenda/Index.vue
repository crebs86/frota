<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import { TailwindPagination } from 'laravel-vue-pagination';
import moment from 'moment';
import { Column, DataTable } from 'primevue';

const props = defineProps({
    agendas: Object | null,
})

function paginate(page = 1) {
    router.visit(route('regulacao.agenda.index') + `?page=${page}`)
}

</script>

<template>

    <Head title="Agendas" />

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Agendas
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.59)]">
                    <div class="inline-flex">
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.home')" title="Início Regulação">
                        <img src="/icons/home.svg" alt="Início Regulação" class="w-6">
                        </Link>
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.agenda.create')" title="Criar Agenda">
                        <img src="/icons/add.svg" alt="Criar Agenda" class="w-6">
                        </Link>
                    </div>
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-1 place-items-center">

                            <DataTable :value="props.agendas?.data ?? []" :class="'w-full'"
                                table-style="width: 99%; min-width: 58rem" class="mt-2">

                                <Column field="posto_coleta" header="Posto Coleta" style="width: 20%" sortable>
                                    <template #body="slotProps">
                                        {{ slotProps.data.posto_coleta }}
                                    </template>
                                </Column>

                                <Column field="vigencia_inicio" header="Data Início" style="width: 15%" sortable>
                                    <template #body="slotProps">
                                        {{ moment(slotProps.data.vigencia_inicio).format('DD/MM/YYYY') }}
                                    </template>
                                </Column>

                                <Column field="vigencia_fim" header="Data Fim" style="width: 15%" sortable>
                                    <template #body="slotProps">
                                        {{ moment(slotProps.data.vigencia_fim).format('DD/MM/YYYY') }}
                                    </template>
                                </Column>

                                <Column field="hora_inicio" header="Hora Início" style="width: 15%" sortable>
                                    <template #body="slotProps">
                                        {{ slotProps.data.hora_inicio }}
                                    </template>
                                </Column>

                                <Column field="hora_fim" header="Hora Fim" style="width: 15%" sortable>
                                    <template #body="slotProps">
                                        {{ slotProps.data.hora_fim }}
                                    </template>
                                </Column>

                                <Column field="deleted_at" header="Ativo" style="width: 5%" sortable>
                                    <template #body="slotProps">
                                        {{ slotProps.data.deleted_at ? 'Sim' : 'Não' }}
                                    </template>
                                </Column>

                                <Column field="id" header="Açoes" style="width: 8%">
                                    <template #body="slotProps">
                                        {{ slotProps.data.id }}
                                    </template>
                                </Column>

                            </DataTable>

                            <TailwindPagination class="mt-3"
                                :item-classes="['bg-blue-100 text-gray-500 border-gray-400 hover:bg-white dark:bg-gray-600 dark:text-gray-100 dark:border-gray-300 dark:hover:bg-gray-800']"
                                :active-classes="['bg-white border-gray-600 text-blue-600 dark:bg-gray-300 dark:border-gray-500 dark:text-blue-500']"
                                :data="props.agendas ?? []" :limit="1" @pagination-change-page="paginate" />
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
