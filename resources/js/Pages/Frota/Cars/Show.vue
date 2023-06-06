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
    car: Object
});

const driverForm = useForm({
    matricula: props.car[0].matricula,
    garagem: props.car[0].garage,
});

function garageName({ id, branch }) {
    return `${id} - ${branch?.name}`
}

</script>

<template>
    <Head title="Frota Inteligente" />

    <FrotaLayout>

        <template #currentPage>
            <BreadCrumbs
                :breadCrumbs="[{ label: 'Carros', link: route('cars.index') }, { label: $page.props.car[0].marca + ' - ' + $page.props.car[0].modelo, link: '' }]">
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
                                Marca
                            </label>
                            <input readonly type="text" :value="props.car[0].marca" placeholder="Marca" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Modelo
                            </label>
                            <input readonly type="text" :value="props.car[0].modelo" placeholder="Modelo"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Placa
                            </label>
                            <input readonly type="text" :value="props.car[0].placa" placeholder="Placa"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>
                        <div class="mt-2">
                            <div class="flex w-full mb-5">
                                <label for="patrimonio" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="patrimonio" class="sr-only" checked="checked" disabled>
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div
                                            class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                        </div>
                                    </div>
                                    <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                        Patrimônio Próprio*
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Nº Patrimônio
                            </label>
                            <input readonly type="text" :value="props.car[0].tombo" placeholder="Nº Patrimônio"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Garagem
                                <Link v-if="props.car[0].garage" :href="route('garages.show', props.car[0].garage)">
                                <mdicon name="open-in-new" />
                                </Link>
                            </label>
                            <input readonly type="text" :value="props.car[0].garage?.branch.name" placeholder="Garagem"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>
                    </template>
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