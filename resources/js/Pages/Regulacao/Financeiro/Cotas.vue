<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import { ref } from 'vue';
import { Button, DatePicker, InputText, ProgressSpinner, Select, DataTable, Column, Dialog, Textarea } from 'primevue';
import { toast } from '@/toast';
import axios from 'axios';
import { currencyMask } from '@/mask';

import Accordion from 'primevue/accordion';
import AccordionPanel from 'primevue/accordionpanel';
import AccordionHeader from 'primevue/accordionheader';
import AccordionContent from 'primevue/accordioncontent';/**/

const props = defineProps({
    contratos: Object,
    postos_coleta: Object
})

const busca = ref({
    posto_coleta: '',
    contrato: '',
    loading: false,
    criarCota: false
})

const cotaUnidade = ref([])

const cota = ref({
    valor: '',
    inicio: '',
    fim: '',
    errors: []
})

function buscarCota() {
    cotaUnidade.value = []
    if (!busca.value.posto_coleta || !busca.value.contrato) {
        toast.error('Selecione um Posto de Coleta e um Contrato')
    } else {
        busca.value.loading = true
        busca.value.criarCota = false
        axios.post(route('regulacao.financeiro.cota.buscar-cota'), {
            contrato: busca.value.contrato.hash,
            posto_coleta: busca.value.posto_coleta.hash
        })
            .then((r) => {
                if (r.data.cotas_financeiras.length === 0) {
                    toast.info('Nenhuma cota definida para este posto de coleta para este contrato.')
                    busca.value.criarCota = true
                } else if (r.data.cotas_financeiras.length >= 1) {
                    cotaUnidade.value = r.data.cotas_financeiras
                } else {
                    toast.error('Erro ao buscar cotas.')
                }
            })
            .catch((e) => {
                if (e.response?.status === 422) {
                    toast.error(e.response.data);
                } else {
                    console.log(e)
                }
            })
            .finally(() => {
                busca.value.loading = false
            })
    }
}

function salvarCota() {
    if (!cota.value.valor || !cota.value.inicio || !cota.value.fim || !busca.value.posto_coleta || !busca.value.contrato) {
        toast.error('Informe todos os campos')
    } else {
        busca.value.loading = true
        axios.post(route('regulacao.financeiro.cota.salvar-cota'), {
            contrato: busca.value.contrato.hash,
            posto_coleta: busca.value.posto_coleta.hash,
            cota: cota.value
        })
            .then((r) => {
                toast.success('Cota definida.')
                cota.value = { valor: '', inicio: '', fim: '', errors: [] }
                cotaUnidade.value = r.data.cotas_financeiras
            })
            .catch((e) => {

                toast.error('Foram encontrado erros ao processar sua solicitação.');
                if (e.response?.status === 422) {
                    cota.value.errors = e.response?.data?.errors
                } else {
                    console.log(e)
                }
            })
            .finally(() => {
                busca.value.loading = false
            })
    }
}

const modal = ref({
    editarCota: false,
    copiarCota: false,
})

const processing = ref({
    editarCota: false,
    copiarCota: false,
})

const cotaAtual = ref({})

function setCotaAtual(valor, editar = true) {
    cotaAtual.value = valor
    cotaAtual.value._inicio = ''
    cotaAtual.value._fim = ''
    cotaAtual.value.valor = currencyMask(valor.valor)
    if (editar) {
        modal.value.editarCota = true
    } else {
        modal.value.copiarCota = true
    }
}

function atualizarCota() {
    processing.value.editarCota = true
    axios.post(route('regulacao.financeiro.cota.atualizar-cota'), {
        contrato: busca.value.contrato.hash,
        posto_coleta: busca.value.posto_coleta.hash,
        valor: cotaAtual.value.valor,
        inicio: cotaAtual.value._inicio,
        fim: cotaAtual.value._fim,
        hash: cotaAtual.value.hash
    })
        .then((r) => {
            cotaUnidade.value = r.data.cotas_financeiras
            modal.value.editarCota = false
        })
        .catch((e) => {
            if (e.response?.status === 422) {
                toast.error(e.response.data?.message);
            } else if (e.response?.status === 409) {
                toast.error(e.response.data);
            } else {
                console.log(e)
            }
        })
        .finally(() => {
            processing.value.editarCota = false
        })
}

function copiarCota() {
    processing.value.copiarCota = true
    axios.post(route('regulacao.financeiro.cota.copiar-cota'), {
        contrato: busca.value.contrato.hash,
        posto_coleta: busca.value.posto_coleta.hash,
        valor: cotaAtual.value.valor,
        inicio: cotaAtual.value._inicio,
        fim: cotaAtual.value._fim,
        hash: cotaAtual.value.hash
    })
        .then((r) => {
            cotaUnidade.value = r.data.cotas_financeiras
            modal.value.copiarCota = false
        })
        .catch((e) => {
            if (e.response?.status === 422) {
                toast.error(e.response.data?.message);
            } else if (e.response?.status === 409) {
                toast.error(e.response.data);
            } else {
                console.log(e)
            }
        })
        .finally(() => {
            processing.value.copiarCota = false
        })
}

</script>

<template>

    <Head title="Cota Financeira" />

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Cota Financeira
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.58)]">
                    <div class="inline-flex">
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.home')" title="Início Financeiro">
                        <img src="/icons/home.svg" alt="Início Financeiro" class="w-6">
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
                        <div class="grid grid-cols-3 gap-3 place-items-center">

                            <form @submit.prevent="buscarCota()" class="col-span-3 w-full">
                                <div class="col-span-3 w-full">
                                    <label class="font-semibold inline-flex">Posto de Coleta*</label>
                                    <Select id="posto" v-model="busca.posto_coleta" :options="props.postos_coleta"
                                        placeholder="Selecione um Posto de Coleta" class="w-full" filter
                                        option-label="name" required
                                        @change="cotaUnidade = []; busca.criarCota = false">
                                    </Select>
                                </div>

                                <div class="col-span-3 w-full">
                                    <label class="font-semibold">Contrato*</label>
                                    <Select id="contrato" v-model="busca.contrato" :options="props.contratos"
                                        placeholder="Selecione um Contrato" class="w-full" filter
                                        option-label="contrato" required
                                        @change="cotaUnidade = []; busca.criarCota = false">
                                        <template #option="slotProps">
                                            <div class="flex items-center">
                                                <div>Contrato: {{ slotProps.option.contrato }}/
                                                    {{ slotProps.option.ano }} -
                                                    {{ slotProps.option.contratada_nome }} - Versão
                                                    {{ slotProps.option.versao }}
                                                </div>
                                            </div>
                                        </template>
                                    </Select>
                                </div>

                                <div class="col-span-4">
                                    <Button type="submit" class="mt-3" severity="info" :disabled="busca.loading">Buscar
                                        Cota</Button>
                                </div>

                                <div class="text-center col-span-3">
                                    <ProgressSpinner v-if="busca.loading" />
                                </div>
                            </form>

                            <div class="col-span-3 w-full" v-if="cotaUnidade.length > 0">
                                <DataTable :value="cotaUnidade" table-style="width: 100%; min-width: 60rem"
                                    class="mt-2">
                                    <Column field="name" header="Posto de Coleta" style="width: 23%" />
                                    <Column field="valor" header="Valor Atual" style="width: 15%">
                                        <template #body="slotProps">
                                            R$ {{ currencyMask(slotProps.data.valor) }}
                                        </template>
                                    </Column>
                                    <Column field="alteracoes" header="Alterações" style="width: 31%">
                                        <template #body="slotProps">
                                            <Accordion value="1" class="col-span-3 w-full">
                                                <AccordionPanel value="0">
                                                    <AccordionHeader></AccordionHeader>
                                                    <AccordionContent>
                                                        <ul v-for="(v, i) in JSON.parse(slotProps.data.alteracoes ?? '{}')"
                                                            :key="'alt_' + i" class="border-b-2">
                                                            <li>Usuário: {{ v.user }}</li>
                                                            <li>Valor: {{ v.valor }}</li>
                                                            <li>Data: {{ moment(v.data).format('DD/MM/YYYY HH:mm:ss') }}
                                                            </li>
                                                            <li>Início: {{ moment(v.inicio).format('DD/MM/YYYY') }}</li>
                                                            <li>Fim: {{ moment(v.fim).format('DD/MM/YYYY') }}</li>
                                                        </ul>
                                                    </AccordionContent>
                                                </AccordionPanel>
                                            </Accordion>
                                        </template>
                                    </Column>
                                    <Column field="inicio" header="Início" style="width: 11%">
                                        <template #body="slotProps">
                                            {{ moment(slotProps.data.inicio).format('DD/MM/YYYY') }}
                                        </template>
                                    </Column>
                                    <Column field="fim" header="Fim" style="width: 11%">
                                        <template #body="slotProps">
                                            {{ moment(slotProps.data.fim).format('DD/MM/YYYY') }}
                                        </template>
                                    </Column>
                                    <Column field="id" header="Ações" style="width: 9%">
                                        <template #body="slotProps">
                                            <div class="inline-flex gap-3">
                                                <button type="button" @click.prevent="setCotaAtual(slotProps.data)"
                                                    title="Editar Cota" v-if="has(
                                                        $page.props.auth.permissions, ['Contratos Editar', 'Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])
                                                    ">
                                                    <img src="/icons/editar.svg" alt="Editar Cota"
                                                        class="min-w-9 w-9 hover:opacity-75" />
                                                </button>

                                                <button type="button"
                                                    @click.prevent="setCotaAtual(slotProps.data, false)"
                                                    title="Copiar Cota" v-if="has(
                                                        $page.props.auth.permissions, ['Contratos Editar', 'Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])
                                                    ">
                                                    <img src="/icons/copia.svg" alt="Copiar Cota"
                                                        class="min-w-9 w-9 hover:opacity-75" />
                                                </button>
                                            </div>
                                        </template>
                                    </Column>
                                </DataTable>
                            </div>

                            <div class="col-span-3 w-full border-t mt-3 pt-3"
                                v-if="cotaUnidade.length === 0 && busca.criarCota">

                                <form class="col-span-3" @submit.prevent="salvarCota()">
                                    <div class="w-full">
                                        <label for="valor" class="font-semibold inline-flex">Valor (R$)*</label>
                                        <InputText v-model="cota.valor" id="valor" class="flex-auto w-full"
                                            @keyup="cota.valor = currencyMask($event.target.value)" autocomplete="off"
                                            required />
                                        <div v-if="cota.errors.valor" class="text-sm text-red-500">
                                            <p v-for="error in cota.errors.valor">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="w-full">
                                        <label for="valor" class="font-semibold inline-flex">Início*</label>
                                        <DatePicker v-model="cota.inicio" showIcon fluid :showOnFocus="true" required
                                            date-format="dd/mm/yy" />
                                        <div v-if="cota.errors.inicio" class="text-sm text-red-500">
                                            <p v-for="error in cota.errors.inicio">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="w-full">
                                        <label for="valor" class="font-semibold inline-flex">Fim*</label>
                                        <DatePicker v-model="cota.fim" showIcon fluid :showOnFocus="true" required
                                            date-format="dd/mm/yy" />
                                        <div v-if="cota.errors.fim" class="text-sm text-red-500">
                                            <p v-for="error in cota.errors.fim">{{ error }}</p>
                                        </div>
                                    </div>

                                    <Button type="submit" label="Salvar Cota" class="mt-3" :disabled="busca.loading" />
                                </form>
                            </div>
                            <Dialog v-model:visible="modal.editarCota" modal header="Editar Cota"
                                :style="{ width: '98%', maxWidth: '500px' }">
                                <form @submit.prevent="atualizarCota()">
                                    <ul>Detalhes
                                        <li><span class="font-bold">Contrato: </span>
                                            {{ busca.contrato.contrato }}/{{ busca.contrato.ano }}
                                        </li>
                                        <li><span class="font-bold">Posto de Coleta: </span>{{ cotaAtual.name }}</li>
                                        <li><span class="font-bold">Período:
                                            </span>{{ moment(cotaAtual.inicio).format('DD/MM/YYYY') }} a
                                            {{ moment(cotaAtual.fim).format('DD/MM/YYYY') }}
                                        </li>
                                    </ul>
                                    <Accordion value="1" class="col-span-3 w-full">
                                        <AccordionPanel value="0">
                                            <AccordionHeader>Alterar Período</AccordionHeader>
                                            <AccordionContent>

                                                <div class="grid gap-4 my-4">
                                                    <label class="font-semibold inline-flex">Início</label>
                                                    <DatePicker v-model="cotaAtual._inicio" showIcon fluid
                                                        :showOnFocus="true" />
                                                </div>

                                                <div class="grid gap-4 my-4">
                                                    <label for="fim" class="font-semibold inline-flex">Fim</label>
                                                    <DatePicker v-model="cotaAtual._fim" showIcon fluid
                                                        :showOnFocus="true" required />
                                                </div>

                                            </AccordionContent>
                                        </AccordionPanel>
                                    </Accordion>
                                    <div class="grid gap-4 my-4">
                                        <label for="valor" class="font-semibold w-24">Valor (R$)</label>
                                        <InputText v-model="cotaAtual.valor" id="valor" class="flex-auto"
                                            @keyup="cotaAtual.valor = currencyMask($event.target.value)"
                                            autocomplete="off" required />
                                    </div>
                                    <div class="flex justify-end gap-2">
                                        <Button type="button" label="Cancelar" severity="secondary"
                                            @click="modal.editarCota = false"></Button>
                                        <Button type="submit" label="Atualizar Cota"
                                            :disabled="processing.editarCota"></Button>
                                    </div>
                                </form>
                            </Dialog>
                            <Dialog v-model:visible="modal.copiarCota" modal header="Copiar Cota"
                                :style="{ width: '98%', maxWidth: '500px' }">
                                <form @submit.prevent="copiarCota()">
                                    <ul>Detalhes
                                        <li><span class="font-bold">Contrato: </span>
                                            {{ busca.contrato.contrato }}/{{ busca.contrato.ano }}
                                        </li>
                                        <li><span class="font-bold">Posto de Coleta: </span>{{ cotaAtual.name }}</li>
                                        <li><span class="font-bold">Período:
                                            </span>{{ moment(cotaAtual.inicio).format('DD/MM/YYYY') }} a
                                            {{ moment(cotaAtual.fim).format('DD/MM/YYYY') }}
                                        </li>
                                    </ul>
                                    <div class="grid gap-4 my-4">
                                        <div class="grid gap-4 my-4">
                                            <label class="font-semibold inline-flex">Início</label>
                                            <DatePicker v-model="cotaAtual._inicio" showIcon fluid
                                                :showOnFocus="true" />
                                        </div>

                                        <div class="grid gap-4 my-4">
                                            <label for="fim" class="font-semibold inline-flex">Fim</label>
                                            <DatePicker v-model="cotaAtual._fim" showIcon fluid :showOnFocus="true"
                                                required />
                                        </div>
                                    </div>
                                    <div class="flex justify-end gap-2">
                                        <Button type="button" label="Cancelar" severity="secondary"
                                            @click="modal.copiarCota = false"></Button>
                                        <Button type="submit" label="Copiar Cota" severity="info"
                                            :disabled="processing.copiarCota"></Button>
                                    </div>
                                </form>
                            </Dialog>
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
