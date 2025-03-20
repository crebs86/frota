<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import { toast } from '@/toast';
import { currencyMask } from '@/mask';
import { onMounted } from 'vue';

const props = defineProps({
    editar: Boolean,
    contrato: Object | null,
    hash: String
})

const contrato = useForm({
    contrato: '',
    ano: '',
    contratada_nome: '',
    contratada_cnpj: '',
    vigencia_inicio: '',
    vigencia_fim: '',
    valor_global: 0,
    aditivos: '',
    descricao: '',
    ativo: true,
    valor: null,
    hash: null
})

function salvar() {
    if (props.editar) {
        contrato.valor_global = contrato.valor.replaceAll('.', '').replace(',', '.')
        contrato.put(route('regulacao.contratos.update', props.hash), {
            onSuccess: () => {
                toast.success('Contrato atualizado com sucesso.')
            }
        })
    } else {
        contrato.valor_global = contrato.valor.replaceAll('.', '').replace(',', '.')
        contrato.post(route('regulacao.contratos.store'), {
            onSuccess: () => {
                toast.success('Contrato cadastrado com sucesso.')
            }
        })
    }
}

const maskCurrency = (event) => {
    let input = event.target;
    contrato.valor = currencyMask(input.value);
}

onMounted(() => {
    if (props.editar) {
        contrato.contrato = props.contrato.contrato
        contrato.ano = props.contrato.ano
        contrato.contratada_nome = props.contrato.contratada_nome
        contrato.contratada_cnpj = props.contrato.contratada_cnpj
        contrato.vigencia_inicio = props.contrato.vigencia_inicio
        contrato.vigencia_fim = props.contrato.vigencia_fim
        contrato.valor = currencyMask(props.contrato.valor_global)
        contrato.aditivos = props.contrato.aditivos
        contrato.descricao = props.contrato.descricao
        contrato.ativo = props.contrato.ativo
        contrato.hash = props.hash
    }
})

</script>

<template>

    <Head title="Novo Contrato" />


    <AuthenticatedLayout>

        <SubSection>
            <template #header>
                {{ props.editar ? 'Editando Contrato ' + contrato.contrato + '/' + contrato.ano : 'Novo Contrato' }}
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.57)]">
                    <div class="inline-flex">
                        <Link
                            v-if="props.edit && has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.contratos.create')" title="Novo Contrato">
                        <img src="/icons/add.svg" alt="Novo Contrato" class="w-6">
                        </Link>
                        <Link
                            v-if="props.edit && has(
                                $page.props.auth.permissions, ['Contrato Ver', 'Contrato Editar', 'Contrato Apagar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.contratos.index')" title="Listar Contratos">
                        <img src="/icons/lista2.svg" alt="Listar Contratos" class="w-6">
                        </Link>
                    </div>
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <form @submit.prevent="salvar()">
                            <div class="grid grid-cols-5 gap-3 place-items-center">
                                <div class="col-span-5 md:col-span-2 w-full">
                                    <label class="text-sm">
                                        Contrato*
                                    </label>
                                    <input type="text" v-model="contrato.contrato"
                                        :class="props.editar ? 'bg-gray-400 cursor-not-allowed' : ''"
                                        class="w-full rounded border border-black text-gray-700" required
                                        :disabled="props.editar" />

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
                                        :class="props.editar ? 'bg-gray-400 cursor-not-allowed' : ''"
                                        class="w-full rounded border border-black text-gray-700" required
                                        :disabled="props.editar" />

                                    <div v-if="contrato.errors?.ano"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.ano">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 md:col-span-2 w-full">
                                    <small class="text-red-500">
                                        Após cadastrado, não é possível editar o número e ano do contrato.
                                    </small>
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

                                <div class="col-span-5 md:col-span-2 w-full">
                                    <label class="text-sm inline-flex">
                                        Valor Global (R$)*
                                    </label>
                                    <input type="text" v-model="contrato.valor" @keyup="maskCurrency($event)"
                                        class="w-full rounded border border-black text-gray-700" maxlength="14"
                                        required />

                                    <div v-if="contrato.errors?.valor_global"
                                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.valor_global">{{ error }}</small>
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
                                <div class="col-span-5 inline-flex gap-3">
                                    <div v-if="props.editar">
                                        <button type="submit"
                                            class="border border-blue-600 bg-blue-500 text-blue-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                                            Salvar Contrato
                                        </button>
                                    </div>
                                    <div v-else>
                                        <button type="submit"
                                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                            Cadastrar Contrato
                                        </button>
                                    </div>
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