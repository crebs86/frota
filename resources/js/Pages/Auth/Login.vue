<script setup>
import Checkbox from '@/Components/Checkbox.vue';
import CustomBackgroundLayout from '@/Layouts/CustomBackgroundLayout.vue';
import InputError from '@/Components/InputError.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

defineProps({
    canResetPassword: Boolean,
    canRegister: Boolean,
    status: String,
});

const form = useForm({
    email: '',
    password: '',
    remember: false
});

const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
    });
};
</script>

<template>
    <CustomBackgroundLayout :main_class="'background-image'" :logo_class="'text-gray-300 dark:text-red-300'">

        <Head title="Log in" />

        <div v-if="status" class="mb-4 font-medium text-sm text-green-600">
            {{ status }}
        </div>

        <form @submit.prevent="submit">
            <div>
                <label for="email" class="text-blue-900 font-bold">E-mail</label>
                <TextInput id="email" type="email" class="mt-1 block w-full bg-[#0000ff08] text-gray-700" v-model="form.email"
                    required autofocus autocomplete="username" />
                <InputError class="mt-2" :message="form.errors.email" />
            </div>

            <div class="mt-4">
                <label for="password" class="text-blue-900 font-bold">Senha</label>
                <TextInput id="password" type="password" class="mt-1 block w-full bg-[#0000ff08] text-gray-700"
                    v-model="form.password" required autocomplete="current-password" />
                <InputError class="mt-2" :message="form.errors.password" />
            </div>

            <div class="block mt-4">
                <label class="flex items-center text-blue-700 font-bold">
                    <Checkbox name="remember" v-model:checked="form.remember" />
                    <span class="ml-2 text-sm text-blue-900">Lembrar de mim</span>
                </label>
            </div>

            <div class="flex items-center justify-end mt-4">
                <Link v-if="canRegister" :href="route('register')"
                    class="underline text-sm hover:text-gray-900 text-gray-300 dark:hover:text-gray-500 pr-5">
                Novo cadastro?
                </Link>
                <!--<Link v-if="canResetPassword" :href="route('password.request')"
                    class="underline text-sm hover:text-gray-900 text-gray-300 dark:hover:text-gray-500">
                Esqueceu sua senha?
                </Link> -->

                <PrimaryButton
                    class="border border-emerald-600 bg-emerald-500 text-white rounded-md px-4 py-3 m-2 transition duration-500 ease select-none hover:bg-emerald-800 focus:outline-none focus:shadow-outline"
                    :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                    Entrar
                </PrimaryButton>
            </div>
        </form>
    </CustomBackgroundLayout>
</template>
