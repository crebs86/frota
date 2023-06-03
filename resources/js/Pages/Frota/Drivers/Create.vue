<script setup>

import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    users: Object,
    garages: Object,
    cars: Object,
    _checker: String
});

const userOptions = props.users;
const _user = ref(null);

const garageOptions = props.garages;
const _garage = ref(null);

const carOptions = props.cars;
const _car = ref(null);
function carName({ modelo, placa }) {
    return `${modelo} - ${placa}`
}

const employee = ref(false);
const registry = ref('');
const cnh = ref(false);

const driver = useForm({
    user: null,
    garage: null,
    car: null,
    employee: null,
    cnh: null,
    registry: null,
});

function saveDriver() {
    driver.user = _user.value.id;
    driver.garage = _garage.value.id;
    driver.car = _car.value.id;
}

</script>

<template>
    <Head title="Frota Inteligente" />

    <FrotaLayout>

        <template #currentPage>
            Novo Motorista
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-max">
                <div class="relative mb-6 w-full z-auto h-[calc(100vh/1.33)]">
                    <div>
                        <label class="text-sm text-gray-500 dark:text-gray-400">
                            Selecione um usuário*
                        </label>
                        <VueMultiselect v-model="_user" :options="userOptions" :multiple="false" :close-on-select="true"
                            selectedLabel="atual" placeholder="Usuários ativos" label="name" track-by="id"
                            selectLabel="Selecionar" deselectLabel="Remover" />

                        <!-- <div v-if="$page.props.errors.user_id" class="text-sm text-red-500">
                        {{ $page.props.errors.user_id }}
                    </div> -->
                    </div>
                    <div class="mt-2">
                        <label class="text-sm text-gray-500 dark:text-gray-400">
                            Selecione uma garagem (opcional)
                        </label>
                        <VueMultiselect v-model="_garage" :options="garageOptions" :multiple="false" :close-on-select="true"
                            value="id" selectedLabel="atual" placeholder="Garagens" label="name" track-by="name"
                            selectLabel="Selecionar" deselectLabel="Remover" />

                        <!-- <div v-if="$page.props.errors.garage_id" class="text-sm text-red-500">
                        {{ $page.props.errors.garage_id }}
                    </div> -->
                    </div>
                    <div class="mt-2">
                        <label class="text-sm text-gray-500 dark:text-gray-400">
                            Selecione um carro favorito (opcional)
                        </label>
                        <VueMultiselect v-model="_car" :options="carOptions" :multiple="false" :close-on-select="true"
                            selectedLabel="atual" placeholder="Carro favorito" :custom-label="carName" label="name"
                            :showNoOptions="false" track-by="name" selectLabel="Selecionar" deselectLabel="Remover" />

                        <!-- <div v-if="$page.props.errors.branch_id" class="text-sm text-red-500">
                        {{ $page.props.errors.branch_id }}
                    </div> -->
                    </div>
                    <div class="mt-2">
                        <div class="flex w-full mb-5">
                            <label for="employee" class="flex items-center cursor-pointer">
                                <div class="relative">
                                    <input type="checkbox" id="employee" class="sr-only" :checked="employee"
                                        v-model="driver.employee">
                                    <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                    </div>
                                    <div
                                        class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                    </div>
                                </div>
                                <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                    Servidor Próprio*
                                </div>
                            </label>
                        </div>

                        <!-- <div v-if="$page.props.errors.branch_id" class="text-sm text-red-500">
                        {{ $page.props.errors.branch_id }}
                    </div> -->
                    </div>
                    <div class="mt-2">
                        <div class="flex w-full mb-5">
                            <label for="cnh" class="flex items-center cursor-pointer">
                                <div class="relative">
                                    <input type="checkbox" id="cnh" class="sr-only" :checked="cnh" v-model="driver.cnh">
                                    <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                    </div>
                                    <div
                                        class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                    </div>
                                </div>
                                <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                    CNH Verificada (opcional)
                                </div>
                            </label>
                        </div>

                        <!-- <div v-if="$page.props.errors.branch_id" class="text-sm text-red-500">
                        {{ $page.props.errors.branch_id }}
                    </div> -->
                    </div>

                    <div class="relative">
                        <label class="text-sm text-gray-500 dark:text-gray-400">
                            Selecione uma garagem (opcional)
                        </label>
                        <input type="text" v-model="driver.registry" name="registry" placeholder="Matrícula" maxlength="25"
                            class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                    </div>
                    <button type="button" @click="saveDriver"
                        class="border border-blue-600 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                        Salvar
                    </button>
                </div>
            </div>
        </template>

    </FrotaLayout>
</template>
<style scoped>
input:checked~.dot {
    transform: translateX(100%);
    background-color: #0ae465;
}
</style>
<style src="vue-multiselect/dist/vue-multiselect.css"></style>
