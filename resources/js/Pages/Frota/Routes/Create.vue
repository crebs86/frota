<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, router } from '@inertiajs/vue3';
import { toast } from '@/toast';
import axios from 'axios';
import { ref } from 'vue';

const props = defineProps({
    drivers: Object,
    branches: Object,
    timetables: Object,
    errors: Object
});


const routeForm = ref({
    driver: '',
    date: '',
    time: '',
    branch: ''
});

function driverName({ id, user }) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}

function branchName({ id, name }) {
    return `${id ? id : ''} - ${name ? name : ''}`
}

function saveRoute() {
    axios.post(route('frota.tasks.route.store'), {
        driver: routeForm.value.driver.id,
        date: routeForm.value.date,
        time: routeForm.value.time.time,
        branch: routeForm.value.branch.id
    })
        .then((r) => {
            toast.success(r.data.message)
            resetForm()
        })
}

function resetForm() {
    routeForm = {
        time: '',
        branch: ''
    };
}

function verifyDriverRoute() {

    if (routeForm.value.date && routeForm.value.driver) {
        console.log('if')
        axios.post(route('frota.tasks.filter-routes'), {
            driver: routeForm.value.driver.id,
            date: routeForm.value.date
        })
            .then((r) => {
                if (r.data.length >= 1) {
                    toast.warning('Já existe agenda para o motorista selecionado. Entrando em modo de edição.', {
                        duration: 3000
                    });
                    router.visit(route('frota.schedules.edit', schedule.driver.id))
                }
            })
            .catch(() => {
                toast.error('Foram encontrado erros ao processar sua solicitação');
            })/**/
    } else {
        console.log('else')
    }
}

</script>

<template>

    <Head title="Configuração de Agenda" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Adicionar Rota
            </template>
            <template #content>
                {{ routeForm }}
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded"
                        v-if="routeForm.date">
                        <div class="relative mb-6 w-full z-auto min-h-fit">

                            <div class="mt-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Selecione um motorista
                                </label>
                                <VueMultiselect v-model="routeForm.driver" :options="props.drivers" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Motorista"
                                    :custom-label="driverName" track-by="id" selectLabel="Selecionar"
                                    @select="verifyDriverRoute" deselectLabel="Remover" />

                                <div v-if="$page.props.errors.driver_id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.driver_id }}
                                </div>
                            </div>

                        </div>
                    </div>

                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
                        <div class="mb-6 w-full z-auto min-h-fit grid grid-cols-1 md:grid-cols-4">

                            <div class="mx-2 grid grid-cols-1">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Data
                                </label>
                                <input type="date" v-model="routeForm.date" @change="verifyDriverRoute"
                                    class="rounded border border-black h-[41px] mt-0.5 text-gray-700">

                                <div v-if="$page.props.errors.driver_id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.driver_id }}
                                </div>
                            </div>

                            <div class="mx-2 col-span-2 md:col-span-1" v-if="routeForm.date">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Hora
                                </label>
                                <VueMultiselect v-model="routeForm.time" :options="props.timetables" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Hora" track-by="id"
                                    label="time" selectLabel="Selecionar" deselectLabel="Remover" />

                                <div v-if="$page.props.errors.driver_id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.driver_id }}
                                </div>
                            </div>

                            <div class="mx-2 col-span-2" v-if="routeForm.date">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Unidade
                                </label>
                                <VueMultiselect v-model="routeForm.branch" :options="props.branches" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Unidade"
                                    :custom-label="branchName" track-by="id" label="time" selectLabel="Selecionar"
                                    deselectLabel="Remover" />

                                <div v-if="$page.props.errors.driver_id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.driver_id }}
                                </div>
                            </div>

                        </div>
                    </div>

                    <button type="button" @click="saveRoute"
                        class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                        Criar
                    </button>
                </div>
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
<style src="vue-multiselect/dist/vue-multiselect.css"></style>
