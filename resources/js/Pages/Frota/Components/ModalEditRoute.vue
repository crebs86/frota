<script setup>
import VueMultiselect from "vue-multiselect";
import { onMounted, ref } from "vue";
import { branchName, drivers } from "@/helpers";
import validateUpRt from "@/validates/createUpdateRoute";
import axios from "axios";
import { toast } from "@/toast";
import { validateDate } from "@/validates/validates";
import { phoneMask } from "@/mask";

const props = defineProps({
    routeForEdition: Object,
    _checker: String,
    isRequest: Boolean,
    drivers: Object | null,
    driver: Object | null
})

const emit = defineEmits(['routeUpdated'])

const passengersEditModel = ref({
    passenger: '',
    contact: ''
})

const maskPhone = (event) => {
    let input = event.target
    input.value = phoneMask(input.value)
}

function setEditPassenger(remove = false, passenger = null, edit = false) {
    props.routeForEdition.errors.passengers = ''
    if (remove) {
        props.routeForEdition.passengers.splice(props.routeForEdition.passengers.indexOf(passenger), 1)
    } else if (edit) {
        passengersEditModel.value.contact = passenger.contact
        passengersEditModel.value.passenger = passenger.passenger
        props.routeForEdition.passengers.splice(props.routeForEdition.passengers.indexOf(passenger), 1)
    } else if (passengersEditModel.value) {
        props.routeForEdition.passengers.push(passengersEditModel.value)
        passengersEditModel.value = {
            passenger: '',
            contact: ''
        }
    } else {
        props.routeForEdition.errors.passengers = 'Vazio.'
    }
}

function updateRoute() {
    console.log(props.isRequest)
    let putRoute = route('frota.routes.route.update', props.routeForEdition.id)//props.isRequest ? route('frota.requests.update', props.routeForEdition.id) : route('frota.routes.route.update', props.routeForEdition.id)
    let val = validateUpRt(props.routeForEdition)
    if (val._run) {
        axios.put(putRoute, {
            id: props.routeForEdition.id,
            branch: props.routeForEdition.branch,
            currentBranch: props.routeForEdition.currentBranch,
            time: props.routeForEdition.time,
            date: props.routeForEdition.date,
            driver: props.routeForEdition.driver.id,
            duration: props.routeForEdition.duration,
            passengers: props.routeForEdition.passengers,
            obs: props.routeForEdition.obs,
            local: props.routeForEdition.local,
            ignore: props.routeForEdition.ignore,
            _checker: props._checker,
        })
            .then(() => {
                emit('routeUpdated', true)
                props.routeForEdition.ignoreQuestion = false
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    props.routeForEdition.errors = e.response.data.error
                } else if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    props.routeForEdition.errors = e.response.data.errors
                } else if (e.response?.status === 409) {
                    props.routeForEdition.ignoreQuestion = true
                    toast.error('Todos os campos são obrigatórios.')
                    props.routeForEdition.errors = e.response.data.errors
                } else if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    props.routeForEdition.errors = e.response.data
                }
            })
    } else {
        props.routeForEdition.errors = val
        toast.error('Preencha todos os campos para atualizar a rota');
    }
}

onMounted(() => {
    props.routeForEdition.ignore = false
    props.routeForEdition.ignoreQuestion = false
    props.routeForEdition.driver = props.driver
    axios.get(route('frota.tasks.get-route-details', props.routeForEdition.id))
        .then((r) => {
            props.routeForEdition.obs = r.data.obs
        })
        .catch((e) => {
            if (e.response?.status === 403) {
                toast.error(e.response.data.error)
                props.routeForEdition.errors = e.response.data.error
            } else if (e.response?.status === 503) {
                toast.error(e.response.data)
                props.routeForEdition.errors = e.response.data
            }
        }
        )
        .finally(() => {

        })
})

</script>

<template>
    <!--Modal editar rota/solicitação-->
    <div class="fixed inset-0 flex items-center justify-center overflow-hidden mx-1">
        <div class="fixed inset-0 transition-opacity">
            <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
        </div>
        <div v-if="props.routeForEdition"
            class="bg-white rounded-lg overflow-auto shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600 p-4 max-h-[95%]">
            <div class="overflow-x-auto overflow-y-hidden grid grid-cols-6 gap-3">

                <div class="grid grid-cols-1 col-span-6 md:col-span-2 h-12 mt-1 md:mt-0">
                    <label class="text-sm">
                        Data*
                    </label>
                    <input type="date" v-model="props.routeForEdition.date"
                        class="rounded border border-black h-[41px] mt-[3px] text-gray-700">

                    <div v-if="props.routeForEdition.errors?.date"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.date">{{ error }}</small>
                    </div>
                </div>
                <div class="col-span-6 md:col-span-2 mt-3 md:mt-0">
                    <label class="text-sm">
                        Hora da Chegada no Destino*
                    </label>
                    <VueMultiselect v-model="props.routeForEdition.time" :options="$page.props.timetables"
                        :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Hora"
                        selectLabel="Selecionar" deselectLabel="Remover" class="border border-black rounded-md" />
                    <div v-if="props.routeForEdition.errors?.time"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.time">{{ error }}</small>
                    </div>
                    <div v-if="props.routeForEdition.ignoreQuestion">
                        <label for="_ignore" class="p-1.5 text-amber-500 font-bold">Ignorar conflito</label>
                        <input type="checkbox" id="_ignore" v-model="props.routeForEdition.ignore"
                            class="text-red-400" />
                    </div>
                </div>

                <div class="col-span-6 md:col-span-2 md:-mt-0.5">
                    <label class="text-sm">
                        Permanência Estipulada*
                    </label>
                    <input type="time" v-model="props.routeForEdition.duration"
                        class="w-full rounded border h-[41px] mt-0.5 text-gray-700">

                    <div v-if="props.routeForEdition.errors?.duration"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.duration">{{ error }}</small>
                    </div>
                </div>
                <div class="col-span-6 md:col-span-3">
                    <label class="text-sm">
                        Motorista
                    </label>
                    <VueMultiselect v-model="props.routeForEdition.driver" :options="props.drivers" :multiple="false"
                        :close-on-select="true" placeholder="Motorista" :custom-label="drivers" selectLabel="Selecionar"
                        deselectLabel="Remover" class="border border-black rounded-md" />

                    <div v-if="props.routeForEdition.errors?.driver"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.driver">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-6 md:col-span-3">
                    <label class="text-sm">
                        Destino
                    </label>
                    <VueMultiselect v-model="props.routeForEdition.branch" :options="$page.props.branches"
                        :multiple="false" :close-on-select="true" placeholder="Destino" label="name" track-by="id"
                        selectLabel="Selecionar" deselectLabel="Remover" @select="$page.props.errors.date = null"
                        :custom-label="branchName" class="border border-black rounded-md" />

                    <div v-if="props.routeForEdition.errors?.branch"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.branch">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-6 md:col-span-3 place-content-center"
                    v-if="props.routeForEdition.branch?.id === 1">
                    <label class="text-sm">
                        Local*
                    </label>
                    <input type="text" v-model="props.routeForEdition.local"
                        class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                    <div v-if="props.routeForEdition.errors?.local"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.local">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-6 md:col-span-3 grid grid-cols-1">
                    <label class="text-sm">
                        Obs.:
                    </label>
                    <textarea class="rounded text-gray-600" v-model="props.routeForEdition.obs"></textarea>
                    <div v-if="props.routeForEdition.errors?.obs"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                        <small v-for="error in props.routeForEdition.errors?.obs">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-6 grid grid-cols-8">
                    <div class="col-span-6 grid grid-cols-4">
                        <div class="col-span-5 md:col-span-2">
                            <label class="text-sm">
                                Passageiro*
                            </label>
                            <input type="text" v-model="passengersEditModel.passenger"
                                class="w-full rounded border border-black h-[41px] text-gray-700"
                                :class="!validateDate(props.routeForEdition.date) ? 'bg-[#afb3b9]' : ''"
                                :disabled="!validateDate(props.routeForEdition.date)" />
                        </div>
                        <div class="col-span-5 md:col-span-2">
                            <label class="text-sm">
                                Contato*
                            </label>
                            <input type="text" v-model="passengersEditModel.contact"
                                class="w-full rounded border border-black h-[41px] text-gray-700"
                                :class="!validateDate(props.routeForEdition.date) ? 'bg-[#afb3b9]' : ''"
                                :disabled="!validateDate(props.routeForEdition.date)"
                                maxlength="11" @keyup="maskPhone($event)"
                                />
                        </div>
                    </div>
                    <button type="button" @click="setEditPassenger(false)"
                        :disabled="passengersEditModel.passenger.length < 3 || passengersEditModel.contact.length < 8"
                        class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline col-span-2 w-full self-center h-28 md:max-h-[41px] md:self-end mt-6 md:-mb-[1px]"
                        :class="passengersEditModel.passenger.length < 3 || passengersEditModel.contact.length < 8 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                        Incluir
                    </button>

                    <div class="col-span-6 md:col-span-3">
                        <div v-for="(p, i) in props.routeForEdition.passengers" :key="'pre_' + i"
                            class="inline-flex w-full">
                            {{ p.passenger }}: {{ p.contact }}
                            <button @click="setEditPassenger(true, p)">
                                <mdicon name="close" class="text-red-400" />
                            </button>
                            <button @click="setEditPassenger(false, p, true)">
                                <mdicon name="pencil" class="text-blue-400" />
                            </button>
                        </div>
                    </div>
                </div>
                <div class="h-[10rem] mx-2 col-span-2 mt-2">
                    <div class="text-center mt-3" v-if="props.routeForEdition.errors?._checker">
                        <span class="border border-red-500 bg-red-400 rounded max-w-fit px-3">
                            {{ props.routeForEdition.errors?._checker[0] }}
                        </span>
                    </div>
                </div>
            </div>

            <div class="dark:bg-gray-500 px-4 py-3 sm:px-6 flex gap-1">
                <button type="button"
                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm"
                    @click="updateRoute()">
                    Salvar
                </button>
                <slot name="close_button"></slot>
            </div>
        </div>
    </div>
</template>

<style scoped></style>
