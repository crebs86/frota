<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head } from '@inertiajs/vue3';
import { onMounted, ref } from 'vue';
import axios from 'axios';
import { toast } from '@/toast';
import moment from 'moment';

const props = defineProps({
    myRoutesByDate: Object
})

const date = ref({
    date: '',
    error: null
});

const myRoutes = ref({})

function myRoutesByDate() {
    myRoutes.value = {};

    axios.post(route('frota.my-routes-bydate', { date: date.value.date }))
        .then((r) => {
            myRoutes.value = r.data[0]
            if (r.data.length < 1) {
                toast.warning('Nenhuma agenda para a data selecionada.');
            }
        })
        .catch((r) => {
            console.log(r)
            toast.error('Erro ao processar solicitação.');
        })
}

onMounted(() => {
    myRoutes.value = props.myRoutesByDate[0]
})

function startRoute() { }

function finishRoute() { }

function eraseRoute() { }

</script>

<template>

    <Head title="Minhas Rotas" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Minhas Rotas
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">

                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">


                        <div class="m-2 grid grid-cols-1 max-w-[200px]">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Data
                            </label>
                            <input type="date" v-model="date.date" @change="myRoutesByDate()"
                                class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                            <div v-if="date.error"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small>{{ date.error }}</small>
                            </div>
                        </div>
                        {{ myRoutes.date }}
                        <table class="min-w-full">
                            <thead>
                                <tr>
                                    <th v-for=" (value, index) in ['Local', 'Hora', 'Iniciada', 'Finalizada', 'Ações']"
                                        :key="index + '' + value"
                                        class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider"
                                        :class="$page.props.app.settingsStyles.main.container">
                                        {{ value }}
                                    </th>
                                </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                                <tr v-for="(m, i) in myRoutes?.routes" :key="i + '_myroutes'">
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        {{ m.branch.name }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        {{ m.time }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        {{ m.started_at ?? 'não' }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        {{ m.ended_at ?? 'não' }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                        <div class="flex gap-3 justify-center"
                                            v-if="moment().isSame(myRoutes?.date, 'day')">
                                            <button>
                                                <mdicon class="text-green-600" name="play" title="Iniciar percurso" />
                                            </button>
                                            <button>
                                                <mdicon class="text-red-600" name="stop" title="Finalizar" />
                                            </button>
                                            <button>
                                                <mdicon class="text-yellow-600" name="eraser"
                                                    title="Apagar informações do percurso" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
