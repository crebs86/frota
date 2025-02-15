<script setup>
import {toast} from '@/toast';
import axios from 'axios';
import {defineEmits, onMounted, ref} from 'vue';
import moment from 'moment';
import validateCUR from "@/validates/insertUpdateFill.js";

const abastecerModalStatus = defineEmits(['abastecerModalStatus'])

function statusModal(status) {
    abastecerModalStatus('abastecerModalStatus', status)
}

const props = defineProps({
    car: Object | null
})

const fills = ref([]);

const fill = ref({
    car: props.car,
    km: '',
    quantidade: '',
    valor: '',
    local: '',
    observacao: '',
    arquivo: '',
    hora: '',
    data: '',
    errors: ''
})

function loadLastFill() {
    if (props.car) {
        axios.post(route('frota.load-last-fill'), props.car)
            .then((r) => {
                fills.value = r.data
            })
            .catch((e) => {
                toast.error(e.response.data)
            })
    } else {
        toast.warning('Selecione um carro para abastecer.')
        statusModal(false)
    }
}

function insertFill() {
    fill.value.errors = ''
    let val = validateCUR(fill.value, ['observacao', 'local', 'valor']);
    if (props.car && val._run) {
        axios.post(route('frota.insert-fill'), fill.value)
            .then(() => {
                fill.value = {
                    km: '',
                    quantidade: '',
                    valor: '',
                    local: '',
                    observacao: '',
                    arquivo: '',
                    hora: '',
                    data: '',
                    errors: ''
                }
                loadLastFill()
            })
            .catch((e) => {
                console.log(e.response?.data?.errors)
                fill.value.errors = e.response?.data?.errors
            })
            .finally()
    } else {
        if (!fill.value.car) {
            toast.warning('Selecione um carro para abastecer.')
            statusModal(false)
        } else {
            fill.value.errors = val
            toast.warning('Informe todos os campos obrigatórios.')
        }
    }
}

const maskCurrency = (event) => {
    let input = event.target;
    fill.value.valor = currencyMask(input.value);
}

const currencyMask = (value) => {
    if (!value) return "";
    value = value.replace(".", "").replace(",", "").replace(/\D/g, "");
    let options = {minimumFractionDigits: 2};
    value = new Intl.NumberFormat("pt-BR", options).format(
        parseFloat(value) / 100
    );

    return value;
};


onMounted(() => {
    loadLastFill()
})

</script>
<template>
    <div
        class="overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none justify-center items-center flex max-h-[95%]">
        <div class="relative my-6 mx-auto w-11/12 md:w-10/12 max-w-6xl max-h-[95%]">

            <div class="border-0 rounded-lg shadow-lg relative flex flex-col w-full outline-none focus:outline-none"
                 :class="$page.props.app.settingsStyles.main.container">

                <div class="flex items-start justify-between p-5 border-b border-solid border-slate-200 rounded-t">
                    <h3 class="text-xl font-semibold uppercase">
                        Abastecimento
                    </h3>
                    <button @click="statusModal(false)"
                            class="absolute -top-3 -right-3 bg-red-500 hover:bg-red-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white">
                        &cross;
                    </button>
                </div>

                <div class="relative p-6 grid grid-cols-1 md:grid-cols-2">
                    <div class="grid grid-cols-2 col-span-2 gap-2 items-start">
                        <div class="grid grid-cols-1 col-span-2 md:col-span-1">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Data*
                            </label>
                            <input type="date" v-model="fill.data"
                                   class="rounded border border-black h-[41px] mt-0.5 text-gray-700"/>

                            <div v-if="fill.errors?.data"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in fill.errors?.data">{{ error }} </small>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 col-span-2 md:col-span-1">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Hora*
                            </label>
                            <input type="time" v-model="fill.hora"
                                   class="rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                            <div v-if="fill.errors?.hora"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in fill.errors?.hora">{{ error }} &nbsp;</small>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 col-span-2 gap-2 items-start">
                        <div class="grid grid-cols-1 mt-6 col-span-2 md:col-span-1">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                *Quantidade (litros)
                            </label>
                            <input type="text" v-model="fill.quantidade"
                                   class="rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                            <div v-if="fill.errors?.quantidade"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in fill.errors?.quantidade">{{ error }} &nbsp;</small>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 mt-6 col-span-2 md:col-span-1">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Valor (R$)
                            </label>
                            <input type="text" v-model="fill.valor" @keyup="maskCurrency($event)"
                                   class="rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                            <div v-if="fill.errors?.valor"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in fill.errors?.valor">{{ error }} &nbsp;</small>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 col-span-2 gap-2 items-start">
                        <div class="grid grid-cols-1 mt-6 col-span-2 md:col-span-1">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                *Km
                            </label>
                            <input type="text" v-model="fill.km"
                                   class="rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                            <div v-if="fill.errors?.km"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in fill.errors?.km">{{ error }} &nbsp;</small>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 mt-6 col-span-2 md:col-span-1">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Local de Abastecimento
                            </label>
                            <input type="text" v-model="fill.local"
                                   class="rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                            <div v-if="fill.errors?.local"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in fill.errors?.local">{{ error }} &nbsp;</small>
                            </div>

                        </div>
                    </div>

                    <div class="grid grid-cols-1 col-span-2 mt-2">
                        <label class="text-sm text-gray-500 dark:text-gray-400">
                            Observações
                        </label>
                        <textarea v-model="fill.observacao" rows="4"
                                  class="rounded border border-black mt-0.5 text-gray-700">
                        </textarea>
                        <div v-if="fill.errors?.observacao"
                             class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                            <small v-for="error in fill.errors?.observacao">{{ error }} &nbsp;</small>
                        </div>
                        <div
                            class="grid grid-cols-2 items-center justify-end p-6 border-t border-solid border-slate-200 rounded-b">
                            <button type="button" @click="insertFill"
                                    class="border border-green-500 bg-green-500 text-white hover:text-green-800 rounded-md px-4 py-2 m-2 transition duration-300 ease select-none hover:bg-green-200 focus:outline-none focus:shadow-outline col-span-2 md:col-span-1">
                                Salvar Abastecimento
                            </button>
                            <button type="button" @click="statusModal(false)"
                                    class="border border-red-500 bg-red-500 text-white hover:text-red-800 rounded-md px-4 py-2 m-2 transition duration-300 ease select-none hover:bg-red-200 focus:outline-none focus:shadow-outline col-span-2 md:col-span-1">
                                Fechar
                            </button>
                        </div>
                    </div>
                    <div class="col-span-2 overflow-x-auto">
                        <h2 class="text-xl text-center underline">Últimos Abastecimentos</h2>
                        <table class="min-w-full">
                            <thead>
                            <tr>
                                <th
                                    class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                    Hora Abastecimento
                                </th>
                                <th
                                    class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                    Quantidade
                                </th>
                                <th
                                    class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                    Valor Total
                                </th>
                                <th
                                    class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                    Local
                                </th>
                                <th
                                    class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                    Km Momento
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr v-for="(f, i) in fills" :key="'fills_' + i">
                                <th
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    {{ f.hora ? moment(f.hora).format('DD/MM/YY HH:mm') : '-' }}
                                </th>
                                <th
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    {{ f.quantidade }}
                                </th>
                                <th
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    {{ f.valor }}
                                </th>
                                <th
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    {{ f.local ?? '-' }}
                                </th>
                                <th
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    {{ f.km }}
                                </th>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <slot name="back"/>
</template>
