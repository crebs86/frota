<script setup>

import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import VueMultiselect from 'vue-multiselect';
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { toast } from '@/toast';

const props = defineProps({
    drivers: Object,
    timetables: Object,
    errors: Object
});


const schedule = useForm({
    driver: { id: '', name: '' },
    timesMorningStart: '',
    timesMorningEnd: '',
    timesAfternoonStart: '',
    timesAfternoonEnd: '',
    timesNightStart: '',
    timesNightEnd: '',
    timesSpecialStart: '',
    timesSpecialEnd: '',

});

function driverName({ id, user }) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}

function saveCar() {
    car.garagem_id = _garagem.value?.id;
    car.post(route('cars.store'), {
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

</script>

<template>
    <Head title="Configuração de Agenda" />

    <FrotaLayout>

        <template #currentPage>
            <BreadCrumbs
                :breadCrumbs="[{ label: 'Agendas', link: route('schedules.index') }, { label: 'Configuração de Agenda', link: '' }]">
            </BreadCrumbs>
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-max">
                <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded">
                    <div class="relative mb-6 w-full z-auto min-h-fit">

                        <div class="mt-2">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Selecione um motorista
                            </label>
                            <VueMultiselect v-model="schedule.driver" :options="props.drivers" :multiple="false"
                                :close-on-select="true" selectedLabel="atual" placeholder="Motorista"
                                :custom-label="driverName" track-by="id" selectLabel="Selecionar" deselectLabel="Remover" />

                            <div v-if="$page.props.errors.garagem_id"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.garagem_id }}
                            </div>
                        </div>

                        <button type="button" @click="saveCar"
                            class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                            Cadastrar
                        </button>
                    </div>
                </div>

                <div :class="$page.props.app.settingsStyles.main.innerSection"
                    class="my-2 px-0.5 py-0.5 rounded grid grid-cols-1 md:grid-cols-2">

                    <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                        :class="$page.props.app.settingsStyles.main.body">
                        <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Manhã</h3>
                        <VueMultiselect v-model="schedule.timesMorningStart" :options="split(props.timetables, 1, 24)"
                            :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Início"
                            track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                        <VueMultiselect v-model="schedule.timesMorningEnd" :options="split(props.timetables, 1, 24)"
                            :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Término"
                            track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                    </div>

                    <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                        :class="$page.props.app.settingsStyles.main.body">
                        <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Tarde</h3>
                        <VueMultiselect v-model="schedule.timesAfternoonStart" :options="split(props.timetables, 25, 48)"
                            :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Início"
                            track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                        <VueMultiselect v-model="schedule.timesAfternoonEnd" :options="split(props.timetables, 25, 48)"
                            :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Término"
                            track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                    </div>

                    <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                        :class="$page.props.app.settingsStyles.main.body">
                        <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Noite</h3>
                        <VueMultiselect v-model="schedule.timesNightStart" :options="split(props.timetables, 49, 72)"
                            :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Início"
                            track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                        <VueMultiselect v-model="schedule.timesNightEnd" :options="split(props.timetables, 49, 72)"
                            :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Término"
                            track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                    </div>

                    <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                        :class="$page.props.app.settingsStyles.main.body">
                        <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Especial</h3>
                        <VueMultiselect v-model="schedule.timesSpecialStart" :options="split(props.timetables, 73, 96)"
                            :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Início"
                            track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                        <VueMultiselect v-model="schedule.timesSpecialEnd" :options="split(props.timetables, 73, 96)"
                            :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Término"
                            track-by="id" label="time" selectLabel="Selecionar" deselectLabel="Remover" />
                    </div>

                </div>
            </div>
        </template>

    </FrotaLayout>
</template>
<style scoped>
input:checked~.dot {
    transform: translateX(100%);
    background-color: #0ae465;
}
</style>
<style src="vue-multiselect/dist/vue-multiselect.css"></style>
