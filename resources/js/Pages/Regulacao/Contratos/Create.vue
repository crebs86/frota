<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';

const contrato = useForm({
    contrato: '241',
    ano: '2022',
    contratada_nome: 'Laboratório AAA',
    contratada_cnpj: '12345678901234',
    vigencia_inicio: '2022-03-19',
    vigencia_fim: '2025-03-19',
    descricao: 'blablabla',
    ativo: true,
})

function salvar() {
    contrato.post(route('regulacao.contratos.store'))
    //console.log(contrato)
}

</script>

<template>

    <Head title="Novo Contrato" />


    <AuthenticatedLayout>

        <!--template #inner_menu>
            <FrotaMenu />
        </template-->
        <SubSection>
            <template #header>
                Novo Contrato
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.57)]">
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <form @submit.prevent="salvar()">
                            <div class="grid grid-cols-5 gap-3 place-items-center">
                                <div class="col-span-5 md:col-span-2 w-full">
                                    <label class="text-sm">
                                        Contrato*
                                    </label>
                                    <input type="text" v-model="contrato.contrato"
                                        class="w-full rounded border border-black text-gray-700" required />

                                    <div v-if="contrato.errors?.contrato"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.contrato">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 md:col-span-1 w-full">
                                    <label class="text-sm">
                                        Ano*
                                    </label>
                                    <input type="text" v-model="contrato.ano"
                                        class="w-full rounded border border-black text-gray-700" required />

                                    <div v-if="contrato.errors?.ano"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.ano">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 w-full grid grid-cols-5 gap-3">

                                    <div class="col-span-5 md:col-span-3 w-full">
                                        <label class="text-sm">
                                            Contratada*
                                        </label>
                                        <input type="text" v-model="contrato.contratada_nome"
                                            class="w-full rounded border border-black text-gray-700" required />

                                        <div v-if="contrato.errors?.contratada_nome"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in contrato.errors?.contratada_nome">{{ error }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-5 md:col-span-2 w-full">
                                        <label class="text-sm inline-flex">
                                            CNPJ Contratada*
                                        </label>
                                        <input type="text" v-model="contrato.contratada_cnpj"
                                            class="w-full rounded border border-black text-gray-700" required />

                                        <div v-if="contrato.errors?.contratada_cnpj"
                                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in contrato.errors?.contratada_cnpj">{{ error }}</small>
                                        </div>
                                    </div>

                                </div>

                                <div class="col-span-5 md:col-span-1 w-full">
                                    <label class="text-sm inline-flex">
                                        Início Vigência*
                                    </label>
                                    <input type="date" v-model="contrato.vigencia_inicio"
                                        class="w-full rounded border border-black text-gray-700" required />

                                    <div v-if="contrato.errors?.vigencia_inicio"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.vigencia_inicio">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 md:col-span-1 w-full">
                                    <label class="text-sm inline-flex">
                                        Fim Vigência*
                                    </label>
                                    <input type="date" v-model="contrato.vigencia_fim"
                                        class="w-full rounded border border-black text-gray-700" required />

                                    <div v-if="contrato.errors?.vigencia_fim"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.vigencia_fim">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 w-full">
                                    <label class="text-sm">
                                        Descrição*
                                    </label>
                                    <textarea type="text" v-model="contrato.descricao" rows="5"
                                        class="w-full rounded border border-black text-gray-700">
                                    </textarea>

                                    <div v-if="contrato.errors?.descricao"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.descricao">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 w-full">

                                    <label for="active" class="flex items-center cursor-pointer max-w-fit">
                                        <div class="relative">
                                            <input type="checkbox" id="active" class="sr-only" :checked="contrato.ativo"
                                                v-model="contrato.ativo" @change="setNumber" />
                                            <div class="bg-gray-200 w-10 h-4 rounded-full shadow-inner"
                                                :class="contrato.ativo ? 'bg-teal-200' : ''">
                                            </div>
                                            <div class="dot absolute w-6 h-4 bg-gray-400 rounded-full shadow -left-1 -top-0 transition"
                                                :class="contrato.ativo ? 'dot-dis bg-green-500' : ''">
                                            </div>
                                        </div>
                                        <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                            Contrato Ativo*
                                        </div>
                                    </label>

                                </div>
                                <div class="col-span-5 w-full">
                                    <button type="submit" @click="saveCar"
                                        class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                        Cadastrar Contrato
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
<style scoped>
input:checked~.dot {
    transform: translateX(100%);
}

input:checked~.dot-dis {
    transform: translateX(100%);
}
</style>