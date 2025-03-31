<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import { Select, DatePicker, Button, ProgressSpinner, DataTable, Column, AccordionHeader, AccordionContent } from 'primevue';
import { ref } from 'vue';
import axios from 'axios';
import { toast } from '@/toast';

const props = defineProps({
    postos_coleta: Object | null
})

const agenda = ref({
    posto_coleta: null,
    agendas: [],
    loading: false,
    abrir: false
})

function buscarAgenda(event) {
    agenda.value.abrir = false
    agenda.value.agendas = []
    if (!agenda.value.posto_coleta) {
        toast.error('Selecione um posto de coleta.')
        throw ('Posto de Coleta não informado.')
    }
    agenda.value.loading = true
    axios.post(route('regulacao.agenda.buscar-agendas'), agenda.value.posto_coleta)
        .then((r) => {
            agenda.value.agendas = r.data
            agenda.value.abrir = true
        })
        .catch((e) => {
            console.log(e)
        })
        .finally(() => {
            agenda.value.loading = false
        })
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
                            :href="route('regulacao.financeiro.index')" title="Início Financeiro">
                        <img src="/icons/financeiro.svg" alt="Início Financeiro" class="w-6">
                        </Link>
                    </div>
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-6 gap-3 place-items-center">
                            <div class="col-span-6 w-full">
                                <label class="font-semibold inline-flex">Posto de Coleta</label>
                                <Select id="posto" v-model="agenda.posto_coleta" :options="props.postos_coleta"
                                    placeholder="Selecione um Posto de Coleta" class="w-full" filter option-label="name"
                                    required @change="agenda.abrir = false; agenda.agendas = []">
                                </Select>
                            </div>
                            <div class="col-span-3 w-full gap-3 space-x-3">
                                <Button typeof="button" label="Buscar Agendas" @click="buscarAgenda($event)" />
                                <Button typeof="button" label="Limpar" severity="warn"
                                    @click="agenda.posto_coleta = null; agenda.abrir = false; agenda.agendas = []" />
                            </div>

                            <div class="text-center col-span-6">
                                <ProgressSpinner v-if="agenda.loading" />
                            </div>
                            <div class="col-span-6 w-full grid grid-cols-1" v-if="agenda.abrir">
                                <div class="w-full">
                                    <Button severity="success" label="Criar Agenda" class="float-right" />
                                </div>
                                <div>
                                    <DataTable :value="agenda.agendas" :class="'w-full'"
                                        table-style="width: 100%; min-width: 55rem" class="mt-2">
                                        <Column field="vigencia_inicio" header="Início" style="width: 15%">
                                            <template #body="slotProps">
                                                {{ moment(slotProps.data.vigencia_inicio).format('DD/MM/YYYY') }}
                                            </template>
                                        </Column>
                                        <Column field="vigencia_fim" header="Fim" style="width: 15%">
                                            <template #body="slotProps">
                                                {{ moment(slotProps.data.vigencia_fim).format('DD/MM/YYYY') }}
                                            </template>
                                        </Column>
                                        <Column field="hora_inicio" header="Início" style="width: 6%"></Column>
                                        <Column field="hora_fim" header="Fim" style="width: 6%"></Column>
                                        <Column field="intervalo" header="Intervalo" style="width: 6%"></Column>
                                        <Column field="vagas" header="Vagas Abertas" style="width: 20%">
                                            <template #body="slotProps">
                                                {{ slotProps.data.vagas }}
                                            </template>
                                        </Column>
                                        <Column field="ativo" header="Ativo" style="width: 5%">
                                            <template #body="slotProps">
                                                {{ slotProps.data.deleted_at ? 'Não' : 'Sim' }}
                                            </template>
                                        </Column>
                                        <Column field="id" header="Ações" style="width: 12%">
                                            <template #body="slotProps">
                                                <div class="inline-flex gap-3">
                                                    editar, inativar
                                                </div>
                                            </template>
                                        </Column>
                                    </DataTable>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
