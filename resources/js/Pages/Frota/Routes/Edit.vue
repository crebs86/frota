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
    driverRoutes: Object
});


const routes = ref({});

const routeForm = ref({
    time: '',
    branch: '',
    error: ''
});

function branchName({ id, name }) {
    return `${id ? id : ''} - ${name ? name : ''}`
}

function saveRoute() {
    routeForm.value.error = ''
    if (!routeForm.value.time.time || !routeForm.value.branch.id) {
        routeForm.value.error = 'Preencha todos os campos.'
    } else {
        axios.post(route('frota.tasks.route.store'), {
            driver: props.driverRoutes[0].driver.id,
            date: props.driverRoutes[0].date,
            time: routeForm.value.time.time,
            branch: routeForm.value.branch.id
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
            })
    }
}

function resetForm() {
    routeForm.value.time = ''
    routeForm.value.branch = ''
}

function verifyDriverRoute() {
    console.log(props.driverRoutes[0].driver.id)
    routeForm.value.error = ''
    routes.value = {};
    if (props.driverRoutes[0].date && props.driverRoutes[0].driver.id) {
        axios.post(route('frota.tasks.filter-routes'), {
            driver: props.driverRoutes[0].driver.id,
            date: props.driverRoutes[0].date
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
            })/**/
    }
}

onMounted(()=>{
    routes.value = props.driverRoutes[0]
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
                Adicionar Rota para: {{ driverRoutes[0]?.driver?.user?.name }}
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
                    <div v-if="routeForm.error"
                        class="p-2 mx-2 text-red-700 bg-red-400 rounded-md border border-red-700">{{ routeForm.error }}
                    </div>
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">

                        <div class="w-full z-auto grid grid-cols-1 md:grid-cols-2">

                            <div class="mx-2 mb-3 pr-3 w-full z-auto col-span-2 md:col-span-1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Motorista
                                </label>
                                <input type="text"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-200 w-full bg-gray-400"
                                    :value="props.driverRoutes[0]?.driver?.user?.name" readonly />
                            </div>

                            <div class="mx-2 mb-3 w-full z-auto pr-3 pl-0.5">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Data
                                </label>
                                <input type="date" :value="props.driverRoutes[0]?.date"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-200 w-full bg-gray-400" readonly>
                            </div>

                            <div class="mx-2 mb-3 col-span-2 md:col-span-1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Hora
                                </label>
                                <VueMultiselect v-model="routeForm.time" :options="props.timetables" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Hora" track-by="id"
                                    label="time" selectLabel="Selecionar" deselectLabel="Remover" />

                            </div>

                            <div class="mx-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Unidade
                                </label>
                                <VueMultiselect v-model="routeForm.branch" :options="props.branches" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Unidade"
                                    :custom-label="branchName" track-by="id" label="time" selectLabel="Selecionar"
                                    deselectLabel="Remover" />
                            </div>

                        </div>

                        <button type="button" @click="saveRoute"
                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
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
                                    </tr>
                                </tbody>
                            </table>
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
