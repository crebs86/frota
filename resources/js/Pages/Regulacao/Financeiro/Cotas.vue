<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import { ref } from 'vue';
import { Button, DatePicker, InputText, ProgressSpinner, Select } from 'primevue';
import { toast } from '@/toast';
import axios from 'axios';
import { currencyMask } from '@/mask';

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
                } else if (r.data.cotas_financeiras.length === 1) {
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
        axios.post(route('regulacao.financeiro.cota.salvar-cota'), {
            contrato: busca.value.contrato.hash,
            posto_coleta: busca.value.posto_coleta.hash,
            cota: cota.value
        })
            .then((r) => {
                toast.success('Cota definida.')
                cota.value = null
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
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('regulacao.financeiro.index')" title="Início Financeiro">
                    <img src="/icons/financeiro.svg" alt="Início Financeiro" class="w-6">
                    </Link>
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-3 gap-3 place-items-center">

                            <form @submit.prevent="buscarCota()" class="col-span-3 w-full">
                                <div class="col-span-3 w-full">
                                    <label class="font-semibold inline-flex">Posto de Coleta*</label>
                                    <Select id="posto" v-model="busca.posto_coleta" :options="props.postos_coleta"
                                        placeholder="Selecione um Posto de Coleta" class="w-full" filter
                                        option-label="name" required>
                                    </Select>
                                </div>

                                <div class="col-span-3 w-full">
                                    <label class="font-semibold">Contrato*</label>
                                    <Select id="contrato" v-model="busca.contrato" :options="props.contratos"
                                        placeholder="Selecione um Contrato" class="w-full" filter
                                        option-label="contrato" required>
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
                                    <Button type="submit" class="mt-3" severity="info">Buscar Cota</Button>
                                </div>

                                <div class="text-center col-span-3">
                                    <ProgressSpinner v-if="busca.loading" />
                                </div>
                            </form>

                            <div class="col-span-3 w-full" v-if="cotaUnidade.length === 1">
                                {{ cotaUnidade.length }}
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
                                        <DatePicker v-model="cota.inicio" showIcon fluid :showOnFocus="true" required />
                                        <div v-if="cota.errors.inicio" class="text-sm text-red-500">
                                            <p v-for="error in cota.errors.inicio">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="w-full">
                                        <label for="valor" class="font-semibold inline-flex">Fim*</label>
                                        <DatePicker v-model="cota.fim" showIcon fluid :showOnFocus="true" required />
                                        <div v-if="cota.errors.fim" class="text-sm text-red-500">
                                            <p v-for="error in cota.errors.fim">{{ error }}</p>
                                        </div>
                                    </div>

                                    <Button type="submit" label="Salvar Cota" class="mt-3" />
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
