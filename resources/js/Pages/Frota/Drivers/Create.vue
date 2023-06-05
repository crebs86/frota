<script setup>

import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import VueMultiselect from 'vue-multiselect';
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
import { toast } from '@/toast'

const props = defineProps({
    users: Object,
    garages: Object,
    cars: Object,
    _checker: String,
    errors: Object
});

const userOptions = props.users;
const _id = ref(null);

const garageOptions = props.garages;
const _garagem = ref(null);

const carOptions = props.cars;
const _carro_favorito = ref(null);

function carName({ modelo, placa }) {
    return `${modelo} - ${placa}`
}

function garageName({ id, branch }) {
    return `${id} - ${branch.name}`
}

const driver = useForm({
    id: null,
    garagem_id: null,
    carro_favorito: null,
    proprio: false,
    matricula: '',
    cnh: false,
});

function saveDriver() {
    //fazer verificação de valores nulos
    driver.id = _id.value.id;
    driver.garagem_id = _garagem.value.id;
    driver.carro_favorito = _carro_favorito.value.id;

    driver.post(route('drivers.store'), {
        onSuccess: (a) => {
            console.log(a)
        },
        onError: () => {
            if (props.errors) {
                toast.error('Foram encontrado erros ao processar sua solicitação');
            }
        },
    })
}

</script>

<template>
    <Head title="Frota Inteligente" />

    <FrotaLayout>

        <template #currentPage>
            <BreadCrumbs
                :breadCrumbs="[{ label: 'Motoristas', link: route('drivers.index') }, { label: 'Novo Motorista', link: '' }]">
            </BreadCrumbs>
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-max">
                <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded">
                    <div class="relative mb-6 w-full z-auto h-[calc(100vh/1.33)]">
                        <div>
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Selecione um usuário*
                            </label>
                            <VueMultiselect v-model="_id" :options="userOptions" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Usuários ativos" label="name" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover" />

                            <div v-if="$page.props.errors.id" class="text-sm text-red-500">
                                {{ $page.props.errors.id }}
                            </div>
                        </div>
                        <div class="mt-2">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Selecione uma garagem (opcional)
                            </label>
                            <VueMultiselect v-model="_garagem" :options="garageOptions" :multiple="false"
                                :close-on-select="true" selectedLabel="atual" placeholder="Garagens"
                                :custom-label="garageName" track-by="id" selectLabel="Selecionar" deselectLabel="Remover" />

                            <div v-if="$page.props.errors.garagem_id" class="text-sm text-red-500">
                                {{ $page.props.errors.garagem_id }}
                            </div>
                        </div>
                        <div class="mt-2">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Selecione um carro favorito (opcional)
                            </label>
                            <VueMultiselect v-model="_carro_favorito" :options="carOptions" :multiple="false"
                                :close-on-select="true" selectedLabel="atual" placeholder="Carro favorito"
                                :custom-label="carName" label="name" :showNoOptions="false" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover" />

                            <div v-if="$page.props.errors.carro_favorito" class="text-sm text-red-500">
                                {{ $page.props.errors.carro_favorito }}
                            </div>
                        </div>
                        <div class="mt-2">
                            <div class="flex w-full mb-5">
                                <label for="proprio" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="proprio" class="sr-only" :checked="proprio"
                                            v-model="driver.proprio">
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

                            <div v-if="$page.props.errors.proprio" class="text-sm text-red-500">
                                {{ $page.props.errors.proprio }}
                            </div>
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

                            <div v-if="$page.props.errors.cnh" class="text-sm text-red-500">
                                {{ $page.props.errors.cnh }}
                            </div>
                        </div>

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Informe a Matrícula, se servidor (opcional)
                            </label>
                            <input type="text" v-model="driver.matricula" name="matricula" placeholder="Matrícula"
                                maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                        </div>
                        <div v-if="$page.props.errors.matricula" class="text-sm text-red-500">
                            {{ $page.props.errors.matricula }}
                        </div>
                        <button type="button" @click="saveDriver"
                            class="border border-blue-600 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                            Cadastrar
                        </button>
                    </div>
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
