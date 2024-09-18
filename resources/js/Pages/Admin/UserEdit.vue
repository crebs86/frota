<script setup>
import { Head, usePage, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import AclMenu from '@/Components/Admin/Menus/AclMenu.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import moment from 'moment';
import swal from 'sweetalert';
import { toast } from '@/toast'
import VueMultiselect from 'vue-multiselect';
import SubSection from '@/Components/Admin/SubSection.vue';
import InnerSection from '@/Components/Admin/InnerSection.vue';

const props = defineProps({
    user: Object,
    branches: Object,
    _checker: String
});

const user = useForm({
    name: props.user.name,
    email: props.user.email,
    cpf: props.user.cpf,
    active: props.user.deleted_at === null,
    _checker: props._checker,
    branch_id: props.user.branch_id,
    notes: props.user.notes,
    password: '',
    password_confirmation: ''
})

const _branch = ref(props.user.branch);

function saveUser() {
    if (_branch.value) {
        user.branch_id = _branch.value.id;
    }

    user.put(route('admin.acl.users.update', props.user.id), {
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

function userEmail(withoutCheck = false) {
    if (withoutCheck) {
        swal({
            title: "Validar e-mail?",
            text: "Deseja realmente validar o email " + props.user.email + " da conta de " + props.user.name,
            icon: "error",
            buttons: ['Cancelar', 'Validar'],
            dangerMode: true,
        })
            .then((verifyEmail) => {
                if (verifyEmail) {
                    router.post(route('admin.acl.users.verify.email', props.user.id), { _checker: props._checker }, {
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
            });
    } else {
        router.post(route('admin.acl.users.require.email.verification', props.user.id), { _checker: props._checker }, {
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
}

</script>
<template>

    <Head title="Editar usuário" />

    <AuthenticatedLayout>
        <template #inner_menu>
            <AclMenu />
        </template>
        <SubSection>
            <template #header>
                Editando Usuário {{ props.user.name }}
            </template>
            <template #content>
                <InnerSection>
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
                            <div class="p-1.5 overflow-x-auto mt-2 bg-transparent">
                                <div class="grid xl:grid-cols-1 xl:gap-1">
                                    <div class="relative mb-6 w-full group">
                                        <label class="text-sm dark:text-gray-400">
                                            Unidade Vinculada
                                        </label>
                                        <VueMultiselect v-model="_branch" :options="props.branches" :multiple="false"
                                            :close-on-select="true" placeholder="Unidades Com Vínculo" label="name"
                                            track-by="id" selectLabel="Selecionar" deselectLabel="Remover" />

                                        <div v-if="usePage().props.errors.branch_id" class="text-sm text-red-500">
                                            {{ usePage().props.errors.branch_id }}
                                        </div>
                                    </div>
                                </div>
                                <div class="grid xl:grid-cols-2 xl:gap-6">
                                    <div class="relative z-0 mb-6 w-full group">
                                        <input type="text" name="name" id="name" v-model="user.name"
                                            class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" " required />
                                        <label for="name"
                                            class="absolute text-sm dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            Nome
                                        </label>
                                        <div v-if="usePage().props.errors.name" class="text-sm text-red-500">
                                            {{ usePage().props.errors.name }}
                                        </div>
                                    </div>
                                    <div class="relative z-0 mb-6 w-full group">
                                        <input type="email" name="email" id="email" v-model="user.email"
                                            class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" " required />
                                        <label for="email"
                                            class="absolute text-sm dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            E-mail
                                        </label>
                                        <div v-if="usePage().props.errors.email" class="text-sm text-red-500">
                                            {{ usePage().props.errors.email }}
                                        </div>
                                    </div>
                                    <div class="relative z-0 mb-6 w-full group">
                                        <input type="text" name="cpf" id="cpf" v-model="user.cpf"
                                            class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" " required />
                                        <label for="cpf"
                                            class="absolute text-sm dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            CPF
                                        </label>
                                        <div v-if="usePage().props.errors.cpf" class="text-sm text-red-500">
                                            {{ usePage().props.errors.cpf }}
                                        </div>
                                    </div>
                                </div>
                                <div class="grid xl:grid-cols-2 xl:gap-6">
                                    <div class="relative z-0 mb-6 w-full group">
                                        <textarea type="text" name="notes" id="notes" v-model="user.notes"
                                            class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" " required />
                                        <label for="notes"
                                            class="absolute text-sm dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            Observações
                                        </label>
                                        <div v-if="usePage().props.errors.notes" class="text-sm text-red-500">
                                            {{ usePage().props.errors.notes }}
                                        </div>
                                    </div>
                                    <div class="relative z-0 mb-6 w-full group">
                                        <label class="inline-flex items-center mt-3">
                                            <input type="checkbox" name="active" id="active"
                                                class="form-checkbox h-5 w-5 text-gray-500" v-model="user.active"
                                                :checked="user.active">
                                            <span class="ml-2 text-gray-500 dark:text-gray-400">
                                                Ativo?
                                            </span>
                                        </label>
                                    </div>
                                    <div class="relative z-0 mb-6 w-full group">
                                        <input type="password" name="password" id="password" v-model="user.password"
                                            class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" " required />
                                        <label for="password"
                                            class="absolute text-sm dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            Senha
                                        </label>
                                        <div v-if="usePage().props.errors.password" class="text-sm text-red-500">
                                            {{ usePage().props.errors.password }}
                                        </div>
                                    </div>
                                    <div class="relative z-0 mb-6 w-full group">
                                        <input type="password" name="password_confirmation" id="password_confirmation"
                                            v-model="user.password_confirmation"
                                            class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" " required />
                                        <label for="password_confirmation"
                                            class="absolute text-sm dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            Repetir Senha
                                        </label>
                                        <div v-if="usePage().props.errors.password_confirmation"
                                            class="text-sm text-red-500">
                                            {{ usePage().props.errors.password_confirmation }}
                                        </div>
                                    </div>
                                </div>
                                <div class="text-center">
                                    <button type="button" @click.prevent="saveUser"
                                        class="border border-blue-500 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-600 focus:outline-none focus:shadow-outline">
                                        Salvar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </template>
                </InnerSection>
                <InnerSection>
                    <template #header>
                        Situação do e-mail
                    </template>
                    <template #content>
                        <div class="mx-auto p-3 rounded-lg">
                            <div class="p-1.5 overflow-x-auto mt-2 bg-transparent">
                                <div class="grid xl:grid-cols-1 xl:gap-6">
                                    <div class="relative z-0 mb-1 w-full group text-center">
                                        {{
                                            $page.props.user.email_verified_at ? 'Verificado em ' +
                                                moment($page.props.user.email_verified_at).format('DD/MM/YYYY HH:mm:ss')
                                                : ''
                                        }}
                                    </div>
                                    <div class="relative z-0 mb-3 w-full group text-center"
                                        v-if="!$page.props.user.email_verified_at">
                                        <button type="button" @click.prevent="userEmail(true)"
                                            class="border border-yellow-500 bg-yellow-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-red-600 focus:outline-none focus:shadow-outline">
                                            Validar e-mail
                                        </button>
                                    </div>
                                    <div class="relative z-0 mb-3 w-full group text-center" v-else>
                                        <button type="button" @click.prevent="userEmail(false)"
                                            class="border border-blue-500 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-300 focus:outline-none focus:shadow-outline">
                                            Exigir validação de endereço de e-mail.
                                        </button>
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
<style src="vue-multiselect/dist/vue-multiselect.css"></style>