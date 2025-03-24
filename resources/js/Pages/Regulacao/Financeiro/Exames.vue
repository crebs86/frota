<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link, router, useForm } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import { Select, Button } from "primevue";
import { ref } from "vue";
import { toast } from "@/toast";
import { currencyMask } from "@/mask.js";

const props = defineProps({
    exames_clinicos: Object | null,
    exames_financeiro: Object | null,
    contratos: Object | null,
})

const contrato = useForm({
    dados: null,
})

function buscarExamesContrato() {
    let dados = contrato.dados;
    contrato.post(route('regulacao.financeiro.exames.exames-por-contrato'), {
        preserveScroll: true,
        onSuccess: (r) => {
            if (r.props.exames_financeiro.length < 1) {
                contrato.dados = dados
                toast.info('Nenhum exame vinculado a este contrato!');
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
            console.log(r.data);
        })
        .catch((e) => {
            if (e.response.status === 409) {
                toast.error(e.response.data)
            }
        })
        .finally(() => {
            exames_clinicos.processing = false
        })
    console.log(params);
}

const exames_clinicos = useForm({
    exames: []
})

function maskCurrency(event) {
    event.preventDefault();
    event.target.value = currencyMask(event.target.value)
}

</script>

<template>

    <Head title="Financeiro - Exames" />

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Financeiro - Exames
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.71)]">
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-6 gap-3 place-items-center">
                            <Select v-model="contrato.dados" :options="props.contratos"
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
                                :disabled="!contrato.dados" />

                            <div class="col-span-6 w-full" v-if="contrato.dados">
                                <ul> Detalhes do Contrato:
                                    <li>Contrato: {{ contrato.dados.contrato }}</li>
                                    <li>Ano: {{ contrato.dados.ano }}</li>
                                    <li>Contratada: {{ contrato.dados.contratada_nome }}</li>
                                    <li>Vigência: {{ moment(contrato.dados.vigencia_inicio).format('DD/MM/YYYY') }}
                                    </li>
                                </ul>
                            </div>

                            <div class="col-span-6 w-full grid grid-cols-6"
                                v-else-if="props.exames_financeiro && props.exames_financeiro.length > 0">
                                <p
                                    class="col-span-6 uppercase text-lg font-extrabold border-s-2 pl-2 mt-4 mb-2 border-s-blue-500 bg-blue-400/40">
                                    Cadastrar exames para este contrato
                                </p>
                                <form @submit.prevent="verificarESalvar()" class="col-span-6" id="valores">
                                    <Button type="submit" label="Verificar e Salvar" severity="success"
                                        :disabled="!contrato.dados" />
                                </form>
                            </div>

                            <div class="col-span-6 w-full grid grid-cols-6"
                                v-else-if="props.exames_financeiro && props.exames_financeiro.length === 0">
                                <p
                                    class="col-span-6 uppercase text-lg font-extrabold border-s-2 pl-2 mt-4 mb-2 border-s-blue-500 bg-blue-400/40">
                                    Cadastrar exames para este contrato
                                </p>
                                <form @submit.prevent="verificarESalvar()" class="col-span-6" id="valores">
                                    <Button type="submit" label="Verificar e Salvar" severity="success"
                                        :disabled="!contrato.dados" />
                                    <div class="cols-span-6 w-full my-2 border-b"
                                        v-for="(v, i) in props.exames_clinicos" :key="i">
                                        <label class="text-sm flex" :for="v.id">
                                            {{ v.Descricao }}*
                                        </label>
                                        <input type="text" :name="v.id" :id="v.id" @keyup="maskCurrency($event)"
                                            class="w-full rounded border border-black text-gray-700"
                                            placeholder="Valor unitário (R$)" />
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

                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
