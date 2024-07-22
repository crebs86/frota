<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, Link, usePage } from '@inertiajs/vue3';
import hasPermission from '@/permissions';
import { toast } from '@/toast'
import { ref } from 'vue';
import moment from 'moment';
import axios from 'axios';

const filter = ref({
    date: '',
    branch: '',
    driver: '',
    time: '',
    error: ''
});

const routeForEdition = ref({
    id: '',
    branch: '',
    time: ''
});

const results = ref({});

const loading = ref(false);

const page = usePage();

const modal = ref({
    byDriver: false,
    byBranch: false,
    editRoute: false
})

function drivers(id) {
    return id.user.name;
}

function filtering() {
    results.value = {};
    if (!filter.value.date || (!filter.value.branch && !filter.value.driver)) {
        page.props.errors.date = 'Informe uma data e, uma unidade ou motorista para prosseguir.'
    } else {
        axios.post(route('frota.tasks.filter'), {
            date: filter.value.date,
            branch: filter.value.branch.id,
            driver: filter.value.driver.id
        })
            .then((r) => {
                if (r.data.data.length === 1) {
                    results.value = r.data.data[0];
                } else if (r.data.data.length > 1) {
                    results.value = r.data.data;
                }
            })
            .catch((e) => {
                toast.error(e.response.data.error);
            })
    }
}

function clean(model) {
    if (model === 'branch') {
        filter.value.driver = '';
    } else if (model === 'driver') {
        filter.value.branch = '';
    }
}

const data = ref({
    branches: '',
    timetables: ''
});

function branchName({ id, name }) {
    return `${id ? id : ''} - ${name ? name : ''}`
}

function openModal() {
    modal.value.byDriver = true
}

function loadData() {
    axios.get(route('frota.load-data'))
        .then((r) => {
            data.value = r.data;
        })
        .catch(() => {
            toast.error('Ocorreu um erro ao solicitar dados ao servidor.');
        })
}

function verifyDriverRoute() {
    loading.value = true;
    filter.value.error = '';
    results.value = {};
    if (filter.value.date && filter.value.driver) {
        openModal()
        loadData()
        axios.post(route('frota.tasks.filter-routes'), {
            driver: filter.value.driver.id,
            date: filter.value.date
        })
            .then((r) => {
                loading.value = false;
                if (r.data.length >= 1) {
                    results.value = r.data[0]
                }
            })
            .catch((e) => {
                loading.value = false;
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                } else {
                    toast.error('Foram encontrados erros ao processar sua solicitação');
                }
            })/**/
    }
}

function saveRoute() {
    filter.value.error = '';
    axios.post(route('frota.tasks.route.store'), {
        driver: filter.value.driver.id,
        date: filter.value.date,
        time: filter.value.time,
        branch: filter.value.branch.id
    })
        .then((r) => {
            toast.success(r.data.message)
            verifyDriverRoute()
            resetForm()
        })
        .catch((e) => {
            if (e.response?.status === 500) {
                toast.error(e.response.data)
                filter.value.error = e.response.data
            }
            if (e.response?.status === 403) {
                toast.error(e.response.data.error)
                filter.value.error = e.response.data.error
            }
        })
}

function updateRoute() {
    //todo
    console.log('todo')
}

function resetForm() {
    filter.value.time = '';
    filter.value.branch = '';
}

function setRouteToEdit(route) {
    modal.value.editRoute = true
    routeForEdition.value.id = route.id
    routeForEdition.value.branch = route.branch
    routeForEdition.value.time = route.time
}

</script>

<template>

    <Head title="Rotas" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Rotas
                <Link :href="route('frota.routes.create')" class="mt-0.5">
                <mdicon name="plus" />
                </Link>
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.66)]">
                    <p class="text-lg mb-1.5">Filtrar</p>
                    <div class="p-2 rounded-lg grid grid-cols-1 md:grid-cols-5 gap-4">
                        <div class="relative z-0 mb-6 w-full group">
                            <div>&nbsp;</div>
                            <input type="date" name="name" id="name" v-model="filter.date"
                                class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                :class="page.props.errors.date ? 'border-red-600' : ''" required placeholder=" "
                                @change="results = {}, $page.props.errors.date = null" />
                            <label for="name"
                                class="absolute text-lg duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-300 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                Data*
                            </label>
                        </div>
                        <div class="relative z-10 mb-6 w-full md:col-span-2">
                            <div>Unidade</div>
                            <VueMultiselect v-model="filter.branch" :options="$page.props.branches" :multiple="false"
                                :close-on-select="true" placeholder="Unidade" label="name" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover"
                                @select="clean('branch'), $page.props.errors.date = null" />
                        </div>
                        <div class="relative z-10 mb-6 w-full md:col-span-2">
                            <div>Motorista</div>
                            <VueMultiselect v-model="filter.driver" :options="$page.props.drivers" :multiple="false"
                                :close-on-select="true" placeholder="Motorista" :custom-label="drivers" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover"
                                @select="clean('driver'), $page.props.errors.date = null" />
                        </div>

                        <div v-if="$page.props.errors.date" class="text-sm text-red-500 md:col-span-5">
                            {{ $page.props.errors.date }}
                        </div>
                        <div>
                            <button type="button" @click="filtering" :disabled="filter.processing"
                                class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline"
                                :class="filter.processing ? 'bg-yellow-300 text-yellow-600' : ''">
                                Filtrar
                            </button>
                        </div>
                    </div>
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mx-2"
                        v-if="results && filter.driver && (filter.driver.id === results?.driver)">
                        <div class="p-2 rounded-lg overflow-y-auto"
                            :class="$page.props.app.settingsStyles.main.innerSection">

                            <button
                                v-if="(moment(moment(results.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                    moment(moment(results.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))) && (hasPermission($page.props.auth.permissions, ['Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar']) || hasPermission($page.props.auth.roles, ['Super Admin']))"
                                @click="verifyDriverRoute()"
                                class="flex px-2 py-1.5 transition duration-500 ease select-none rounded-md border border-blue-500 dark:border-slate-300 bg-blue-300 hover:bg-blue-400 text-blue-500 hover:text-blue-200 dark:bg-slate-400 dark:hover:bg-slate-600 dark:text-slate-800 dark:hover:text-slate-200 float-right">
                                Editar Rota
                                <mdicon name="text-box-edit" />
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
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(r, i) in results.routes" :key="'route-' + i">
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
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded mx-2"
                        v-if="results && filter.branch && (filter.branch.id === results[0]?.to)">
                        <div class="p-2 rounded-lg overflow-y-auto"
                            :class="$page.props.app.settingsStyles.main.innerSection">
                            <table class="min-w-full">
                                <thead>
                                    <tr>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Hora
                                        </th>
                                        <th
                                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                            Motorista
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
                                    <tr v-for="(r, i) in results" :key="'route-branch-' + i">
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            {{ r.time }}
                                        </td>
                                        <td
                                            class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                            {{ r.task_data.driver.user.name }}
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
                                            <Link
                                                v-if="(moment(moment(results.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                                    moment(moment(results.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))) && (hasPermission($page.props.auth.permissions, ['Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar']) || hasPermission($page.props.auth.roles, ['Super Admin']))"
                                                :href="route('frota.routes.driver.edit', [filter.date, r.task_data?.driver?.id])">
                                            <button
                                                class="px-2 py-1.5 transition duration-500 ease select-none rounded-md border border-blue-500 dark:border-slate-300 bg-blue-300 hover:bg-blue-400 text-blue-500 hover:text-blue-200 dark:bg-slate-400 dark:hover:bg-slate-600 dark:text-slate-800 dark:hover:text-slate-200">

                                                Editar Rota
                                            </button>
                                            </Link>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <!-- modal -->
                <div class="fixed z-50 inset-0 flex items-center justify-center overflow-hidden mx-1"
                    :class="modal.byDriver ? 'block' : 'hidden'">
                    <div class="fixed inset-0 transition-opacity">
                        <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                    </div>
                    <div v-if="data?.timetables && data?.branches"
                        class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600">
                        <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                                Editando Rota de:
                                <span class="font-bold underline">
                                    {{ filter.driver?.user?.name ?? '' }}
                                </span>
                            </h3>
                            <div class="mt-2 overflow-auto">
                                <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                                    <div class="mb-6 w-full z-auto min-h-fit grid grid-cols-1 md:grid-cols-4">

                                        <div class="mx-2 grid grid-cols-1">
                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                Data
                                            </label>
                                            <input type="date" v-model="filter.date" @change="verifyDriverRoute"
                                                class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                                            <div v-if="$page.props.errors.driver_id"
                                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                {{ $page.props.errors.driver_id }}
                                            </div>
                                        </div>

                                        <div class="mx-2 col-span-2 md:col-span-1" v-if="data?.timetables !== ''">
                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                Hora
                                            </label>
                                            <VueMultiselect v-model="filter.time" :options="data?.timetables"
                                                :multiple="false" :close-on-select="true" selectedLabel="atual"
                                                placeholder="Hora" selectLabel="Selecionar" deselectLabel="Remover" />

                                            <div v-if="$page.props.errors.driver_id"
                                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                {{ $page.props.errors.driver_id }}
                                            </div>
                                        </div>

                                        <div class="mx-2 col-span-2" v-if="data?.branches !== ''">
                                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                                Unidade
                                            </label>
                                            <VueMultiselect v-model="filter.branch" :options="data?.branches"
                                                :multiple="false" :close-on-select="true" selectedLabel="atual"
                                                placeholder="Unidade" :custom-label="branchName" track-by="id"
                                                label="time" selectLabel="Selecionar" deselectLabel="Remover" />

                                            <div v-if="$page.props.errors.driver_id"
                                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                                {{ $page.props.errors.driver_id }}
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
                                        <tr v-if="loading">
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
                                        <tr v-for="(r, i) in results.routes" :key="'route-' + i"
                                            v-if="results?.routes?.length > 0">
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
                        <div class="dark:bg-gray-500 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                            <button type="button"
                                class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm"
                                @click="modal.byDriver = false">
                                Fechar
                            </button>
                        </div>
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
                                        {{ filter.driver?.user?.name ?? '' }}
                                    </span> em {{ moment(filter.date).format('DD/MM/YYYY') }}
                                </h3>
                                <div class="mt-2 overflow-x-auto grid grid-cols-1 md:grid-cols-2">
                                    <div class="z-10 mb-6 w-full">
                                        <div>Unidade</div>
                                        <VueMultiselect v-model="routeForEdition.branch" :options="$page.props.branches"
                                            :multiple="false" :close-on-select="true" placeholder="Unidade" label="name"
                                            track-by="id" selectLabel="Selecionar" deselectLabel="Remover"
                                            @select="clean('branch'), $page.props.errors.date = null" />
                                    </div>


                                    <div class="mx-2 col-span-2 md:col-span-1 mb-52 md:mb-20"
                                        v-if="data?.timetables !== ''">
                                        <label class="text-sm text-gray-500 dark:text-gray-400">
                                            Hora
                                        </label>
                                        <VueMultiselect v-model="routeForEdition.time" :options="data?.timetables"
                                            :multiple="false" :close-on-select="true" selectedLabel="atual"
                                            placeholder="Hora" selectLabel="Selecionar" deselectLabel="Remover" />
                                    </div>
                                </div>
                            </div>
                            <div class="dark:bg-gray-500 px-4 py-3 sm:px-6 sm:flex">
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
