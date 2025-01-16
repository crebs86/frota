<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
import { toast } from '@/toast';
import has from '@/arrayHelpers'

const props = defineProps({
    canEdit: Boolean,
    schedule: Object,
    timetables: Object,
    _checker: String
});

const canEdit = ref(props.canEdit);

const scheduleForm = useForm({
    driver: props.schedule[0].driver_name.user.name,
    driver_id: props.schedule[0].driver_name.user.id,
    timeMorningStart: getTime(props.schedule[0].morning_start),
    timeMorningEnd: getTime(props.schedule[0].morning_end),
    timeAfternoonStart: getTime(props.schedule[0].afternoon_start),
    timeAfternoonEnd: getTime(props.schedule[0].afternoon_end),
    timeNightStart: getTime(props.schedule[0].night_start),
    timeNightEnd: getTime(props.schedule[0].night_end),
    timeSpecialStart: getTime(props.schedule[0].special_start),
    timeSpecialEnd: getTime(props.schedule[0].special_end),
    _checker: props._checker
});

function saveSchedule() {

    scheduleForm.put(route('frota.schedules.update', scheduleForm.driver_id), {
        onSuccess: () => {
            toast.success('Agenda atualizada com sucesso.');
        },
        onError: () => {
            toast.error('Foram encontrado erros ao processar sua solicitação.');
        },
    })
}

function split(obj, start, end) {
    return obj.filter((o) => o.id >= start && o.id <= end);
}

function getTime(time) {
    return props.timetables.filter((o) => o.time === time)[0];
}

</script>

<template>

    <Head title="Frota Inteligente" />
    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Editar Agenda de &nbsp;<span class="font-medium">{{ scheduleForm.driver }} </span>
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                    <div class="p-2 rounded-lg min-h-[calc(100vh/1.33)]"
                        :class="$page.props.app.settingsStyles.main.innerSection">

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Marca
                            </label>
                            <input disabled type="text" v-model="scheduleForm.driver" placeholder="Marca" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>
                        <div v-if="$page.props.errors.marca"
                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                            {{ $page.props.errors.marca }}<br />
                        </div>
                        <div :class="$page.props.app.settingsStyles.main.innerSection"
                            class="my-2 px-0.5 py-0.5 rounded grid grid-cols-1 md:grid-cols-2">

                            <div class="rounded m-1 p-1.5 pb-2 grid grid-cols-2 gap-x-1 gap-y-5"
                                :class="$page.props.app.settingsStyles.main.body">
                                <h3 class="text-lg col-span-3 md:col-span-4 text-center border-b">Manhã</h3>
                                <VueMultiselect v-model="scheduleForm.timeMorningStart"
                                    :options="split(props.timetables, 1, 24)" :multiple="false" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Início" track-by="time" label="time"
                                    selectLabel="Selecionar" deselectLabel="Remover" />
                                <VueMultiselect v-model="scheduleForm.timeMorningEnd"
                                    :options="split(props.timetables, 1, 24)" :multiple="false" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Término" track-by="time" label="time"
                                    selectLabel="Selecionar" deselectLabel="Remover" />

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
                                <VueMultiselect v-model="scheduleForm.timeAfternoonStart"
                                    :options="split(props.timetables, 25, 48)" :multiple="false" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Início" track-by="time" label="time"
                                    selectLabel="Selecionar" deselectLabel="Remover" />
                                <VueMultiselect v-model="scheduleForm.timeAfternoonEnd"
                                    :options="split(props.timetables, 25, 48)" :multiple="false" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Término" track-by="time" label="time"
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
                                <VueMultiselect v-model="scheduleForm.timeNightStart"
                                    :options="split(props.timetables, 49, 72)" :multiple="false" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Início" track-by="time" label="time"
                                    selectLabel="Selecionar" deselectLabel="Remover" />
                                <VueMultiselect v-model="scheduleForm.timeNightEnd"
                                    :options="split(props.timetables, 49, 72)" :multiple="false" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Término" track-by="time" label="time"
                                    selectLabel="Selecionar" deselectLabel="Remover" />
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
                                <VueMultiselect v-model="scheduleForm.timeSpecialStart"
                                    :options="split(props.timetables, 73, 96)" :multiple="false" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Início" track-by="time" label="time"
                                    selectLabel="Selecionar" deselectLabel="Remover" />
                                <VueMultiselect v-model="scheduleForm.timeSpecialEnd"
                                    :options="split(props.timetables, 73, 96)" :multiple="false" :close-on-select="true"
                                    selectedLabel="atual" placeholder="Término" track-by="time" label="time"
                                    selectLabel="Selecionar" deselectLabel="Remover" />
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

                        <template
                            v-if="!canEdit && has(
                                $page.props.auth.permissions, ['Carros Editar', 'Carros Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                            <button type="button" @click="canEdit = true"
                                class="border border-yellow-600 bg-yellow-500 text-yellow-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-yellow-700 focus:outline-none focus:shadow-outline">
                                Editar Agenda
                            </button>
                        </template>
                        <template
                            v-else-if="canEdit && has(
                                $page.props.auth.permissions, ['Carros Editar', 'Carros Apagar', 'Carros Ver']) || has($page.props.auth.roles, ['Super Admin'])">
                            <button type="button" @click="canEdit = false"
                                class="border border-gray-600 bg-gray-500 text-gray-100 rounded-md px-4 py-2 m-2 mt-4 transition duration-500 ease select-none hover:bg-gray-700 focus:outline-none focus:shadow-outline">
                                Cancelar Edição de Agenda
                            </button>
                            <button type="button" @click="saveSchedule"
                                class="border border-blue-600 bg-blue-500 text-blue-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                                Salvar
                            </button>
                        </template>
                    </div>
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

input:checked~.dot-dis {
    transform: translateX(100%);
    background-color: #9afbbc;
}
</style>
<style src="vue-multiselect/dist/vue-multiselect.css"></style>