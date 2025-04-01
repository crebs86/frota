<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import { Select, DatePicker, Button, ProgressSpinner, DataTable, Column, AccordionHeader, AccordionContent, Dialog, InputText } from 'primevue';
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
    modal: false
})

const novaAgenda = ref({
    inicio: '',
    fim: '',
    hora_inicio: '',
    hora_fim: '',
    vagas: '',
    intervalo: '',
    loading: false,
    abrir: false,
})

const editarAgenda = ref({
    inicio: '',
    fim: '',
    hora_inicio: '',
    hora_fim: '',
    vagas: '',
    intervalo: '',
    loading: false,
    abrir: false,
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

function resetCriarAgenda() {
    novaAgenda.value = {
        inicio: '',
        fim: '',
        hora_inicio: '',
        hora_fim: '',
        vagas: '',
        intervalo: '',
        loading: false,
        abrir: false,
        hash: ''
    }
}

function criarAgenda() {
    if (!novaAgenda.value.inicio || !novaAgenda.value.fim || !novaAgenda.value.hora_inicio || !novaAgenda.value.hora_fim || !novaAgenda.value.vagas || !novaAgenda.value.intervalo) {
        toast.error('Informe todos os campos antes de prosseguir.')
        throw ('Informe todos os campos antes de prosseguir.')
    } else {
        novaAgenda.value.loading = true
        axios.post(route('regulacao.agenda.store'), {
            hash: agenda.value.posto_coleta.hash,
            vigencia_inicio: novaAgenda.value.inicio,
            vigencia_fim: novaAgenda.value.fim,
            hora_inicio: moment(novaAgenda.value.hora_inicio).format('HH:mm'),
            hora_fim: moment(novaAgenda.value.hora_fim).format('HH:mm'),
            intervalo: novaAgenda.value.intervalo,
            vagas: novaAgenda.value.vagas,
        })
            .then((r) => {
                resetCriarAgenda()
                agenda.value.agendas = r.data
            }).catch((e) => {
                console.log(e)
            })
            .finally(() => {
                novaAgenda.value.loading = false
            })
    }
}

function resetEditarAgenda() {
    editarAgenda.value = {
        inicio: '',
        fim: '',
        hora_inicio: '',
        hora_fim: '',
        vagas: '',
        intervalo: '',
        loading: false,
        abrir: false,
        hash: '',
        loading: false
    }
}

function setAgenda(agenda) {
    editarAgenda.value = {
        inicio: moment(agenda.vigencia_inicio).format('DD/MM/YYYY'),
        fim: moment(agenda.vigencia_fim).format('DD/MM/YYYY'),
        hora_inicio: agenda.hora_inicio,
        hora_fim: agenda.hora_fim,
        vagas: agenda.vagas,
        intervalo: agenda.intervalo.toString(),
        abrir: true,
        hash: agenda.hash,
    }
}

function atualizarAgenda() {
    if (!editarAgenda.value.inicio || !editarAgenda.value.fim || !editarAgenda.value.hora_inicio || !editarAgenda.value.hora_fim || !editarAgenda.value.vagas || !editarAgenda.value.intervalo) {
        toast.error('Informe todos os campos antes de prosseguir.')
        throw ('Informe todos os campos antes de prosseguir.')
    } else {
        editarAgenda.value.loading = true
        axios.put(route('regulacao.agenda.update'), {
            hash: agenda.value.posto_coleta.hash,
            agenda: editarAgenda.value.hash,
            vigencia_inicio: moment(editarAgenda.value.inicio, 'DD/MM/YYYY').format('YYYY-MM-DD'),
            vigencia_fim: moment(editarAgenda.value.fim, 'DD/MM/YYYY').format('YYYY-MM-DD'),
            hora_inicio: moment(editarAgenda.value.hora_inicio, 'HH:mm:ss').format('HH:mm'),
            hora_fim: moment(editarAgenda.value.hora_fim, 'HH:mm:ss').format('HH:mm'),
            intervalo: editarAgenda.value.intervalo,
            vagas: editarAgenda.value.vagas,
        })
            .then((r) => {
                resetCriarAgenda()
                agenda.value.agendas = r.data
            }).catch((e) => {
                console.log(e)
            })
            .finally(() => {
                editarAgenda.value.loading = false
                editarAgenda.value.abrir = false
            })
    }
}

const desativar = ref({
    loading: false,
    abrir: false
})

function desativarAgenda() {
    desativar.value.loading = true
    axios.post(route('regulacao.agenda.delete'), {
        hash: agenda.value.posto_coleta.hash,
        agenda: editarAgenda.value.hash
    })
        .then((r) => {
            toast.success('A agenda foi desativada.')
            agenda.value.agendas = r.data
        }).catch((e) => {
            console.log(e)
        })
        .finally(() => {
            desativar.value.loading = false
            desativar.value.abrir = false
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
                                    <Button @click="novaAgenda.abrir = true" severity="success" label="Criar Agenda"
                                        class="float-right" />
                                </div>
                                <div>
                                    <DataTable :value="agenda.agendas" :class="'w-full'"
                                        table-style="width: 100%; min-width: 55rem" class="mt-2">
                                        <Column field="vigencia_inicio" header="Data Início" style="width: 15%"
                                            sortable>
                                            <template #body="slotProps">
                                                {{ moment(slotProps.data.vigencia_inicio).format('DD/MM/YYYY') }}
                                            </template>
                                        </Column>
                                        <Column field="vigencia_fim" header="Data Fim" style="width: 15%" sortable>
                                            <template #body="slotProps">
                                                {{ moment(slotProps.data.vigencia_fim).format('DD/MM/YYYY') }}
                                            </template>
                                        </Column>
                                        <Column field="hora_inicio" header="Hora Início" style="width: 12%"></Column>
                                        <Column field="hora_fim" header="Hora Fim" style="width: 6%"></Column>
                                        <Column field="intervalo" header="Intervalo" style="width: 6%"></Column>
                                        <Column field="vagas" header="Vagas Abertas" style="width: 16%">
                                            <template #body="slotProps">
                                                {{ slotProps.data.vagas }}
                                            </template>
                                        </Column>
                                        <Column field="ativo" header="Ativo" style="width: 4%">
                                            <template #body="slotProps">
                                                {{ slotProps.data.deleted_at ? 'Não' : 'Sim' }}
                                            </template>
                                        </Column>
                                        <Column field="id" header="Ações" style="width: 12%">
                                            <template #body="slotProps">
                                                <div class="flex justify-center gap-3">
                                                    <button title="Editar Agenda" @click="setAgenda(slotProps.data)"
                                                        v-if="has(
                                                            $page.props.auth.permissions, ['Contratos Editar', 'Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                                        <img src="/icons/editar.svg" alt="Editar Agenda"
                                                            class="min-w-9 w-9 hover:opacity-75" />
                                                    </button>
                                                    <button title="Desativar Agenda"
                                                        @click="editarAgenda.hash = slotProps.data.hash; desativar.abrir = true;"
                                                        v-if="has(
                                                            $page.props.auth.permissions, ['Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                                        <img src="/icons/desabilitar.svg" alt="Desativar Agenda"
                                                            class="min-w-9 w-9 hover:opacity-75" />
                                                    </button>
                                                </div>
                                            </template>
                                        </Column>
                                    </DataTable>
                                </div>
                            </div>
                        </div>
                    </div>
                    <Dialog v-model:visible="novaAgenda.abrir" header="Criar Agenda"
                        :style="{ width: '98%', maxWidth: '500px' }">
                        <form @submit.prevent="criarAgenda()">
                            <ul>
                                <li>
                                    Posto de Coleta: {{ agenda?.posto_coleta?.name }}
                                </li>
                            </ul>
                            <div class="grid grid-cols-1 gap-3 my-4">
                                <div class="grid grid-cols-1">
                                    <label class="font-semibold inline-flex">Vigência Início</label>
                                    <DatePicker v-model="novaAgenda.inicio" showIcon fluid :showOnFocus="true" />
                                </div>
                                <div class="grid grid-cols-1">
                                    <label for="fim" class="font-semibold inline-flex">Vigência Fim</label>
                                    <DatePicker v-model="novaAgenda.fim" showIcon fluid :showOnFocus="true" />
                                </div>

                                <div class="grid grid-cols-1">
                                    <label for="hota_inicio" class="font-semibold inline-flex">Hora Início</label>
                                    <DatePicker v-model="novaAgenda.hora_inicio" showIcon fluid :showOnFocus="true"
                                        timeOnly />
                                </div>
                                <div class="grid grid-cols-1">
                                    <label for="hora_fim" class="font-semibold inline-flex">Hora Fim</label>
                                    <DatePicker v-model="novaAgenda.hora_fim" showIcon fluid :showOnFocus="true"
                                        timeOnly />
                                </div>

                                <div class="grid grid-cols-1">
                                    <label for="hora_fim" class="font-semibold inline-flex">Vagas</label>
                                    <InputText type="number" v-model="novaAgenda.vagas" />
                                </div>
                                <div class="grid grid-cols-1">
                                    <label for="hora_fim" class="font-semibold inline-flex">Intervalo</label>
                                    <InputText type="number" v-model="novaAgenda.intervalo" />
                                </div>
                            </div>
                            <div class="flex justify-end gap-2">
                                <Button type="button" label="Cancelar" severity="secondary"
                                    @click="novaAgenda.abrir = false"></Button>
                                <Button type="submit" severity="info" :disabled="novaAgenda.loading">
                                    Criar Agenda
                                    <ProgressSpinner v-if="novaAgenda.loading" style="width: 18px; height: 18px;"
                                        strokeWidth="8" />
                                </Button>
                            </div>
                        </form>
                    </Dialog>
                    <Dialog v-model:visible="editarAgenda.abrir" header="Editar Agenda"
                        :style="{ width: '98%', maxWidth: '500px' }">
                        <form @submit.prevent="atualizarAgenda()">
                            <ul>
                                <li>
                                    Posto de Coleta: {{ agenda?.posto_coleta?.name }}
                                </li>
                            </ul>
                            <div class="grid grid-cols-1 gap-3 my-4">
                                <div class="grid grid-cols-1">
                                    <label class="font-semibold inline-flex">Vigência Início</label>
                                    <DatePicker v-model="editarAgenda.inicio" showIcon fluid :showOnFocus="true" />
                                </div>
                                <div class="grid grid-cols-1">
                                    <label for="fim" class="font-semibold inline-flex">Vigência Fim</label>
                                    <DatePicker v-model="editarAgenda.fim" showIcon fluid :showOnFocus="true" />
                                </div>

                                <div class="grid grid-cols-1">
                                    <label for="hota_inicio" class="font-semibold inline-flex">Hora Início</label>
                                    <DatePicker v-model="editarAgenda.hora_inicio" showIcon fluid :showOnFocus="true"
                                        timeOnly />
                                </div>
                                <div class="grid grid-cols-1">
                                    <label for="hora_fim" class="font-semibold inline-flex">Hora Fim</label>
                                    <DatePicker v-model="editarAgenda.hora_fim" showIcon fluid :showOnFocus="true"
                                        timeOnly />
                                </div>

                                <div class="grid grid-cols-1">
                                    <label for="hora_fim" class="font-semibold inline-flex">Vagas</label>
                                    <InputText type="number" v-model="editarAgenda.vagas" />
                                </div>
                                <div class="grid grid-cols-1">
                                    <label for="hora_fim" class="font-semibold inline-flex">Intervalo</label>
                                    <InputText type="number" v-model="editarAgenda.intervalo" />
                                </div>
                            </div>
                            <div class="flex justify-end gap-2">
                                <Button type="button" label="Cancelar" severity="secondary"
                                    @click="editarAgenda.abrir = false; resetEditarAgenda();"></Button>
                                <Button type="submit" severity="info" :disabled="editarAgenda.loading">
                                    Atualizar Agenda
                                    <ProgressSpinner v-if="editarAgenda.loading" style="width: 18px; height: 18px;"
                                        strokeWidth="8" />
                                </Button>
                            </div>
                        </form>
                    </Dialog>
                    <Dialog v-model:visible="desativar.abrir" header="Desativar Agenda"
                        :style="{ width: '98%', maxWidth: '500px' }">
                        <form @submit.prevent="desativarAgenda(editarAgenda.agenda)">
                            <ul>
                                <li>
                                    Posto de Coleta: {{ agenda?.posto_coleta?.name }}
                                </li>
                            </ul>
                            <div class="grid grid-cols-1 gap-3 my-4">
                                <p>Deseja realmente desativar esta agenda?</p>
                            </div>
                            <div class="flex justify-end gap-2">
                                <Button type="button" label="Cancelar" severity="secondary"
                                    @click="desativar.abrir = false; resetEditarAgenda();"></Button>
                                <Button type="submit" severity="info" :disabled="desativar.loading">
                                    Atualizar Agenda
                                    <ProgressSpinner v-if="desativar.loading" style="width: 18px; height: 18px;"
                                        strokeWidth="8" />
                                </Button>
                            </div>
                        </form>
                    </Dialog>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
