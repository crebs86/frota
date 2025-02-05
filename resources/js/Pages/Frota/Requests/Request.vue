<script setup>
import { getStyles, styles } from "@/contrasts.js";
import moment from 'moment';
import has from "@/arrayHelpers.js";
import VueMultiselect from "vue-multiselect";
import { computed, defineAsyncComponent, onBeforeMount, ref } from "vue";
import { validateDate } from "@/validates/validates.js";
import axios from "axios";
import { toast } from "@/toast";
import validate from "@/validates/indexSaveRoute.js";
import { branchName } from "@/helpers";
import { phoneMask } from "@/mask";

const EditRoute = defineAsyncComponent(() => import('@/Pages/Frota/Components/ModalEditRoute.vue'));

const p = defineProps({
    props: Object
});

const props = ref({});

const routes = ref([]);

const requestForm = ref({
    driver: '',
    date: '',
    time: '',
    branch: '',
    errors: {},
    local: '',
    duration: '',
    passengers: [],
    type: 1,
    obs: '',
    _checker: '',
    ignore: false,
    ignoreQuestion: false
});

const routeForEdition = ref({
    id: '',
    branch: '',
    currentBranch: '',
    time: '',
    local: '',
    duration: '',
    obs: '',
    passengers: [],
    errors: {},
    ignore: false,
    ignoreQuestion: false
});

const filter = ref({
    routes: false,
    requests: false,
});

const filteredRoutes = computed(() => {
    return routes.value?.routes?.filter((i => {
        if (filter.value.routes && !filter.value.requests) {
            return i.type === 0
        } else if (!filter.value.routes && filter.value.requests) {
            return i.type === 1
        } else {
            return true
        }
    }))
});

const modal = ref({
    editRoute: false,
    editRequest: false
});


function driverName({ id, user }) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}


function routeUpdated(reload = false) {
    if (reload) {
        verifyDriverRoute();
    }
    modal.value.editRoute = false;
    routeForEdition.value.time = ''
    routeForEdition.value.branch = ''
    routeForEdition.value.local = ''
    routeForEdition.value.duration = ''
    routeForEdition.value.obs = ''
    routeForEdition.value.passengers = []
}

function verifyDriverRoute() {
    requestForm.value.errors = []
    routes.value = [];
    if (requestForm.value.date && requestForm.value.driver) {
        axios.post(route('frota.requests.get-routes-and-requests'), {
            driver: requestForm.value.driver.id,
            date: requestForm.value.date
        })
            .then((r) => {
                if (Object.values(r.data).length > 0) {
                    routes.value = r.data[0] ?? []
                    requestForm.value._checker = r.data[1] ?? null
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

const passengersModel = ref({
    passenger: '',
    contact: ''
})

const maskPhone = (event) => {
    let input = event.target
    input.value = phoneMask(input.value)
}

function setPassenger(remove = false, passenger = null, edit = false) {
    requestForm.value.errors.passengers = ''
    if (remove) {
        requestForm.value.passengers.splice(requestForm.value.passengers.indexOf(passenger), 1)
    } else if (edit) {
        passengersModel.value.contact = passenger.contact
        passengersModel.value.passenger = passenger.passenger
        requestForm.value.passengers.splice(requestForm.value.passengers.indexOf(passenger), 1)
    } else if (passengersModel.value) {
        requestForm.value.passengers.push(passengersModel.value)
        passengersModel.value = {
            passenger: '',
            contact: ''
        }
    } else {
        routeForm.value.errors.passengers = 'Vazio.'
    }
}

function getRouteStatus(type, status) {
    if (type === 0) {
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

function resetForm() {
    requestForm.value.time = ''
    requestForm.value.branch = ''
    requestForm.value.duration = ''
    requestForm.value.passengers = []
    requestForm.value.obs = ''
}

function saveRequest() {
    requestForm.value.errors = []
    let val = validate(requestForm.value, ['driver'])

    if (val._run &&
        validateDate(requestForm.value.date)
    ) {
        axios.post(route('frota.request.store'), {
            driver: requestForm.value.driver?.id,
            date: requestForm.value.date,
            time: requestForm.value.time,
            duration: requestForm.value.duration,
            branch: requestForm.value.branch?.id,
            local: requestForm.value.local,
            type: requestForm.value.type,
            obs: requestForm.value.obs,
            _checker: requestForm.value._checker,
            passengers: requestForm.value.passengers,
            ignore: requestForm.value.ignore
        })
            .then((r) => {
                toast.success(r.data.message, { duration: 5000 })
                verifyDriverRoute()
                resetForm()
                requestForm.value.ignoreQuestion = false
            })
            .catch((e) => {
                if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    requestForm.value.errors = e.response.data
                } else if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                } else if (e.response?.status === 422) {
                    toast.error('Todos os campos são obrigatórios.')
                    requestForm.value.errors = e.response.data.errors
                } else if (e.response?.status === 409) {
                    requestForm.value.ignoreQuestion = true
                    toast.error(e.response.data.message)
                    requestForm.value.errors = e.response.data.errors
                } else {
                    toast.error('Foram encontrados erros ao processar sua solicitação');
                }
            })
    } else {
        if (!validateDate(requestForm.value.date)) {
            toast.error('Não é possível criar/adicionar a agenda para datas passadas.')
        } else {
            requestForm.value.errors = val
            toast.error('Preencha todos os campos para prosseguir.')
        }
    }
}

function setRouteToEdit(route) {
    modal.value.editRoute = true
    routeForEdition.value._checker = requestForm.value._checker
    routeForEdition.value.id = route.id
    routeForEdition.value.errors = []
    routeForEdition.value.currentBranch = route.branch
    routeForEdition.value.branch = route.branch
    routeForEdition.value.time = route.time
    routeForEdition.value.duration = route.duration
    routeForEdition.value.obs = route.obs
    routeForEdition.value.date = route.date
    routeForEdition.value.passengers = Object.values(JSON.parse(route.passengers) ?? [])
    if (route.branch.id === 1) {
        routeForEdition.value.local = route.branch.name
    } else {
        routeForEdition.value.local = ''
    }
}

onBeforeMount(() => {
    props.value = p.props
})
</script>

<template>
    <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
        <h2 class="text-xl text-center">Solicitar Carro</h2>
        <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded" v-if="requestForm.date">
            <div class="relative w-full z-auto min-h-fit grid grid-cols-4 gap-3">
                <div class="col-span-4 md:col-span-2 h-12">
                    <label class="text-sm">
                        Selecione um motorista
                    </label>
                    <VueMultiselect v-model="requestForm.driver" :options="props.drivers" :multiple="false"
                        :close-on-select="true" selectedLabel="atual" placeholder="Motorista" :custom-label="driverName"
                        track-by="id" selectLabel="Selecionar" @select="verifyDriverRoute" deselectLabel="Remover" />
                    <div v-if="requestForm.errors?.driver"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.driver">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-4 md:col-span-2" v-if="validateDate(requestForm.date)">
                    <label class="text-sm">
                        Destino*
                    </label>
                    <VueMultiselect v-model="requestForm.branch" :options="props.branches" :multiple="false"
                        :close-on-select="true" selectedLabel="atual" placeholder="Destino" :custom-label="branchName"
                        track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                    <div v-if="requestForm.errors?.branch"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.branch">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-4" v-if="requestForm.date && requestForm.branch?.id === 1">
                    <label class="text-sm">
                        Local*
                    </label>
                    <input type="text" v-model="requestForm.local"
                        class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700" />

                    <div v-if="requestForm.errors?.local"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.local">{{ error }}</small>
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
                    <input type="date" v-model="requestForm.date" @change="verifyDriverRoute"
                        class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                    <div v-if="requestForm.errors?.date"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.date">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-6 md:col-span-2" v-if="validateDate(requestForm.date)">
                    <label class="text-sm">
                        Hora da Chegada no Destino*
                    </label>
                    <VueMultiselect v-model="requestForm.time" :options="props.timetables" :multiple="false"
                        :close-on-select="true" selectedLabel="atual" placeholder="Hora" selectLabel="Selecionar"
                        deselectLabel="Remover" />

                    <div v-if="requestForm.errors?.time"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.time">{{ error }}</small>
                    </div>
                    <div v-if="requestForm.ignoreQuestion">
                        <label for="_ignore" class="p-1.5 text-amber-500 font-bold">Ignorar conflito.</label>
                        <input type="checkbox" id="_ignore" v-model="requestForm.ignore" class="text-red-400" />
                    </div>
                </div>

                <div class="col-span-6 md:col-span-2 text-left" v-if="validateDate(requestForm.date)">
                    <label class="text-sm">
                        Tempo de Permanência*
                    </label>
                    <input type="time" v-model="requestForm.duration" class="h-[41px] w-full text-gray-800 rounded" />

                    <div v-if="requestForm.errors?.duration"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.duration">{{ error }}</small>
                    </div>
                </div>
                <div class="col-span-6 grid grid-cols-1 -mt-1.5 md:mt-0" v-if="validateDate(requestForm?.date)">
                    <label class="text-sm col-span-6">
                        Obs.:
                    </label>
                    <textarea class="rounded text-gray-600" v-model="requestForm.obs"></textarea>
                    <div v-if="requestForm.errors?.obs"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                        <small v-for="error in requestForm.errors?.obs">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-6 grid grid-cols-8" v-if="validateDate(requestForm.date)">
                    <div class="col-span-6 grid grid-cols-4 gap-2">
                        <div class="col-span-5 md:col-span-2">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Passageiro*
                            </label>
                            <input type="text" v-model="passengersModel.passenger"
                                class="w-full rounded border border-black h-[41px] text-gray-700"
                                :class="!validateDate(requestForm?.date) ? 'bg-[#afb3b9]' : ''"
                                :disabled="!validateDate(requestForm?.date)" />
                        </div>
                        <div class="col-span-5 md:col-span-2">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Contato*
                            </label>
                            <input type="text" v-model="passengersModel.contact" @keyup="maskPhone($event)"
                                class="w-full rounded border border-black h-[41px] text-gray-700"
                                :class="!validateDate(requestForm?.date) ? 'bg-[#afb3b9]' : ''" maxlength="11"
                                :disabled="!validateDate(requestForm?.date)" />
                        </div>
                    </div>
                    <button type="button" @click="setPassenger(false)"
                        :disabled="passengersModel.passenger.length < 3 || passengersModel.contact.length < 8"
                        class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline col-span-2 w-full self-center h-28 md:max-h-[41px] md:self-end mt-6 md:-mb-[1px]"
                        :class="passengersModel.passenger.length < 3 || passengersModel.contact.length < 8 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                        Incluir
                    </button>

                    <div v-if="requestForm.errors?.passengers"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                        <small v-for="error in requestForm.errors?.passengers">{{ error }}</small>
                    </div>

                    <div class="col-span-4 mb-4" v-if="validateDate(requestForm?.date)">
                        <div v-for="(p, i) in requestForm.passengers" :key="'pre_' + i" class="inline-flex w-full">
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

            <button type="button" @click="saveRequest" v-if="validateDate(requestForm.date)"
                class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline w-full max-w-[300px]">
                Enviar Solicitação
            </button>
        </div>

        <!-- modal edit -->
        <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mx-2 mt-3"
            v-if="requestForm?.driver && (requestForm?.driver?.id === routes?.driver && routes?.driver != null)">
            <p><span class="font-bold">Motorista:</span>
                {{ requestForm?.driver?.id === routes[0]?.driver ? requestForm?.driver?.user?.name : '' }}
            </p>
            <p><span class="font-bold">Data:</span>
                {{ moment(routes.date).format('DD/MM/YYYY') }}
            </p>
            <div class="p-2 rounded-lg overflow-y-auto" :class="$page.props.app.settingsStyles.main.innerSection">
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
                                <input checked id="bordered-radio-2" type="checkbox" v-model="filter.requests"
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
                                Chegada Prevista
                            </th>
                            <th
                                class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                Destino
                            </th>
                            <th
                                class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                Passageiros
                            </th>
                            <th
                                class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                Tempo de Permanência
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
                    <tbody class="border border-black">
                        <tr v-for="(r, i) in filteredRoutes" :key="'route-' + i"
                            :class="getRouteStatus(r.type, r.status) !== 'Confirmado' && getRouteStatus(r.type, r.status) !== 'Aprovado' ? styles($page.props.app.settingsStyles.main.body) : ''">
                            <td
                                class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                {{ r.time }}
                            </td>
                            <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center"
                                :class="r.to === 1 || r.b === 1 ? 'underline underline-offset-8' : ''">
                                {{ r.branch.name }}
                                <mdicon name="circle" class="float-right text-red-500" v-if="r.to === 1 || r.b === 1" />
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
                                <p class="mx-auto text-sm px-2 rounded-md border" :class="getStyles(r.type, r.status)">
                                    {{
                                        getRouteStatus(r.type, r.status)
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
                                <button @click="setRouteToEdit(r)" v-if="moment(moment(requestForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                    moment(moment(requestForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))
                                    && (has($page.props.auth.permissions, ['Agenda Editar', 'Agenda Apagar']) || has($page.props.auth.roles, ['Super Admin']))
                                    && (r.type === 0
                                        || r.type === 1 && getRouteStatus(r.type, r.status) === 'Aprovado')">
                                    <mdicon name="pencil" class="hover:text-green-500 dark:hover:text-blue-300" />
                                </button>
                                <button @click="setRouteToEdit(r)" v-else-if="moment(moment(requestForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                    moment(moment(requestForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))
                                    && (has($page.props.auth.permissions, ['Solicitacao Editar', 'Solicitacao Apagar']) || has($page.props.auth.roles, ['Super Admin']) || r.user?.id === $page.props.auth.user.id)
                                    && r.type === 1">
                                    <mdicon name="hand-wash" class="hover:text-green-500 dark:hover:text-blue-300" />
                                </button>
                                <span v-else>-</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!--Modal editar rota-->
        <EditRoute v-if="modal.editRoute" :routeForEdition="routeForEdition" :drivers="props.drivers"
            :driver="requestForm.driver" :_checker="routeForEdition._checker" @routeUpdated="routeUpdated"
            :isRequest="true">
            <template #close_button>
                <button type="button"
                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm"
                    @click="routeUpdated()">
                    Fechar
                </button>
            </template>
        </EditRoute>

    </div>
</template>

<style scoped></style>
