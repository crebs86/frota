<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link, router, useForm } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
//import moment from 'moment';
import { ref } from 'vue';
import { Button, Dialog, InputText, Textarea, Select } from 'primevue';
import { toast } from '@/toast';

const props = defineProps({
    branches: Object | null,
    errors: Object
})

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

const modal = ref({
    novoPosto: false
});

const postoColeta = useForm({
    hash: null
});

const _branch = ref(null);

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
            modal.value.novoPosto = false;
            toast.success('Unidade criada com sucesso.');
            router.visit(route('regulacao.financeiro.posto-coleta.create'), {
                only: ['branches']
            })
        })
        .catch((e) => {
            toast.error('Foram encontrado erros ao processar sua solicitação.');
            if (e.response?.status === 422) {
                branch.value.errors = e.response?.data?.errors
            } else {
                console.log(e)
            }
        }).finally(() => {
            branch.value.processing = false;
        })
}

function salvarPostoColeta() {
    postoColeta.hash = _branch.value?.hash;
    if (postoColeta.hash) {
        postoColeta.post(route('regulacao.financeiro.posto-coleta.store'), {
            onSuccess: () => {
                toast.success('Posto de Coleta foi vinculado a unidade.');
                router.visit(route('regulacao.financeiro.posto-coleta.create'), {
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
        toast.error('Selecione uma unidades para cadatrar como posto de coleta.');
    }
}

</script>

<template>

    <Head title="Criar Posto de Coleta" />

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Criar Posto de Coleta
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <div class="inline-flex">
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.financeiro.index')" title="Início Financeiro">
                        <img src="/icons/financeiro.svg" alt="Início Financeiro" class="w-6">
                        </Link>
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.financeiro.index')" title="Adicionar Posto de Coleta">
                        <img src="/icons/add.svg" alt="Adicionar Posto de Coleta" class="w-6">
                        </Link>
                    </div>

                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-3 gap-3 place-items-center">

                            <div class="relative mb-6 w-full z-auto col-span-3">
                                <div class="mt-2">
                                    <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                        Selecione uma unidade para cadastrar Posto de Coleta
                                        <button @click="modal.novoPosto = true"
                                            class="border-2 border-teal-500 rounded-md mx-2 -mt-0.5 hover:opacity-70 hover:text-green-500 mb-2">
                                            <mdicon name="source-branch-plus" title="Nova Unidade" />
                                        </button>
                                    </label>

                                    <Select v-model="_branch" :options="props.branches"
                                        placeholder="Selecione um contrato" class="w-full col-span-5" filter
                                        option-label="name">
                                    </Select>

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
                                <button type="button" @click="salvarPostoColeta"
                                    class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                    Cadastrar Posto de Coleta
                                </button>
                            </div>

                            <Dialog v-model:visible="modal.novoPosto" modal header="Cadastrar Unidade"
                                :style="{ width: '98%', maxWidth: '650px' }">
                                <form @submit.prevent="createBranch()">

                                    <div class="grid gap-4 mb-4">
                                        <label for="nome" class="font-semibold w-24">Nome*</label>
                                        <InputText v-model="branch.name" id="nome" class="flex-auto" autocomplete="off"
                                            required />

                                        <div v-if="branch.errors.name" class="text-sm text-red-500">
                                            <p v-for="error in branch.errors.name">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="grid gap-4 mb-4">
                                        <label for="cnpj" class="font-semibold w-24">CNPJ</label>
                                        <InputText v-model="branch.cnpj" id="cnpj" class="flex-auto"
                                            autocomplete="off" />

                                        <div v-if="branch.errors.cnpj" class="text-sm text-red-500">
                                            <p v-for="error in branch.errors.cnpj">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="grid gap-4 mb-4">
                                        <label for="email" class="font-semibold w-24">E-mail</label>
                                        <InputText v-model="branch.email" id="email" class="flex-auto"
                                            autocomplete="off" />

                                        <div v-if="branch.errors.email" class="text-sm text-red-500">
                                            <p v-for="error in branch.errors.email">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="grid gap-4 mb-4">
                                        <label for="cep" class="font-semibold w-24">CEP</label>
                                        <InputText v-model="branch.cep" id="cep" class="flex-auto" autocomplete="off" />

                                        <div v-if="branch.errors.cep" class="text-sm text-red-500">
                                            <p v-for="error in branch.errors.cep">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="grid gap-4 mb-4">
                                        <label for="address" class="font-semibold w-24">Endereço*</label>
                                        <InputText v-model="branch.address" id="address" class="flex-auto"
                                            autocomplete="off" required />

                                        <div v-if="branch.errors.address" class="text-sm text-red-500">
                                            <p v-for="error in branch.errors.address">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="grid gap-4 mb-4">
                                        <label for="phones" class="font-semibold w-24">Contatos</label>
                                        <InputText v-model="branch.phones" id="phones" class="flex-auto"
                                            autocomplete="off" />

                                        <div v-if="branch.errors.phones" class="text-sm text-red-500">
                                            <p v-for="error in branch.errors.phones">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="grid gap-4 mb-8">
                                        <label for="Observações" class="font-semibold w-24">Observações</label>
                                        <Textarea id="Observações" class="flex-auto" maxlength="255"
                                            v-model="branch.notes" autocomplete="off" />

                                        <div v-if="branch.errors.notes" class="text-sm text-red-500">
                                            <p v-for="error in branch.errors.notes">{{ error }}</p>
                                        </div>
                                    </div>

                                    <div class="flex justify-end gap-2">
                                        <Button type="button" label="Cancelar" severity="secondary"
                                            @click="modal.novoPosto = false"></Button>
                                        <Button type="submit" label="Inserir" :disabled="branch.processing"></Button>
                                    </div>
                                </form>
                            </Dialog>

                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
