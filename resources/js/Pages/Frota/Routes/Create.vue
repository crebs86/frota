<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, router } from '@inertiajs/vue3';
import { toast } from '@/toast';
import axios from 'axios';
import { ref } from 'vue';
import moment from 'moment';

const props = defineProps({
    drivers: Object,
    branches: Object,
    timetables: Object,
    errors: Object
});

const routes = ref({});

const routeForm = ref({
    driver: '',
    date: '',
    time: '',
    branch: '',
    error: ''
});

const modal = ref({
    editRoute: false
});

const routeForEdition = ref({
    id: '',
    branch: '',
    time: ''
});

function validateDate(date) {
    return moment(date).isSame(moment(), 'day') || moment(date).isAfter(moment(), 'day')
}

function driverName({ id, user }) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}

function branchName({ id, name }) {
    return `${id ? id : ''} - ${name ? name : ''}`
}

function saveRoute() {
    routeForm.value.error = ''
    if (routeForm.value.driver?.id &&
        routeForm.value.date &&
        routeForm.value.time &&
        routeForm.value.branch?.id &&
        validateDate(routeForm.value.date)
    ) {
        axios.post(route('frota.tasks.route.store'), {
            driver: routeForm.value.driver?.id,
            date: routeForm.value.date,
            time: routeForm.value.time,
            branch: routeForm.value.branch?.id
        })
            .then((r) => {
                toast.success(r.data.message)
                verifyDriverRoute()
                resetForm()
            })
            .catch((e) => {
                if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    routeForm.value.error = e.response.data
                } else if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeForm.value.error = e.response.data.error
                } else if (e.response?.status === 422) {
                    toast.error('Verifique os dados informados.')
                    routeForm.value.error = e.response.data
                } else {
                    toast.error('Foram encontrados erros ao processar sua solicitação');
                }
            })
    } else {
        if (!validateDate(routeForm.value.date)) {
            toast.error('Não é possível criar/adicionar a agenda para datas passadas.')
        } else {
            toast.error('Preencha todos os campos para prosseguir.')
        }
    }
}

function resetForm() {
    routeForm.value.time = ''
    routeForm.value.branch = ''
}

function verifyDriverRoute() {
    routeForm.value.error = ''
    routes.value = {};
    if (routeForm.value.date && routeForm.value.driver) {
        axios.post(route('frota.tasks.filter-routes'), {
            driver: routeForm.value.driver.id,
            date: routeForm.value.date
        })
            .then((r) => {
                if (r.data.length >= 1) {
                    routes.value = r.data[0]
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
    if (routeForEdition.value.branch && routeForEdition.value.time) {
        axios.put(route('frota.routes.route.update', routeForEdition.value.id), {
            id: routeForEdition.value.id,
            branch: routeForEdition.value.branch,
            time: routeForEdition.value.time
        })
            .then(() => {
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
            })
    } else {
        toast.error('Preencha todos os campos para atualizar a rota');
    }
}

function setRouteToEdit(route) {
    modal.value.editRoute = true
    routeForEdition.value.id = route.id
    routeForEdition.value.branch = route.branch
    routeForEdition.value.time = route.time
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
                Adicionar Rota
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
                    <div v-if="routeForm.error && !routeForm.error?.errors"
                        class="p-2 mx-2 text-red-700 bg-red-400 rounded-md border border-red-700">{{ routeForm.error }}
                    </div>
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded"
                        v-if="routeForm.date">
                        <div class="relative mb-6 w-full z-auto min-h-fit">

                            <div class="mt-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Selecione um motorista
                                </label>
                                <VueMultiselect v-model="routeForm.driver" :options="props.drivers" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Motorista"
                                    :custom-label="driverName" track-by="id" selectLabel="Selecionar"
                                    @select="verifyDriverRoute" deselectLabel="Remover" />

                                <div v-if="routeForm.error?.errors?.driver"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.error?.errors.driver">{{ error }}</small>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                        <div class="mb-6 w-full z-auto min-h-fit grid grid-cols-1 md:grid-cols-4">

                            <div class="mx-2 grid grid-cols-1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Data
                                </label>
                                <input type="date" v-model="routeForm.date" @change="verifyDriverRoute"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                                <div v-if="routeForm.error?.errors?.date"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.error?.errors.date">{{ error }}</small>
                                </div>
                            </div>

                            <div class="mx-2 col-span-2 md:col-span-1" v-if="routeForm.date">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Hora
                                </label>
                                <VueMultiselect v-model="routeForm.time" :options="props.timetables" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Hora"
                                    selectLabel="Selecionar" deselectLabel="Remover" />

                                <div v-if="routeForm.error?.errors?.time"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.error?.errors.time">{{ error }}</small>
                                </div>
                            </div>

                            <div class="mx-2 col-span-2" v-if="routeForm.date">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Unidade
                                </label>
                                <VueMultiselect v-model="routeForm.branch" :options="props.branches" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Unidade"
                                    :custom-label="branchName" track-by="id" label="time" selectLabel="Selecionar"
                                    deselectLabel="Remover" />

                                <div v-if="routeForm.error?.errors?.branch"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    <small v-for="error in routeForm.error?.errors.branch">{{ error }}</small>
                                </div>
                            </div>

                        </div>

                        <button type="button" @click="saveRoute" v-if="validateDate(routes.date)"
                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
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
                                            <button @click="setRouteToEdit(r)"
                                                v-if="moment(moment(routeForm.date).format('YYYY-MM-DD')).isAfter(moment().format('YYYY-MM-DD')) ||
                                                    moment(moment(routeForm.date).format('YYYY-MM-DD')).isSame(moment().format('YYYY-MM-DD'))">
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

                                <div class="mt-2 overflow-x-auto grid grid-cols-1 md:grid-cols-2 h-[375px]">
                                    <div class="z-10 mb-6 w-full">
                                        <div>Unidade</div>
                                        <VueMultiselect v-model="routeForEdition.branch" :options="$page.props.branches"
                                            :multiple="false" :close-on-select="true" placeholder="Unidade" label="name"
                                            track-by="id" selectLabel="Selecionar" deselectLabel="Remover"
                                            @select="$page.props.errors.date = null" />
                                    </div>

                                    <div class="mx-2 col-span-2 md:col-span-1 mb-52 md:mb-20">
                                        <label class="text-sm text-gray-500 dark:text-gray-400">
                                            Hora
                                        </label>
                                        <VueMultiselect v-model="routeForEdition.time" :options="$page.props.timetables"
                                            :multiple="false" :close-on-select="true" selectedLabel="atual"
                                            placeholder="Hora" selectLabel="Selecionar" deselectLabel="Remover" />
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
<style src="vue-multiselect/dist/vue-multiselect.css"></style>
