<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import {Head, Link} from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';

</script>

<template>

    <Head title="Financeiro"/>

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Financeiro
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
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
