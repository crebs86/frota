<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, useForm } from '@inertiajs/vue3';
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
    requests: Object,
    errors: Object
});

const filter = ref({
    routes: false,
    requests: false
});

const filterRequests = useForm({
    driver: route().params?.driver ?? '',
    branch: route().params?.branch ?? '',
    type: route().params?.type ?? '',
    date: route().params?.date ?? ''
})

function filtering() {
    filterRequests.post(route('frota.requests.index.filter'))
}

const routes = ref(props.requests);

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

const requestForm = ref({
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
    requestForm.value.errors = []
    let val = validate(requestForm.value)

    if (val._run &&
        validateDate(requestForm.value.date)
    ) {
        axios.post(route('frota.requests.store'), {
            driver: requestForm.value.driver?.id,
            date: requestForm.value.date,
            time: requestForm.value.time,
            duration: requestForm.value.duration,
            branch: requestForm.value.branch?.id,
            local: requestForm.value.local,
            _checker: routes.value[0]?._checker ?? null,
            passengers: requestForm.value.passengers
        })
            .then((r) => {
                toast.success(r.data.message, { duration: 5000 })
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

function resetForm() {
    requestForm.value.time = ''
    requestForm.value.branch = ''
    requestForm.value.duration = ''
    requestForm.value.passengers = []
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

    <Head title="Gerenciar Solicitações" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Gerenciar Solicitações
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                        <div class="relative w-full z-auto min-h-fit grid grid-cols-4 gap-3">

                            <div class="col-span-4 md:col-span-2 h-12">
                                <label class="text-sm">
                                    Motorista
                                </label>
                                <VueMultiselect v-model="filterRequests.driver" :options="props.drivers"
                                    :multiple="false" :close-on-select="true" selectedLabel="atual"
                                    placeholder="Motorista" :custom-label="driverName" track-by="id"
                                    selectLabel="Selecionar" @select="verifyDriverRoute" deselectLabel="Remover" />

                                <div v-if="filterRequests.errors?.driver"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filterRequests.errors?.driver">{{ error }}</small>
                                </div>
                            </div>
                            <div class="col-span-4 md:col-span-2 mt-6 md:mt-0">
                                <label class="text-sm">
                                    Unidade*
                                </label>
                                <VueMultiselect v-model="filterRequests.branch" :options="props.branches"
                                    :multiple="false" :close-on-select="true" selectedLabel="atual"
                                    placeholder="Unidade" :custom-label="branchName" track-by="id" label="time"
                                    selectLabel="Selecionar" deselectLabel="Remover" />
                                <div v-if="filterRequests.errors?.branch"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filterRequests.errors?.branch">{{ error }}</small>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mt-3">
                        <div class="w-full z-auto min-h-fit grid grid-cols-1 md:grid-cols-6 gap-3">

                            <div class="col-span-6 md:col-span-2">
                                <label class="text-sm">
                                    Tipo de Data*
                                </label>
                                <VueMultiselect v-model="filterRequests.type"
                                    :options="['Data Solicitada', 'Data Criação']" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Tipo de Data"
                                    selectLabel="Selecionar" deselectLabel="Remover" />

                                <div v-if="filterRequests.errors?.type"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filterRequests.errors?.type">{{ error }}</small>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 col-span-6 md:col-span-2 h-12 mt-1.5 md:mt-0">
                                <label class="text-sm">
                                    Data*
                                </label>
                                <input type="date" v-model="filterRequests.date" :disabled="!filterRequests.type"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-700"
                                    :class="!filterRequests.type ? 'bg-gray-400' : ''">

                                <div v-if="filterRequests.errors?.date"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filterRequests.errors?.date">{{ error }}</small>
                                </div>
                            </div>
                            <div class="grid grid-cols-1 col-span-6 md:col-span-2">
                                <button type="button" @click="filtering"
                                    class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline w-full max-w-[300px] mt-5">
                                    Filtrar
                                </button>
                            </div>

                        </div>
                    </div>
                    <!-- {{ filteredRoutes }} -->
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mx-2 mt-3">

                        <div class="rounded-lg overflow-y-auto"
                            :class="$page.props.app.settingsStyles.main.innerSection">

                            <button @click="verifyDriverRoute"
                                class="flex px-2 py-1.5 transition duration-500 ease select-none rounded-md border border-blue-500 dark:border-slate-300 bg-blue-300 hover:bg-blue-400 text-blue-500 hover:text-blue-200 dark:bg-slate-400 dark:hover:bg-slate-600 dark:text-slate-800 dark:hover:text-slate-200 float-right mb-1.5">
                                Recarregar Solicitações
                                <mdicon name="refresh" />
                            </button>

                            <table class="min-w-full" :class="$page.props.app.settingsStyles.main.body">
                                <thead>
                                    <tr>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Data
                                        </th>
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
                                            {{ moment(r.date).format('DD/MM/YYYY') }}
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            {{ r.time }}
                                        </td>
                                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center"
                                            :class="r.to === 1 || r.b === 1 ? 'underline underline-offset-8' : ''">
                                            {{ r.local ?? r.branch.name }}
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
                                            <button @click="setRouteToEdit(r)" v-if="moment(moment(requestForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                                moment(moment(requestForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))
                                                && (has($page.props.auth.permissions, ['Agenda Editar', 'Agenda Apagar']) || has($page.props.auth.roles, ['Super Admin']))
                                                && r.task">
                                                <mdicon name="pencil"
                                                    class="hover:text-green-500 dark:hover:text-blue-300" />
                                            </button>
                                            <button @click="setRequestToEdit(r)" v-else-if="moment(moment(requestForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                                moment(moment(requestForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))
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
