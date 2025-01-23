<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head } from '@inertiajs/vue3';
import { toast } from '@/toast.ts';
import axios from 'axios';
import { computed, ref } from 'vue';
import moment from 'moment';
import validate from '@/validates/indexSaveRoute.js';
import validateUpRt from '@/validates/createUpdateRoute.js';
import { getStyles, styles } from '@/contrasts';
import has from '@/arrayHelpers';

const props = defineProps({
    drivers: Object,
    branches: Object,
    timetables: Object,
    routes: Object,
    errors: Object
});

const filter = ref({
    routes: false,
    requests: false,
})

const routes = ref([]);

const filteredRoutes = computed(() => {
    return routes.value?.filter((i => {
        if (filter.value.routes && !filter.value.requests) {
            return !(i.local)
        } else if (!filter.value.routes && filter.value.requests) {
            return !(i.task)
        } else {
            return true
        }
    }))
});

const routeForm = ref({
    driver: '',
    date: '',
    time: '',
    branch: '',
    errors: [],
    local: '',
    duration: '',
    passengers: [],
    _checker: ''
});

const modal = ref({
    editRoute: false,
    editRequest: false
});

const routeForEdition = ref({
    id: '',
    branch: '',
    currentBranch: '',
    time: '',
    local: '',
    duration: '',
    passengers: [],
    errors: []
});

const routeRequestEdition = ref({
    id: '',
    driver: '',
    date: '',
    branch: '',
    currentBranch: '',
    time: '',
    local: '',
    duration: '',
    passengers: [],
    errors: []
});

const passengersModel = ref('')

function setPassenger(remove = false, passenger = null) {
    routeForm.value.errors.passengers = ''
    if (remove) {
        routeForm.value.passengers.splice(routeForm.value.passengers.indexOf(passenger), 1)
    } else if (passengersModel.value) {
        routeForm.value.passengers.push(passengersModel.value)
        passengersModel.value = ''
    } else {
        routeForm.value.errors.passengers = 'Vazio.'
    }
}

const passengersRequestModel = ref('')

function setRequestPassenger(remove = false, passenger = null) {
    routeRequestEdition.value.errors.passengers = ''
    if (remove) {

        routeRequestEdition.value.passengers.splice(routeRequestEdition.value.passengers.indexOf(passenger), 1)
    } else if (passengersRequestModel.value) {

        routeRequestEdition.value.passengers.push(passengersRequestModel.value)
        passengersRequestModel.value = ''
    } else {

        routeRequestEdition.value.errors.passengers = 'Vazio.'
    }
}

const passengersEditModel = ref('')

function setEditPassenger(remove = false, passenger = null) {
    routeForEdition.value.errors.passengers = ''
    if (remove) {
        routeForEdition.value.passengers.splice(routeForEdition.value.passengers.indexOf(passenger), 1)
    } else if (passengersEditModel.value) {
        routeForEdition.value.passengers.push(passengersEditModel.value)
        passengersEditModel.value = ''
    } else {
        routeForEdition.value.errors.passengers = 'Vazio.'
    }
}

function validateDate(date) {
    return moment(date).isSame(moment(), 'day') || moment(date).isAfter(moment(), 'day') || true
}

function driverName({ id, user }) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}

function branchName({ id, name }) {
    if (id === 1) {
        return `${id ? id : ''} - Não Cadastrado`
    } else {
        return `${id ? id : ''} - ${name ? name : ''}`
    }
}

function saveRoute() {
    routeForm.value.errors = []
    let val = validate(routeForm.value)

    if (val._run &&
        validateDate(routeForm.value.date)
    ) {
        axios.post(route('frota.requests.store'), {
            driver: routeForm.value.driver?.id,
            date: routeForm.value.date,
            time: routeForm.value.time,
            duration: routeForm.value.duration,
            branch: routeForm.value.branch?.id,
            local: routeForm.value.local,
            _checker: routes.value[0]?._checker ?? null,
            passengers: routeForm.value.passengers
        })
            .then((r) => {
                toast.success(r.data.message, { duration: 5000 })
                verifyDriverRoute()
                resetForm()
            })
            .catch((e) => {
                if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    routeForm.value.errors = e.response.data
                } else if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                } else if (e.response?.status === 422) {
                    toast.error('Todos os campos são obrigatórios.')
                    routeForm.value.errors = e.response.data.errors
                } else {
                    toast.error('Foram encontrados erros ao processar sua solicitação');
                }
            })
    } else {
        if (!validateDate(routeForm.value.date)) {
            toast.error('Não é possível criar/adicionar a agenda para datas passadas.')
        } else {
            routeForm.value.errors = val
            toast.error('Preencha todos os campos para prosseguir.')
        }
    }
}

function resetForm() {
    routeForm.value.time = ''
    routeForm.value.branch = ''
    routeForm.value.duration = ''
    routeForm.value.passengers = []
}

function verifyDriverRoute() {
    routeForm.value.errors = []
    routes.value = [];
    if (routeForm.value.date && routeForm.value.driver) {
        axios.post(route('frota.requests.get-routes-and-requests'), {
            driver: routeForm.value.driver.id,
            date: routeForm.value.date
        })
            .then((r) => {
                if (Object.values(r.data).length > 0) {
                    routes.value = r.data
                } else {
                    toast.info('Sem tarefas para a data selecionada.')
                }
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                } else {
                    toast.error('Foram encontrados erros ao processar sua solicitação');
                }
            })
    }
}

function updateRoute() {
    let val = validateUpRt(routeForEdition.value, ['driver'])
    if (val._run) {
        axios.put(route('frota.routes.route.update', routeForEdition.value.id), {
            id: routeForEdition.value.id,
            branch: routeForEdition.value.branch,
            currentBranch: routeForEdition.value.currentBranch,
            time: routeForEdition.value.time,
            duration: routeForEdition.value.duration,
            passengers: routeForEdition.value.passengers,
            local: routeForEdition.value.local,
            _checker: routeForEdition.value._checker
        })
            .then(() => {
                verifyDriverRoute();
                modal.value.editRoute = false;
                routeForEdition.value.time = ''
                routeForEdition.value.branch = ''
                routeForEdition.value.local = ''
                routeForEdition.value.duration = ''
                routeForEdition.value.passengers = []
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeForEdition.value.errors = e.response.data.error
                } else if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    routeForEdition.value.errors = e.response.data.errors
                } else if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    routeForEdition.value.errors = e.response.data
                }
            })
    } else {
        routeForEdition.value.errors = val
        toast.error('Preencha todos os campos para atualizar a rota');
    }
}

function updateRequest() {
    let val = validateUpRt(routeRequestEdition.value)
    if (val._run) {
        axios.put(route('frota.requests.update', routeRequestEdition.value.id), {
            id: routeRequestEdition.value.id,
            branch: routeRequestEdition.value.branch.id,
            currentBranch: routeRequestEdition.value.currentBranch.id,
            time: routeRequestEdition.value.time,
            driver: routeRequestEdition.value.driver.id,
            date: routeRequestEdition.value.date,
            duration: routeRequestEdition.value.duration,
            passengers: routeRequestEdition.value.passengers,
            local: routeRequestEdition.value.local,
            _checker: routeRequestEdition.value._checker
        })
            .then(() => {
                verifyDriverRoute();
                modal.value.editRequest = false;
                routeRequestEdition.value.time = ''
                routeRequestEdition.value.branch = ''
                routeRequestEdition.value.local = ''
                routeRequestEdition.value.duration = ''
                routeRequestEdition.value.passengers = []
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeRequestEdition.value.errors = e.response.data.error
                } else if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    routeRequestEdition.value.errors = e.response.data.errors
                } else if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    routeRequestEdition.value.errors = e.response.data
                }
            })
    } else {
        routeRequestEdition.value.errors = val
        toast.error('Preencha todos os campos para atualizar a solicitação.');
    }
}

function setRouteToEdit(route) {
    routeForEdition.value._checker = route._checker
    routeForEdition.value.id = route.id
    routeForEdition.value.errors = []
    routeForEdition.value.time = route.time
    routeForEdition.value.duration = route.duration
    routeForEdition.value.passengers = Object.values(JSON.parse(route.passengers) ?? [])
    if (route.b === 1) {
        routeForEdition.value.currentBranch = { "id": route.b, "name": 'Não Cadastrado' }
        routeForEdition.value.branch = { "id": route.b, "name": 'Não Cadastrado' }
        routeForEdition.value.local = route.branch
    } else {
        routeForEdition.value.local = ''
        routeForEdition.value.currentBranch = { "id": route.b, "name": route.branch }
        routeForEdition.value.branch = { "id": route.b, "name": route.branch }
    }
    modal.value.editRoute = true
}

function setRequestToEdit(route) {
    routeRequestEdition.value._checker = route._checker
    routeRequestEdition.value.id = route.id
    routeRequestEdition.value.date = route.date
    routeRequestEdition.value.driver = route.driver
    routeRequestEdition.value.errors = []
    routeRequestEdition.value.time = route.time
    routeRequestEdition.value.duration = route.duration
    routeRequestEdition.value.passengers = Object.values(JSON.parse(route.passengers) ?? [])
    if (route.branch.id === 1) {
        routeRequestEdition.value.currentBranch = { "id": route.branch.id, "name": 'Não Cadastrado' }
        routeRequestEdition.value.branch = { "id": route.branch.id, "name": 'Não Cadastrado' }
        routeRequestEdition.value.local = route.local
    } else {
        routeRequestEdition.value.local = ''
        routeRequestEdition.value.currentBranch = { "id": route.branch.id, "name": route.branch.name }
        routeRequestEdition.value.branch = { "id": route.branch.id, "name": route.branch.name }
    }
    modal.value.editRequest = true
}

function getRouteStatus(task, status) {
    if (task) {
        return 'Confirmado'
    }
    //0 Pendente; 1 Aprovado; 2 Negado; 3 em Avaliação; 4 Carona
    switch (status) {
        case 0:
            return 'Pendente'
        case 1:
            return 'Aprovado'
        case 2:
            return 'Negado'
        case 3:
            return 'Em avaliação'
        case 4:
            return 'Carona'
        default:
            return 'Erro'
    }
}

</script>

<template>

    <Head title="Solicitar Carro" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Solicitar Carro
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded"
                        v-if="routeForm.date">
                        <div class="relative w-full z-auto min-h-fit grid grid-cols-4 gap-3">
                            <div class="col-span-4 md:col-span-2 h-12">
                                <label class="text-sm">
                                    Selecione um motorista
                                </label>
                                <VueMultiselect v-model="routeForm.driver" :options="props.drivers" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Motorista"
                                    :custom-label="driverName" track-by="id" selectLabel="Selecionar"
                                    @select="verifyDriverRoute" deselectLabel="Remover" />

                                <div v-if="routeForm.errors?.driver"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.driver">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-4 md:col-span-2" v-if="validateDate(routeForm.date)">
                                <label class="text-sm">
                                    Unidade*
                                </label>
                                <VueMultiselect v-model="routeForm.branch" :options="props.branches" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Unidade"
                                    :custom-label="branchName" track-by="id" label="time" selectLabel="Selecionar"
                                    deselectLabel="Remover" />
                                <div v-if="routeForm.errors?.branch"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.branch">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-4" v-if="routeForm.date && routeForm.branch?.id === 1">
                                <label class="text-sm">
                                    Local*
                                </label>
                                <input type="text" v-model="routeForm.local"
                                    class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700" />

                                <div v-if="routeForm.errors?.local"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.local">{{ error }}</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mt-3">
                        <div class="w-full z-auto min-h-fit grid grid-cols-1 md:grid-cols-6 gap-3">

                            <div class="grid grid-cols-1 col-span-6 md:col-span-2 h-12">
                                <label class="text-sm">
                                    Data*
                                </label>
                                <input type="date" v-model="routeForm.date" @change="verifyDriverRoute"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                                <div v-if="routeForm.errors?.date"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.date">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 md:col-span-2" v-if="validateDate(routeForm.date)">
                                <label class="text-sm">
                                    Hora*
                                </label>
                                <VueMultiselect v-model="routeForm.time" :options="props.timetables" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Hora"
                                    selectLabel="Selecionar" deselectLabel="Remover" />

                                <div v-if="routeForm.errors?.time"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.time">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 md:col-span-2 text-left" v-if="validateDate(routeForm.date)">
                                <label class="text-sm">
                                    Duração (h)*
                                </label>
                                <input type="time" v-model="routeForm.duration"
                                    class="h-[41px] w-full text-gray-800 rounded" />

                                <div v-if="routeForm.errors?.duration"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.duration">{{ error }}</small>
                                </div>
                            </div>
                            <div class="col-span-6 md:col-span-4" v-if="validateDate(routeForm.date)">
                                <div class="grid grid-cols-6">
                                    <label class="text-sm col-span-6">
                                        Incluir Passageiro*
                                    </label>
                                    <div class="inline-flex col-span-6">
                                        <input type="text" v-model="passengersModel"
                                            class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700" />
                                        <button type="button" @click="setPassenger(false)"
                                            v-if="validateDate(routeForm.date)" :disabled="passengersModel?.length < 4"
                                            class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                            :class="passengersModel?.length < 4 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                            Incluir
                                        </button>
                                    </div>
                                    <div v-if="routeForm.errors?.passengers"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                        <small v-for="error in routeForm.errors?.passengers">{{ error }}</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-span-4 mb-4 -mt-2" v-if="validateDate(routeForm.date)">
                                <span v-for="(p, i) in routeForm.passengers" :key="'p_' + i" class=" inline-flex mx-4">
                                    {{ p }}
                                    <button @click="setPassenger(true, p)">
                                        <mdicon name="close" class="text-red-400" />
                                    </button>
                                </span>
                            </div>
                        </div>

                        <button type="button" @click="saveRoute" v-if="validateDate(routeForm.date)"
                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline w-full max-w-[300px]">
                            Enviar Solicitação
                        </button>
                    </div>

                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mx-2 mt-3"
                        v-if="routeForm?.driver?.id === routes[0]?.driver || routeForm?.driver?.id === routes[0]?.driver.id">
                        <p><span class="font-bold">Motorista:</span>
                            {{ routeForm?.driver?.id === routes[0]?.driver ? routeForm?.driver?.user?.name : '' }}
                        </p>
                        <p><span class="font-bold">Data:</span>
                            {{ moment(routes.date).format('DD/MM/YYYY') }}
                        </p>
                        <div class="p-2 rounded-lg overflow-y-auto"
                            :class="$page.props.app.settingsStyles.main.innerSection">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-1">

                                <div class="grid grid-cols-1">
                                    <p>Filtrar:</p>
                                    <div class="inline-flex gap-1 my-1">
                                        <div
                                            class="flex items-center ps-4 border border-gray-200 rounded dark:border-gray-700 px-3 w-[135px]">
                                            <input id="bordered-radio-1" type="checkbox" v-model="filter.routes"
                                                class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600">
                                            <label for="bordered-radio-1"
                                                class="w-full py-4 ms-2 text-sm font-medium text-gray-900 dark:text-gray-300">
                                                Agendados
                                            </label>
                                        </div>
                                        <div
                                            class="flex items-center ps-4 border border-gray-200 rounded dark:border-gray-700 px-3 w-[135px]">
                                            <input checked id="bordered-radio-2" type="checkbox"
                                                v-model="filter.requests"
                                                class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600">
                                            <label for="bordered-radio-2"
                                                class="w-full py-4 ms-2 text-sm font-medium text-gray-900 dark:text-gray-300">
                                                Solicitações
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="self-end w-full">
                                    <button @click="verifyDriverRoute"
                                        class="flex px-2 py-1.5 mb-1 transition duration-500 ease select-none rounded-md border border-blue-500 dark:border-slate-300 bg-blue-300 hover:bg-blue-400 text-blue-500 hover:text-blue-200 dark:bg-slate-400 dark:hover:bg-slate-600 dark:text-slate-800 dark:hover:text-slate-200 self-end max-h-[38px] max-w-fit float-right">
                                        Recarregar Rotas
                                        <mdicon name="refresh" />
                                    </button>
                                </div>

                            </div>
                            <table class="min-w-full" :class="$page.props.app.settingsStyles.main.body">
                                <thead>
                                    <tr>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Hora
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Unidade
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Passageiros
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Duração
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
                                            Status
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Ações
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(r, i) in filteredRoutes" :key="'route-' + i"
                                        :class="getRouteStatus(r.task, r.status) !== 'Confirmado' ? styles($page.props.app.settingsStyles.main.body) : ''">
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            {{ r.time }}
                                        </td>
                                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center"
                                            :class="r.to === 1 || r.b === 1 ? 'underline underline-offset-8' : ''">
                                            {{ r.local ?? r.branch }}
                                            <mdicon name="circle" class="float-right text-red-500"
                                                v-if="r.to === 1 || r.b === 1" />
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            {{ Object.values(JSON.parse(r.passengers ?? '[]')).length }}
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            {{ r.duration }}
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <p class="mx-auto text-sm px-2 rounded-md border w-min"
                                                :class="r.started_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                                {{
                                                    r.started_at ? moment(r.started_at).format('DD/MM/YYYY HH:mm') :
                                                        '-'
                                                }}
                                            </p>
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <p class="mx-auto text-sm px-2 rounded-md border w-min"
                                                :class="r.ended_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                                {{
                                                    r.ended_at ? moment(r.ended_at).format('DD/MM/YYYY HH:mm') :
                                                        '-'
                                                }}
                                            </p>
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <p class="mx-auto text-sm px-2 rounded-md border"
                                                :class="getStyles(r.task, r.status)">
                                                {{
                                                    getRouteStatus(r.task, r.status)
                                                }}
                                                <br>
                                                <span class="text-[10px]">
                                                    {{
                                                        r.created_at ? moment(r.created_at).format('DD/MM/YYYY HH:mm:ss') :
                                                            ''
                                                    }}
                                                </span>
                                            </p>
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <button @click="setRouteToEdit(r)" v-if="moment(moment(routeForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                                moment(moment(routeForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))
                                                && (has($page.props.auth.permissions, ['Agenda Editar', 'Agenda Apagar']) || has($page.props.auth.roles, ['Super Admin']))
                                                && r.task">
                                                <mdicon name="pencil"
                                                    class="hover:text-green-500 dark:hover:text-blue-300" />
                                            </button>
                                            <button @click="setRequestToEdit(r)" v-else-if="moment(moment(routeForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                                moment(moment(routeForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))
                                                && (has($page.props.auth.permissions, ['Solicitacao Editar', 'Solicitacao Apagar']) || has($page.props.auth.roles, ['Super Admin']))
                                                && r.user?.id === $page.props.auth.user.id">
                                                <mdicon name="hand-wash"
                                                    class="hover:text-green-500 dark:hover:text-blue-300" />
                                            </button>
                                            <span v-else>-</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--Modal editar rota-->
                    <div class="fixed inset-0 flex items-center justify-center overflow-hidden mx-1"
                        :class="modal.editRoute ? 'block' : 'hidden'">
                        <div class="fixed inset-0 transition-opacity">
                            <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                        </div>
                        <div v-if="routeForEdition"
                            class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600 p-4">

                            <div class="overflow-x-auto grid grid-cols-3 gap-3">

                                <div class="col-span-3 md:col-span-1">
                                    <label class="text-sm">
                                        Hora
                                    </label>
                                    <VueMultiselect v-model="routeForEdition.time" :options="$page.props.timetables"
                                        :multiple="false" :close-on-select="true" selectedLabel="atual"
                                        placeholder="Hora" selectLabel="Selecionar" deselectLabel="Remover" />

                                    <div v-if="routeForEdition.errors?.time"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in routeForEdition.errors?.time">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-3 md:col-span-2">
                                    <label class="text-sm">
                                        Unidade
                                    </label>
                                    <VueMultiselect v-model="routeForEdition.branch" :options="$page.props.branches"
                                        :multiple="false" :close-on-select="true" placeholder="Unidade" label="name"
                                        track-by="id" selectLabel="Selecionar" deselectLabel="Remover"
                                        @select="$page.props.errors.date = null" :custom-label="branchName" />

                                    <div v-if="routeForEdition.errors?.branch"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in routeForEdition.errors?.branch">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-3" v-if="routeForEdition.branch?.id === 1">
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

                                <div class="col-span-3 md:col-span-1">
                                    <label class="text-sm">
                                        Duração*
                                    </label>
                                    <input type="time" v-model="routeForEdition.duration"
                                        class="w-full rounded border h-[41px] mt-0.5 text-gray-700">

                                    <div v-if="routeForEdition.errors?.duration"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in routeForEdition.errors?.duration">{{ error }}</small>
                                    </div>
                                </div>
                                <div class="col-span-3 md:col-span-3">
                                    <div class="grid grid-cols-6">
                                        <label class="text-sm col-span-6">
                                            Incluir Passageiro*
                                        </label>
                                        <div class="inline-flex col-span-6">
                                            <input type="text" v-model="passengersEditModel"
                                                class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700" />
                                            <button type="button" @click="setEditPassenger(false)"
                                                v-if="validateDate(routes?.date)"
                                                :disabled="passengersEditModel?.length < 3"
                                                class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                                :class="passengersEditModel?.length < 4 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                                Incluir
                                            </button>
                                        </div>
                                        <div v-if="routeForEdition.errors?.passengers"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                            <small v-for="error in routeForEdition.errors?.passengers">
                                                {{ error }}
                                            </small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-span-3 mb-4 -mt-2">
                                    <span v-for="(p, i) in routeForEdition.passengers" :key="'ps_' + i"
                                        class=" inline-flex">
                                        {{ p }}
                                        <button @click="setEditPassenger(true, p)">
                                            <mdicon name="close" class="text-red-400" />
                                        </button>
                                    </span>
                                </div>

                                <div class="h-[10rem] mx-2 col-span-2 mt-2">
                                    <div class="text-center mt-3" v-if="routeForEdition.errors?._checker">
                                        <span class="border border-red-500 bg-red-400 rounded max-w-fit px-3">
                                            {{ routeForEdition.errors?._checker[0] }}
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
                                <button type="button"
                                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm"
                                    @click="modal.editRoute = false, routeForEdition = {}">
                                    Fechar
                                </button>
                            </div>
                        </div>
                    </div>
                    <!--Modal editar solicitação -->
                    <div class="fixed inset-0 flex items-center justify-center overflow-hidden mx-1"
                        :class="modal.editRequest ? 'block' : 'hidden'">
                        <div class="fixed inset-0 transition-opacity">
                            <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                        </div>
                        <div v-if="routeRequestEdition"
                            class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600">
                            <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                                <!-- {{ routeRequestEdition }} -->
                                <div class="overflow-x-auto grid grid-cols-4 gap-3">

                                    <div class="col-span-4 md:col-span-2 h-12">
                                        <label class="text-sm">
                                            Motorista*
                                        </label>
                                        <VueMultiselect v-model="routeRequestEdition.driver" :options="props.drivers"
                                            :multiple="false" :close-on-select="true" selectedLabel="atual"
                                            placeholder="Motorista" :custom-label="driverName" track-by="id"
                                            selectLabel="Selecionar" deselectLabel="Remover" />

                                        <div v-if="routeForm.errors?.driver"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForm.errors?.driver">{{ error }}</small>
                                        </div>
                                    </div>
                                    <div class="col-span-4 md:col-span-2 mt-4 md:mt-0">
                                        <label class="text-sm">
                                            Unidade*
                                        </label>
                                        <VueMultiselect v-model="routeRequestEdition.branch"
                                            :options="$page.props.branches" :multiple="false" :close-on-select="true"
                                            placeholder="Unidade" label="name" track-by="id" selectLabel="Selecionar"
                                            deselectLabel="Remover" @select="$page.props.errors.date = null"
                                            :custom-label="branchName" />

                                        <div v-if="routeRequestEdition.errors?.branch"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeRequestEdition.errors?.branch">{{ error
                                                }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-4" v-if="routeRequestEdition.branch?.id === 1">
                                        <label class="text-sm">
                                            Local*
                                        </label>
                                        <input type="text" v-model="routeRequestEdition.local"
                                            class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                                        <div v-if="routeRequestEdition.errors?.local"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeRequestEdition.errors?.local">{{ error
                                                }}</small>
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-1 col-span-4 md:col-span-2 h-12">
                                        <label class="text-sm">
                                            Data*
                                        </label>
                                        <input type="date" v-model="routeRequestEdition.date"
                                            @change="verifyDriverRoute"
                                            class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                                        <div v-if="routeRequestEdition.errors?.date"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeRequestEdition.errors?.date">{{ error }}</small>
                                        </div>
                                    </div>
                                    <div class="col-span-4 md:col-span-1 mt-4 md:mt-0">
                                        <label class="text-sm">
                                            Hora*
                                        </label>
                                        <VueMultiselect v-model="routeRequestEdition.time"
                                            :options="$page.props.timetables" :multiple="false" :close-on-select="true"
                                            selectedLabel="atual" placeholder="Hora" selectLabel="Selecionar"
                                            deselectLabel="Remover" />

                                        <div v-if="routeRequestEdition.errors?.time"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeRequestEdition.errors?.time">{{ error }}</small>
                                        </div>
                                    </div>
                                    <div class="col-span-4 md:col-span-1 md:-mt-0.5">
                                        <label class="text-sm">
                                            Duração*
                                        </label>
                                        <input type="time" v-model="routeRequestEdition.duration"
                                            class="w-full rounded border h-[41px] mt-0.5 text-gray-700">

                                        <div v-if="routeRequestEdition.errors?.duration"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeRequestEdition.errors?.duration">{{ error
                                                }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-4">
                                        <div class="grid grid-cols-6">
                                            <label class="text-sm col-span-6">
                                                Incluir Passageiro*
                                            </label>
                                            <div class="inline-flex col-span-6">
                                                <input type="text" v-model="passengersRequestModel"
                                                    class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700" />
                                                <button type="button" @click="setRequestPassenger(false)"
                                                    v-if="validateDate(routes?.date)"
                                                    :disabled="passengersRequestModel?.length < 3"
                                                    class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                                    :class="passengersRequestModel?.length < 4 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                                    Incluir
                                                </button>
                                            </div>
                                            <div v-if="routeRequestEdition.errors?.passengers"
                                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                                <small v-for="error in routeRequestEdition.errors?.passengers">
                                                    {{ error }}
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-span-3 mb-4 -mt-2">
                                        <span v-for="(p, i) in routeRequestEdition.passengers" :key="'ps_' + i"
                                            class=" inline-flex">
                                            {{ p }}
                                            <button @click="setRequestPassenger(true, p)">
                                                <mdicon name="close" class="text-red-400" />
                                            </button>
                                        </span>
                                    </div>

                                    <div class="h-[5rem] mx-2 col-span-2 mt-2">
                                        <div class="text-center mt-3" v-if="routeRequestEdition.errors?._checker">
                                            <span class="border border-red-500 bg-red-400 rounded max-w-fit px-3">
                                                {{ routeRequestEdition.errors?._checker[0] }}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="dark:bg-gray-500 px-4 py-3 sm:px-6 flex gap-1">
                                <button type="button"
                                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm"
                                    @click="updateRequest()">
                                    Salvar Solicitação
                                </button>
                                <button type="button"
                                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm"
                                    @click="modal.editRequest = false, routeRequestEdition = {}">
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
<style src="../../../../../node_modules/vue-multiselect/dist/vue-multiselect.css"></style>
