<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, useForm, router } from '@inertiajs/vue3';
import { toast } from '@/toast';
import axios from 'axios';

const props = defineProps({
    drivers: Object,
    timetables: Object,
    errors: Object
});


const schedule = useForm({
    driver: { id: '', name: '' },
    driver_id: '',
    timeMorningStart: '',
    timeMorningEnd: '',
    timeAfternoonStart: '',
    timeAfternoonEnd: '',
    timeNightStart: '',
    timeNightEnd: '',
    timeSpecialStart: '',
    timeSpecialEnd: '',
});

function driverName({ id, user }) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}

function saveSchedule() {
    schedule.driver_id = schedule.driver.id;
    schedule.post(route('frota.schedules.store'), {
        onSuccess: (a) => {
            toast.success('Agenda atualizada com sucesso.');
        },
        onError: () => {
            if (props.errors) {
                toast.error('Foram encontrado erros ao processar sua solicitação');
            }
        },
    })
}

function split(obj, start, end) {
    return obj.filter((o) => o.id >= start && o.id <= end);
}

function verifyDriverSchedule() {

    setTimeout(
        () => {
            axios.post(route('frota.schedules.driver', schedule.driver.id))
                .then((r) => {
                    if (r.data.length >= 1) {
                        toast.warning('Já existe agenda para o motorista selecionado. Entrando em modo de edição.', {
                            duration: 3000
                        });
                        router.visit(route('frota.schedules.edit', schedule.driver.id))
                    }
                })
                .catch((e) => {
                    toast.error('Foram encontrado erros ao processar sua solicitação');
                })
        }, 150
    )
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
                Criar Rotas
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.33)]">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded">
                        <div class="relative mb-6 w-full z-auto min-h-fit">

                            <div class="mt-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Selecione um motorista
                                </label>
                                <VueMultiselect v-model="schedule.driver" :options="props.drivers" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Motorista"
                                    :custom-label="driverName" track-by="id" selectLabel="Selecionar"
                                    @select="verifyDriverSchedule" deselectLabel="Remover" />

                                <div v-if="$page.props.errors.driver_id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.driver_id }}
                                </div>
                            </div>

                        </div>
                    </div>

                    <div :class="$page.props.app.settingsStyles.main.innerSection"
                        class="my-2 px-0.5 py-0.5 rounded grid grid-cols-1 md:grid-cols-2">

                        <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                            :class="$page.props.app.settingsStyles.main.body">
                            <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Manhã</h3>
                            <VueMultiselect v-model="schedule.timeMorningStart"
                                :options="split(props.timetables, 1, 24)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Início" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <VueMultiselect v-model="schedule.timeMorningEnd" :options="split(props.timetables, 1, 24)"
                                :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Término"
                                track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />

                            <div v-if="$page.props.errors.timeMorningStart"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-3">
                                {{ $page.props.errors.timeMorningStart }}
                            </div>
                            <div v-if="$page.props.errors.timeMorningEnd"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-3">
                                {{ $page.props.errors.timeMorningEnd }}
                            </div>
                        </div>

                        <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                            :class="$page.props.app.settingsStyles.main.body">
                            <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Tarde</h3>
                            <VueMultiselect v-model="schedule.timeAfternoonStart"
                                :options="split(props.timetables, 25, 48)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Início" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <VueMultiselect v-model="schedule.timeAfternoonEnd"
                                :options="split(props.timetables, 25, 48)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Término" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timeAfternoonStart"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-3">
                                {{ $page.props.errors.timeAfternoonStart }}
                            </div>
                            <div v-if="$page.props.errors.timeAfternoonEnd"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-3">
                                {{ $page.props.errors.timeAfternoonEnd }}
                            </div>
                        </div>

                        <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                            :class="$page.props.app.settingsStyles.main.body">
                            <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Noite</h3>
                            <VueMultiselect v-model="schedule.timeNightStart" :options="split(props.timetables, 49, 72)"
                                :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Início"
                                track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                            <VueMultiselect v-model="schedule.timeNightEnd" :options="split(props.timetables, 49, 72)"
                                :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Término"
                                track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timeNightStart"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-3">
                                {{ $page.props.errors.timeNightStart }}
                            </div>
                            <div v-if="$page.props.errors.timeNightEnd"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-3">
                                {{ $page.props.errors.timeNightEnd }}
                            </div>
                        </div>

                        <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                            :class="$page.props.app.settingsStyles.main.body">
                            <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Especial</h3>
                            <VueMultiselect v-model="schedule.timeSpecialStart"
                                :options="split(props.timetables, 73, 96)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Início" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <VueMultiselect v-model="schedule.timeSpecialEnd" :options="split(props.timetables, 73, 96)"
                                :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Término"
                                track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timeSpecialStart"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-3">
                                {{ $page.props.errors.timeSpecialStart }}
                            </div>
                            <div v-if="$page.props.errors.timeSpecialEnd"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-3">
                                {{ $page.props.errors.timeSpecialEnd }}
                            </div>
                        </div>

                    </div>

                    <button type="button" @click="saveSchedule"
                        class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                        Salvar
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
