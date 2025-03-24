<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';

</script>

<template>

    <Head title="Contratos" />

    <AuthenticatedLayout>

        <SubSection>
            <template #header>
                Contratos
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.57)]">
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('regulacao.contratos.create')" title="Novo Contrato">
                    <img src="/icons/add.svg" alt="Novo Contrato" class="w-6">
                    </Link>
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="py-2">
                            <DataTable :value="$page.props.contratos" tableStyle="min-width: 50rem">
                                <Column field="contrato" header="Contrato" sortable style="width: 12%"></Column>
                                <Column field="ano" header="Ano" sortable style="width: 10%"></Column>
                                <Column field="contratada_nome" header="Contratada" sortable style="width: 45%">
                                </Column>
                                <Column field="vigencia_fim" header="Vigência" sortable style="width: 10%">
                                    <template #body="slotProps">
                                        {{ moment(slotProps.data.vigencia_fim).format('DD/MM/YYYY') }}
                                    </template>
                                </Column>
                                <Column header="Ações" style="width: 18%">
                                    <template #body="slotProps">
                                        <div class="flex justify-center gap-3">
                                            <Link :href="route('regulacao.contratos.show', slotProps.data.view)"
                                                title="Ver"
                                                v-if="has(
                                                    $page.props.auth.permissions, ['Contratos Editar', 'Contratos Ver', 'Contratos Criar', 'Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/ver_2.svg" alt="Ver Contrato"
                                                class="min-w-9 w-9 hover:opacity-75" />
                                            </Link>
                                            <Link :href="route('regulacao.contratos.edit', slotProps.data.id)"
                                                title="Editar"
                                                v-if="has(
                                                    $page.props.auth.permissions, ['Contratos Editar', 'Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <img src="/icons/editar.svg" alt="Editar Contrato"
                                                class="min-w-9 w-9 hover:opacity-75" />
                                            </Link>
                                        </div>
                                    </template>
                                </Column>
                            </DataTable>
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
