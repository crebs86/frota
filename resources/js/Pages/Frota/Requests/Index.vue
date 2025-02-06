<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head } from '@inertiajs/vue3';
import { defineAsyncComponent, ref } from 'vue';

const Evaluate = defineAsyncComponent(() => import('@/Pages/Frota/Requests/Evaluate.vue'))
const Request = defineAsyncComponent(() => import('@/Pages/Frota/Requests/Request.vue'))

const props = defineProps({
    drivers: Object,
    branches: Object,
    timetables: Object,
    routes: Object,
    errors: Object,
    evaluator: Boolean,
    requester: Boolean,
});

const tab = ref({
    evaluator: props.evaluator,
    requester: props.requester,
    current: props.evaluator ? 'evaluator' : 'requester'
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
                <button class="py-1 px-1.5 rounded border border-blue-600 mr-1.5 text-white bg-blue-300 font-normal"
                    :class="tab.current === 'requester' ? 'bg-blue-600' : ''" :disabled="!tab.requester"
                    @click="tab.current = 'requester'" v-if="tab.requester && tab.evaluator">
                    Solicitar
                </button>
                <button class="py-1 px-1.5 rounded border border-green-600 bg-green-300 text-green-100 font-normal"
                    :class="tab.current === 'evaluator' ? 'bg-green-500' : ''" @click="tab.current = 'evaluator'"
                    v-if="tab.requester && tab.evaluator">
                    Avaliar
                </button>
            </template>
            <template #content>
                <Request v-if="tab.current === 'requester'" :props="props"></Request>
                <Evaluate v-if="tab.current === 'evaluator'" :props="props"></Evaluate>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
<style scoped>
input:checked~.dot {
    transform: translateX(100%);
    background-color: #0ae465;
}

button:disabled,
button[disabled] {
    background-color: #c1c1c1;
    cursor: not-allowed;
}
</style>
