<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, Link } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';

</script>

<template>

    <Head title="Regulação" />


    <AuthenticatedLayout>

        <!--template #inner_menu>
            <FrotaMenu />
        </template-->
        <SubSection>
            <template #header>
                Regulação
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-3 gap-3 place-items-center">

                            <Link :href="route('regulacao.agenda.index')">
                            <button class="flex flex-col items-center max-w-fit hover:opacity-75">
                                <img src="/icons/agenda.svg" alt="Agenda Unidade" class="min-w-16 w-24">
                                <span>Agenda</span>
                            </button>
                            </Link>

                            <Link :href="route('regulacao.financeiro.index')">
                            <button class="flex flex-col items-center max-w-fit hover:opacity-75">
                                <img src="/icons/financeiro.svg" alt="Controle Financeiro" class="min-w-16 w-24">
                                <span>Financeiro</span>
                            </button>
                            </Link>

                            <Link :href="route('regulacao.contratos.index')">
                            <button class="flex flex-col items-center max-w-fit hover:opacity-75">
                                <img src="/icons/laboratorio5.svg" alt="Contratos" class="min-w-16 w-24">
                                <span>Contratos</span>
                            </button>
                            </Link>

                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
