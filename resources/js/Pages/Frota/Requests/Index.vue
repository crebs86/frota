<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import {Head} from '@inertiajs/vue3';
import {toast} from '@/toast.ts';
import axios from 'axios';
import {computed, defineAsyncComponent, ref} from 'vue';
import moment from 'moment';
import validate from '@/validates/indexSaveRoute.js';
import validateUpRt from '@/validates/createUpdateRoute.js';
import {getStyles, styles} from '@/contrasts';
import has from '@/arrayHelpers';

const Evaluate = defineAsyncComponent(() => import('@/Pages/Frota/Requests/Evaluate.vue'))
const Request = defineAsyncComponent(() => import('@/Pages/Frota/Requests/Request.vue'))

const props = defineProps({
    drivers: Object,
    branches: Object,
    timetables: Object,
    routes: Object,
    errors: Object,
    liberator: Boolean
});


const routeForEdition = ref({
    id: '',
    branch: '',
    currentBranch: '',
    time: '',
    local: '',
    duration: '',
    passengers: [],
    errors: []
});

const routeRequestEdition = ref({
    id: '',
    driver: '',
    date: '',
    branch: '',
    currentBranch: '',
    time: '',
    local: '',
    duration: '',
    passengers: [],
    errors: []
});


const passengersRequestModel = ref('')

function setRequestPassenger(remove = false, passenger = null) {
    routeRequestEdition.value.errors.passengers = ''
    if (remove) {

        routeRequestEdition.value.passengers.splice(routeRequestEdition.value.passengers.indexOf(passenger), 1)
    } else if (passengersRequestModel.value) {

        routeRequestEdition.value.passengers.push(passengersRequestModel.value)
        passengersRequestModel.value = ''
    } else {

        routeRequestEdition.value.errors.passengers = 'Vazio.'
    }
}

const passengersEditModel = ref('')

function setEditPassenger(remove = false, passenger = null) {
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

function validateDate(date) {
    return moment(date).isSame(moment(), 'day') || moment(date).isAfter(moment(), 'day') || true
}

function updateRoute() {
    let val = validateUpRt(routeForEdition.value, ['driver'])
    if (val._run) {
        axios.put(route('frota.routes.route.update', routeForEdition.value.id), {
            id: routeForEdition.value.id,
            branch: routeForEdition.value.branch,
            currentBranch: routeForEdition.value.currentBranch,
            time: routeForEdition.value.time,
            duration: routeForEdition.value.duration,
            passengers: routeForEdition.value.passengers,
            local: routeForEdition.value.local,
            _checker: routeForEdition.value._checker
        })
            .then(() => {
                verifyDriverRoute();
                modal.value.editRoute = false;
                routeForEdition.value.time = ''
                routeForEdition.value.branch = ''
                routeForEdition.value.local = ''
                routeForEdition.value.duration = ''
                routeForEdition.value.passengers = []
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeForEdition.value.errors = e.response.data.error
                } else if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    routeForEdition.value.errors = e.response.data.errors
                } else if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    routeForEdition.value.errors = e.response.data
                }
            })
    } else {
        routeForEdition.value.errors = val
        toast.error('Preencha todos os campos para atualizar a rota');
    }
}

function updateRequest() {
    let val = validateUpRt(routeRequestEdition.value)
    if (val._run) {
        axios.put(route('frota.requests.update', routeRequestEdition.value.id), {
            id: routeRequestEdition.value.id,
            branch: routeRequestEdition.value.branch.id,
            currentBranch: routeRequestEdition.value.currentBranch.id,
            time: routeRequestEdition.value.time,
            driver: routeRequestEdition.value.driver.id,
            date: routeRequestEdition.value.date,
            duration: routeRequestEdition.value.duration,
            passengers: routeRequestEdition.value.passengers,
            local: routeRequestEdition.value.local,
            _checker: routeRequestEdition.value._checker
        })
            .then(() => {
                verifyDriverRoute();
                modal.value.editRequest = false;
                routeRequestEdition.value.time = ''
                routeRequestEdition.value.branch = ''
                routeRequestEdition.value.local = ''
                routeRequestEdition.value.duration = ''
                routeRequestEdition.value.passengers = []
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    routeRequestEdition.value.errors = e.response.data.error
                } else if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    routeRequestEdition.value.errors = e.response.data.errors
                } else if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    routeRequestEdition.value.errors = e.response.data
                }
            })
    } else {
        routeRequestEdition.value.errors = val
        toast.error('Preencha todos os campos para atualizar a solicitação.');
    }
}

function setRouteToEdit(route) {
    routeForEdition.value._checker = route._checker
    routeForEdition.value.id = route.id
    routeForEdition.value.errors = []
    routeForEdition.value.time = route.time
    routeForEdition.value.duration = route.duration
    routeForEdition.value.passengers = Object.values(JSON.parse(route.passengers) ?? [])
    if (route.b === 1) {
        routeForEdition.value.currentBranch = {"id": route.b, "name": 'Não Cadastrado'}
        routeForEdition.value.branch = {"id": route.b, "name": 'Não Cadastrado'}
        routeForEdition.value.local = route.branch
    } else {
        routeForEdition.value.local = ''
        routeForEdition.value.currentBranch = {"id": route.b, "name": route.branch}
        routeForEdition.value.branch = {"id": route.b, "name": route.branch}
    }
    modal.value.editRoute = true
}

function setRequestToEdit(route) {
    routeRequestEdition.value._checker = route._checker
    routeRequestEdition.value.id = route.id
    routeRequestEdition.value.date = route.date
    routeRequestEdition.value.driver = route.driver
    routeRequestEdition.value.errors = []
    routeRequestEdition.value.time = route.time
    routeRequestEdition.value.duration = route.duration
    routeRequestEdition.value.passengers = Object.values(JSON.parse(route.passengers) ?? [])
    if (route.branch.id === 1) {
        routeRequestEdition.value.currentBranch = {"id": route.branch.id, "name": 'Não Cadastrado'}
        routeRequestEdition.value.branch = {"id": route.branch.id, "name": 'Não Cadastrado'}
        routeRequestEdition.value.local = route.local
    } else {
        routeRequestEdition.value.local = ''
        routeRequestEdition.value.currentBranch = {"id": route.branch.id, "name": route.branch.name}
        routeRequestEdition.value.branch = {"id": route.branch.id, "name": route.branch.name}
    }
    modal.value.editRequest = true
}


</script>

<template>

    <Head title="Solicitações"/>

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu/>
        </template>
        <SubSection>
            <template #header>
                <button class="py-1 px-1.5 rounded border border-blue-600 mr-1.5"
                        :class="!props.liberator ? 'bg-blue-700 hover:bg-blue-300' : 'bg-blue-300 hover:bg-blue-700' ">
                    Solicitações
                </button>
                <button class="py-1 px-1.5 rounded border border-green-600"
                        :class="props.liberator ? 'bg-green-700 hover:bg-green-300' : 'bg-green-300 hover:bg-green-700' ">
                    Avaliar
                </button>
            </template>
            <template #content>
                <Request v-if="!props.liberator" :props="props"></Request>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
<style scoped>
input:checked ~ .dot {
    transform: translateX(100%);
    background-color: #0ae465;
}
</style>
<style src="../../../../../node_modules/vue-multiselect/dist/vue-multiselect.css"></style>
