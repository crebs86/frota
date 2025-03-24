<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import {Head, Link, router, useForm} from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import {Select, Button, Dialog, Textarea, InputText, DataTable, Column} from "primevue";
import {FilterMatchMode} from '@primevue/core/api';
import {onBeforeMount, onMounted, ref} from "vue";
import {toast} from "@/toast";
import {currencyMask} from "@/mask.js";

const props = defineProps({
    exames_clinicos: Object | null,
    exames_financeiro: Object | null,
    contratos: Object | null,
    dados: Object | null,
})

const contrato = useForm({
    dados: null,
})

const lista_exames_clinicos = ref([])

const visible = ref(false);

const modal = ref({
    editarValor: false,
});

function buscarExamesContrato() {
    let dados = contrato.dados;
    //contrato.post(route('regulacao.financeiro.exames.exames-por-contrato'), {
    contrato.get(route('regulacao.financeiro.exames.index', contrato.dados.hash), {
        preserveScroll: true,
        onFinish: () => {
            contrato.dados = dados
        },
        onSuccess: (r) => {
            if (r.props.exames_financeiro.length < 1) {
                visible.value = true
                toast.info('Nenhum exame vinculado a este contrato!');
            } else {
                lista_exames_clinicos.value = r.props.exames_financeiro
            }
        }
    })

}

function verificarESalvar() {
    exames_clinicos.processing = true
    let form = document.querySelector('form');
    let params = new FormData(form);
    axios.post(route('regulacao.financeiro.exames.salvar-exames-por-contrato', contrato.dados.hash), params)
        .then((r) => {
            toast.success(r.data);
            buscarExamesContrato()
        })
        .catch((e) => {
            if (e.response.status === 409) {
                toast.error(e.response.data)
            }
        })
        .finally(() => {
            exames_clinicos.processing = false
        })
}

const exames_clinicos = useForm({
    exames: []
})

function maskCurrency(event) {
    event.preventDefault();
    event.target.value = currencyMask(event.target.value)
}

const exameAtual = ref({
    id: null,
    exame: null,
    codigo: null,
    valor: null,
    hash: null
})

function editarValor(exame) {
    modal.value.editarValor = true
    exameAtual.value = exame
    exameAtual.value.valor = currencyMask(exame.valor)
    exameAtual.value.original = currencyMask(exame.valor)
}

function salvarNovoValorExame() {
    axios.put(route('regulacao.financeiro.exames.atualizar-valor-exame', exameAtual.value.hash), exameAtual.value)
        .then((r) => {
            toast.success(r.data)
            modal.value.editarValor = false
        })
        .catch((e) => {
            exameAtual.value.valor = exameAtual.value.original
            if (e.response.status === 409) {
                toast.error(e.response.data)
            } else if (e.response.status === 422) {
                toast.error(e.response.data.message)
            } else {
                console.error(e)
            }
        })
        .finally(() => {
        })
}

const filters = ref({
    global: {value: null, matchMode: FilterMatchMode.CONTAINS},
    exame: {value: null, matchMode: FilterMatchMode.IN}
})

onBeforeMount(() => {
    contrato.dados = props.dados;
    lista_exames_clinicos.value = props.exames_financeiro
    visible.value = props.exames_financeiro?.length === 0
})

</script>

<template>

    <Head title="Financeiro - Exames"/>

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Financeiro - Exames
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.71)]">
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('regulacao.financeiro.index')" title="Início Financeiro">
                        <img src="/icons/financeiro.svg" alt="Início Financeiro" class="w-6">
                    </Link>
                    <div class="p-2 rounded-lg overflow-y-auto"
                         :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-6 gap-3 place-items-center">
                            <Select v-model="contrato.dados" :options="props.contratos"
                                    :selected="contrato.dados"
                                    @change="lista_exames_clinicos = []; visible = false"
                                    placeholder="Selecione um contrato" class="w-full col-span-5" filter
                                    option-label="contratada_nome">
                                <template #option="slotProps">
                                    <div class="flex items-center">
                                        <div>{{ slotProps.option.contrato }}/{{ slotProps.option.ano }} -
                                            {{ slotProps.option.contratada_nome }}
                                        </div>
                                    </div>
                                </template>
                            </Select>
                            <Button label="Selecionar" severity="success" @click="buscarExamesContrato()"
                                    :disabled="!contrato.dados"/>

                            <div class="col-span-6 w-full text-lg" v-if="contrato.dados">
                                <ul> Detalhes do Contrato
                                    <li>Contrato: {{ contrato.dados?.contrato }}</li>
                                    <li>Ano: {{ contrato.dados?.ano }}</li>
                                    <li>Contratada: {{ contrato.dados?.contratada_nome }}</li>
                                    <li>Vigência: {{ moment(contrato.dados?.vigencia_inicio).format('DD/MM/YYYY') }}
                                    </li>
                                </ul>
                            </div>

                            <div class="col-span-6 w-full grid grid-cols-6"
                                 v-if="lista_exames_clinicos && lista_exames_clinicos.length > 0">
                                <p
                                    class="col-span-6 uppercase text-lg font-extrabold border-s-2 pl-2 mt-4 mb-2 border-s-yellow-500 bg-yellow-400/40">
                                    Listar exames do contrato {{ contrato.dados?.contrato }}/{{ contrato.dados?.ano }}
                                </p>
                                <DataTable v-model:filters="filters" :value="props.exames_financeiro"
                                           tableStyle="min-width: 50rem"
                                           :global-filter-fields="['exame']" class="col-span-6">
                                    <template #header>
                                        <div class="flex justify-end">
                                            <IconField>
                                                <InputIcon>
                                                    <i class="pi pi-search"/>
                                                </InputIcon>
                                                <InputText v-model="filters['global'].value"
                                                           placeholder="Filtrar por nome do exame"/>
                                            </IconField>
                                        </div>
                                    </template>
                                    <Column field="exame" header="Exame" sortable style="width: 50%"></Column>
                                    <Column field="valor" header="Valor" sortable style="width: 15%">
                                        <template #body="slotProps">
                                            {{ currencyMask(slotProps.data.valor) }}
                                        </template>
                                    </Column>
                                    <Column field="codigo" header="Código" sortable style="width: 15%">
                                    </Column>
                                    <Column header="Ações" style="width: 15%">
                                        <template #body="slotProps">
                                            <div class="flex justify-center gap-3">
                                                <button @click="editarValor(slotProps.data)">
                                                    <img src="/icons/editar.svg" alt="Editar Valor" title="Editar Valor"
                                                         class="min-w-9 w-9 hover:opacity-75"/>
                                                </button>
                                            </div>
                                        </template>
                                    </Column>
                                </DataTable>
                            </div>

                            <div class="col-span-6 w-full grid grid-cols-6"
                                 v-else-if="props.exames_financeiro && props.exames_financeiro.length === 0 && visible">
                                <p
                                    class="col-span-6 uppercase text-lg font-extrabold border-s-2 pl-2 mt-4 mb-2 border-s-blue-500 bg-blue-400/40">
                                    Cadastrar exames para o contrato
                                    {{ contrato.dados?.contrato }}/{{ contrato.dados?.ano }}
                                </p>
                                <form @submit.prevent="verificarESalvar()" class="col-span-6" id="valores">
                                    <Button type="submit" label="Verificar e Salvar" severity="success"
                                            :disabled="!contrato.dados"/>
                                    <div class="cols-span-6 w-full my-2 border-b"
                                         v-for="(v, i) in props.exames_clinicos" :key="i">
                                        <label class="text-sm flex" :for="v.id">
                                            {{ v.Descricao }}*
                                        </label>
                                        <input type="text" :name="v.id" :id="v.id" @keyup="maskCurrency($event)"
                                               class="w-full rounded border border-black text-gray-700"
                                               placeholder="Valor unitário (R$)"/>
                                        <div>
                                            <ul> Detalhes
                                                <li><span class="font-bold">Código Externo: </span>
                                                    {{ v.CodigoExterno }}
                                                </li>
                                                <li><span class="font-bold">Exclusivo UPA: </span>
                                                    {{ v.ExameParaProntoAtendimento ? 'sim' : 'não' }}
                                                </li>
                                                <li><span class="font-bold">Autorização Prévia: </span>
                                                    {{ v.ExameAutorizacaoPrevia ? 'sim' : 'não' }}
                                                </li>
                                                <li><span class="font-bold">Informar Data Início Sintomas: </span>
                                                    {{ v.InformarDataInicioSintoma ? 'sim' : 'não' }}
                                                </li>
                                                <li><span class="font-bold">Material para Lacen: </span>
                                                    {{ v.ExameParaLACEN ? 'sim' : 'não' }}
                                                </li>
                                                <li><span class="font-bold">Sexo: </span>
                                                    {{ v.Sexo }}
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <Dialog v-model:visible="modal.editarValor" modal header="Editar Valor Exame"
                                    :style="{ width: '98%', maxWidth: '550px' }">
                                <form @submit.prevent="salvarNovoValorExame()">
                                    {{ exameAtual }}
                                    <div class="grid gap-4 mb-8">
                                        <ul class="space-y-3">
                                            <li>Exame: {{ exameAtual.exame }}</li>
                                            <li>Código: {{ exameAtual.codigo }}</li>
                                        </ul>
                                    </div>
                                    <div class="grid gap-4 mb-4">
                                        <label for="valor" class="font-semibold w-24">Novo Valor (R$)</label>
                                        <InputText v-model="exameAtual.valor" id="valor" class="flex-auto"
                                                   @keyup="exameAtual.valor = currencyMask($event.target.value)"
                                                   autocomplete="off" required/>
                                    </div>
                                    <div class="flex justify-end gap-2">
                                        <Button type="button" label="Cancelar" severity="secondary"
                                                @click="modal.editarValor = false; exameAtual.valor = exameAtual.original"></Button>
                                        <Button type="submit" label="Atualizar"></Button>
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
