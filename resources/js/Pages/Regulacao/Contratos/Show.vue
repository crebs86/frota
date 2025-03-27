<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';
import { cnpjMask, currencyMask } from "@/mask.js";
import { Column, DataTable } from "primevue";

</script>

<template>

    <Head title="Contratos" />

    <AuthenticatedLayout>

        <SubSection>
            <template #header>
                Detalhes do Contrato
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.57)]">
                    <div class="inline-flex">
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.home')" title="Início Financeiro">
                        <img src="/icons/home.svg" alt="Início Financeiro" class="w-6">
                        </Link>
                        <Link
                            v-if="has($page.props.auth.permissions, ['Contratos Editar', 'Contratos Apagar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 p-1.5 border m-0.5 mb-1 rounded shadow-lg hover:opacity-65"
                            :href="route('regulacao.contratos.edit', $page.props.contrato.id)" title="Editar Contrato">
                        <img src="/icons/editar.svg" alt="Editar Contrato" class="w-6">
                        </Link>
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Ver', 'Contrato Editar', 'Contrato Apagar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.contratos.index')" title="Listar Contratos">
                        <img src="/icons/lista2.svg" alt="Listar Contratos" class="w-6">
                        </Link>
                    </div>
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-1 gap-3">
                            <ul>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Contrato/Ano:</span>
                                    {{ $page.props.contrato.contrato }}/{{ $page.props.contrato.ano }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Ativo:</span>
                                    {{ $page.props.contrato.ativo ? 'Sim' : 'Não' }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Contratada:</span>
                                    {{ $page.props.contrato.contratada_nome }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">CNPJ Contratada:</span>
                                    {{ cnpjMask($page.props.contrato.contratada_cnpj) }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Início Vigência:</span>
                                    {{ moment($page.props.contrato.vigencia_inicio).format('DD/MM/YYYY') }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Fim Vigência:</span>
                                    {{ moment($page.props.contrato.vigencia_fim).format('DD/MM/YYYY') }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Contratante</span> {{ $page.props.contrato.contratante }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Descrição:</span> {{ $page.props.contrato.descricao }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Atualizado por:</span> {{ $page.props.contrato.name }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Criado em:</span>
                                    {{ moment($page.props.contrato.created_at).format('DD/MM/YYYY hh:mm:ss') }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Atualizado em:</span>
                                    {{ moment($page.props.contrato.updated_at).format('DD/MM/YYYY hh:mm:ss') }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Valor Global:</span> R$
                                    {{ currencyMask($page.props.contrato.valor_global) }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Versão:</span>
                                    {{ $page.props.contrato.versao }}
                                </li>
                                <li class="py-2 hover:opacity-70">
                                    <span class="font-bold">Aditivos:</span>
                                    <DataTable
                                        :value="$page.props.contrato.aditivos ? JSON.parse($page.props.contrato.aditivos) : []">
                                        <Column field="valor" header="Valor" sortable style="width: 40%">
                                            <template #body="slotProps">
                                                R$ {{ currencyMask(slotProps.data.valor.toFixed(2)) }}
                                            </template>
                                        </Column>
                                        <Column field="descricao" header="Descrição" sortable style="width: 40%" />
                                    </DataTable>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>

    </AuthenticatedLayout>
</template>
