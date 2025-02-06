<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head } from '@inertiajs/vue3';
import { toast } from '@/toast';
import axios from 'axios';
import { onMounted, ref } from 'vue';
import moment from 'moment';
import validateESR from '@/validates/editSaveRoute';
import { branchName, drivers } from '@/helpers';
import { validateDate } from '@/validates/validates';
import { phoneMask } from '@/mask';

const props = defineProps({
    branches: Object,
    timetables: Object,
    errors: Object,
    driverRoutes: Object,
    _checker: String
});

const routes = ref({});
const _drivers = ref([]);

const routeForm = ref({
    time: '',
    branch: '',
    duration: '',
    local: '',
    _checker: '',
    errors: {},
    ignore: false,
    ignoreQuestion: false,
    passengers: [],
    obs: ''
});

const modal = ref({
    editRoute: false
});

const routeForEdition = ref({
    id: '',
    branch: '',
    driver: '',
    currentBranch: '',
    time: '',
    duration: '',
    local: '',
    error: '',
    errors: {},
    date: '',
    ignore: false,
    ignoreQuestion: false,
    passengers: [],
    obs: ''
});

const maskPhone = (event) => {
    let input = event.target
    input.value = phoneMask(input.value)
}

function saveRoute() {
    routeForm.value.errors = {}
    let val = validateESR(routeForm.value)
    if (val._run) {
        axios.post(route('frota.tasks.route.store'), {
            driver: props.driverRoutes.driver.id,
            date: props.driverRoutes.date,
            time: routeForm.value.time,
            local: routeForm.value.local,
            branch: routeForm.value.branch.id,
            passengers: routeForm.value.passengers,
            obs: routeForm.value.obs,
            duration: routeForm.value.duration,
            ignore: routeForm.value.ignore,
            obs: routeForm.value.obs,
            _checker: routeForm.value._checker
        })
            .then((r) => {
                toast.success(r.data.message)
                verifyDriverRoute()
                resetForm()
            })
            .catch((e) => {
                if (e.response?.status === 500) {
                    toast.error(e.response.data)
                    routeForm.value.errors = e.response.data
                } else if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeForm.value.errors = e.response.data.error
                } else if (e.response?.status === 409) {
                    routeForm.value.ignoreQuestion = true
                    toast.error('Agenda em conflito.')
                    routeForm.value.errors = e.response.data.errors
                } else if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    routeForm.value.errors = e.response.data.errors
                }
            })
    } else {
        routeForm.value.errors = val
    }
}

function updateRoute() {
    if (routeForEdition.value.branch && routeForEdition.value.time) {
        axios.put(route('frota.routes.route.update', routeForEdition.value.id), {
            id: routeForEdition.value.id,
            branch: routeForEdition.value.branch,
            currentBranch: routeForEdition.value.currentBranch,
            local: routeForEdition.value.local,
            time: routeForEdition.value.time,
            date: routeForEdition.value.date,
            ignore: routeForEdition.value.ignore,
            _checker: routeForm.value._checker,
            passengers: routeForEdition.value.passengers,
            obs: routeForEdition.value.obs,
            duration: routeForEdition.value.duration,
            driver: routeForEdition.value.driver.id
        })
            .then((r) => {
                toast.success(r.data)
                verifyDriverRoute();
                modal.value.editRoute = false;
                routeForEdition.value = {};
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeForEdition.value.error = e.response.data.error;
                } else if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    routeForEdition.value.error = e.response.data
                } else if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    routeForEdition.value.errors = e.response.data.errors
                } else if (e.response?.status === 409) {
                    routeForEdition.value.ignoreQuestion = true
                    toast.error(e.response.data.message)
                    routeForEdition.value.errors = e.response.data.errors
                    console.log(e.response)
                }
            })
    } else {
        toast.error('Preencha todos os campos para atualizar a rota');
    }
}

function resetForm() {
    routeForm.value.time = ''
    routeForm.value.branch = ''
    routeForm.value.duration = ''
    routeForm.value.local = ''
    routeForm.value._checker = ''
    routeForm.value.errors = {}
    routeForm.value.ignore = false
    routeForm.value.ignoreQuestion = false
    routeForm.value.passengers = []
    routeForm.value.obs = ''
}

function resetRouteForEdition() {
    routeForEdition.value.id = ''
    routeForEdition.value.driver = ''
    routeForEdition.value.time = ''
    routeForEdition.value.date = ''
    routeForEdition.value.branch = ''
    routeForEdition.value.currentBranch = ''
    routeForEdition.value.duration = ''
    routeForEdition.value.local = ''
    routeForEdition.value._checker = ''
    routeForEdition.value.errors = {}
    routeForEdition.value.ignore = false
    routeForEdition.value.ignoreQuestion = false
    routeForEdition.value.passengers = []
    routeForEdition.value.obs = ''
}

function verifyDriverRoute() {
    routeForm.value.errors = {}
    routes.value = {};
    if (props.driverRoutes.date && props.driverRoutes.driver.id) {
        axios.post(route('frota.tasks.filter-routes'), {
            driver: props.driverRoutes.driver.id,
            date: props.driverRoutes.date
        })
            .then((r) => {
                if (r.data.length >= 1) {
                    //console.log(r.data[0])
                    routes.value = r.data[0]
                    routeForm.value._checker = r.data[1]
                }
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                } else {
                    toast.error('Foram encontrados erros ao processar sua solicitação');
                }
            })/**/
    }
}

function setRouteToEdit(route) {
    loadDrivers()
    resetPassengerEditModel()
    modal.value.editRoute = true
    routeForEdition.value.id = route.id
    routeForEdition.value.driver = props.driverRoutes?.driver
    routeForEdition.value.branch = route.branch
    routeForEdition.value.currentBranch = route.branch
    routeForEdition.value.time = route.time
    routeForEdition.value.duration = route.duration
    routeForEdition.value.date = props.driverRoutes?.date
    routeForEdition.value.obs = route.obs
    routeForEdition.value.passengers = Object.values(JSON.parse(route.passengers) ?? [])
    if (route.branch.id === 1) {
        routeForEdition.value.local = route.branch.name
    }
}

function loadDrivers() {
    if (_drivers.value.length < 1) {
        axios.get(route('frota.load-drivers'))
            .then((r) => {
                _drivers.value = r.data
            })
            .catch()
            .finally()
    }
}

const passengersModel = ref({
    passenger: '',
    contact: ''
})

function resetPassengerModel() {
    passengersModel.value = {
        passenger: '',
        contact: ''
    }
}

function setPassenger(remove = false, passenger = null, edit = false) {
    routeForm.value.errors.passengers = ''
    if (remove) {
        routeForm.value.passengers.splice(routeForm.value.passengers.indexOf(passenger), 1)
    } else if (edit) {
        passengersModel.value.contact = passenger.contact
        passengersModel.value.passenger = passenger.passenger
        routeForm.value.passengers.splice(routeForm.value.passengers.indexOf(passenger), 1)
    } else if (passengersModel.value) {
        routeForm.value.passengers.push(passengersModel.value)
        resetPassengerModel()
    } else {
        routeForm.value.errors.passengers = 'Vazio.'
    }
}

const passengersEditModel = ref({
    passenger: '',
    contact: ''
})

function resetPassengerEditModel() {
    passengersEditModel.value = {
        passenger: '',
        contact: ''
    }
}

function setEditPassenger(remove = false, passenger = null, edit = false) {
    routeForEdition.value.errors.passengers = ''
    if (remove) {
        routeForEdition.value.passengers.splice(routeForEdition.value.passengers.indexOf(passenger), 1)
    } else if (edit) {
        passengersEditModel.value.contact = passenger.contact
        passengersEditModel.value.passenger = passenger.passenger
        routeForEdition.value.passengers.splice(routeForEdition.value.passengers.indexOf(passenger), 1)
    } else if (passengersEditModel.value) {
        routeForEdition.value.passengers.push(passengersEditModel.value)
        resetPassengerEditModel()
    } else {
        routeForEdition.value.errors.passengers = 'Vazio.'
    }
}

onMounted(() => {
    routes.value = props.driverRoutes
    routeForm.value._checker = props._checker
})

</script>

<template>

    <Head title="Rotas" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Editar Rotas para: {{ driverRoutes?.driver?.user?.name }}
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">

                        <div class="w-full z-auto grid grid-cols-1 md:grid-cols-6 gap-2">

                            <div class="w-full z-auto col-span-6 md:col-span-3">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Motorista
                                </label>
                                <input type="text"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-500 w-full bg-gray-300"
                                    :value="props.driverRoutes?.driver?.user?.name" readonly />
                            </div>

                            <div class="w-full z-auto col-span-6 md:col-span-3">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Data
                                </label>
                                <input type="date" :value="props.driverRoutes?.date"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-500 w-full bg-gray-300"
                                    readonly>
                            </div>

                            <div class="col-span-6 md:col-span-3">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Hora da Chegada no Destino*
                                </label>
                                <VueMultiselect v-model="routeForm.time" :options="props.timetables" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Hora"
                                    selectLabel="Selecionar" deselectLabel="Remover"
                                    class="border border-black rounded-md" />

                                <div v-if="routeForm.errors?.time"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit flex">
                                    <small v-for="error in routeForm.errors?.time">{{ error }}</small>
                                </div>
                                <div v-if="routeForm.ignoreQuestion">
                                    <label for="_ignore" class="p-1.5 text-amber-500 font-bold">
                                        Ignorar conflito e agendar
                                    </label>
                                    <input type="checkbox" id="_ignore" v-model="routeForm.ignore"
                                        class="text-red-400" />
                                </div>
                            </div>

                            <div class="text-left col-span-6 md:col-span-3">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Tempo de Permanência*
                                </label>
                                <input type="time" v-model="routeForm.duration"
                                    class="h-[41px] w-full text-gray-800 rounded" />

                                <div v-if="routeForm.errors?.duration"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.duration">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 md:col-span-3">
                                <label class="text-sm">
                                    Destino*
                                </label>
                                <VueMultiselect v-model="routeForm.branch" :options="props.branches" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Destino"
                                    :custom-label="branchName" track-by="id" label="time" selectLabel="Selecionar"
                                    deselectLabel="Remover" class="border border-black rounded-md" />

                                <div v-if="routeForm.errors?.branch"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.branch">{{ error }}</small>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 col-span-6 md:col-span-3">
                                <label class="text-sm text-gray-500 dark:text-gray-400 col-span-6">
                                    Obs.:
                                </label>
                                <textarea class="rounded text-gray-600" v-model="routeForm.obs"></textarea>
                                <div v-if="routeForm.errors?.obs"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                    <small v-for="error in routeForm.errors?.obs">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6" v-if="routeForm.branch?.id === 1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Local*
                                </label>
                                <input type="text" v-model="routeForm.local"
                                    class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                                <div v-if="routeForm.errors?.local"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.local">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 grid grid-cols-8 gap-2">
                                <div class="col-span-6 grid grid-cols-4 gap-2">
                                    <div class="col-span-5 md:col-span-2">
                                        <label class="text-sm text-gray-500 dark:text-gray-400">
                                            Passageiro*
                                        </label>
                                        <input type="text" v-model="passengersModel.passenger"
                                            class="w-full rounded border border-black h-[41px] text-gray-700" />
                                    </div>
                                    <div class="col-span-5 md:col-span-2">
                                        <label class="text-sm text-gray-500 dark:text-gray-400">
                                            Contato*
                                        </label>
                                        <input type="text" v-model="passengersModel.contact" maxlength="11"
                                            @keyup="maskPhone($event)"
                                            class="w-full rounded border border-black h-[41px] text-gray-700" />
                                    </div>
                                </div>
                                <button type="button" @click="setPassenger(false)"
                                    :disabled="passengersModel.passenger.length < 3 || passengersModel.contact.length < 8"
                                    class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline col-span-2 w-full self-center h-28 md:max-h-[41px] md:self-end mt-6"
                                    :class="passengersModel.passenger.length < 3 || passengersModel.contact.length < 8 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                    Incluir
                                </button>

                                <div v-if="routeForm.errors?.passengers"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                    <small v-for="error in routeForm.errors?.passengers">{{ error }}</small>
                                </div>

                                <div class="col-span-4 mb-4">
                                    <div v-for="(p, i) in routeForm.passengers" :key="'pre_' + i"
                                        class="inline-flex w-full">
                                        {{ p.passenger }}: {{ p.contact }}
                                        <button @click="setPassenger(true, p)">
                                            <mdicon name="close" class="text-red-400" />
                                        </button>
                                        <button @click="setPassenger(false, p, true)">
                                            <mdicon name="pencil" class="text-blue-400" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button type="button" @click="saveRoute"
                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline mt-6">
                            Adicionar Rota
                        </button>
                    </div>
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mx-2">

                        <div class="p-2 rounded-lg overflow-y-auto"
                            :class="$page.props.app.settingsStyles.main.innerSection">
                            <button @click="verifyDriverRoute"
                                class="flex px-2 py-1.5 transition duration-500 ease select-none rounded-md border border-blue-500 dark:border-slate-300 bg-blue-300 hover:bg-blue-400 text-blue-500 hover:text-blue-200 dark:bg-slate-400 dark:hover:bg-slate-600 dark:text-slate-800 dark:hover:text-slate-200 float-right">
                                Recarregar Rotas
                                <mdicon name="refresh" />
                            </button>
                            <table class="min-w-full">
                                <thead>
                                    <tr>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Chegada Prevista
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Destino
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Saída
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Chegada
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Ações
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(r, i) in routes.routes" :key="'route-' + i">
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            {{ r.time }}
                                        </td>
                                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center"
                                            :class="r.branch.id === 1 ? 'underline underline-offset-8' : ''">
                                            <span>{{ r.branch.name }}</span>
                                            <mdicon name="circle" class="float-right text-red-500"
                                                v-if="r.branch.id === 1" />
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                                :class="r.started_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                                {{ r.started_at ? moment(r.started_at).format('DD/MM/YYYY HH:mm') :
                                                    'pendente' }}
                                            </p>
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                                :class="r.ended_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                                {{ r.ended_at ? moment(r.ended_at).format('DD/MM/YYYY HH:mm') :
                                                    'pendente' }}
                                            </p>
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <button @click="setRouteToEdit(r)" v-if="!r.started_at">
                                                <mdicon name="pencil"
                                                    class="hover:text-green-500 dark:hover:text-gray-400" />
                                            </button>
                                            <mdicon name="cancel" v-else
                                                class="hover:text-green-500 dark:hover:text-gray-400" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>


                    <!--Modal editar rota-->
                    <div class="fixed inset-0 items-center justify-center overflow-auto mx-1"
                        :class="modal.editRoute ? 'flex' : 'hidden'">
                        <div class="fixed inset-0 transition-opacity">
                            <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                        </div>
                        <div v-if="routeForEdition"
                            class="bg-white rounded-lg text-left overflow-auto shadow-xl transform transition-all w-11/12 md:max-w-[1024px] max-h-[90%] dark:bg-gray-600">
                            <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                                <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                                    Editando Rota de:
                                    <span class="font-bold underline">
                                        {{ props.driverRoutes?.driver?.user?.name }}
                                    </span> em {{ moment(props.driverRoutes?.date).format('DD/MM/YYYY') }}
                                </h3>

                                <div class="mt-2 overflow-x-hidden grid grid-cols-1 md:grid-cols-6 gap-2">

                                    <div class="col-span-6 md:col-span-2">
                                        <label class="text-sm">
                                            Data*
                                        </label>
                                        <input type="date" v-model="routeForEdition.date"
                                            class="rounded border border-black h-[41px] text-gray-700 w-full">

                                        <div v-if="routeForEdition.errors?.date"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.errors?.date">{{ error }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-5 md:col-span-2">
                                        <label class="text-sm">
                                            Hora da Chegada no Destino*
                                        </label>
                                        <VueMultiselect v-model="routeForEdition.time" :options="$page.props.timetables"
                                            :multiple="false" :close-on-select="true" selectedLabel="atual"
                                            placeholder="Hora" selectLabel="Selecionar" deselectLabel="Remover"
                                            class="border border-black rounded-md" />
                                        <div v-if="routeForEdition.ignoreQuestion">
                                            <label for="_ignore" class="p-1.5 text-amber-500 font-bold">
                                                Ignorar conflito e agendar
                                            </label>
                                            <input type="checkbox" id="_ignore" v-model="routeForEdition.ignore"
                                                class="text-red-400" />
                                        </div>
                                        <div v-if="routeForEdition.errors?.time"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.errors?.time">{{ error }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-6 md:col-span-2 text-left"
                                        v-if="validateDate(routeForEdition.date)">
                                        <label class="text-sm">
                                            Tempo de Permanência*
                                        </label>
                                        <input type="time" v-model="routeForEdition.duration"
                                            class="h-[41px] w-full text-gray-800 rounded" />

                                        <div v-if="routeForEdition.errors?.duration"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.errors?.duration">{{ error }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-6 md:col-span-3">
                                        <label class="text-sm">
                                            Motorista
                                        </label>
                                        <VueMultiselect v-model="routeForEdition.driver" :options="_drivers"
                                            :multiple="false" :close-on-select="true" placeholder="Motorista"
                                            :custom-label="drivers" selectLabel="Selecionar" deselectLabel="Remover"
                                            class="border border-black rounded-md" />

                                        <div v-if="routeForEdition.errors?.driver"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.errors?.driver">{{ error
                                                }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-6 md:col-span-3">
                                        <label class="text-sm">Destino</label>
                                        <VueMultiselect v-model="routeForEdition.branch" :options="props.branches"
                                            :multiple="false" :close-on-select="true" placeholder="Destino" label="name"
                                            :custom-label="branchName" track-by="id" selectLabel="Selecionar"
                                            deselectLabel="Remover" @select="$page.props.errors.date = null"
                                            class="border border-black rounded-md" />

                                        <div v-if="routeForEdition.errors?.to"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.errors?.to">{{ error }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-6" v-if="routeForEdition.branch?.id === 1">
                                        <label class="text-sm">
                                            Local*
                                        </label>
                                        <input type="text" v-model="routeForEdition.local"
                                            class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                                        <div v-if="routeForEdition.errors?.local"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.errors?.local">{{ error }}</small>
                                        </div>
                                    </div>
                                    <div class="col-span-6 grid grid-cols-1 -mt-1.5 md:mt-0">
                                        <label class="text-sm">
                                            Obs.:
                                        </label>
                                        <textarea class="rounded text-gray-600"
                                            v-model="routeForEdition.obs"></textarea>
                                        <div v-if="routeForEdition.errors?.obs"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                            <small v-for="error in routeForEdition.errors?.obs">{{ error }}</small>
                                        </div>
                                    </div>
                                    <div class="col-span-6 grid grid-cols-8 gap-2"
                                        v-if="validateDate(routeForEdition.date)">
                                        <div class="col-span-6 grid grid-cols-4 gap-2">
                                            <div class="col-span-5 md:col-span-2">
                                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                                    Passageiro*
                                                </label>
                                                <input type="text" v-model="passengersEditModel.passenger"
                                                    class="w-full rounded border border-black h-[41px] text-gray-700" />
                                            </div>
                                            <div class="col-span-5 md:col-span-2">
                                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                                    Contato*
                                                </label>
                                                <input type="text" v-model="passengersEditModel.contact"
                                                    @keyup="maskPhone($event)" maxlength="11"
                                                    class="w-full rounded border border-black h-[41px] text-gray-700" />
                                            </div>
                                        </div>
                                        <button type="button" @click="setEditPassenger(false)"
                                            :disabled="passengersEditModel.passenger.length < 3 || passengersEditModel.contact.length < 8"
                                            class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline col-span-2 w-full self-center h-28 md:max-h-[41px] md:self-end mt-6"
                                            :class="passengersEditModel.passenger.length < 3 || passengersEditModel.contact.length < 8 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                            Incluir
                                        </button>

                                        <div v-if="routeForEdition.errors?.passengers"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                            <small v-for="error in routeForEdition.errors?.passengers">{{ error
                                                }}</small>
                                        </div>

                                        <div class="col-span-4 mb-4" v-if="validateDate(routeForEdition?.date)">
                                            <div v-for="(p, i) in routeForEdition.passengers" :key="'pre_' + i"
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

                                </div>
                            </div>
                            <div class="dark:bg-gray-500 px-4 py-3 sm:px-6 gap-1 grid grid-cols-1 md:flex text-center">
                                <button type="button"
                                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm"
                                    @click="updateRoute()">
                                    Salvar
                                </button>
                                <button type="button"
                                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm"
                                    @click="modal.editRoute = false, resetRouteForEdition()">
                                    Fechar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
<style scoped>
input:checked~.dot {
    transform: translateX(100%);
    background-color: #0ae465;
}
</style>
