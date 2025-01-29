<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, useForm } from '@inertiajs/vue3';
import { toast } from '@/toast.ts';
import axios from 'axios';
import { computed, defineAsyncComponent, onMounted, onUpdated, ref } from 'vue';
import moment from 'moment';
import validate from '@/validates/indexSaveRoute.js';
import validateUpRt from '@/validates/createUpdateRoute.js';
import { getStyles, styles } from '@/contrasts';
import has from '@/arrayHelpers';

const ModalEvalueRequest = defineAsyncComponent(() => import('@/Pages/Frota/Components/ModalEvalueRequest.vue'))

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
    filterRequests.post(route('frota.requests.index'))
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
    evalueRequest: false
});

const requestForEvalue = ref({
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

function setRouteToEdit(request) {
    console.log(request)
    requestForEvalue.value._checker = request._checker
    requestForEvalue.value.branch = request.branch
    requestForEvalue.value.date = request.date
    requestForEvalue.value.driver = request.driver
    requestForEvalue.value.duration = request.duration
    requestForEvalue.value.id = request.id
    requestForEvalue.value.local = request.local
    requestForEvalue.value.obs = request.obs
    requestForEvalue.value.passengers = Object.values(JSON.parse(request.passengers) ?? [])
    requestForEvalue.value.status = request.status
    requestForEvalue.value.errors = []
    requestForEvalue.value.time = request.time
    requestForEvalue.value.to = request.to

    modal.value.evalueRequest = true
}

function resetForm() {
    requestForm.value.time = ''
    requestForm.value.branch = ''
    requestForm.value.duration = ''
    requestForm.value.passengers = []
}


//todo escoder botão se não validado os requisitos
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

onUpdated(() => {
    console.log('atualizado...')
    routes.value = props.requests
})

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
                                    Destino*
                                </label>
                                <VueMultiselect v-model="filterRequests.branch" :options="props.branches"
                                    :multiple="false" :close-on-select="true" selectedLabel="atual"
                                    placeholder="Destino" :custom-label="branchName" track-by="id" label="time"
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
                                    class="rounded border border-black h-[42px] mt-[3.2px] text-gray-700"
                                    :class="!filterRequests.type ? 'bg-gray-400' : ''">

                                <div v-if="filterRequests.errors?.date"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in filterRequests.errors?.date">{{ error }}</small>
                                </div>
                            </div>
                            <div class="grid grid-cols-1 col-span-6 md:col-span-2">
                                <button type="button" @click="filtering"
                                    class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline w-full max-w-[300px] mt-6">
                                    Filtrar
                                </button>
                            </div>

                        </div>
                    </div>
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mt-3">

                        <div class="rounded-lg overflow-y-auto"
                            :class="$page.props.app.settingsStyles.main.innerSection">

                            <table class="min-w-full mt-3" :class="$page.props.app.settingsStyles.main.body">
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
                                            Destino
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Motorista
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Ocupantes
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
                                            {{ r.driver.user.name }}
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
                                            <button @click="setRouteToEdit(r)"
                                                v-if="(has($page.props.auth.permissions, ['Liberador']) || has($page.props.auth.roles, ['Super Admin']))">
                                                <mdicon name="arrow-up-down" title="Avaliar"
                                                    class="hover:text-green-500 dark:hover:text-blue-300" />
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--Modal avaliar solicitação-->
                    <ModalEvalueRequest v-if="modal.evalueRequest" :request="requestForEvalue"></ModalEvalueRequest>

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
