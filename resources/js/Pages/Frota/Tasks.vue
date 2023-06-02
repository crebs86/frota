<script setup>
import SimpleTable from '@/Components/Frota/SimpleTable.vue';
import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import { Head, Link } from '@inertiajs/vue3';


</script>

<template>
    <Head title="Frota Inteligente" />

    <FrotaLayout>

        <template #currentPage>
            Minhas Tarefas
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                <SimpleTable 
                :titles="['Início', 'Fim', 'Local', 'Responsável', 'Ações']" 
                
                />
            </div>
        </template>

    </FrotaLayout>
</template>
