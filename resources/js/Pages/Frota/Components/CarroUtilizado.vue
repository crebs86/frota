<script setup>
import {defineEmits, ref} from "vue";
import moment from "moment/moment.js";
import VueMultiselect from "vue-multiselect";
import {toast} from "@/toast";

const carroModalStatus = defineEmits(['carroModalStatus'])

const props = defineProps({
    currentCar: Object | null,
    cars: Object,
})

const model = ref({
    car: '',
    currentCar: props.currentCar,
})

function cars({modelo, placa}) {
    return `${modelo ?? ''} - ${placa ?? ''}`
}

function statusModal(status) {
    carroModalStatus('carroModalStatus', status)
}

function saveCar() {
    axios.post(route('frota.favorite.car'), model.value)
        .then((r) => {
            statusModal(false)
            toast.success(r.data)
        })
        .catch((e) => {
            if (e.response && e.response.status === 500) {
                toast.error(e.response.data)
            }
        })
}
</script>
<template>
    <div
        class="overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none justify-center items-center flex max-h-[95%]">
        <div class="relative my-6 mx-auto w-11/12 md:w-10/12 max-w-6xl max-h-[95%]">

            <div
                class="border-0 rounded-lg shadow-lg relative flex flex-col w-full outline-none focus:outline-none min-h-[300px]"
                :class="$page.props.app.settingsStyles.main.container">

                <div class="flex items-start justify-between p-5 border-b border-solid border-slate-200 rounded-t">
                    <h3 class="text-xl font-semibold uppercase">
                        Confirme o carro que está utilizando
                    </h3>
                    <button @click="statusModal(false)"
                            class="absolute -top-3 -right-3 bg-red-500 hover:bg-red-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white">
                        &cross;
                    </button>
                </div>
                <div class="relative p-6 grid grid-cols-1">
                    <div>Carro atual: {{ props.currentCar?.modelo }} {{ props.currentCar?.placa }}</div>
                    <div class="my-2" v-if="moment().isSame(myRoutes?.date, 'day')">
                        <label class="text-sm text-gray-500 dark:text-gray-400">
                            Carro utilizado
                        </label>
                        <VueMultiselect v-model="model.car" :options="props.cars" :multiple="false"
                                        :close-on-select="true" selectedLabel="atual" placeholder="Carro atual"
                                        :custom-label="cars" track-by="id" selectLabel="Selecionar"
                                        deselectLabel="Remover"/>
                    </div>
                </div>
                <div class="flex place-content-center">
                    <button @click="saveCar()"
                            class="border border-blue-500 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-300 ease select-none focus:outline-none focus:shadow-outline col-span-2 md:col-span-1"
                            :disabled="!model.car"
                            :class="model.car ? 'hover:text-blue-800 hover:bg-blue-200' : 'opacity-40'">
                        Confirmar Carro
                    </button>
                </div>
            </div>
        </div>
    </div>
    <slot name="back"/>
</template>
