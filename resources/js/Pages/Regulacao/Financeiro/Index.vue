<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';

</script>

<template>

    <Head title="Financeiro" />

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Financeiro
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('regulacao.home')" title="Início Financeiro">
                    <img src="/icons/home.svg" alt="Início Financeiro" class="w-6">
                    </Link>

                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-3 gap-3 place-items-center">

                            <Link :href="route('regulacao.financeiro.exames.index')">
                            <button class="flex flex-col items-center max-w-fit hover:opacity-75">
                                <img src="/icons/laboratorio4.svg" alt="Exames" class="min-w-16 w-24">
                                <span>Exames</span>
                            </button>
                            </Link>

                            <Link :href="route('regulacao.financeiro.cota.index')">
                            <button class="flex flex-col items-center max-w-fit hover:opacity-75">
                                <img src="/icons/cash3.svg" alt="Cotas" class="min-w-16 w-24">
                                <span>Cotas</span>
                            </button>
                            </Link>

                            <Link :href="route('regulacao.financeiro.posto-coleta.index')">
                            <button class="flex flex-col items-center max-w-fit hover:opacity-75">
                                <img src="/icons/hospital6.svg" alt="Cotas" class="min-w-16 w-24">
                                <span>Postos de Coleta</span>
                            </button>
                            </Link>

                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
