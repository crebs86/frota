<script setup>

import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, useForm, Link } from '@inertiajs/vue3';
import { ref } from 'vue';
import { toast } from '@/toast'

const props = defineProps({
    branches: Object,
    errors: Object
});

const branchesOptions = props.branches;
const _branch = ref(null);

function branchName({ id, name }) {
    return `${id} - ${name}`
}

const garage = useForm({
    id: null
});

function saveDriver() {
    //fazer verificação de valores nulos
    garage.id = _branch.value?.id;
    if (garage.id) {
        garage.post(route('frota.garages.store'), {
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

    <Head title="Gararagens" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Garagens
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-max">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded">
                        <div class="relative mb-6 w-full z-auto min-h-[calc(100vh/1.33)]">
                            <div class="mt-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                    Selecione uma unidade para cadastrar garagem
                                    <Link :href="route('branches.create')" class="ml-1.5">
                                    <mdicon name="source-branch-plus" title="Nova Unidade" />
                                    </Link>
                                </label>
                                <VueMultiselect v-model="_branch" :options="branchesOptions" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Unidades"
                                    :custom-label="branchName" track-by="id" selectLabel="Selecionar"
                                    deselectLabel="Remover" />

                                <div v-if="$page.props.errors.id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.id }}
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
                                class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                Cadastrar Garagem
                            </button>
                        </div>
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
</style>
<style src="vue-multiselect/dist/vue-multiselect.css"></style>
