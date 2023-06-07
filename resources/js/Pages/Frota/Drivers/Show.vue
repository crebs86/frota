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
    garages: Object,
    cars: Object,
});

const driverForm = useForm({
    cnh: props.driver[0].cnh,
    proprio: props.driver[0].proprio,
    matricula: props.driver[0].matricula,
    garagem_id: props.driver[0].garage,
    carro_favorito: props.driver[0].car,
});

function carName({ modelo, placa }) {
    return `${modelo} - ${placa}`
}

function garageName({ id, branch }) {
    return `${id} - ${branch?.name}`
}

function saveDriver() {
    //fazer verificação de valores nulos
    driverForm.garagem_id = driverForm.garagem_id.id;
    driverForm.carro_favorito = driverForm.carro_favorito.id;

    driverForm.put(route('drivers.update',  props.driver[0].id), {
        onSuccess: (a) => {
            console.log(a)
        },
        onError: () => {
            if (props.errors) {
                toast.error('Foram encontrado erros ao processar sua solicitação');
            }
        },
    })
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
                <div class="p-2 rounded-lg min-h-[calc(100vh/1.33)]"
                    :class="$page.props.app.settingsStyles.main.innerSection">
                    <template v-if="$page.props.canEdit">
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Nome
                                <Link :href="route('admin.acl.users.show', props.driver[0].id)">
                                <mdicon name="open-in-new" size="20" />
                                </Link>
                            </label>
                            <input readonly type="text" :value="props.driver[0].user.name" placeholder="Nome" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>
                        {{ driverForm }}
                        <div class="mt-2 pl-1.5">
                            <div class="flex w-full mb-5">
                                <label for="cnh" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="cnh" class="sr-only"
                                            :checked="props.driver[0].cnh === null ? true : true" />
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div
                                            class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                        </div>
                                    </div>
                                    <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                        CNH Verificada?
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="mt-2 pl-1.5">
                            <div class="flex w-full mb-5">
                                <label for="proprio" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="proprio" class="sr-only"
                                            :checked="props.driver[0].proprio === null ? true : true" />
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div
                                            class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                        </div>
                                    </div>
                                    <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                        Servidor próprio?
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Matrícula (opcional)
                            </label>
                            <input type="text" v-model="driverForm.matricula" name="matricula" placeholder="somente números"
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
                        <div class="mt-2">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Carro favorito (opcional)
                            </label>
                            <VueMultiselect v-model="driverForm.carro_favorito" :options="$page.props.cars"
                                :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Carro favorito"
                                :custom-label="carName" label="name" :showNoOptions="false" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover" />

                            <div v-if="$page.props.errors.carro_favorito" class="text-sm text-red-500">
                                {{ $page.props.errors.carro_favorito }}
                            </div>
                        </div>
                        <button type="button" @click="saveDriver"
                            class="border border-blue-600 bg-blue-500 text-white rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                            Atualizar
                        </button>
                    </template>

                    <template v-else>
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Nome
                                <Link :href="route('admin.acl.users.show', props.driver[0].id)">
                                <mdicon name="open-in-new" size="20" />
                                </Link>
                            </label>
                            <input readonly type="text" :value="props.driver[0].user.name" placeholder="Nome" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>
                        <div class="mt-2 pl-1.5">
                            <div class="flex w-full mb-5">
                                <label for="cnh" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="cnh" class="sr-only"
                                            :checked="props.driver[0].cnh === null ? true : true" disabled />
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div
                                            class="dot-dis absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                        </div>
                                    </div>
                                    <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                        CNH Verificada?
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="mt-2 pl-1.5">
                            <div class="flex w-full mb-5">
                                <label for="proprio" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="proprio" class="sr-only"
                                            :checked="props.driver[0].proprio === null ? true : true" disabled />
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div
                                            class="dot-dis absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                        </div>
                                    </div>
                                    <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                        Servidor próprio?
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Matrícula
                            </label>
                            <input readonly type="text" :value="props.driver[0].matricula" placeholder="Matrícula"
                                maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Carro Favorito
                                <Link v-if="props.driver[0].car" :href="route('cars.show', props.driver[0].car)">
                                <mdicon name="open-in-new" size="20" />
                                </Link>
                            </label>
                            <input readonly type="text"
                                :value="props.driver[0].car ? props.driver[0].car?.modelo + ' - ' + props.driver[0].car?.placa : ''"
                                placeholder="Carro" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Garagem (local)
                                <Link v-if="props.driver[0].garage" :href="route('garages.show', props.driver[0].garage)">
                                <mdicon name="open-in-new" size="20" />
                                </Link>
                            </label>
                            <input readonly type="text" :value="props.driver[0].garage?.branch.name" placeholder="Garagem"
                                maxlength="25"
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

input:checked~.dot-dis {
    transform: translateX(100%);
    background-color: #9afbbc;
}
</style>
<style src="vue-multiselect/dist/vue-multiselect.css"></style>