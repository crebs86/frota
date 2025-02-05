<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head } from '@inertiajs/vue3';
import { toast } from '@/toast';
import axios from 'axios';
import { defineAsyncComponent, ref } from 'vue';
import moment from 'moment';
import validate from '@/validates/indexSaveRoute';
import has from '@/arrayHelpers'
import { validateDate } from "@/validates/validates.js";
import { branchName, driverName } from "@/helpers.js";
import { phoneMask } from '@/mask';

const ModalEditRoute = defineAsyncComponent(() => import('@/Pages/Frota/Components/ModalEditRoute.vue'))

const props = defineProps({
    drivers: Object,
    branches: Object,
    errors: Object
});

const routes = ref({});

const routeForm = ref({
    driver: '',
    date: '',
    time: '',
    branch: '',
    errors: [],
    local: '',
    duration: '',
    obs: '',
    passengers: [],
    _checker: '',
    ignore: false,
    ignoreQuestion: false,
});

const modal = ref({
    editRoute: false
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
    errors: []
});

const passengersModel = ref({
    passenger: '',
    contact: ''
})

const maskPhone = (event) => {
    let input = event.target
    input.value = phoneMask(input.value)
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
        passengersModel.value = {
            passenger: '',
            contact: ''
        }
    } else {
        routeForm.value.errors.passengers = 'Vazio.'
    }
}

function saveRoute() {
    routeForm.value.errors = []
    routeForm.value.ignoreQuestion = false
    let val = validate(routeForm.value)

    if (val._run &&
        validateDate(routeForm.value.date)
    ) {
        axios.post(route('frota.tasks.route.store'), {
            driver: routeForm.value.driver?.id,
            date: routeForm.value.date,
            time: routeForm.value.time,
            duration: routeForm.value.duration,
            branch: routeForm.value.branch?.id,
            local: routeForm.value.local,
            obs: routeForm.value.obs,
            _checker: routeForm.value._checker,
            passengers: routeForm.value.passengers,
            ignore: routeForm.value.ignore,
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
                } else if (e.response?.status === 409) {
                    routeForm.value.ignoreQuestion = true
                    toast.error('Agenda em conflito.')
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
    routeForm.value.obs = ''
    routeForm.value.passengers = []
}

function verifyDriverRoute() {
    routeForm.value.errors = []
    routes.value = {};
    if (routeForm.value.date && routeForm.value.driver) {
        axios.post(route('frota.tasks.filter-routes'), {
            driver: routeForm.value.driver.id,
            date: routeForm.value.date
        })
            .then((r) => {
                if (r.data[0]?.routes) {
                    routes.value = r.data[0]
                } else {
                    toast.info('Sem tarefas para a data selecionada.')
                }
                routeForm.value._checker = r.data[1]
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

function setRouteToEdit(route) {
    routeForEdition.value._checker = routeForm.value._checker
    modal.value.editRoute = true
    routeForEdition.value.id = route.id
    routeForEdition.value.errors = []
    routeForEdition.value.currentBranch = route.branch
    routeForEdition.value.branch = route.branch
    routeForEdition.value.date = route.date
    routeForEdition.value.time = route.time
    routeForEdition.value.duration = route.duration
    routeForEdition.value.obs = route.obs
    routeForEdition.value.passengers = Object.values(JSON.parse(route.passengers) ?? [])
    if (route.branch.id === 1) {
        routeForEdition.value.local = route.branch.name
    } else {
        routeForEdition.value.local = ''
    }
}
</script>

<template>

    <Head title="Criar Rota" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                {{
                    (has($page.props.auth.permissions, ['Agenda Criar', 'Agenda Editar', 'Agenda Apagar']) ||
                        has($page.props.auth.roles, ['Super Admin'])) ? 'Adicionar Rota' : 'Pesquisar Rotas'
                }}
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                        <div class="relative w-full z-auto min-h-fit grid grid-cols-6 gap-3">

                            <div class="grid grid-cols-1 col-span-6 md:col-span-2 h-12 mt-1 md:mt-0">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Data*
                                </label>
                                <input type="date" v-model="routeForm.date" @change="verifyDriverRoute"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                                <div v-if="routeForm.errors?.date"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.date">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 md:col-span-2 mt-2 md:mt-0">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Hora da Chegada no Destino*
                                </label>
                                <VueMultiselect v-model="routeForm.time" :options="$page.props.timetables"
                                    :multiple="false" :disabled="!validateDate(routeForm?.date)" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Hora" selectLabel="Selecionar"
                                    deselectLabel="Remover" />

                                <div v-if="routeForm.errors?.time"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit flex">
                                    <small v-for="error in routeForm.errors?.time">{{ error }}</small>
                                </div>
                                <div v-if="routeForm.ignoreQuestion">
                                    <label for="_ignore" class="p-1.5 text-amber-500 font-bold">Ignorar conflito e
                                        agendar</label>
                                    <input type="checkbox" id="_ignore" v-model="routeForm.ignore"
                                        class="text-red-400" />
                                </div>
                            </div>

                            <div class="col-span-6 md:col-span-2 text-left -mt-1.5 md:mt-0">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Tempo de Permanência*
                                </label>
                                <input type="time" v-model="routeForm.duration"
                                    class="h-[41px] w-full text-gray-800 rounded"
                                    :class="!validateDate(routeForm?.date) ? 'bg-[#afb3b9]' : ''"
                                    :disabled="!validateDate(routeForm?.date)" />

                                <div v-if="routeForm.errors?.duration"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.duration">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 md:col-span-3 h-12">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Selecione um motorista*
                                </label>
                                <VueMultiselect v-model="routeForm.driver" :options="props.drivers" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Motorista"
                                    :custom-label="driverName" track-by="id" selectLabel="Selecionar"
                                    @select="verifyDriverRoute" deselectLabel="Remover"
                                    :disabled="!validateDate(routeForm?.date)" />

                                <div v-if="routeForm.errors?.driver" class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border
                                border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.driver">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 md:col-span-3 mt-3 md:mt-0">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Destino*
                                </label>
                                <VueMultiselect v-model="routeForm.branch" :options="props.branches" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Destino"
                                    :custom-label="branchName" track-by="id" label="time" selectLabel="Selecionar"
                                    :disabled="!validateDate(routeForm?.date)" deselectLabel="Remover" />
                                <div v-if="routeForm.errors?.branch"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.branch">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6" v-if="routeForm.branch?.id === 1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Local*
                                </label>
                                <input type="text" v-model="routeForm.local"
                                    class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700" />

                                <div v-if="routeForm.errors?.local"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.errors?.local">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 grid grid-cols-1">
                                <label class="text-sm text-gray-500 dark:text-gray-400 col-span-6">
                                    Obs.:
                                </label>
                                <textarea class="rounded text-gray-600" v-model="routeForm.obs"
                                    :class="!validateDate(routeForm?.date) ? 'bg-[#afb3b9]' : ''"
                                    :disabled="!validateDate(routeForm?.date)"></textarea>
                                <div v-if="routeForm.errors?.obs"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                    <small v-for="error in routeForm.errors?.obs">{{ error }}</small>
                                </div>
                            </div>

                            <div class="col-span-6 grid grid-cols-8">
                                <div class="col-span-6 grid grid-cols-4 gap-2">
                                    <div class="col-span-5 md:col-span-2">
                                        <label class="text-sm text-gray-500 dark:text-gray-400">
                                            Passageiro*
                                        </label>
                                        <input type="text" v-model="passengersModel.passenger"
                                            class="w-full rounded border border-black h-[41px] text-gray-700"
                                            :class="!validateDate(routeForm?.date) ? 'bg-[#afb3b9]' : ''"
                                            :disabled="!validateDate(routeForm?.date)" />
                                    </div>
                                    <div class="col-span-5 md:col-span-2">
                                        <label class="text-sm text-gray-500 dark:text-gray-400">
                                            Contato*
                                        </label>
                                        <input type="text" v-model="passengersModel.contact"
                                            class="w-full rounded border border-black h-[41px] text-gray-700"
                                            :class="!validateDate(routeForm?.date) ? 'bg-[#afb3b9]' : ''"
                                            maxlength="11" @keyup="maskPhone($event)"
                                            :disabled="!validateDate(routeForm?.date)" />
                                    </div>
                                </div>
                                <button type="button" @click="setPassenger(false)"
                                    :disabled="passengersModel.passenger.length < 3 || passengersModel.contact.length < 8"
                                    class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline col-span-2 w-full self-center h-28 md:max-h-[41px] md:self-end mt-6 md:-mb-[1px]"
                                    :class="passengersModel.passenger.length < 3 || passengersModel.contact.length < 8 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                    Incluir
                                </button>

                                <div v-if="routeForm.errors?.passengers"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                                    <small v-for="error in routeForm.errors?.passengers">{{ error }}</small>
                                </div>

                                <div class="col-span-4 mb-4" v-if="validateDate(routeForm?.date)">
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
                        <button type="button" @click="saveRoute" v-if="validateDate(routeForm?.date)"
                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline w-full max-w-[300px]">
                            Criar/Adicionar
                        </button>
                    </div>

                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mx-2"
                        v-if="routeForm?.driver?.id === routes?.driver && routes?.driver">
                        <p><span class="font-bold">Motorista:</span>
                            {{ routeForm.driver.id === routes.driver ? routeForm.driver.user.name : '' }}
                        </p>
                        <p><span class="font-bold">Data:</span>
                            {{ moment(routes.date).format('DD/MM/YYYY') }}
                        </p>
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
                                            {{ r.branch.name }}
                                            <mdicon name="circle" class="float-right text-red-500"
                                                v-if="r.branch.id === 1" />
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
                                            <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                                :class="r.started_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                                {{
                                                    r.started_at ? moment(r.started_at).format('DD/MM/YYYY HH:mm') :
                                                        '-'
                                                }}
                                            </p>
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <p class="mx-auto text-sm px-2 rounded-md border  w-min"
                                                :class="r.ended_at ? 'border-teal-700 bg-green-500 text-teal-700' : 'border-amber-700 bg-yellow-500 text-amber-700'">
                                                {{
                                                    r.ended_at ? moment(r.ended_at).format('DD/MM/YYYY HH:mm') :
                                                        '-'
                                                }}
                                            </p>
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            <button @click="setRouteToEdit(r)"
                                                v-if="(has($page.props.auth.permissions, ['Agenda Editar', 'Agenda Apagar']) || has($page.props.auth.roles, ['Super Admin'])) && (moment(moment(routeForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                                    moment(moment(routeForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD')))">
                                                <mdicon name="pencil"
                                                    class="hover:text-green-500 dark:hover:text-gray-400" />
                                            </button>
                                            <span v-else>-</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <ModalEditRoute v-if="modal.editRoute" :routeForEdition="routeForEdition" :isRequest="false"
                        :props="props" :driver="routeForm.driver" :drivers="props.drivers"
                        :_checker="routeForm._checker" @routeUpdated="routeUpdated">
                        <template #close_button>
                            <button type="button"
                                class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm"
                                @click="routeUpdated()">
                                Fechar
                            </button>
                        </template>
                    </ModalEditRoute>
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
<style src="vue-multiselect/dist/vue-multiselect.css"></style>
