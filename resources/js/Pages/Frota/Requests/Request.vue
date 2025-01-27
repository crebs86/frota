<script setup>
import {getStyles, styles} from "@/contrasts.js";
import moment from 'moment';
import has from "@/arrayHelpers.js";
import VueMultiselect from "vue-multiselect";
import {computed, onBeforeMount, ref} from "vue";
import {validateDate} from "@/validates/validates.js";
import axios from "axios";
import {toast} from "@/toast";
import validate from "@/validates/indexSaveRoute.js";

const p = defineProps({
    props: Object
})

const props = ref({});

const routes = ref([]);

const requestForm = ref({
    driver: '',
    date: '',
    time: '',
    branch: '',
    errors: [],
    local: '',
    duration: '',
    passengers: [],
    type: 1,
    _checker: ''
});

const filter = ref({
    routes: false,
    requests: false,
})

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


function driverName({id, user}) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}

function branchName({id, name}) {
    if (id === 1) {
        return `${id ? id : ''} - Não Cadastrado`
    } else {
        return `${id ? id : ''} - ${name ? name : ''}`
    }
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

const passengersModel = ref('')

function setPassenger(remove = false, passenger = null) {
    requestForm.value.errors.passengers = ''
    if (remove) {
        requestForm.value.passengers.splice(requestForm.value.passengers.indexOf(passenger), 1)
    } else if (passengersModel.value) {
        requestForm.value.passengers.push(passengersModel.value)
        passengersModel.value = ''
    } else {
        requestForm.value.errors.passengers = 'Vazio.'
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
}

function saveRequest() {
    requestForm.value.errors = []
    let val = validate(requestForm.value)

    if (val._run &&
        validateDate(requestForm.value.date)
    ) {
        axios.post(route('frota.tasks.route.store'), {
            driver: requestForm.value.driver?.id,
            date: requestForm.value.date,
            time: requestForm.value.time,
            duration: requestForm.value.duration,
            branch: requestForm.value.branch?.id,
            local: requestForm.value.local,
            type: requestForm.value.type,
            _checker: requestForm.value._checker,
            passengers: requestForm.value.passengers
        })
            .then((r) => {
                toast.success(r.data.message, {duration: 5000})
                verifyDriverRoute()
                resetForm()
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

onBeforeMount(() => {
    props.value = p.props
})
</script>

<template>
    <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
        <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded"
             v-if="requestForm.date">
            <div class="relative w-full z-auto min-h-fit grid grid-cols-4 gap-3">
                <div class="col-span-4 md:col-span-2 h-12">
                    <label class="text-sm">
                        Selecione um motorista
                    </label>
                    <VueMultiselect v-model="requestForm.driver" :options="props.drivers" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Motorista"
                                    :custom-label="driverName" track-by="id" selectLabel="Selecionar"
                                    @select="verifyDriverRoute" deselectLabel="Remover"/>

                    <div v-if="requestForm.errors?.driver"
                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.driver">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-4 md:col-span-2" v-if="validateDate(requestForm.date)">
                    <label class="text-sm">
                        Unidade*
                    </label>
                    <VueMultiselect v-model="requestForm.branch" :options="props.branches" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Unidade"
                                    :custom-label="branchName" track-by="id" label="time"
                                    selectLabel="Selecionar"
                                    deselectLabel="Remover"/>
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
                           class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700"/>

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
                        Hora*
                    </label>
                    <VueMultiselect v-model="requestForm.time" :options="props.timetables" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Hora"
                                    selectLabel="Selecionar" deselectLabel="Remover"/>

                    <div v-if="requestForm.errors?.time"
                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.time">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-6 md:col-span-2 text-left" v-if="validateDate(requestForm.date)">
                    <label class="text-sm">
                        Duração (h)*
                    </label>
                    <input type="time" v-model="requestForm.duration"
                           class="h-[41px] w-full text-gray-800 rounded"/>

                    <div v-if="requestForm.errors?.duration"
                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in requestForm.errors?.duration">{{ error }}</small>
                    </div>
                </div>
                <div class="col-span-6 md:col-span-4" v-if="validateDate(requestForm.date)">
                    <div class="grid grid-cols-6">
                        <label class="text-sm col-span-6">
                            Incluir Passageiro*
                        </label>
                        <div class="inline-flex col-span-6 gap-1">
                            <input type="text" v-model="passengersModel"
                                   class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                            <button type="button" @click="setPassenger(false)"
                                    v-if="validateDate(requestForm.date)"
                                    :disabled="passengersModel?.length < 4"
                                    class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                    :class="passengersModel?.length < 4 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                Incluir
                            </button>
                        </div>
                        <div v-if="requestForm.errors?.passengers"
                             class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                            <small v-for="error in requestForm.errors?.passengers">{{ error }}</small>
                        </div>
                    </div>
                </div>
                <div class="col-span-4 mb-4 -mt-2" v-if="validateDate(requestForm.date)">
                                <span v-for="(p, i) in requestForm.passengers" :key="'p_' + i"
                                      class=" inline-flex mx-4">
                                    {{ p }}
                                    <button @click="setPassenger(true, p)">
                                        <mdicon name="close" class="text-red-400"/>
                                    </button>
                                </span>
                </div>
            </div>

            <button type="button" @click="saveRequest" v-if="validateDate(requestForm.date)"
                    class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline w-full max-w-[300px]">
                Enviar Solicitação
            </button>
        </div>
        <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mx-2 mt-3"
             v-if="requestForm?.driver?.id === routes?.driver">
            <p><span class="font-bold">Motorista:</span>
                {{ requestForm?.driver?.id === routes[0]?.driver ? requestForm?.driver?.user?.name : '' }}
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
                            <mdicon name="refresh"/>
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
                    <tbody class="border border-black">
                    <tr v-for="(r, i) in filteredRoutes" :key="'route-' + i"
                        :class="getRouteStatus(r.type, r.status) !== 'Confirmado' ? styles($page.props.app.settingsStyles.main.body) : ''">
                        <td
                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                            {{ r.time }}
                        </td>
                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center"
                            :class="r.to === 1 || r.b === 1 ? 'underline underline-offset-8' : ''">
                            {{ r.branch.name }}
                            <mdicon name="circle" class="float-right text-red-500"
                                    v-if="r.to === 1 || r.b === 1"/>
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
                               :class="getStyles(r.type, r.status)">
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
                                                && r.task">
                                <mdicon name="pencil"
                                        class="hover:text-green-500 dark:hover:text-blue-300"/>
                            </button>
                            <button @click="setRequestToEdit(r)" v-else-if="moment(moment(requestForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                                moment(moment(requestForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))
                                                && (has($page.props.auth.permissions, ['Solicitacao Editar', 'Solicitacao Apagar']) || has($page.props.auth.roles, ['Super Admin']))
                                                && r.user?.id === $page.props.auth.user.id">
                                <mdicon name="hand-wash"
                                        class="hover:text-green-500 dark:hover:text-blue-300"/>
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
                                        placeholder="Hora" selectLabel="Selecionar"
                                        deselectLabel="Remover"/>

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
                                        :multiple="false" :close-on-select="true" placeholder="Unidade"
                                        label="name"
                                        track-by="id" selectLabel="Selecionar" deselectLabel="Remover"
                                        @select="$page.props.errors.date = null"
                                        :custom-label="branchName"/>

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
                                       class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
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
                                            <mdicon name="close" class="text-red-400"/>
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
                                            selectLabel="Selecionar" deselectLabel="Remover"/>

                            <div v-if="requestForm.errors?.driver"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in requestForm.errors?.driver">{{ error }}</small>
                            </div>
                        </div>
                        <div class="col-span-4 md:col-span-2 mt-4 md:mt-0">
                            <label class="text-sm">
                                Unidade*
                            </label>
                            <VueMultiselect v-model="routeRequestEdition.branch"
                                            :options="$page.props.branches" :multiple="false"
                                            :close-on-select="true"
                                            placeholder="Unidade" label="name" track-by="id"
                                            selectLabel="Selecionar"
                                            deselectLabel="Remover" @select="$page.props.errors.date = null"
                                            :custom-label="branchName"/>

                            <div v-if="routeRequestEdition.errors?.branch"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in routeRequestEdition.errors?.branch">{{
                                        error
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
                                <small v-for="error in routeRequestEdition.errors?.local">{{
                                        error
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
                                            :options="$page.props.timetables" :multiple="false"
                                            :close-on-select="true"
                                            selectedLabel="atual" placeholder="Hora"
                                            selectLabel="Selecionar"
                                            deselectLabel="Remover"/>

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
                                <small v-for="error in routeRequestEdition.errors?.duration">{{
                                        error
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
                                           class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
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
                                                <mdicon name="close" class="text-red-400"/>
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

<style scoped>

</style>
