<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import {Head,usePoll} from '@inertiajs/vue3';
import {defineAsyncComponent, onMounted, ref} from 'vue';
import axios from 'axios';
import {toast} from '@/toast';
import moment from 'moment';
import VueMultiselect from 'vue-multiselect';
import {phoneMask} from "@/mask.js";

const Abastecer = defineAsyncComponent(() => import('../Components/Abastecer.vue'));

const props = defineProps({
    myRoutesByDate: Object,
    cars: Object,
    driver: Object
})

const date = ref({
    date: '',
    error: null
});

const myRoutes = ref({})

const car = ref({});

const routeModel = ref({
    km: '',
    obs: '',
    started_at: '',
    errors: ''
})

const maskPhone = (event) => {
    let input = event.target
    input.value = phoneMask(input.value)
}


usePoll(1000 * 60 * 5, {
    onStart() {
        console.log('Atualizando lista...')
    },
    onFinish() {
        myRoutes.value = props.myRoutesByDate[0]
        car.value = props.driver?.car
        console.log('Atualizado.')
  }
})

const singleRouteModel = ref({
    branch: '',
    km: '',
    obs: '',
    local: '',
    errors: [],
    passengers: [],
})

const passengersModel = ref({
    passenger: '',
    contact: ''
})

function setPassenger(remove = false, passenger = null, edit = false) {
    singleRouteModel.value.errors.passengers = ''
    if (remove) {
        singleRouteModel.value.passengers.splice(singleRouteModel.value.passengers.indexOf(passenger), 1)
    } else if (edit) {
        passengersModel.value.contact = passenger.contact
        passengersModel.value.passenger = passenger.passenger
        singleRouteModel.value.passengers.splice(singleRouteModel.value.passengers.indexOf(passenger), 1)
    } else if (passengersModel.value) {
        singleRouteModel.value.passengers.push(passengersModel.value)
        passengersModel.value = {
            passenger: '',
            contact: ''
        }
    } else {
        routeForm.value.errors.passengers = 'Vazio.'
    }
}

const branches = ref({})

function resetModel() {
    routeModel.value.km = ''
    routeModel.value.obs = ''
    routeModel.value.started_at = ''
    routeModel.value.errors = ''
    routeModel.value.passengers = []
}

const modal = ref(false)
const modalStart = ref(false)
const modalEnd = ref(false)
const modalSingleRoute = ref(false)

const currentRoute = ref({})

function km(car_log, type) {
    return car_log?.filter((c) => {
        return c.type === type
    })
}

function branchName({id, name}) {
    return `${id ? id : ''} - ${name ? name : ''}`
}

function cars({modelo, placa}) {
    return `${modelo ?? ''} - ${placa ?? ''}`
}

function myRoutesByDate() {
    myRoutes.value = {};

    axios.post(route('frota.my-routes-bydate', {date: date.value.date}))
        .then((r) => {
            myRoutes.value = r.data[0]
            if (r.data.length < 1) {
                toast.warning('Nenhuma agenda para a data selecionada.');
            }
        })
        .catch((r) => {
            console.log(r)
            toast.error('Erro ao processar solicitação.');
        })
}

function startRoute() {
    if (currentRoute.value.started_at === null) {
        if (routeModel.value.km && car.value?.placa) {
            axios.post(route('frota.tasks.start-route', {
                id: currentRoute.value.id,
            }), {
                km: routeModel.value.km,
                obs: routeModel.value.obs,
                car: car.value.placa,
                started_at: routeModel.value.started_at
            })
                .then((r) => {
                    myRoutes.value = r.data[0]
                    modalStart.value = false
                    resetModel()
                })
                .catch((e) => {
                    if (e?.response?.status === 403 || e?.response?.status === 404) {
                        toast.error(e?.response?.data)
                    } else if (e?.response?.status === 422) {
                        toast.error(e?.response?.data?.message)
                        routeModel.value.errors = e?.response?.data?.errors
                    } else {
                        toast.error('Erro ao processar sua solicitação.')
                    }
                })
        } else {
            if (!car.value?.placa) {
                toast.error('Selecione um carro para fazer a rota.')
            } else {
                toast.error('Informe a quilometragem no momento da partida.')
            }
        }
    } else {
        toast.warning('Rota já iniciada.')
    }
}

function finishRoute() {
    if (currentRoute.value.ended_at === null) {
        if (routeModel.value.km && car.value?.placa) {
            axios.post(route('frota.tasks.finish-route', {
                id: currentRoute.value.id
            }), {
                km: routeModel.value.km,
                obs: routeModel.value.obs,
                car: car.value.placa,
                ended_at: routeModel.value.started_at
            })
                .then((r) => {
                    myRoutes.value = r.data[0]
                    modalEnd.value = false
                    resetModel()
                })
                .catch((e) => {
                    if (e?.response?.status === 403) {
                        toast.error(e?.response?.data)
                    } else {
                        toast.error('Erro ao processar sua solicitação.')
                    }
                })
        } else {
            if (!car.value?.placa) {
                toast.error('Selecione um carro para fazer a rota.')
            } else {
                toast.error('Informe a quilometragem no momento da partida.')
            }
        }
    } else {
        toast.warning('Rota já finalizada.')
    }
}

function eraseRouteModal(route) {
    modal.value = true
    currentRoute.value = route
}

function startRouteModal(route) {
    modalStart.value = true
    currentRoute.value = route
}

function endRouteModal(route) {
    modalEnd.value = true
    currentRoute.value = route
}

function singleRouteModal() {
    if (branches.value.length > 0) {
        modalSingleRoute.value = true
    } else {
        axios.get(route('frota.load-branches'))
            .then((r) => {
                branches.value = r.data
                modalSingleRoute.value = true
                resetModel()
            })
            .catch(() => {
                toast.error('Erro ao carregar unidades.')
            })
    }
}

function eraseRoute() {
    if (currentRoute.value.id) {
        axios.post(route('frota.tasks.erase-route', {
            id: currentRoute.value.id
        }))
            .then((r) => {
                myRoutes.value = r.data[0]
                modal.value = false
                currentRoute.value = {}
            })
            .catch((e) => {
                if (e?.response?.status === 403) {
                    toast.error(e?.response?.data)
                } else {
                    toast.error('Erro ao processar sua solicitação.')
                }
            })
    } else {
        toast.warning('Rota já finalizada.')
    }
}

function saveSingleRoute() {
    if (car.value?.placa && singleRouteModel.value?.branch?.id && singleRouteModel.value?.km) {
        axios.post(route('frota.tasks.set-sigle-route'), {
            car: car.value.placa,
            branch: singleRouteModel.value.branch.id,
            km: singleRouteModel.value.km,
            obs: singleRouteModel.value.obs,
            local: singleRouteModel.value.local,
            passengers: singleRouteModel.value.passengers,
        })
            .then((r) => {
                myRoutes.value = r.data[0]
                modalSingleRoute.value = false
            })
            .catch((e) => {
                if (e.response?.status === 500) {
                    toast.error(e.response.data)
                    routeForm.value.errors = e.response.data
                }
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeForm.value.errors = e.response.data.error
                }
                if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    singleRouteModel.value.errors = e.response.data.errors
                }
            })
            .finally()
    } else {
        toast.error('Preencha todos os campos.')
    }
}

const abastecerModal = ref(false)

function abastecerModalStatus(status) {
    abastecerModal.value = status
}

onMounted(() => {
    myRoutes.value = props.myRoutesByDate[0]
    car.value = props.driver?.car
})

</script>

<template>

    <Head title="Minhas Rotas"/>

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu/>
        </template>
        <SubSection>
            <template #header>
                Minhas Tarefas
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">

                    <div class="p-2 rounded-lg overflow-y-auto"
                         :class="$page.props.app.settingsStyles.main.innerSection">

                        <div class="my-2 grid grid-cols-1">
                            <div class="grid grid-cols-1 max-w-[200px]">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Data
                                </label>
                                <input type="date" v-model="date.date" @change="myRoutesByDate()"
                                       class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                                <div v-if="date.error"
                                     class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small>{{ date.error }}</small>
                                </div>
                            </div>
                            <div class="my-2 grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-2">
                                <button @click="singleRouteModal()"
                                        class="border border-blue-600 bg-blue-500 text-blue-100 rounded-md px-4 py-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                                    Inserir Rota Avulsa
                                </button>
                                <button @click="abastecerModalStatus(true)"
                                        class="border rounded-md px-4 py-2 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                        :class="car ? 'border-yellow-600 bg-yellow-700 text-yellow-100 hover:bg-yellow-500' : 'border-gray-600 bg-gray-600 text-gray-100'"
                                        :disabled="!car">
                                    Abastecer
                                </button>
                                <button
                                    class="border rounded-md px-4 py-2 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                    :class="car ? 'border-green-600 bg-green-500 text-green-100 hover:bg-green-700' : 'border-gray-600 bg-gray-600 text-gray-100'"
                                    :disabled="!car">
                                    Manutenção
                                </button>
                                <button
                                    class="border rounded-md px-4 py-2 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                    :class="car ? ' border-red-600 bg-red-700 text-red-100 hover:bg-red-500' : 'border-gray-600 bg-gray-600 text-gray-100'"
                                    :disabled="!car">
                                    Ocorrências
                                </button>
                            </div>
                        </div>

                        <div class="my-2" v-if="moment().isSame(myRoutes?.date, 'day')">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Carro utilizado
                            </label>
                            <VueMultiselect v-model="car" :options="props.cars" :multiple="false"
                                            :close-on-select="true" selectedLabel="atual" placeholder="Carro atual"
                                            :custom-label="cars" track-by="id" selectLabel="Selecionar"
                                            deselectLabel="Remover"/>
                        </div>

                        <table class="min-w-full">
                            <thead>
                            <tr>
                                <th v-for=" (value, index) in ['Local Destino', 'Hora Agendada', 'Iniciada', 'Finalizada', 'Ações']"
                                    :key="index + '' + value"
                                    class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider"
                                    :class="$page.props.app.settingsStyles.main.container">
                                    {{ value }}
                                </th>
                            </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                            <tr v-for="(m, i) in myRoutes?.routes" :key="i + '_myroutes'">
                                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center w-[300px]"
                                    :class="m.branch.id === 1 ? 'underline underline-offset-8' : ''">
                                    <span>{{ m.branch.name }}</span>
                                    <mdicon name="circle" class="float-right text-red-500"
                                            v-if="m.branch.id === 1"/>
                                </td>
                                <td
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    {{ m.time }}
                                </td>
                                <td
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                       :class="m.started_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                        {{ m.started_at ? moment(m.started_at).format('DD/MM/YY HH:mm') : '-' }}
                                    </p>
                                    <small>Km:
                                        {{ km(m.cars_log, 'start') ? km(m.cars_log, 'start')[0]?.km : '' }}
                                    </small>
                                </td>
                                <td
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                       :class="m.ended_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                        {{ m.ended_at ? moment(m.ended_at).format('DD/MM/YY HH:mm') : '-' }}
                                    </p>
                                    <small>Km:
                                        {{ km(m.cars_log, 'end') ? km(m.cars_log, 'end')[0]?.km : '' }}
                                    </small>
                                </td>
                                <td
                                    class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                    <div class="flex gap-3 justify-center"
                                         v-if="moment().isSame(myRoutes?.date, 'day')">
                                        <button @click="startRouteModal(m)" :disabled="m.started_at">
                                            <mdicon :class="m.started_at ? 'text-gray-400' : 'text-green-600'"
                                                    name="play" title="Iniciar percurso"/>
                                        </button>
                                        <button @click="endRouteModal(m)"
                                                :disabled="m.ended_at || m.started_at === null">
                                            <mdicon
                                                :class="m.ended_at || m.started_at === null ? 'text-gray-400' : 'text-red-600'"
                                                name="stop" title="Finalizar"/>
                                        </button>
                                        <button @click="eraseRouteModal(m)"
                                                :disabled="m.started_at === null && m.ended_at === null">
                                            <mdicon
                                                :class="m.started_at === null && m.ended_at === null ? 'text-gray-400' : 'text-yellow-600'"
                                                name="eraser" title="Apagar informações do percurso"/>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <div class="h-[12em]"></div>
                    </div>
                </div>

                <!-- modal start route-->
                <div class="fixed z-50 inset-0 flex items-center justify-center overflow-hidden mx-1"
                     :class="modalStart ? 'block' : 'hidden'">
                    <div class="fixed inset-0 transition-opacity">
                        <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                    </div>
                    <div
                        class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[768px] dark:bg-gray-600">
                        <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100 uppercase">
                                Confirmar inicialização de rota
                            </h3>
                            <div class="mt-2">
                                <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                                    <div class="mb-6 p-3 w-full z-auto min-h-fit grid grid-cols-1 gap-1">

                                        <div class="my-2 grid grid-cols-1 place-items-center">
                                            <div>
                                                <div>
                                                    <span class="font-bold">Destino:</span>
                                                    {{ currentRoute.branch?.name }}
                                                </div>
                                                <div>
                                                    <span class="font-bold">Horário:</span>
                                                    {{ currentRoute.time }}
                                                </div>
                                            </div>

                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                Hora da Chegada no Destino*
                                            </label>
                                            <input type="time" v-model="routeModel.started_at"
                                                   class="rounded border border-black h-[41px] w-full max-w-[450px] mt-0.5 text-gray-700">
                                            <div v-if="routeModel.errors?.started_at"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in routeModel.errors?.started_at">
                                                    {{ error }}
                                                </small>
                                            </div>

                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                KM
                                            </label>
                                            <input type="number" maxlength="7" v-model="routeModel.km"
                                                   class="rounded border border-black h-[41px] w-full max-w-[450px] mt-0.5 text-gray-700">
                                            <div v-if="routeModel.errors?.km"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in routeModel.errors?.km">{{ error }}</small>
                                            </div>

                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                Observações
                                            </label>
                                            <textarea v-model="routeModel.obs"
                                                      class="rounded border border-black mt-0.5 text-gray-700 w-full max-w-[450px]"
                                                      rows="4">
                                            </textarea>
                                            <div v-if="routeModel.errors?.obs"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in routeModel.errors?.obs">{{ error }}</small>
                                            </div>
                                        </div>
                                    </div>

                                    <button type="button" @click="startRoute"
                                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                        Iniciar
                                    </button>

                                    <button type="button"
                                            @click="modalStart = false, currentRoute = {}, routeModel = {}, resetModel()"
                                            class="border border-gray-600 bg-gray-500 text-gray-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-gray-600 focus:outline-none focus:shadow-outline">
                                        Cancelar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- modal end route-->
                <div class="fixed z-50 inset-0 flex items-center justify-center overflow-hidden mx-1"
                     :class="modalEnd ? 'block' : 'hidden'">
                    <div class="fixed inset-0 transition-opacity">
                        <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                    </div>
                    <div
                        class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[768px] dark:bg-gray-600">
                        <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100 uppercase">
                                Confirmar finalização de rota
                            </h3>
                            <div class="mt-2">
                                <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                                    <div class="mb-6 p-3 w-full z-auto min-h-fit grid grid-cols-1 gap-1">

                                        <div class="my-2 grid grid-cols-1 place-items-center">
                                            <div>
                                                <div>
                                                    <span class="font-bold">Destino:</span>
                                                    {{ currentRoute.branch?.name }}
                                                </div>
                                                <div>
                                                    <span class="font-bold">Horário:</span>
                                                    {{ currentRoute.time }}
                                                </div>
                                            </div>

                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                Hora da Chegada no Destino*
                                            </label>
                                            <input type="time" v-model="routeModel.started_at"
                                                   class="rounded border border-black h-[41px] w-full max-w-[450px] mt-0.5 text-gray-700">
                                            <div v-if="routeModel.errors?.started_at"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in routeModel.errors?.started_at">{{
                                                        error
                                                    }}</small>
                                            </div>
                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                KM
                                            </label>
                                            <input type="number" maxlength="7" v-model="routeModel.km"
                                                   class="rounded border border-black h-[41px] w-full max-w-[450px] mt-0.5 text-gray-700">
                                            <div v-if="routeModel.errors?.km"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in routeModel.errors?.km">{{ error }}</small>
                                            </div>

                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                Observações
                                            </label>
                                            <textarea v-model="routeModel.obs"
                                                      class="rounded border border-black mt-0.5 text-gray-700 w-full max-w-[450px]"
                                                      rows="4">
                                            </textarea>
                                            <div v-if="routeModel.errors?.obs"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in routeModel.errors?.obs">{{ error }}</small>
                                            </div>
                                        </div>

                                    </div>

                                    <button type="button" @click="finishRoute"
                                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                        Encerrar
                                    </button>

                                    <button type="button"
                                            @click="modalEnd = false, currentRoute = {}, routeModel = {}, resetModel()"
                                            class="border border-gray-600 bg-gray-500 text-gray-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-gray-600 focus:outline-none focus:shadow-outline">
                                        Cancelar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- modal erase route-->
                <div class="fixed z-50 inset-0 flex items-center justify-center overflow-hidden mx-1"
                     :class="modal ? 'block' : 'hidden'">
                    <div class="fixed inset-0 transition-opacity">
                        <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                    </div>
                    <div
                        class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[768px] dark:bg-gray-600">
                        <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                                Confirmação
                            </h3>
                            <div class="mt-2">
                                <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                                    <div class="mb-6 p-3 w-full z-auto min-h-fit grid grid-cols-1 md:grid-cols-2 gap-1">

                                        <div class="relative z-0 mb-6 w-full">
                                            Deseja realmente limpar as informações de inicio e fim da rota?
                                        </div>

                                    </div>

                                    <button type="button" @click="eraseRoute"
                                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                        Limpar
                                    </button>

                                    <button type="button" @click="modal = false, currentRoute = {}"
                                            class="border border-gray-600 bg-gray-500 text-gray-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-gray-600 focus:outline-none focus:shadow-outline">
                                        Cancelar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- modal single route -->
                <div class="fixed z-50 inset-0 flex items-center justify-center overflow-hidden mx-1"
                     :class="modalSingleRoute ? 'block' : 'hidden'">
                    <div class="fixed inset-0 transition-opacity">
                        <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                    </div>
                    <div
                        class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[768px] dark:bg-gray-600">
                        <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                                Adicionar Nova Rota Avulsa
                            </h3>
                            <div class="mt-2">
                                <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                                    <div class="mb-6 p-3 w-full z-auto min-h-fit grid grid-cols-1 gap-1">

                                        <div class="my-2 grid grid-cols-1 place-items-center">
                                            <div>
                                                Carro: {{ `${car?.id} - ${car?.modelo} - ${car?.placa}` }}
                                            </div>

                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                Destino*
                                            </label>
                                            <VueMultiselect v-model="singleRouteModel.branch" :options="branches"
                                                            :multiple="false" :close-on-select="true"
                                                            selectedLabel="atual"
                                                            placeholder="Destino" :custom-label="branchName"
                                                            track-by="id"
                                                            label="time" selectLabel="Selecionar"
                                                            deselectLabel="Remover"
                                                            class="max-w-[450px]" v-if="branches.length > 0"/>
                                            <div v-if="singleRouteModel.errors?.branch"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in singleRouteModel.errors?.branch">
                                                    {{ error }}
                                                </small>
                                            </div>

                                            <label class="text-sm text-gray-500 dark:text-gray-400 mt-3"
                                                   v-if="singleRouteModel.branch?.id === 1">
                                                Local*
                                            </label>
                                            <input type="text" v-model="singleRouteModel.local"
                                                   v-if="singleRouteModel.branch?.id === 1"
                                                   class="w-full max-w-[450px] rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">
                                            <div v-if="singleRouteModel.errors?.local"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in singleRouteModel.errors?.local">
                                                    {{ error }}
                                                </small>
                                            </div>
                                            <div class="grid grid-cols-6 gap-2 mt-0.5 border">
                                                <h2 class="col-span-6">Opcional</h2>
                                                <div class="col-span-4 md:col-span-2">
                                                    <label class="text-sm">
                                                        Passageiro
                                                    </label>
                                                    <input type="text" v-model="passengersModel.passenger"
                                                           class="w-full rounded border border-black h-[41px] text-gray-700"/>
                                                </div>
                                                <div class="col-span-4 md:col-span-2">
                                                    <label class="text-sm">
                                                        Contato
                                                    </label>
                                                    <input type="text" v-model="passengersModel.contact"
                                                           class="w-full rounded border border-black h-[41px] text-gray-700"
                                                           maxlength="11" @keyup="maskPhone($event)"/>
                                                </div>
                                                <button type="button" @click="setPassenger(false)"
                                                        :disabled="passengersModel.passenger.length < 3 || passengersModel.contact.length < 8"
                                                        class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline col-span-2 w-full self-center h-28 md:max-h-[41px] md:self-end -mt-12 md:-mb-[1px] md:-mt-0"
                                                        :class="passengersModel.passenger.length < 3 || passengersModel.contact.length < 8 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                                    Incluir
                                                </button>

                                                <div v-if="singleRouteModel.errors?.passengers"
                                                     class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-5">
                                                    <small v-for="error in singleRouteModel.errors?.passengers">
                                                        {{ error }}
                                                    </small>
                                                </div>

                                                <div class="col-span-4 mb-4">
                                                    <div v-for="(p, i) in singleRouteModel.passengers" :key="'pre_' + i"
                                                         class="inline-flex w-full">
                                                        {{ p.passenger }}: {{ p.contact }}
                                                        <button @click="setPassenger(true, p)">
                                                            <mdicon name="close" class="text-red-400"/>
                                                        </button>
                                                        <button @click="setPassenger(false, p, true)">
                                                            <mdicon name="pencil" class="text-blue-400"/>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <label class="mt-3 text-sm text-gray-500 dark:text-gray-400">
                                                KM*
                                            </label>
                                            <input type="number" maxlength="7" v-model="singleRouteModel.km"
                                                   class="rounded border border-black h-[41px] w-full max-w-[450px] mt-0.5 text-gray-700">
                                            <div v-if="singleRouteModel.errors?.km"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in singleRouteModel.errors?.km">
                                                    {{ error }}
                                                </small>
                                            </div>

                                            <label class="mt-3 text-sm text-gray-500 dark:text-gray-400">
                                                Observações
                                            </label>
                                            <textarea v-model="singleRouteModel.obs"
                                                      class="rounded border border-black mt-0.5 text-gray-700 w-full max-w-[450px]"
                                                      rows="4">
                                            </textarea>
                                            <div v-if="singleRouteModel.errors?.obs"
                                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                <small v-for="error in singleRouteModel.errors?.obs">
                                                    {{ error }}
                                                </small>
                                            </div>

                                        </div>

                                    </div>

                                    <button type="button" @click="saveSingleRoute()"
                                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                        Criar e Iniciar Rota
                                    </button>

                                    <button type="button" @click="modalSingleRoute = false, currentRoute = {}"
                                            class="border border-gray-600 bg-gray-500 text-gray-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-gray-600 focus:outline-none focus:shadow-outline">
                                        Cancelar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <Abastecer v-if="abastecerModal" @abastecerModalStatus="abastecerModalStatus" :car="car">
                    <template #back>
                        <div v-if="abastecerModal" class="opacity-70 fixed inset-0 z-40 bg-black"></div>
                    </template>
                </Abastecer>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
