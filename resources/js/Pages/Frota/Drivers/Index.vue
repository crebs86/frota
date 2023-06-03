<script setup>
import SimpleTable from '@/Components/Frota/SimpleTable.vue';
import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import { Head, Link } from '@inertiajs/vue3';


</script>

<template>
    <Head title="Frota Inteligente" />

    <FrotaLayout>

        <template #currentPage>
            Motoristas
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                <Link class="flex gap-1 max-w-max hover:text-gray-700 dark:hover:text-green-100" :href="route('drivers.create')" title="Relatórios">
                        <mdicon name="account-multiple-plus" />
                        <div>
                            Novo Motorista
                        </div>
                </Link>
                <SimpleTable :titles="['Nome', 'Garagem', 'Carro Favorito', 'Servidor?', 'Matrícula', 'Ativo', 'Ações']" />
            </div>
        </template>

    </FrotaLayout>
</template>
