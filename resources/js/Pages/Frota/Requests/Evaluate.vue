<script setup>
import has from '@/arrayHelpers';
import { getRouteStatus, getStyles } from '@/contrasts';
import { driverName } from '@/helpers';
import { toast } from '@/toast';
import axios from 'axios';
import moment from 'moment';
import { onBeforeMount, ref } from 'vue';
import VueMultiselect from 'vue-multiselect';

const data = defineProps({
    props: Object
});

const props = ref([]);

const requests = ref([]);

const filter = ref({
    date: '',
    driver: ''
})

const modal = ref({
    evaluate: false
})

const model = ref({
    justification: ''
})

const currentRequest = ref({})

function driver(id) {
    return props.value.drivers.filter((item) => {
        return item.id === id
    })
}

function filterRequests() {
    axios.post(route('frota.requests.evaluate'), filter.value)
        .then((r) => {
            requests.value = r.data
        })
        .catch((e) => {
            console.log(e)
        })
        .finally()
}

function allow(r) {
    axios.post(route('frota.requests.allow'), { route: r.route, _checker: r._checker })
        .then(() => {
            requests.value[requests.value.indexOf(r)].status = 1
        })
        .catch((e) => {
            toast.error(e.response.data)
        })
        .finally()
}

function deny() {
    axios.post(route('frota.requests.allow'), {
        route: currentRequest.value.route,
        _checker: currentRequest.value._checker,
        type: true,
        justification: model.value.justification
    })
        .then(() => {
            requests.value[requests.value.indexOf(currentRequest.value)].status = 2
            modal.value.evaluate = false
            model.value.justification = ''
        })
        .catch((e) => {
            toast.error(e.response.data)
        })
        .finally()
}

onBeforeMount(() => {
    props.value = data.props
    axios.get(route('frota.requests.evaluate'))
        .then((r) => {
            requests.value = r.data
        })
        .catch((e) => {
            console.log(e)
        })
        .finally()
})
</script>

<template>
    <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
        <h2 class="text-xl text-center">Avaliar Solicitações</h2>
        <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
            <div class="grid grid-cols-6 gap-1">

                <input type="date" v-model="filter.date"
                    class="w-full rounded border border-gray-500 bg-red-100 h-[41px] text-gray-700 col-span-6 md:col-span-1">

                <VueMultiselect v-model="filter.driver" :options="props.drivers" :multiple="false"
                    :close-on-select="true" placeholder="Motorista" :custom-label="driverName" track-by="id"
                    selectLabel="Selecionar" deselectLabel="Remover" class="col-span-6 md:col-span-4" />

                <button @click="filterRequests"
                    class="px-2 py-1 rounded border border-green-700 bg-green-500 text-green-800 font-bold col-span-6 md:col-span-1">
                    Filtrar
                </button>

            </div>
            <div class="overflow-y-auto">
                <table class="min-w-full" :class="$page.props.app.settingsStyles.main.body">
                    <thead>
                        <tr>
                            <th
                                class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                Data
                            </th>
                            <th
                                class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                Chegada Prevista
                            </th>
                            <th
                                class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                Motorista
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
                                Status
                            </th>
                            <th
                                class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                                Ações
                            </th>
                        </tr>
                    </thead>
                    <tbody class="border border-black">
                        <tr v-for="(r, i) in requests" :key="'reqs_' + i">
                            <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                {{ moment(r.date).format('DD/MM/YYYY') }}
                            </td>
                            <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                {{ r.time }}
                            </td>
                            <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                {{ driver(r.driver)[0].user.name }}
                            </td>
                            <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center"
                                :class="r.to === 1 || r.b === 1 ? 'underline underline-offset-8' : ''">
                                {{ r.branch }}
                                <mdicon name="circle" class="float-right text-red-500" v-if="r.to === 1 || r.b === 1" />
                            </td>
                            <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                {{ Object.values(JSON.parse(r.passengers ?? '[]')).length }}
                            </td>
                            <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                {{ r.duration }}
                            </td>
                            <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                                <p class="mx-auto text-sm px-2 rounded-md border" :class="getStyles(r.type, r.status)">
                                    {{
                                        getRouteStatus(false, r.status)
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
                            <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                <div class="inline-flex gap-2">
                                    <button @click="setRouteToEdit(r)"
                                        v-if="(has($page.props.auth.permissions, ['Liberador']) || has($page.props.auth.roles, ['Super Admin']))">
                                        <mdicon name="map-search" title="Detalhes"
                                            class="text-yellow-500 hover:text-yellow-300" />
                                    </button>
                                    <button @click="allow(r)" :disabled="r.status == 1"
                                        v-if="(has($page.props.auth.permissions, ['Liberador']) || has($page.props.auth.roles, ['Super Admin']))">
                                        <mdicon name="check-all" title="Confirmar"
                                            :class="r.status !== 1 ? 'text-green-500 hover:text-green-300' : 'text-gray-500'" />
                                    </button>
                                    <button @click="currentRequest = r, modal.evaluate = true" :disabled="r.status == 2"
                                        v-if="(has($page.props.auth.permissions, ['Liberador']) || has($page.props.auth.roles, ['Super Admin']))">
                                        <mdicon name="cancel" title="Negar"
                                            :class="r.status != 2 ? 'text-red-600 hover:text-red-300' : 'text-gray-500'" />
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="fixed inset-0 items-center justify-center overflow-hidden mx-1"
        :class="modal.evaluate ? 'flex' : 'hidden'">
        <div class="fixed inset-0 transition-opacity">
            <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
        </div>
        <div
            class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[400px] dark:bg-gray-600 p-4">

            <div class="overflow-x-auto grid grid-cols-1">
                <label class="text-sm" for="justification">Justificativa</label>
                <textarea v-model="model.justification" id="justification"
                    class="min-w-full rounded my-1.5 text-gray-700" maxlength="255"></textarea>
            </div>

            <div class="dark:bg-gray-500 px-4 py-3 sm:px-6 flex gap-1 justify-end">
                <button type="button"
                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm"
                    @click="deny()">
                    Negar Solicitação
                </button>
                <button type="button"
                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm"
                    @click="modal.evaluate = false, currentRequest = {}">
                    Fechar
                </button>

            </div>
        </div>
    </div>

</template>

<style scoped></style>
