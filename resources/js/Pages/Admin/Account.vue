<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import NavLink from '@/Components/NavLink.vue';
import {Head, useForm, usePage} from '@inertiajs/vue3';
import {computed} from 'vue';
import swal from 'sweetalert';
import {toast} from '@/toast'
import InnerSection from '@/Components/Admin/InnerSection.vue';
import SubSection from '@/Components/Admin/SubSection.vue';

const user = useForm({
    name: usePage().props.auth.user.name,
    email: usePage().props.auth.user.email
})
const password = useForm({
    current_password: '',
    password: '',
    password_confirmation: ''
})

const avatar = useForm({
    avatar: '',
})

const changeEmail = computed(() => {
    return usePage().props.auth.user.email !== user.email
})

function save() {
    user.post(route('user.account.update'), {
        onSuccess: (data) => toast.success(data.props.message),
        onError: (errors) => {
            toast.error('Erro ao salvar atualizações!')
        },
    })
}

function saveUser() {
    if (usePage().props.auth.user.email !== user.email) {
        swal({
            title: "Alteração de endereço de e-mail",
            text: "Você está alterando seu endereço de e-mail e sua validação poderá ser solicitada.",
            icon: "warning",
            buttons: ['Cancelar', 'Prosseguir'],
            dangerMode: true,
        })
            .then((willRestore) => {
                if (willRestore) {
                    save();
                }
            });
    } else {
        save();
    }
}

function updatePassword() {
    password.post(route('user.account.update.password'), {
        onSuccess: () => {
            if (usePage().props.flash.success) {
                toast.success(usePage().props.flash.success);
            } else if (usePage().props.flash.error) {
                toast.error(usePage().props.flash.error);
            }
        },
        onError: () => {
            if (usePage().props.errors) {
                toast.error('Erro ao alterar senha.');
            }
        },
    })
}

function sendAvatar() {

    if (avatar.avatar.size / 1000 / 1000 <= 1) {
        avatar.post(route('frota.update.avatar'), {
            forceFormData: true,
            onSuccess: () => {
                if (usePage().props.flash.success) {
                    toast.success(usePage().props.flash.success);
                } else if (usePage().props.flash.error) {
                    toast.error(usePage().props.flash.error);
                }
            },
            onError: () => {
                if (usePage().props.errors) {
                    toast.error('Erro ao salvar avatar.');
                }
            },
        })
    } else {
        toast.error('Imagem deve ter o tamanho máximo de 1Mb.')
    }
}

</script>

<template>
    <Head title="Minha Conta"/>

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Dados da conta, {{ $page.props.auth.user.name }}
                <NavLink :href="route('logout')" method="post" :class="'text-gray-800 dark:text-white border-1'">
                    Sair
                </NavLink>
            </template>
            <template #content>
                <div v-if="changeEmail">
                    <div class="max-w-lg bg-yellow-500 text-sm text-white rounded-md shadow-lg mx-auto my-2">
                        <div class="flex p-4">
                            Ao alterar seu e-mail poderá ser solicitado sua verificação antes de poder usar a sua conta
                            novamente. Confira com cuidado o endereço digitado.
                        </div>
                    </div>
                </div>
                <InnerSection>
                    <template #content>
                        <div class="pt-0.5" v-if="usePage().props.flash.info">
                            <div class="max-w-lg bg-yellow-500 text-sm text-white rounded-md shadow-lg mx-auto my-2">
                                <div class="p-3 text-center">
                                    {{ usePage().props.flash.info }}
                                </div>
                            </div>
                        </div>
                        <div class="mx-auto rounded-lg">
                            <div class="py-2 overflow-x-auto mt-2">
                                <div class="grid xl:grid-cols-3 xl:gap-6">
                                    <div class="relative z-0 mb-6 w-full group">
                                        <input type="text" name="name" id="name" v-model="user.name"
                                               class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                               placeholder=" " required/>
                                        <label for="name"
                                               class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            Nome
                                        </label>
                                        <div v-if="usePage().props.errors.name" class="text-sm text-red-500">
                                            {{ usePage().props.errors.name }}
                                        </div>
                                    </div>
                                    <div class="relative z-0 mb-6 w-full group">
                                        <input type="email" name="email" id="email" v-model="user.email"
                                               autocomplete="email"
                                               class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                               placeholder=" " required/>
                                        <label for="email"
                                               class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            E-mail
                                        </label>
                                        <div v-if="usePage().props.errors.email" class="text-sm text-red-500">
                                            {{ usePage().props.errors.email }}
                                        </div>
                                    </div>
                                    <div class="relative z-0 mb-6 w-full group">
                                        <input type="text" name="cpf" id="cpf" :value="usePage().props.auth.user.cpf"
                                               class="block py-2.5 px-0 w-full text-sm text-gray-500 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-gray-500 dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                               placeholder=" " readonly/>
                                        <label for="cpf"
                                               class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                            CPF
                                        </label>
                                    </div>
                                </div>
                                <div class="text-center">
                                    <button type="button" @click.prevent="saveUser"
                                            class="border border-blue-500 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-red-600 focus:outline-none focus:shadow-outline">
                                        Atualizar Conta
                                    </button>
                                </div>
                            </div>
                        </div>
                    </template>
                </InnerSection>
                <InnerSection>
                    <template #header>
                        Alterar senha
                    </template>
                    <template #content>
                        <div class="py-2 overflow-x-auto mt-2 bg-transparent">
                            <div class="grid xl:grid-cols-3 xl:gap-6">
                                <div class="relative z-0 mb-6 w-full group">
                                    <input type="password" name="current_password" id="current_password"
                                           v-model="password.current_password" autocomplete="new-password"
                                           class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                           placeholder=" " required/>
                                    <label for="current_password"
                                           class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                        Senha Atual
                                    </label>
                                    <div v-if="usePage().props.errors.current_password" class="text-sm text-red-500">
                                        {{ usePage().props.errors.current_password }}
                                    </div>
                                </div>
                                <div class="relative z-0 mb-6 w-full group">
                                    <input type="password" name="password" id="password" v-model="password.password"
                                           autocomplete="new-password"
                                           class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                           placeholder=" " required/>
                                    <label for="password"
                                           class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                        Nova Senha
                                    </label>
                                    <div v-if="usePage().props.errors.password" class="text-sm text-red-500">
                                        {{ usePage().props.errors.password }}
                                    </div>
                                </div>
                                <div class="relative z-0 mb-6 w-full group">
                                    <input type="password" name="password_confirmation" id="password_confirmation"
                                           v-model="password.password_confirmation" autocomplete="new-password"
                                           class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                           placeholder=" " required/>
                                    <label for="password_confirmation"
                                           class="absolute text-sm duration-300 transform -translate-y-6 scale-75 top-3 z-0 origin-[0] peer-focus:left-0 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                        Confirmar Nova Senha
                                    </label>
                                    <div v-if="usePage().props.errors.password_confirmation"
                                         class="text-sm text-red-500">
                                        {{ usePage().props.errors.password_confirmation }}
                                    </div>
                                </div>
                            </div>
                            <div class="text-center">
                                <button type="button" @click.prevent="updatePassword"
                                        class="border border-blue-500 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-red-600 focus:outline-none focus:shadow-outline">
                                    Atualizar Senha
                                </button>
                            </div>
                        </div>
                    </template>
                </InnerSection>
                <InnerSection>
                    <template #header>
                        Avatar
                    </template>
                    <template #content>
                        <div class="py-2 overflow-x-auto mt-2 bg-transparent">
                            <img alt="avatar" :src="usePage().props.auth.avatar" class="mb-4 max-w-80" v-if="usePage().props.auth.avatar" />
                            <img alt="avatar" src="/logos/default_avatar.webp" class="mb-4 max-w-80" v-else />
                            <form @submit.prevent="sendAvatar">
                                <div class="grid grid-cols-1">
                                    <div class="relative z-0 mb-6 w-full group">
                                        <label for="avatar">
                                            Selecione uma imagem (jpg, jpeg, png) tamanho máximo de 1Mb
                                        </label>
                                        <input type="file" name="avatar" id="avatar"
                                               @input="avatar.avatar = $event.target.files[0]"
                                               class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                               placeholder=" " required accept="image/png, image/jpeg, image/jpg"/>
                                        <progress v-if="avatar.progress" :value="avatar.progress.percentage" max="100">
                                            {{ avatar.progress.percentage }}%
                                        </progress>
                                        <div v-if="usePage().props.errors.avatar" class="text-sm text-red-500">
                                            {{ usePage().props.errors.avatar }}
                                        </div>
                                    </div>
                                </div>
                                <div class="text-center">
                                    <button type="submit"
                                            class="border border-blue-500 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-red-600 focus:outline-none focus:shadow-outline">
                                        Salvar Avatar
                                    </button>
                                </div>
                            </form>
                        </div>
                    </template>
                </InnerSection>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
