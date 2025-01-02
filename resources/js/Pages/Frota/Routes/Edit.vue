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

const props = defineProps({
    branches: Object,
    timetables: Object,
    errors: Object,
    driverRoutes: Object,
    _checker: String
});

const routes = ref({});

const routeForm = ref({
    time: '',
    branch: '',
    local: '',
    error: ''
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
    error: ''
});

function branchName({ id, name }) {
    if (id === 1) {
        return `${id ? id : ''} - Não Cadastrado`
    } else {
        return `${id ? id : ''} - ${name ? name : ''}`
    }
}

function saveRoute() {
    routeForm.value.error = ''
    if (!routeForm.value.time || !routeForm.value.branch.id
        || (routeForm.value.branch.id === 1 && !routeForm.value.local)
    ) {
        routeForm.value.error = 'Preencha todos os campos.'
    } else {
        axios.post(route('frota.tasks.route.store'), {
            driver: props.driverRoutes.driver.id,
            date: props.driverRoutes.date,
            time: routeForm.value.time,
            local: routeForm.value.local,
            branch: routeForm.value.branch.id,
            _checker: props._checker
        })
            .then((r) => {
                toast.success(r.data.message)
                verifyDriverRoute()
                resetForm()
            })
            .catch((e) => {
                if (e.response?.status === 500) {
                    toast.error(e.response.data)
                    routeForm.value.error = e.response.data
                }
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeForm.value.error = e.response.data.error
                }
                if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    routeForm.value.error = e.response.data.errors
                }
            })
    }
}

function updateRoute() {
    if (routeForEdition.value.branch && routeForEdition.value.time) {
        axios.put(route('frota.routes.route.update', routeForEdition.value.id), {
            id: routeForEdition.value.id,
            branch: routeForEdition.value.branch,
            currentBranch: routeForEdition.value.currentBranch,
            local: routeForEdition.value.local,
            time: routeForEdition.value.time
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
                    filter.value.error = e.response.data.error
                }
                if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    filter.value.error = e.response.data
                }
                if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    routeForEdition.value.error = e.response.data.errors
                }
            })
    } else {
        toast.error('Preencha todos os campos para atualizar a rota');
    }
}

function resetForm() {
    routeForm.value.time = ''
    routeForm.value.branch = ''
}

function verifyDriverRoute() {
    routeForm.value.error = ''
    routes.value = {};
    if (props.driverRoutes.date && props.driverRoutes.driver.id) {
        axios.post(route('frota.tasks.filter-routes'), {
            driver: props.driverRoutes.driver.id,
            date: props.driverRoutes.date
        })
            .then((r) => {
                if (r.data.length >= 1) {
                    console.log(r.data[0])
                    routes.value = r.data[0]
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
    modal.value.editRoute = true
    routeForEdition.value.id = route.id
    routeForEdition.value.branch = route.branch
    routeForEdition.value.currentBranch = route.branch
    routeForEdition.value.time = route.time
    if (route.branch.id === 1) {
        routeForEdition.value.local = route.branch.name
    }
}

onMounted(() => {
    routes.value = props.driverRoutes
    console.log(props.driverRoutes)
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
                    <div v-if="routeForm.error"
                        class="p-2 mx-2 text-red-700 bg-red-400 rounded-md border border-red-700">
                        {{ typeof routeForm.error === 'string'
                            ? routeForm.error
                            : 'Ocorreram erros ao processar requisição.' }}
                    </div>
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">

                        <div class="w-full z-auto grid grid-cols-1 md:grid-cols-2">

                            <div class="mx-2 mb-3 pr-3 w-full z-auto col-span-2 md:col-span-1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Motorista
                                </label>
                                <input type="text"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-200 w-full bg-gray-400"
                                    :value="props.driverRoutes?.driver?.user?.name" readonly />
                            </div>

                            <div class="mx-2 mb-3 w-full z-auto pr-3 pl-0.5">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Data
                                </label>
                                <input type="date" :value="props.driverRoutes?.date"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-200 w-full bg-gray-400"
                                    readonly>
                            </div>

                            <div class="mx-2 mb-3 col-span-2 md:col-span-1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Hora*
                                </label>
                                <VueMultiselect v-model="routeForm.time" :options="props.timetables" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Hora"
                                    selectLabel="Selecionar" deselectLabel="Remover" />

                                <div v-if="routeForm.error?.time"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.error?.time">{{ error }}</small>
                                </div>
                            </div>

                            <div class="mx-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Unidade*
                                </label>
                                <VueMultiselect v-model="routeForm.branch" :options="props.branches" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Unidade"
                                    :custom-label="branchName" track-by="id" label="time" selectLabel="Selecionar"
                                    deselectLabel="Remover" />

                                <div v-if="routeForm.error?.branch"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.error?.branch">{{ error }}</small>
                                </div>
                            </div>

                            <div class="mx-2 col-span-2 mt-2" v-if="routeForm.branch?.id === 1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Local*
                                </label>
                                <input type="text" v-model="routeForm.local"
                                    class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                                <div v-if="routeForm.error?.local"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.error?.local">{{ error }}</small>
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
                                            Hora
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Unidade</th>
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
                                            <mdicon name="circle" class="float-right text-red-500" v-if="r.branch.id === 1" />
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
                                            <button @click="setRouteToEdit(r)">
                                                <mdicon name="pencil"
                                                    class="hover:text-green-500 dark:hover:text-gray-400" />
                                            </button>
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
                            class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600">
                            <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                                <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                                    Editando Rota de:
                                    <span class="font-bold underline">
                                        {{ props.driverRoutes?.driver?.user?.name }}
                                    </span> em {{ moment(props.driverRoutes?.date).format('DD/MM/YYYY') }}
                                </h3>
                                <div class="mt-2 overflow-x-auto grid grid-cols-1 md:grid-cols-2">
                                    <div class="mx-2 col-span-2 md:col-span-1">
                                        <div>Unidade</div>
                                        <VueMultiselect v-model="routeForEdition.branch" :options="props.branches"
                                            :multiple="false" :close-on-select="true" placeholder="Unidade" label="name"
                                            :custom-label="branchName" track-by="id" selectLabel="Selecionar"
                                            deselectLabel="Remover" @select="$page.props.errors.date = null" />

                                        <div v-if="routeForEdition.error?.to"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.error?.to">{{ error }}</small>
                                        </div>
                                    </div>

                                    <div class="mx-2 col-span-2 md:col-span-1">
                                        <label class="text-sm text-gray-500 dark:text-gray-400">
                                            Hora
                                        </label>
                                        <VueMultiselect v-model="routeForEdition.time" :options="$page.props.timetables"
                                            :multiple="false" :close-on-select="true" selectedLabel="atual"
                                            placeholder="Hora" selectLabel="Selecionar" deselectLabel="Remover" />

                                        <div v-if="routeForEdition.error?.time"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.error?.time">{{ error }}</small>
                                        </div>
                                    </div>

                                    <div class="mx-2 col-span-2 mt-2" v-if="routeForEdition.branch?.id === 1">
                                        <label class="text-sm text-gray-500 dark:text-gray-400">
                                            Local*
                                        </label>
                                        <input type="text" v-model="routeForEdition.local"
                                            class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                                        <div v-if="routeForEdition.error?.local"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in routeForEdition.error?.local">{{ error }}</small>
                                        </div>
                                    </div>
                                    <div class="h-[15rem]"></div>
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
<style src="vue-multiselect/dist/vue-multiselect.css"></style>
