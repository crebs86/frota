<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import InnerSection from '@/Components/Admin/InnerSection.vue';
import { Head, useForm, usePage } from '@inertiajs/vue3';
import { toast } from '../../toast';
import has from '@/arrayHelpers';
import VueMultiselect from 'vue-multiselect';
import { ref } from 'vue';

const user = useForm({
    name: '',
    email: '',
    cpf: '',
    branch_id: '',
    notes: ''
})

const _branch = ref(null);

function createUser() {
    user.branch_id = _branch.value?.id;
    user.post(route('admin.acl.users.store'), {
        onSuccess: () => {
            if (usePage().props.flash.success) {
                toast.success(usePage().props.flash.success);
            } else if (usePage().props.flash.error) {
                toast.error(usePage().props.flash.error);
            }

        },
        onError: () => {
            if (usePage().props.errors) {
                toast.error('Foram encontrado erros ao processar sua solicitação');
            }
        },
    })
}

function garageName({ id, name }) {
    return `${id} - ${name}`
}

</script>

<template>

    <Head title="Criar Usuário" />

    <AuthenticatedLayout>

        <SubSection class="container mx-auto mt-1 text-justify px-0 md:px-3 rounded-lg py-3">
            <template #header>
                Novo Usuário
            </template>
            <template #content>
                <InnerSection class="mx-auto p-0.5 md:p-3 rounded-lg">
                    <template #content>
                        <div class="p-0 rounded-lg">
                            <div class="pt-0.5" v-if="usePage().props.flash.info">
                                <div
                                    class="max-w-lg bg-yellow-500 text-sm text-white rounded-md shadow-lg mx-auto my-2">
                                    <div class="p-3 text-center">
                                        {{ usePage().props.flash.info }}
                                    </div>
                                </div>
                            </div>
                            <div class="mx-auto p-3 rounded-lg">
                                <div class="py-2 overflow-x-auto mt-2 bg-transparent">
                                    <div
                                        class="align-middle inline-block min-w-full shadow overflow-hidden shadow-dashboard px-1 md:px-8 pt-2.5 rounded-bl-lg rounded-br-lg">

                                        <div class="grid xl:grid-cols-2 xl:gap-6">
                                            <div class="relative z-0 mb-6 w-full group">
                                                <input type="text" name="name" id="name" v-model="user.name"
                                                    class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                    placeholder=" " />
                                                <label for="name"
                                                    class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-300 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                    Nome
                                                </label>
                                                <div v-if="usePage().props.errors.name" class="text-sm text-red-500">
                                                    {{ usePage().props.errors.name }}
                                                </div>
                                            </div>
                                            <div class="relative z-0 mb-6 w-full group">
                                                <input type="email" name="email" id="email" v-model="user.email"
                                                    class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                    placeholder=" " />
                                                <label for="email"
                                                    class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-300 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                    E-mail
                                                </label>
                                                <div v-if="usePage().props.errors.email" class="text-sm text-red-500">
                                                    {{ usePage().props.errors.email }}
                                                </div>
                                            </div>
                                        </div>

                                        <div class="grid xl:grid-cols-2 xl:gap-6">
                                            <div class="relative z-0 mb-6 w-full group">
                                                <input type="text" name="cpf" id="cpf" v-model="user.cpf"
                                                    class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                    placeholder=" " />
                                                <label for="cpf"
                                                    class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-300 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                    CPF
                                                </label>
                                                <div v-if="usePage().props.errors.cpf" class="text-sm text-red-500">
                                                    {{ usePage().props.errors.cpf }}
                                                </div>
                                            </div>
                                            <div class="relative z-50 mb-6 w-full group">

                                                <VueMultiselect v-model="_branch" :options="$page.props.branches"
                                                    :multiple="false" :close-on-select="true" selectedLabel="atual"
                                                    placeholder="Garagens" :custom-label="garageName" track-by="id"
                                                    selectLabel="Selecionar" deselectLabel="Remover" id="branch_id" />

                                                <label for="branch_id"
                                                    class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-300 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6 -mt-2">
                                                    Unidade
                                                </label>
                                                <div v-if="usePage().props.errors.branch_id"
                                                    class="text-sm text-red-500">
                                                    {{ usePage().props.errors.branch_id }}
                                                </div>
                                            </div>
                                        </div>
                                        <div class="grid xl:grid-cols-1 xl:gap-6">
                                            <div class="relative z-0 mb-6 w-full group">
                                                <textarea type="text" name="notes" id="notes" v-model="user.notes"
                                                    class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                                    placeholder=" " required />
                                                <label for="notes"
                                                    class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-300 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                                    Observações
                                                </label>
                                                <div v-if="usePage().props.errors.notes" class="text-sm text-red-500">
                                                    {{ usePage().props.errors.notes }}
                                                </div>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <button type="button" @click.prevent="user.reset()"
                                                class="border border-yellow-500 bg-yellow-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-yellow-800 focus:outline-none focus:shadow-outline">
                                                Limpar
                                            </button>
                                            <button type="button" @click.prevent="createUser"
                                                v-if="has(usePage().props.auth.permissions, ['Cliente Editar']) || has(usePage().props.auth.roles, ['Super Admin'])"
                                                class="border border-green-500 bg-green-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-800 focus:outline-none focus:shadow-outline">
                                                Criar Usuário
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </template>
                </InnerSection>
            </template>
        </SubSection>

    </AuthenticatedLayout>
</template>
