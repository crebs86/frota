<script setup>

import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import VueMultiselect from 'vue-multiselect';
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
import { toast } from '@/toast'

const props = defineProps({
    branches: Object,
    errors: Object
});

const branchesOptions = props.branches;
const _branch = ref(null);

function brancheName({ id, name }) {
    return `${id} - ${name}`
}

const garage = useForm({
    id: null
});

function saveDriver() {
    //fazer verificação de valores nulos
    garage.id = _branch.value?.id;
    if (garage.id) {
        garage.post(route('garages.store'), {
            onSuccess: (a) => {
                console.log(a)
            },
            onError: () => {
                if (props.errors) {
                    toast.error('Foram encontrado erros ao processar sua solicitação');
                }
            },
        })
    } else {
        toast.error('Selecione uma unidades para cadatrar.');
    }
}

</script>

<template>
    <Head title="Frota Inteligente" />

    <FrotaLayout>

        <template #currentPage>
            <BreadCrumbs
                :breadCrumbs="[{ label: 'Garagens', link: route('garages.index') }, { label: 'Nova Garagem', link: '' }]">
            </BreadCrumbs>
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-max">
                <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded">
                    <div class="relative mb-6 w-full z-auto h-[calc(100vh/1.33)]">
                        <div class="mt-2">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Selecione uma unidade para cadastrar garagem
                            </label>
                            <VueMultiselect v-model="_branch" :options="branchesOptions" :multiple="false"
                                :close-on-select="true" selectedLabel="atual" placeholder="Unidades"
                                :custom-label="brancheName" track-by="id" selectLabel="Selecionar"
                                deselectLabel="Remover" />

                            <div v-if="$page.props.errors.garagem_id" class="text-sm text-red-500">
                                {{ $page.props.errors.garagem_id }}
                            </div>
                        </div>
                        <div class="px-0.5 mt-1">
                            <ul>
                                <li>
                                    <span class="font-bold">Código:</span> {{ _branch?.id }}
                                </li>
                                <li>
                                    <span class="font-bold">Nome:</span> {{ _branch?.name }}
                                </li>
                                <li>
                                    <span class="font-bold">Email:</span> {{ _branch?.email }}
                                </li>
                                <li>
                                    <span class="font-bold">Endereço:</span> {{ _branch?.address }}
                                </li>
                                <li>
                                    <span class="font-bold">Contato:</span> {{ _branch?.phones }}
                                </li>
                                <li>
                                    <span class="font-bold">Observações:</span> {{ _branch?.notes }}
                                </li>
                            </ul>
                        </div>
                        <button type="button" @click="saveDriver"
                            class="border border-blue-600 bg-blue-500 text-white rounded-md px-4 py-2 mt-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                            Cadastrar Garagem
                        </button>
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
