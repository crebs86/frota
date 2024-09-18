<script setup>

import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, router, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
import { toast } from '@/toast'
import axios from 'axios';

const props = defineProps({
    branches: Object,
    errors: Object
});

const branch = ref({
    id: '',
    name: '',
    email: '',
    cep: '',
    address: '',
    phones: '',
    cnpj: '',
    notes: '',
    processing: false,
    errors: {}
})

function createBranch() {
    branch.value.processing = true;
    branch.value.errors = {}
    axios.post(route('branches.store'), {
        id: branch.value.id,
        name: branch.value.name,
        email: branch.value.email,
        cep: branch.value.cep,
        address: branch.value.address,
        phones: branch.value.phones,
        cnpj: branch.value.cnpj,
        notes: branch.value.notes
    })
        .then(() => {
            branch.value.processing = false;
            modal.value.newBranch = false;
            toast.success('Unidade criada com sucesso.');
            router.visit(route('frota.garages.create'), {
                only: ['branches']
            })
        })
        .catch((e) => {
            branch.value.processing = false;
            toast.error('Foram encontrado erros ao processar sua solicitação.');
            if (e.response.status === 422) {
                branch.value.errors = e.response?.data?.errors
            }
        })
}

const branchesOptions = props.branches;
const _branch = ref(null);

function branchName({ id, name }) {
    return `${id} - ${name}`
}

const garage = useForm({
    id: null
});

const modal = ref({
    newBranch: false
});

function saveGarage() {
    garage.id = _branch.value?.id;
    if (garage.id) {
        garage.post(route('frota.garages.store'), {
            onSuccess: () => {
                toast.success('A garagem foi vinculada a unidade criada com sucesso.');
                router.visit(route('frota.garages.create'), {
                    only: ['branches']
                })
            },
            onError: () => {
                if (props.errors) {
                    toast.error('Foram encontrado erros ao processar sua solicitação.');
                }
            },
        })
    } else {
        toast.error('Selecione uma unidades para cadatrar.');
    }
}

</script>

<template>

    <Head title="Nova Garagem" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Garagens
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-max">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded">
                        <div class="relative mb-6 w-full z-auto min-h-[calc(100vh/1.33)]">
                            <div class="mt-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                    Selecione uma unidade para cadastrar garagem
                                    <button @click="modal.newBranch = true">
                                        <mdicon name="source-branch-plus" title="Nova Unidade" />
                                    </button>
                                </label>
                                <VueMultiselect v-model="_branch" :options="branchesOptions" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Unidades"
                                    :custom-label="branchName" track-by="id" selectLabel="Selecionar"
                                    deselectLabel="Remover" />

                                <div v-if="$page.props.errors.id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.id }}
                                </div>
                            </div>

                            <div class="px-0.5 mt-1">
                                <ul>
                                    <li>
                                        <span class="font-bold">Código:</span> {{ _branch?.id }}
                                    </li>
                                    <li>
                                        <span class="font-bold">Nome:</span> {{ _branch?.name }}
                                    </li>
                                    <li>
                                        <span class="font-bold">Email:</span> {{ _branch?.email }}
                                    </li>
                                    <li>
                                        <span class="font-bold">Endereço:</span> {{ _branch?.address }}
                                    </li>
                                    <li>
                                        <span class="font-bold">Contato:</span> {{ _branch?.phones }}
                                    </li>
                                    <li>
                                        <span class="font-bold">Observações:</span> {{ _branch?.notes }}
                                    </li>
                                </ul>
                            </div>
                            <button type="button" @click="saveGarage"
                                class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                Cadastrar Garagem
                            </button>
                        </div>
                    </div>
                </div>
                <!-- modal -->
                <div class="fixed z-50 inset-0 flex items-center justify-center overflow-hidden mx-1"
                    :class="modal.newBranch ? 'block' : 'hidden'">
                    <div class="fixed inset-0 transition-opacity">
                        <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
                    </div>
                    <div
                        class="bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600">
                        <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                                Criando Nova Unidade
                            </h3>
                            <div class="mt-2">
                                <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                                    <div class="mb-6 p-3 w-full z-auto min-h-fit grid grid-cols-1 md:grid-cols-2 gap-1">

                                        <div class="relative z-0 mb-6 w-full">
                                            <input type="text" name="name" id="name" v-model="branch.name"
                                                class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                placeholder=" " />
                                            <label for="name"
                                                class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                Nome
                                            </label>
                                            <div v-if="branch.errors.name" class="text-sm text-red-500">
                                                <p v-for="error in branch.errors.name">{{ error }}</p>
                                            </div>
                                        </div>
                                        <div class="relative z-0 mb-6 w-full">
                                            <input type="email" name="email" id="email" v-model="branch.email"
                                                class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                placeholder=" " />
                                            <label for="email"
                                                class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                E-mail
                                            </label>
                                            <div v-if="branch.errors.email" class="text-sm text-red-500">
                                                <p v-for="error in branch.errors.email">{{ error }}</p>
                                            </div>
                                        </div>

                                        <div class="relative z-0 mb-6 w-full group">
                                            <input type="text" name="cep" id="cep" v-model="branch.cep"
                                                class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                placeholder=" " />
                                            <label for="cep"
                                                class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                CEP
                                            </label>
                                            <div v-if="branch.errors.cep" class="text-sm text-red-500">
                                                <p v-for="error in branch.errors.cep">{{ error }}</p>
                                            </div>
                                        </div>
                                        <div class="relative z-0 mb-6 w-full group">
                                            <input type="text" name="address" id="address" v-model="branch.address"
                                                class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                placeholder=" " required />
                                            <label for="address"
                                                class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                Endereço
                                            </label>
                                            <div v-if="branch.errors.address" class="text-sm text-red-500">
                                                <p v-for="error in branch.errors.address">{{ error }}</p>
                                            </div>

                                        </div>

                                        <div class="relative z-0 mb-6 w-full group">
                                            <input type="text" name="phones" id="phones" v-model="branch.phones"
                                                class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                placeholder=" " required />
                                            <label for="phones"
                                                class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                Telefones
                                            </label>
                                            <div v-if="branch.errors.phones" class="text-sm text-red-500">
                                                <p v-for="error in branch.errors.phones">{{ error }}</p>
                                            </div>
                                        </div>
                                        <div class="relative z-0 mb-6 w-full group">
                                            <input type="text" name="cnpj" id="cnpj" v-model="branch.cnpj"
                                                class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                placeholder=" " />
                                            <label for="cnpj"
                                                class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                CNPJ
                                            </label>
                                            <div v-if="branch.errors.cnpj" class="text-sm text-red-500">
                                                <p v-for="error in branch.errors.cnpj">{{ error }}</p>
                                            </div>

                                        </div>
                                        <div class="grid xl:grid-cols-1 xl:gap-6">
                                            <div class="relative z-0 mb-6 w-full group">
                                                <textarea type="text" name="notes" id="notes" v-model="branch.notes"
                                                    class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                    placeholder=" " required />
                                                <label for="notes"
                                                    class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                    Observações
                                                </label>
                                                <div v-if="branch.errors.notes" class="text-sm text-red-500">
                                                    <p v-for="error in branch.errors.notes">{{ error }}</p>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <button type="button" @click="createBranch" :disabled="branch.processing"
                                        class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                        Criar/Adicionar
                                    </button>

                                    <button type="button" @click="modal.newBranch = false"
                                        class="border border-gray-600 bg-gray-500 text-gray-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-gray-600 focus:outline-none focus:shadow-outline">
                                        Cancelar
                                    </button>
                                </div>
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
