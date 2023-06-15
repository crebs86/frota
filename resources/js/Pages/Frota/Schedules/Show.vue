<script setup>
import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, Link, useForm } from '@inertiajs/vue3';
import hasPermission from '@/permissions';
import { ref } from 'vue';
import { toast } from '@/toast';

const props = defineProps({
    canEdit: Boolean,
    car: Object,
    _checker: String
});

const canEdit = ref(props.canEdit);

const carForm = useForm({
    marca: props.car[0].marca,
    modelo: props.car[0].modelo,
    placa: props.car[0].placa,
    patrimonio: props.car[0].patrimonio === 1,
    tombo: props.car[0].tombo,
    matricula: props.car[0].matricula,
    garagem_id: props.car[0].garage,
    _checker: props._checker
});

function garageName({ id, branch }) {
    return `${id} - ${branch?.name}`
}


function saveCar() {
    carForm.garagem_id = carForm.garagem_id ? carForm.garagem_id.id : null;

    carForm.put(route('cars.update', props.car[0].id), {
        onSuccess: () => {
            carForm.garagem_id = props.car[0].garage;
            toast.success('Carro atualizado com sucesso.');
        },
        onError: () => {
            toast.error('Foram encontrado erros ao processar sua solicitação.');
        },
    })
}

function setNumber() {

    if (!carForm.patrimonio) {
        carForm.tombo = null
    }
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
                <div class="p-2 rounded-lg min-h-[calc(100vh/1.33)]"
                    :class="$page.props.app.settingsStyles.main.innerSection">

                    <div class="relative">
                        <label class="text-sm text-gray-500 dark:text-gray-400">
                            Marca
                        </label>
                        <input :disabled="!canEdit" type="text" v-model="carForm.marca" placeholder="Marca" maxlength="25"
                            class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-100"
                            :class="!canEdit ? 'bg-slate-300' : ''">
                    </div>
                    <div v-if="$page.props.errors.marca"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        {{ $page.props.errors.marca }}
                    </div>

                    <div class="relative">
                        <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                            Modelo
                        </label>
                        <input :disabled="!canEdit" type="text" v-model="carForm.modelo" placeholder="Modelo"
                            class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-100"
                            :class="!canEdit ? 'bg-slate-300' : ''" />
                    </div>
                    <div v-if="$page.props.errors.modelo"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        {{ $page.props.errors.modelo }}
                    </div>

                    <div class="relative">
                        <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                            Placa
                        </label>
                        <input :disabled="!canEdit" type="text" v-model="carForm.placa" placeholder="Placa"
                            class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-100"
                            :class="!canEdit ? 'bg-slate-300' : ''" />
                    </div>
                    <div v-if="$page.props.errors.placa"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        {{ $page.props.errors.placa }}
                    </div>

                    <div class="mt-2">
                        <div class="flex w-full mb-5">
                            <label for="patrimonio" class="flex items-center cursor-pointer">
                                <div class="relative">
                                    <input type="checkbox" id="patrimonio" class="sr-only" checked="checked"
                                        :disabled="!canEdit" v-model="carForm.patrimonio" @change="setNumber" />
                                    <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                    </div>
                                    <div class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition"
                                        :class="!canEdit ? 'dot-dis' : ''">
                                    </div>
                                </div>
                                <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                    Patrimônio Próprio*
                                </div>
                            </label>
                        </div>
                    </div>
                    <div v-if="$page.props.errors.patrimonio"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        {{ $page.props.errors.patrimonio }}
                    </div>

                    <div class="relative">
                        <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                            Nº Patrimônio
                        </label>
                        <input :disabled="canEdit && carForm.patrimonio ? false : true" type="text" v-model="carForm.tombo"
                            placeholder="Nº Patrimônio"
                            class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-100"
                            :class="!(canEdit && carForm.patrimonio) ? 'bg-slate-300' : ''" />
                    </div>
                    <div v-if="$page.props.errors.tombo"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        {{ $page.props.errors.tombo }}
                    </div>

                    <div class="-mt-0.5" v-if="canEdit">
                        <label class="text-sm text-gray-500 dark:text-gray-400">
                            Selecione uma garagem (opcional)
                        </label>
                        <VueMultiselect v-model="carForm.garagem_id" :options="$page.props.garages" :multiple="false"
                            :close-on-select="true" selectedLabel="atual" placeholder="Garagens" :custom-label="garageName"
                            track-by="id" selectLabel="Selecionar" deselectLabel="Remover" />

                        <div v-if="$page.props.errors.garagem_id"
                            class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                            {{ $page.props.errors.garagem_id }}
                        </div>
                    </div>
                    <div class="relative -mt-1" v-else>
                        <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                            Garagem (local)
                            <Link v-if="props.car[0].garage" :href="route('garages.show', props.car[0].garage)">
                            <mdicon name="open-in-new" size="20" />
                            </Link>
                        </label>
                        <input readonly type="text" :value="props.car[0].garage?.branch.name" placeholder="Garagem"
                            maxlength="25"
                            class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                    </div>

                    <template v-if="!canEdit">
                        <button type="button" @click="canEdit = true"
                            class="border border-yellow-600 bg-yellow-500 text-yellow-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-yellow-700 focus:outline-none focus:shadow-outline">
                            Editar Motorista
                        </button>
                    </template>
                    <template v-else>
                        <button type="button" @click="canEdit = false"
                            class="border border-gray-600 bg-gray-500 text-gray-100 rounded-md px-4 py-2 m-2 mt-4 transition duration-500 ease select-none hover:bg-gray-700 focus:outline-none focus:shadow-outline">
                            Cancelar Edição de Motorista
                        </button>
                        <button type="button" @click="saveCar"
                            class="border border-blue-600 bg-blue-500 text-blue-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                            Salvar
                        </button>
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