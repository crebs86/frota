<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import {Head, Link} from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import moment from 'moment';

</script>

<template>

    <Head title="Posto de Coleta"/>

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Posto de Coleta
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('regulacao.financeiro.index')" title="Início Financeiro">
                        <img src="/icons/financeiro.svg" alt="Início Financeiro" class="w-6">
                    </Link>
                    <div class="p-2 rounded-lg overflow-y-auto"
                         :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-3 gap-3 place-items-center">
                            

                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
