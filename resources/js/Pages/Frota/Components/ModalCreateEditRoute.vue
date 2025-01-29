<script setup>
import {branchName} from '@/helpers';
import {toast} from '@/toast';
import validate from '@/validates/indexSaveRoute';
import moment from 'moment';
import {ref, defineProps, onMounted} from 'vue';
import VueMultiselect from 'vue-multiselect';

const emit = defineEmits([
    'verifyDriverRoute'
])

const props = defineProps({
    data: Object,
    filter: Object | String,
    results: Object,
    loading: Boolean
})

const modal = ref({
    editRoute: false
})

const filter = ref({
    date: '',
    branch: '',
    driver: '',
    time: '',
    errors: [],
    local: '',
    _checker: '',
    passengers: [],
    duration: '',
    obs: ''
});

const routeForEdition = ref({
    id: '',
    branch: '',
    currentBranch: '',
    time: '',
    local: '',
    obs: '',
    passengers: [],
    duration: '',
    error: '',
    errors: []
});

const passengersModel = ref('')

function setPassenger(remove = false, passenger = null) {
    filter.value.errors.passengers = ''
    if (remove) {
        filter.value.passengers.splice(filter.value.passengers.indexOf(passenger), 1)
    } else if (passengersModel.value) {
        filter.value.passengers.push(passengersModel.value)
        passengersModel.value = ''
    } else {
        filter.value.errors.passengers = 'Vazio.'
    }
}

const passengersEditModel = ref('')

function setPassengerEdit(remove = false, passenger = null) {
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

function saveRoute() {
    props.loading = false
    filter.value.errors = '';
    let val = validate(filter.value, ['driver'])

    if (val._run) {
        axios.post(route('frota.tasks.route.store'), {
            driver: filter.value.driver,
            date: filter.value.date,
            time: filter.value.time,
            branch: filter.value.branch.id,
            obs: filter.value.obs,
            passengers: filter.value.passengers,
            duration: filter.value.duration,
            _checker: filter.value._checker,
            local: filter.value.local
        })
            .then((r) => {
                toast.success(r.data.message)
                emit('verifyDriverRoute')
                resetForm()
            })
            .catch((e) => {
                if (e.response?.status === 500) {
                    toast.error(e.response.data)
                    filter.value.errors = e.response.data
                } else if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    filter.value.errors = e.response.data.error
                } else {
                    toast.error('Ocorreu um erro ao processar solicitação.')
                    console.log(e)
                    if (e.response?.data?.errors) {
                        filter.value.errors = e.response?.data?.errors
                    }
                }
            })
            .finally(() => props.loading = false)
    } else {
        filter.value.errors = val
        console.log(val)
        toast.error('Preencha todos os campos.')
    }
}

function updateRoute() {
    props.loading = true
    routeForEdition.value.error = ''
    if (routeForEdition.value.branch && routeForEdition.value.time) {
        axios.put(route('frota.routes.route.update', routeForEdition.value.id), {
            id: routeForEdition.value.id,
            branch: routeForEdition.value.branch,
            time: routeForEdition.value.time,
            currentBranch: routeForEdition.value.currentBranch,
            local: routeForEdition.value.local,
            obs: routeForEdition.value.obs,
            passengers: routeForEdition.value.passengers,
            duration: routeForEdition.value.duration,
            _checker: props.filter._checker,
        })
            .then(() => {
                emit('verifyDriverRoute');
                modal.value.editRoute = false;
                routeForEdition.value = {};
                toast.success(r.data)
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    filter.value.errors = e.response.data.error
                }
                if (e.response?.status === 422) {
                    toast.error(e.response.data.error)
                    routeForEdition.value.error = e.response?.data?.errors
                }
                if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    filter.value.errors = e.response.data
                }
            })
            .finally(() => props.loading = false)
    } else {
        toast.error('Preencha todos os campos para atualizar a rota');
    }
}

function resetForm() {
    filter.value.time = '';
    filter.value.branch = '';
    filter.value.passengers = [];
    filter.value.obs = '';
    filter.value.duration = '';
}

function setRouteToEdit(route) {
    modal.value.editRoute = true
    routeForEdition.value.id = route.id
    routeForEdition.value.branch = route.branch
    routeForEdition.value.currentBranch = route.branch
    routeForEdition.value.time = route.time
    routeForEdition.value.duration = route.duration
    routeForEdition.value.passengers = Object.values(JSON.parse(route.passengers) ?? [])
    routeForEdition.value.obs = route.obs
    if (route.branch.id === 1) {
        routeForEdition.value.local = route.branch.name
    } else {
        routeForEdition.value.local = ''
    }
}

onMounted(() => {
    filter.value.date = props.filter.date
    filter.value.driver = props.results.driver
})

</script>
<template>
    <div class="fixed z-50 inset-0 flex items-center justify-center overflow-hidden mx-1">
        <div class="fixed inset-0 transition-opacity">

            <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
        </div>
        <div v-if="props.data?.timetables && props.data?.branches"
             class="bg-white rounded-lg text-left overflow-hidden overflow-y-scroll shadow-xl transform transition-all w-11/12 md:max-w-[1024px] max-h-[90%] dark:bg-gray-600">
            <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                    Rota de:
                    <span class="font-bold underline">
                        {{ props.filter?.driver?.user?.name ?? '' }}
                    </span>
                </h3>
                <div class="mt-2 overflow-auto">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                        <div class="mb-6 w-full z-auto min-h-fit grid grid-cols-1 md:grid-cols-4 gap-1">

                            <div class="grid grid-cols-1 col-span-4 md:col-span-1">
                                <label class="text-sm text-gray-500 dark:text-gray-300">
                                    Data*
                                </label>
                                <input type="date" v-model="filter.date" @change="verifyDriverRoute"
                                       class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                                <div v-if="filter.errors?.date"
                                     class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filter.errors?.date">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-4 md:col-span-1" v-if="props.data?.timetables !== ''">
                                <label class="text-sm text-gray-500 dark:text-gray-300">
                                    Hora*
                                </label>
                                <VueMultiselect v-model="filter.time" :options="props.data?.timetables"
                                                :multiple="false" :close-on-select="true" selectedLabel="atual"
                                                placeholder="Hora"
                                                selectLabel="Selecionar" deselectLabel="Remover"/>

                                <div v-if="filter.errors?.time"
                                     class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filter.errors?.time">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-4 md:col-span-2" v-if="props.data?.branches !== ''">
                                <label class="text-sm text-gray-500 dark:text-gray-300">
                                    Unidade*
                                </label>
                                <VueMultiselect v-model="filter.branch" :options="props.data?.branches"
                                                :multiple="false" :close-on-select="true" selectedLabel="atual"
                                                placeholder="Unidade" :custom-label="branchName" track-by="id"
                                                label="time"
                                                selectLabel="Selecionar" deselectLabel="Remover"/>

                                <div v-if="filter.errors?.branch"
                                     class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filter.errors?.branch">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-4 mt-2" v-if="filter.branch?.id === 1">
                                <label class="text-sm text-gray-500 dark:text-gray-300">
                                    Local*
                                </label>
                                <input type="text" v-model="filter.local"
                                       class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                                <div v-if="filter.errors?.local"
                                     class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filter.errors?.local">{{ error }}</small>
                                </div>
                            </div>
                            <div class="col-span-6 md:col-span-2 text-left -mt-1.5 md:mt-0">
                                <label class="text-sm text-gray-500 dark:text-gray-300">
                                    Duração (h)*
                                </label>
                                <input type="time" v-model="filter.duration"
                                       class="h-[41px] w-full text-gray-800 rounded"/>

                                <div v-if="filter.errors?.duration"
                                     class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filter.errors?.duration">{{ error }}</small>
                                </div>
                            </div>
                            <div class="col-span-4 md:col-span-2 grid grid-cols-1 -mt-1.5 md:mt-0">
                                <label class="text-sm text-gray-500 dark:text-gray-400 col-span-6">
                                    Obs.:
                                </label>
                                <textarea class="rounded text-gray-600" v-model="filter.obs"></textarea>
                                <div v-if="filter.errors?.obs"
                                     class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                    <small v-for="error in filter.errors?.obs">{{ error }}</small>
                                </div>
                            </div>
                            <div class="col-span-6 md:col-span-4 -mt-1 md:mt-0">
                                <div class="grid grid-cols-6">
                                    <label class="text-sm text-gray-500 dark:text-gray-400 col-span-6">
                                        Incluir Passageiro*
                                    </label>
                                    <div class="inline-flex col-span-6">
                                        <input type="text" v-model="passengersModel"
                                               class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                                        <button type="button" @click="setPassenger(false)"
                                                :disabled="passengersModel?.length < 4"
                                                class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                                :class="passengersModel?.length < 4 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                            Incluir
                                        </button>
                                    </div>
                                    <div v-if="filter.errors?.passengers"
                                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                        <small v-for="error in filter.errors?.passengers">{{ error }}</small>
                                    </div>
                                </div>
                            </div>

                            <div class="col-span-4 md:col-span-2">
                                <div v-for="(p, i) in filter.passengers" :key="'pe_' + i"
                                     class="inline-flex w-full">
                                    {{ p }}
                                    <button @click="setPassenger(true, p)">
                                        <mdicon name="close" class="text-red-400"/>
                                    </button>
                                </div>
                            </div>

                        </div>

                        <button type="button" @click="saveRoute"
                                class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                            Criar/Adicionar
                        </button>
                    </div>

                    <table class="min-w-full">
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
                        <tr v-if="props.loading">
                            <td colspan="4">
                                <div class="shadow rounded-md p-4 max-w-sm w-full mx-auto">
                                    <div class="animate-pulse flex space-x-4">
                                        <div class="rounded-full bg-slate-700 h-10 w-10"></div>
                                        <div class="flex-1 space-y-6 py-1">
                                            <div class="h-2 bg-slate-700 rounded"></div>
                                            <div class="space-y-3">
                                                <div class="grid grid-cols-3 gap-4">
                                                    <div class="h-2 bg-slate-700 rounded col-span-2">
                                                    </div>
                                                    <div class="h-2 bg-slate-700 rounded col-span-1">
                                                    </div>
                                                </div>
                                                <div class="h-2 bg-slate-700 rounded"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr v-for="(r, i) in props.results?.routes" :key="'route-' + i"
                            v-if="props.results?.routes?.length > 0">
                            <td
                                class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                {{ r.time }}
                            </td>
                            <td
                                class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                {{ r.branch.name }}
                            </td>
                            <td
                                class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                   :class="r.started_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                    {{
                                        r.started_at ? moment(r.started_at).format('DD/MM/YYYY HH:mm') :
                                            'pendente'
                                    }}
                                </p>
                            </td>
                            <td
                                class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                   :class="r.ended_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                    {{
                                        r.ended_at ? moment(r.ended_at).format('DD/MM/YYYY HH:mm') :
                                            'pendente'
                                    }}
                                </p>
                            </td>
                            <td
                                class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                <button @click="setRouteToEdit(r)" v-if="!r.started_at">
                                    <mdicon name="pencil" class="hover:text-green-500 dark:hover:text-gray-400"/>
                                </button>
                                <mdicon name="cancel" v-else
                                        class="hover:text-green-500 dark:hover:text-gray-400"/>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <slot name="close_button"/>
        </div>

        <div class="fixed inset-0 flex items-center justify-center overflow-hidden mx-1"
             :class="modal.editRoute ? 'block' : 'hidden'">
            <div class="fixed inset-0 transition-opacity">
                <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
            </div>
            <div v-if="routeForEdition"
                 class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600">
                <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                    <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                        Editando Rota de:
                        <span class="font-bold underline">
                            {{ props.filter?.driver?.user?.name ?? '' }}
                        </span> em {{ moment(filter.date).format('DD/MM/YYYY') }}
                    </h3>
                    <div class="grid grid-cols-4 gap-1">
                        <div class="col-span-4 md:col-span-2">
                            <label class="text-sm text-gray-500 dark:text-gray-300">
                                Unidade
                            </label>
                            <VueMultiselect v-model="routeForEdition.branch" :options="$page.props.branches"
                                            :multiple="false" :close-on-select="true" placeholder="Unidade" label="name"
                                            track-by="id" selectLabel="Selecionar" deselectLabel="Remover"
                                            :custom-label="branchName" @select="$page.props.errors.date = null"/>
                            <div v-if="routeForEdition.error?.branch"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in routeForEdition.error?.branch">{{ error }}</small>
                            </div>
                        </div>

                        <div class="col-span-4 md:col-span-2" v-if="props.data?.timetables !== ''">
                            <label class="text-sm text-gray-500 dark:text-gray-300">
                                Hora
                            </label>
                            <VueMultiselect v-model="routeForEdition.time" :options="props.data?.timetables"
                                            :multiple="false" :close-on-select="true" selectedLabel="atual"
                                            placeholder="Hora"
                                            selectLabel="Selecionar" deselectLabel="Remover"/>
                            <div v-if="routeForEdition.error?.time"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in routeForEdition.error?.time">{{ error }}</small>
                            </div>
                        </div>

                        <div class="col-span-4" v-if="routeForEdition.branch?.id === 1">
                            <label class="text-sm text-gray-500 dark:text-gray-300">
                                Local*
                            </label>
                            <input type="text" v-model="routeForEdition.local"
                                   class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                            <div v-if="routeForEdition.error?.local"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in routeForEdition.error?.local">{{ error }}</small>
                            </div>
                        </div>

                        <div class="col-span-4 md:col-span-2">
                            <label class="text-sm text-gray-500 dark:text-gray-300">
                                Duração (h)*
                            </label>
                            <input type="time" v-model="routeForEdition.duration"
                                   class="h-[41px] w-full text-gray-800 rounded"/>

                            <div v-if="routeForEdition.errors?.duration"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in routeForEdition.errors?.duration">{{ error }}</small>
                            </div>
                        </div>
                        <div class="col-span-4 md:col-span-2 grid grid-cols-1 md:mt-1">
                            <label class="text-sm text-gray-500 dark:text-gray-300">
                                Obs.:
                            </label>
                            <textarea class="rounded text-gray-600" v-model="routeForEdition.obs"></textarea>
                            <div v-if="routeForEdition.errors?.obs"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                <small v-for="error in routeForEdition.errors?.obs">{{ error }}</small>
                            </div>
                        </div>
                        <div class="col-span-4 md:col-span-3 grid grid-cols-1">
                            <label class="text-sm text-gray-500 dark:text-gray-300">
                                Incluir Passageiro*
                            </label>
                            <div class="inline-flex">
                                <input type="text" v-model="passengersEditModel"
                                       class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                                <button type="button" @click="setPassengerEdit(false)"
                                        :disabled="passengersEditModel?.length < 3"
                                        class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                        :class="passengersEditModel?.length < 3 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                    Incluir
                                </button>
                            </div>
                            <div v-if="routeForEdition.errors?.passengers"
                                 class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                <small v-for="error in routeForEdition.errors?.passengers">{{ error }}</small>
                            </div>
                        </div>
                        <div class="col-span-4 md:col-span-2">
                            <div v-for="(p, i) in Object.values(routeForEdition.passengers ?? [])" :key="'pe_' + i"
                                 class="inline-flex w-full">
                                {{ p }}
                                <button @click="setPassengerEdit(true, p)">
                                    <mdicon name="close" class="text-red-400"/>
                                </button>
                            </div>
                        </div>
                        <div class="h-[6rem] col-span-2"></div>
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
                        Cancelar
                    </button>
                </div>
            </div>
        </div>

    </div>
</template>
