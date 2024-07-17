<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import hasPermission from '@/permissions';
import { toast } from '@/toast'
import { ref } from 'vue';
import moment from 'moment';
import axios from 'axios';

const filter = ref({
    date: '',
    branch: '',
    driver: ''
});

const results = ref({});

const page = usePage();

function drivers(id) {
    return id.user.name
}

function filtering() {
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
                    results.value = r.data.data[0]
                } else if (r.data.data.length > 1) {
                    results.value = r.data.data
                }
            })
            .catch((e) => {
                toast.error(e.response.data.error)
            })
    }
}

function clean(model) {
    if (model === 'branch') {
        filter.value.driver = ''
    } else if (model === 'driver') {
        filter.value.branch = ''
    }
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
                                :class="page.props.errors.date ? 'border-red-600' : ''" required placeholder=" " />
                            <label for="name"
                                class="absolute text-lg duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-300 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                Data*
                            </label>
                        </div>
                        <div class="relative z-10 mb-6 w-full md:col-span-2">
                            <div>Unidade</div>
                            <VueMultiselect v-model="filter.branch" :options="$page.props.branches" :multiple="false"
                                :close-on-select="true" placeholder="Unidade" label="name" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover" @select="clean('branch')" />
                        </div>
                        <div class="relative z-10 mb-6 w-full md:col-span-2">
                            <div>Motorista</div>
                            <VueMultiselect v-model="filter.driver" :options="$page.props.drivers" :multiple="false"
                                :close-on-select="true" placeholder="Motorista" :custom-label="drivers" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover" @select="clean('driver')" />
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
                            <button
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
