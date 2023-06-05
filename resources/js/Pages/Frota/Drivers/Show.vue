<script setup>
import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, Link, useForm } from '@inertiajs/vue3';
import hasPermission from '@/permissions';
import { ref } from 'vue';

const props = defineProps({
    canEdit: Boolean,
    driver: Object,
    garages: Object
});

const driverForm = useForm({
    matricula: props.driver[0].matricula,
    garagem: props.driver[0].garage,
});

function carName({ modelo, placa }) {
    return `${modelo} - ${placa}`
}

function garageName({ id, branch }) {
    return `${id} - ${branch?.name}`
}

</script>

<template>
    <Head title="Frota Inteligente" />

    <FrotaLayout>

        <template #currentPage>
            <BreadCrumbs
                :breadCrumbs="[{ label: 'Motoristas', link: route('drivers.index') }, { label: $page.props.driver[0].user.name, link: '' }]">
            </BreadCrumbs>
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                <div class="p-2 rounded-lg h-[calc(100vh/1.33)]" :class="$page.props.app.settingsStyles.main.innerSection">
                    <template v-if="$page.props.canEdit">
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Matrícula (opcional)
                            </label>
                            <input type="text" v-model="driverForm.matricula" name="matricula" placeholder="Matrícula"
                                maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                        </div>
                        <div v-if="$page.props.errors.matricula" class="text-sm text-red-500">
                            {{ $page.props.errors.matricula }}
                        </div>

                        <div class="mt-2">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Garagem (opcional)
                            </label>
                            <VueMultiselect v-model="driverForm.garagem" :options="$page.props.garages" :multiple="false"
                                :close-on-select="true" selectedLabel="atual" placeholder="Garagens"
                                :custom-label="garageName" track-by="id" selectLabel="Selecionar" deselectLabel="Remover" />

                            <div v-if="$page.props.errors.garagem_id" class="text-sm text-red-500">
                                {{ $page.props.errors.garagem_id }}
                            </div>
                        </div>
                    </template>

                    <template v-else>
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Nome
                            </label>
                            <input readonly type="text" :value="props.driver[0].user.name" placeholder="Nome" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                        </div>
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Carro
                                <Link v-if="props.driver[0].car" :href="route('cars.show', props.driver[0].car)">
                                <mdicon name="open-in-new" />
                                </Link>
                            </label>
                            <input readonly type="text"
                                :value="props.driver[0].car ? props.driver[0].car?.modelo + ' - ' + props.driver[0].car?.placa : ''"
                                placeholder="Carro" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                        </div>
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Garagem
                                <Link v-if="props.driver[0].garage" :href="route('garages.show', props.driver[0].garage)">
                                <mdicon name="open-in-new" />
                                </Link>
                            </label>
                            <input readonly type="text" :value="props.driver[0].garage?.branch.name" placeholder="Garagem"
                                maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                        </div>
                    </template>
                </div>
            </div>
        </template>

    </FrotaLayout>
</template>
<style src="vue-multiselect/dist/vue-multiselect.css"></style>