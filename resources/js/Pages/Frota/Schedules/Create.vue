<script setup>

import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import VueMultiselect from 'vue-multiselect';
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { toast } from '@/toast';
import { ref } from 'vue';
import axios from 'axios';

const props = defineProps({
    drivers: Object,
    timetables: Object,
    errors: Object
});

const scheduleTemplate = useForm({
    driver: null,
    timesMorningStart: null,
    timesMorningEnd: null,
    timesAfternoonStart: null,
    timesAfternoonEnd: null,
    timesNightStart: null,
    timesNightEnd: null,
    timesSpecialStart: null,
    timesSpecialEnd: null,
});

const _scheduleTemplate = ref({
    driver: null,
    timesMorningStart: '',
    timesMorningEnd: '',
    timesAfternoonStart: '',
    timesAfternoonEnd: '',
    timesNightStart: '',
    timesNightEnd: '',
    timesSpecialStart: '',
    timesSpecialEnd: '',
});

const driverUser = ref({ id: '', name: '' });

function driverName({ id, user }) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}

function saveScheduleTemplate() {

    scheduleTemplate.driver = driverUser?.value?.user?.id

    scheduleTemplate.timesMorningStart = _scheduleTemplate?.value.timesMorningStart?.id ?? null
    scheduleTemplate.timesMorningEnd = _scheduleTemplate?.value.timesMorningEnd?.id ?? null
    scheduleTemplate.timesAfternoonStart = _scheduleTemplate?.value.timesAfternoonStart?.id ?? null
    scheduleTemplate.timesAfternoonEnd = _scheduleTemplate?.value.timesAfternoonEnd?.id ?? null
    scheduleTemplate.timesNightStart = _scheduleTemplate?.value.timesNightStart?.id ?? null
    scheduleTemplate.timesNightEnd = _scheduleTemplate?.value.timesNightEnd?.id ?? null
    scheduleTemplate.timesSpecialStart = _scheduleTemplate?.value.timesSpecialStart?.id ?? null
    scheduleTemplate.timesSpecialEnd = _scheduleTemplate?.value.timesSpecialEnd?.id ?? null

    scheduleTemplate.post(route('schedules.template.save', scheduleTemplate.driver), {
        onSuccess: () => {
            toast.success('Modelo de Agenda atualizado com sucesso.');
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

function setDriver() {
    axios.get(route('schedules.template.get', driverUser.value.id))
        .then(r => {
            _scheduleTemplate.value.timesMorningStart = props.timetables.filter((t) => t.id === r.data.timesMorningStart)[0]
            _scheduleTemplate.value.timesMorningEnd = props.timetables.filter((t) => t.id === r.data.timesMorningEnd)[0]
            _scheduleTemplate.value.timesAfternoonStart = props.timetables.filter((t) => t.id === r.data.timesAfternoonStart)[0]
            _scheduleTemplate.value.timesAfternoonEnd = props.timetables.filter((t) => t.id === r.data.timesAfternoonEnd)[0]
            _scheduleTemplate.value.timesNightStart = props.timetables.filter((t) => t.id === r.data.timesNightStart)[0]
            _scheduleTemplate.value.timesNightEnd = props.timetables.filter((t) => t.id === r.data.timesNightEnd)[0]
            _scheduleTemplate.value.timesSpecialStart = props.timetables.filter((t) => t.id === r.data.timesSpecialStart)[0]
            _scheduleTemplate.value.timesSpecialEnd = props.timetables.filter((t) => t.id === r.data.timesSpecialEnd)[0]
        })
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
                                Motorista
                            </label>
                            <VueMultiselect v-model="driverUser" @select="setDriver" :options="props.drivers"
                                :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Motorista"
                                :custom-label="driverName" track-by="id" selectLabel="Selecionar" deselectLabel="Remover" />

                            <div v-if="$page.props.errors.driver"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.driver }}
                            </div>
                        </div>
                        <!-- 
                        <VDatePicker v-model="date" is-dark="system"/> -->

                    </div>
                </div>
                <!-- {{ _scheduleTemplate }} -->
                <div :class="$page.props.app.settingsStyles.main.innerSection"
                    class="my-2 px-0.5 py-0.5 rounded grid grid-cols-1 md:grid-cols-2 pb-72">

                    <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                        :class="$page.props.app.settingsStyles.main.body">
                        <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Manhã</h3>
                        <div class="col-span-4 md:col-span-1">
                            <VueMultiselect v-model="_scheduleTemplate.timesMorningStart"
                                :options="split(props.timetables, 1, 24)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Início" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timesMorningStart"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.timesMorningStart }}
                            </div>
                        </div>
                        <div class="col-span-4 md:col-span-1">
                            <VueMultiselect v-model="_scheduleTemplate.timesMorningEnd"
                                :options="split(props.timetables, 1, 24)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Término" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timesMorningEnd"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.timesMorningEnd }}
                            </div>
                        </div>
                    </div>

                    <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                        :class="$page.props.app.settingsStyles.main.body">
                        <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Tarde</h3>
                        <div class="col-span-4 md:col-span-1">
                            <VueMultiselect v-model="_scheduleTemplate.timesAfternoonStart"
                                :options="split(props.timetables, 25, 48)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Início" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timesAfternoonStart"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.timesAfternoonStart }}
                            </div>
                        </div>
                        <div class="col-span-4 md:col-span-1">
                            <VueMultiselect v-model="_scheduleTemplate.timesAfternoonEnd"
                                :options="split(props.timetables, 25, 48)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Término" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timesAfternoonEnd"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.timesAfternoonEnd }}
                            </div>
                        </div>
                    </div>

                    <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                        :class="$page.props.app.settingsStyles.main.body">
                        <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Noite</h3>
                        <div class="col-span-4 md:col-span-1">
                            <VueMultiselect v-model="_scheduleTemplate.timesNightStart"
                                :options="split(props.timetables, 49, 72)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Início" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timesNightStart"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.timesNightStart }}
                            </div>
                        </div>
                        <div class="col-span-4 md:col-span-1">
                            <VueMultiselect v-model="_scheduleTemplate.timesNightEnd"
                                :options="split(props.timetables, 49, 72)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Término" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timesNightEnd"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.timesNightEnd }}
                            </div>
                        </div>
                    </div>

                    <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                        :class="$page.props.app.settingsStyles.main.body">
                        <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Especial</h3>
                        <div class="col-span-4 md:col-span-1">
                            <VueMultiselect v-model="_scheduleTemplate.timesSpecialStart"
                                :options="split(props.timetables, 73, 96)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Início" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timesSpecialStart"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.timesSpecialStart }}
                            </div>
                        </div>
                        <div class="col-span-4 md:col-span-1">
                            <VueMultiselect v-model="_scheduleTemplate.timesSpecialEnd"
                                :options="split(props.timetables, 73, 96)" :multiple="false" :close-on-select="true"
                                selectedLabel="atual" placeholder="Término" track-by="id" label="time"
                                selectLabel="Selecionar" deselectLabel="Remover" />
                            <div v-if="$page.props.errors.timesSpecialEnd"
                                class="text-xs text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.timesSpecialEnd }}
                            </div>
                        </div>
                    </div>

                    <button type="button" @click="saveScheduleTemplate"
                        class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline col-span-full w-11/12 md:w-1/2 mx-auto">
                        Criar Padrão de Agenda
                    </button>

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
