<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head } from '@inertiajs/vue3';
import { defineAsyncComponent, ref } from 'vue';
import has from '@/arrayHelpers';

const Evaluate = defineAsyncComponent(() => import('@/Pages/Frota/Requests/Evaluate.vue'))
const Request = defineAsyncComponent(() => import('@/Pages/Frota/Requests/Request.vue'))

const props = defineProps({
    drivers: Object,
    branches: Object,
    timetables: Object,
    routes: Object,
    errors: Object,
    liberator: Boolean
});

const tab = ref({
    liberator: props.liberator,
    requester: !props.liberator
})

</script>

<template>

    <Head title="Solicitações" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                <button class="py-1 px-1.5 rounded border border-blue-600 mr-1.5 text-white"
                    :class="tab.requester ? 'bg-blue-700 hover:bg-blue-300' : 'bg-blue-300 hover:bg-blue-700'"
                    @click="tab.liberator = false, tab.requester = true">
                    Solicitações
                </button>
                <button class="py-1 px-1.5 rounded border border-green-600 bg-green-300"
                    :class="!tab.liberator && !has(['Super Admin'], $page.props.auth.roles) ? 'opacity-25' : 'hover:bg-green-700'"
                    :disabled="!tab.liberator && !has(['Super Admin'], $page.props.auth.roles)"
                    @click="tab.liberator = true, tab.requester = false" v-if="!tab.liberator">
                    Avaliar
                </button>
            </template>
            <template #content>
                <Request v-if="tab.requester" :props="props"></Request>
                <Evaluate v-if="tab.liberator" :props="props"></Evaluate>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
<style scoped>
input:checked~.dot {
    transform: translateX(100%);
    background-color: #0ae465;
}
</style>
<style src="../../../../../node_modules/vue-multiselect/dist/vue-multiselect.css"></style>
