<script setup>

import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import VueMultiselect from 'vue-multiselect';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
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

    if (_id.value !== null) {

        driver.id = _id.value.id;
        driver.garagem_id = _garagem.value?.id;
        driver.carro_favorito = _carro_favorito.value?.id;

        driver.post(route('frota.drivers.store'), {
            onSuccess: (a) => {
                console.log(a)
            },
            onError: () => {
                if (props.errors) {
                    toast.error('Foram encontrado erros ao processar sua solicitação');
                }
            },
        })
    } else {
        toast.error('Selecione um usuário.');
    }
}

</script>

<template>

    <Head title="Frota Inteligente" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Cadastrar Novo Motorista
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-max">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded">
                        <div class="relative mb-6 w-full z-auto h-[calc(100vh/1.33)]">
                            <div>
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Selecione um usuário*
                                </label>
                                <VueMultiselect v-model="_id" :options="userOptions" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Usuários ativos"
                                    label="name" track-by="id" selectLabel="Selecionar" deselectLabel="Remover" />

                                <div v-if="$page.props.errors.id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.id }}
                                </div>
                            </div>
                            <div class="mt-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Selecione uma garagem (opcional)
                                </label>
                                <VueMultiselect v-model="_garagem" :options="garageOptions" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Garagens"
                                    :custom-label="garageName" track-by="id" selectLabel="Selecionar"
                                    deselectLabel="Remover" />

                                <div v-if="$page.props.errors.garagem_id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
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

                                <div v-if="$page.props.errors.carro_favorito"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.carro_favorito }}
                                </div>
                            </div>
                            <div class="mt-2">
                                <div class="flex w-full mb-5">
                                    <label for="proprio" class="flex items-center cursor-pointer">
                                        <div class="relative">
                                            <input type="checkbox" id="proprio" class="sr-only" :checked="proprio"
                                                v-model="driver.proprio">
                                            <div
                                                class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
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

                                <div v-if="$page.props.errors.proprio"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.proprio }}
                                </div>
                            </div>
                            <div class="mt-2">
                                <div class="flex w-full mb-5">
                                    <label for="cnh" class="flex items-center cursor-pointer">
                                        <div class="relative">
                                            <input type="checkbox" id="cnh" class="sr-only" :checked="cnh"
                                                v-model="driver.cnh">
                                            <div
                                                class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
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

                                <div v-if="$page.props.errors.cnh"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.cnh }}
                                </div>
                            </div>

                            <div class="mt-2">
                                <p class="text-sm text-gray-500 dark:text-gray-400 text-left">
                                    Informe a Matrícula, se servidor próprio (opcional)
                                </p>
                                <input type="text" v-model="driver.matricula" name="matricula"
                                    placeholder="somente números" maxlength="25"
                                    class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">

                                <div v-if="$page.props.errors.matricula"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.matricula }}
                                </div>
                            </div>

                            <button type="button" @click="saveDriver"
                                class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                Cadastrar Motorista
                            </button>
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
