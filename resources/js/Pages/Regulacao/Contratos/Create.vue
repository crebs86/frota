<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import {Head, Link, useForm} from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import {toast} from '@/toast';
import {currencyMask, cnpjMask} from '@/mask';
import {onBeforeMount, ref} from 'vue';
import {Button, Dialog, InputText, Textarea, DataTable, Column, Row} from 'primevue';

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
    contratante: '',
    aditivos: '',
    descricao: '',
    ativo: true,
    valor: null,
    hash: null
})

const modal = ref({
    aditivo: false,
    editarAditivo: false,
    excluirAditivo: false,
})

function salvar() {
    contrato.valor_global = contrato.valor.replaceAll('.', '').replace(',', '.')
    if (props.editar) {
        contrato.put(route('regulacao.contratos.update', props.hash), {
            preserveScroll: true,
            onSuccess: () => {
                toast.success('Contrato atualizado com sucesso.')
            }
        })
    } else {
        contrato.post(route('regulacao.contratos.store'), {
            onSuccess: () => {
                toast.success('Contrato cadastrado com sucesso.')
            }
        })
    }
}

const aditivo = useForm({
    previa: null,
    valor: 0,
    descricao: '',
})

function inserirAditivo() {
    aditivo.valor = aditivo.previa.replaceAll('.', '').replace(',', '.')
    aditivo.post(route('regulacao.contratos.aditivo.insert', props.hash), {
        preserveScroll: true,
        onSuccess: (r) => {
            if (r.props.flash.error) {
                toast.error(r.props.flash.error)
                throw r.props.flash.error
            }
            toast.success('Aditivo inserido com sucesso.')
            modal.value.aditivo = false;
            contrato.aditivos = r.props.contrato.aditivos;
            aditivo.reset()
        },
        onError: () => {
            toast.error('Erro ao inserir aditivo.')
        }
    })
}

const maskCNPJ = (event) => {
    let input = event.target;
    contrato.contratada_cnpj = cnpjMask(input.value);
}


function somar(aditivos) {
    let total = (props.contrato.valor_global);
    //console.log(total, props.contrato.valor_global);
    JSON.parse(aditivos).forEach((item) => {
        //console.log(parseFloat(total) + parseFloat(item.valor));
        total = parseFloat(total) + parseFloat(item.valor);
    });
    return 'R$ ' + currencyMask(parseFloat(total.toString()).toFixed(2))
}

const aditivoEditar = useForm({
    indice: '',
    previa: null,
    valor: 0,
    descricao: '',
})

function editarAditivo(aditivo) {
    //console.log(parseFloat(aditivo.valor).toFixed(2));
    modal.value.editarAditivo = true;
    aditivoEditar.previa = currencyMask(parseFloat(aditivo.valor).toFixed(2))
    aditivoEditar.descricao = aditivo.descricao
    aditivoEditar.indice = aditivo.indice
}

function atualizarAditivo() {
    aditivoEditar.valor = aditivoEditar.previa.replaceAll('.', '').replace(',', '.')
    aditivoEditar.put(route('regulacao.contratos.aditivo.update', props.hash), {
        preserveScroll: true,
        onSuccess: (r) => {
            if (r.props.flash.error) {
                toast.error(r.props.flash.error)
                throw r.props.flash.error
            }
            toast.success('Aditivo atualizado.')
            modal.value.editarAditivo = false;
            contrato.aditivos = r.props.contrato.aditivos;
            aditivoEditar.reset()
        }
    })
}

const aditivoExcluir = useForm({
    indice: '',
    valor: 0,
    descricao: '',
})

function excluirAditivo(aditivo) {
    modal.value.excluirAditivo = true
    aditivoExcluir.valor = currencyMask(parseFloat(aditivo.valor).toFixed(2))
    aditivoExcluir.descricao = aditivo.descricao
    aditivoExcluir.indice = aditivo.indice
}

function removerAditivo() {
    aditivoExcluir.delete(route('regulacao.contratos.aditivo.remover', props.hash), {
        preserveScroll: true,
        onSuccess: (r) => {
            if (r.props.flash.error) {
                toast.error(r.props.flash.error)
                throw r.props.flash.error
            }
            modal.value.excluirAditivo = false;
            toast.success('Aditivo removido do contrato.')
            contrato.aditivos = r.props.contrato.aditivos;
            aditivoExcluir.reset()
        },
        onError: () => {
            toast.error('Erro ao remover aditivo do contrato.')
        },
    })
}

onBeforeMount(() => {
    if (props.editar) {
        contrato.contrato = props.contrato.contrato
        contrato.ano = props.contrato.ano
        contrato.contratada_nome = props.contrato.contratada_nome
        contrato.contratada_cnpj = cnpjMask(props.contrato.contratada_cnpj)
        contrato.vigencia_inicio = props.contrato.vigencia_inicio
        contrato.vigencia_fim = props.contrato.vigencia_fim
        contrato.valor = currencyMask(props.contrato.valor_global)
        contrato.contratante = props.contrato.contratante
        contrato.aditivos = props.contrato.aditivos
        contrato.descricao = props.contrato.descricao
        contrato.ativo = props.contrato.ativo
        contrato.hash = props.hash
    }
})

</script>

<template>

    <Head title="Novo Contrato"/>


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
                                           :disabled="props.editar"/>

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
                                           :disabled="props.editar"/>

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
                                               class="w-full rounded border border-black text-gray-700" maxlength="255"
                                               required/>

                                        <div v-if="contrato.errors?.contratada_nome"
                                             class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                            <small v-for="error in contrato.errors?.contratada_nome">{{ error }}</small>
                                        </div>
                                    </div>

                                    <div class="col-span-5 md:col-span-2 w-full">
                                        <label class="text-sm inline-flex">
                                            CPF/CNPJ Contratada*
                                        </label>
                                        <input type="text" v-model="contrato.contratada_cnpj"
                                               @keyup="maskCNPJ($event)" maxlength="18"
                                               class="w-full rounded border border-black text-gray-700" required/>

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
                                           class="w-full rounded border border-black text-gray-700" required/>

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
                                           class="w-full rounded border border-black text-gray-700" required/>

                                    <div v-if="contrato.errors?.vigencia_fim"
                                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.vigencia_fim">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 md:col-span-1 w-full">
                                    <label class="text-sm inline-flex">
                                        Valor Global (R$)*
                                    </label>
                                    <input type="text" v-model="contrato.valor"
                                           @keyup="contrato.valor = currencyMask($event.target.value)"
                                           class="w-full rounded border border-black text-gray-700" maxlength="14"
                                           required/>

                                    <div v-if="contrato.errors?.valor_global"
                                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.valor_global">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 md:col-span-2 w-full">
                                    <label class="text-sm">
                                        Contratante*
                                    </label>
                                    <input type="text" v-model="contrato.contratante"
                                           class="w-full rounded border border-black text-gray-700" maxlength="255"
                                           required/>

                                    <div v-if="contrato.errors?.contratante"
                                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.contratante">{{ error }}</small>
                                    </div>
                                </div>

                                <div class="col-span-5 w-full">
                                    <label class="text-sm">
                                        Descrição*
                                    </label>
                                    <textarea type="text" v-model="contrato.descricao" rows="5" maxlength="550"
                                              class="w-full rounded border border-black text-gray-700">
                                    </textarea>
                                    <small class="text-xs">Insira até {{ 550 - contrato.descricao.length }}
                                        caracteres</small>

                                    <div v-if="contrato.errors?.descricao"
                                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.descricao">{{ error }}</small>
                                    </div>
                                </div>
                                <div class="col-span-5 w-full">

                                    <label for="active" class="flex items-center cursor-pointer max-w-fit">
                                        <div class="relative">
                                            <input type="checkbox" id="active" class="sr-only" :checked="contrato.ativo"
                                                   v-model="contrato.ativo"/>
                                            <div class="bg-gray-200 w-10 h-4 rounded-full shadow-inner"
                                                 :class="contrato.ativo ? 'bg-teal-200' : ''">
                                            </div>
                                            <div
                                                class="dot absolute w-6 h-4 bg-gray-400 rounded-full shadow -left-1 -top-0 transition"
                                                :class="contrato.ativo ? 'dot-dis bg-green-500' : ''">
                                            </div>
                                        </div>
                                        <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                            Contrato Ativo*
                                        </div>
                                    </label>

                                </div>
                                <div class="col-span-5 w-full">
                                    Aditivos
                                </div>
                                <div class="col-span-5 w-full" v-if="props.editar">
                                    <DataTable :value="contrato.aditivos ? JSON.parse(contrato.aditivos) : []">
                                        <Column field="valor" header="Valor" sortable style="width: 40%">
                                            <template #body="slotProps">
                                                R$ {{ currencyMask(slotProps.data.valor.toFixed(2)) }}
                                            </template>
                                        </Column>
                                        <Column field="descricao" header="Descrição" sortable style="width: 40%"/>
                                        <Column field="indice" header="Ações" style="width: 20%">
                                            <template #body="slotProps">
                                                <div class="flex justify-center gap-3">
                                                    <button type="button"
                                                            @click.prevent="excluirAditivo(slotProps.data)"
                                                            title="Excluir Aditivo"
                                                            v-if="has(
                                                                    $page.props.auth.permissions, ['Contratos Editar', 'Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])
                                                            ">
                                                        <img src="/icons/lixeira3.svg" alt="Excluir Aditivo"
                                                             class="min-w-9 w-9 hover:opacity-75"/>
                                                    </button>
                                                    <button type="button"
                                                            @click.prevent="editarAditivo(slotProps.data)"
                                                            title="Excluir Aditivo"
                                                            v-if="has(
                                                                    $page.props.auth.permissions, ['Contratos Editar', 'Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                                        <img src="/icons/editar.svg" alt="Editar Aditivo"
                                                             class="min-w-9 w-9 hover:opacity-75"/>
                                                    </button>
                                                </div>
                                            </template>
                                        </Column>
                                    </DataTable>

                                    <div class="col-span-5 w-full">
                                        Total atual do contrato:
                                        {{ somar(contrato.aditivos) }}
                                    </div>
                                </div>
                                <div class="col-span-5 w-full" v-if="props.editar">

                                    <label class="text-sm flex">
                                        Inserir Aditivo*
                                    </label>

                                    <button type="button" @click.prevent="modal.aditivo = true"
                                            class="border border-teal-600 bg-teal-500 text-teal-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-teal-700 focus:outline-none focus:shadow-outline">
                                        Inserir Aditivo
                                    </button>
                                    <div v-if="contrato.errors?.descricao"
                                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                        <small v-for="error in contrato.errors?.descricao">{{ error }}</small>
                                    </div>
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

                        <Dialog v-model:visible="modal.aditivo" modal header="Inserir Aditivo"
                                :style="{ width: '98%', maxWidth: '500px' }">
                            <div class="grid gap-4 mb-4">
                                <label for="valor" class="font-semibold w-24">Valor (R$)</label>
                                <InputText v-model="aditivo.previa" id="valor" class="flex-auto"
                                           @keyup="aditivo.previa = currencyMask($event.target.value)"
                                           autocomplete="off"/>
                            </div>
                            <div class="grid gap-4 mb-8">
                                <label for="detalhes" class="font-semibold w-24">Detalhes</label>
                                <Textarea id="detalhes" class="flex-auto" maxlength="550"
                                          v-model="aditivo.descricao" autocomplete="off"/>
                            </div>
                            <div class="flex justify-end gap-2">
                                <Button type="button" label="Cancelar" severity="secondary"
                                        @click="modal.aditivo = false"></Button>
                                <Button type="button" label="Inserir"
                                        @click="inserirAditivo()"></Button>
                            </div>
                        </Dialog>

                        <Dialog v-model:visible="modal.editarAditivo" modal header="Editar Aditivo"
                                :style="{ width: '98%', maxWidth: '500px' }">
                            <div class="grid gap-4 mb-4">
                                <label for="valor" class="font-semibold w-24">Valor (R$)</label>
                                <InputText v-model="aditivoEditar.previa" id="valor" class="flex-auto"
                                           @keyup="aditivoEditar.previa = currencyMask($event.target.value)"
                                           autocomplete="off"/>
                            </div>
                            <div class="grid gap-4 mb-8">
                                <label for="detalhes" class="font-semibold w-24">Detalhes</label>
                                <Textarea id="detalhes" class="flex-auto" maxlength="550"
                                          v-model="aditivoEditar.descricao" autocomplete="off"/>
                            </div>
                            <div class="flex justify-end gap-2">
                                <Button type="button" label="Cancelar" severity="secondary"
                                        @click="modal.editarAditivo = false"></Button>
                                <Button type="button" label="Atualizar"
                                        @click="atualizarAditivo()"></Button>
                            </div>
                        </Dialog>

                        <Dialog v-model:visible="modal.excluirAditivo" modal header="Remover Aditivo"
                                :style="{ width: '98%', maxWidth: '500px' }">
                            <div class="grid gap-4 mb-4">
                                <label for="valor" class="font-semibold w-24">Valor (R$)</label>
                                <InputText v-model="aditivoExcluir.valor" id="valor" class="flex-auto"
                                           autocomplete="off" readonly/>
                            </div>
                            <div class="grid gap-4 mb-8">
                                <label for="detalhes" class="font-semibold w-24">Detalhes</label>
                                <Textarea id="detalhes" class="flex-auto" maxlength="550"
                                          v-model="aditivoExcluir.descricao" autocomplete="off" readonly/>
                            </div>
                            <div class="flex justify-end gap-2">
                                <Button type="button" label="Cancelar" severity="secondary"
                                        @click="modal.excluirAditivo = false"></Button>
                                <Button type="button" label="Remover" severity="danger"
                                        @click="removerAditivo()"></Button>
                            </div>
                        </Dialog>

                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
<style scoped>
input:checked ~ .dot {
    transform: translateX(100%);
}

input:checked ~ .dot-dis {
    transform: translateX(100%);
}
</style>
