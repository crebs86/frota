<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, useForm, Link } from '@inertiajs/vue3';
import { toast } from '@/toast'
import { ref } from 'vue';

const props = defineProps({
    _checker: String,
    garages: Object,
    errors: Object
});


const car = useForm({
    marca: '',
    modelo: '',
    placa: '',
    patrimonio: false,
    tombo: '',
    garagem_id: null
});

const garageOptions = props.garages;
const _garagem = ref(null);

function garageName({ id, branch }) {
    return `${id} - ${branch.name}`
}

function saveCar() {
    car.garagem_id = _garagem.value?.id;
    car.post(route('frota.cars.store'), {
        onSuccess: (a) => {
            toast.success('Carro cadastrado com sucesso.');
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

    <Head title="Novo Carro" />


    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Novo Carro
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
                    <div :class="$page.props.app.settingsStyles.main.innerSection" class="px-2 py-0.5 rounded">
                        <div class="relative mb-6 w-full z-auto">

                            <div class="relative">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Marca
                                </label>
                                <input type="text" v-model="car.marca" name="marca" placeholder="Marca" maxlength="25"
                                    class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                            </div>
                            <div v-if="$page.props.errors.marca"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.marca }}
                            </div>

                            <div class="relative">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Modelo
                                </label>
                                <input type="text" v-model="car.modelo" name="modelo" placeholder="Modelo"
                                    maxlength="25"
                                    class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                            </div>
                            <div v-if="$page.props.errors.modelo"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.modelo }}
                            </div>

                            <div class="relative">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Placa
                                </label>
                                <input type="text" v-model="car.placa" name="matricula" placeholder="Placa"
                                    maxlength="25"
                                    class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                            </div>
                            <div v-if="$page.props.errors.placa"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.placa }}
                            </div>
                            <div class="mt-2 px-1.5">
                                <div class="flex w-full mb-5">
                                    <label for="proprio" class="flex items-center cursor-pointer">
                                        <div class="relative">
                                            <input type="checkbox" id="proprio" class="sr-only"
                                                :checked="car.patrimonio" v-model="car.patrimonio">
                                            <div
                                                class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                            </div>
                                            <div
                                                class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                            </div>
                                        </div>
                                        <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                            Patrimônio?
                                        </div>
                                    </label>
                                </div>

                                <div v-if="$page.props.errors.proprio"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.proprio }}
                                </div>
                            </div>

                            <div class="relative">
                                <label class="text-sm text-gray-500 dark:text-gray-400">
                                    Nº Patrimônio
                                </label>
                                <input type="text" v-model="car.tombo" name="matricula" placeholder="Nº patrimônio"
                                    maxlength="25"
                                    class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]">
                            </div>
                            <div v-if="$page.props.errors.tombo"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.tombo }}
                            </div>

                            <div class="mt-2">
                                <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                    Selecione uma garagem (opcional)
                                    <Link :href="route('branches.create')" class="ml-1.5">
                                    <mdicon name="source-branch-plus" title="Nova Unidade" />
                                    </Link>
                                </label>
                                <VueMultiselect v-model="_garagem" :options="garageOptions" :multiple="false"
                                    :close-on-select="true" selectedLabel="atual" placeholder="Garagens"
                                    :custom-label="garageName" track-by="id" selectLabel="Selecionar"
                                    open-direction="top" class="border border-black rounded-md"
                                    deselectLabel="Remover" />

                                <div v-if="$page.props.errors.garagem_id"
                                    class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                    {{ $page.props.errors.garagem_id }}
                                </div>
                            </div>

                            <button type="button" @click="saveCar"
                                class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline">
                                Cadastrar Carro
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
