<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import VueMultiselect from 'vue-multiselect';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { toast } from '@/toast';
import { ref } from 'vue';

const props = defineProps({
    canEdit: Boolean,
    driver: Object,
    _checker: String
});

const canEdit = ref(props.canEdit);

const driverForm = useForm({
    cnh: props.driver.cnh === 1,
    proprio: props.driver.proprio === 1,
    matricula: props.driver.matricula,
    garagem_id: props.driver.garage,
    carro_favorito: props.driver.car,
    deleted_at: props.driver.deleted_at !== null,
    _checker: props._checker,
});

function carName({ modelo, placa }) {
    return `${modelo ? modelo : ''} - ${placa ? placa : ''}`;
}

function garageName({ id, branch }) {
    return `${id ? id : ''} - ${branch?.name ? branch?.name : ''}`;
}

function saveDriver() {
    driverForm.garagem_id = driverForm.garagem_id ? driverForm.garagem_id.id : null;
    driverForm.carro_favorito = driverForm.carro_favorito ? driverForm.carro_favorito.id : null;

    driverForm.put(route('frota.drivers.update', props.driver.id), {
        onSuccess: () => {
            driverForm.garagem_id = props.driver.garage;
            driverForm.carro_favorito = props.driver.car;
            toast.success('Motorista atualizado com sucesso.');
        },
        onError: () => {
            toast.error('Foram encontrado erros ao processar sua solicitação.');
        },
    })
}

</script>

<template>

    <Head title="Ver Motorista" />

    <AuthenticatedLayout>
        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Motorista: {{ props.driver.user.name }}
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                    <div class="p-2 rounded-lg min-h-[calc(100vh/1.33)]"
                        :class="$page.props.app.settingsStyles.main.innerSection">

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Nome
                                <Link :href="route('admin.acl.users.show', props.driver.id)">
                                <mdicon name="open-in-new" size="20" />
                                </Link>
                            </label>
                            <input readonly type="text" :value="props.driver.user.name" placeholder="Nome"
                                maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300"
                                :class="canEdit ? 'bg-slate-400' : ''" />
                        </div>

                        <div class="mt-1 pl-1.5">
                            <div class="flex w-full mb-5">
                                <label for="cnh" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="cnh" class="sr-only" v-model="driverForm.cnh"
                                            :disabled="!canEdit" />
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition"
                                            :class="!canEdit ? 'dot-dis' : ''">
                                        </div>
                                    </div>
                                    <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                        CNH Verificada?
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="mt-1 pl-1.5">
                            <div class="flex w-full mb-5">
                                <label for="proprio" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="proprio" class="sr-only" v-model="driverForm.proprio"
                                            :disabled="!canEdit" />
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition"
                                            :class="!canEdit ? 'dot-dis' : ''">
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
                            <input :readonly="!canEdit" type="text" v-model="driverForm.matricula"
                                placeholder="Matrícula" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-100"
                                :class="!canEdit ? 'bg-slate-300' : ''" />
                        </div>

                        <div v-if="canEdit">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Selecione um carro favorito (opcional)
                            </label>
                            <VueMultiselect v-model="driverForm.carro_favorito" :options="$page.props.cars"
                                :multiple="false" :close-on-select="true" selectedLabel="atual"
                                placeholder="Carro favorito" :custom-label="carName" label="name" :showNoOptions="false"
                                track-by="id" selectLabel="Selecionar" deselectLabel="Remover" readonly />

                            <div v-if="$page.props.errors.carro_favorito"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.carro_favorito }}
                            </div>
                        </div>
                        <div class="relative -mt-0.5" v-else>
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Carro Favorito
                                <Link v-if="props.driver.car" :href="route('frota.cars.show', props.driver.car)">
                                <mdicon name="open-in-new" size="20" />
                                </Link>
                            </label>
                            <input readonly type="text"
                                :value="props.driver.car ? props.driver.car?.modelo + ' - ' + props.driver.car?.placa : ''"
                                placeholder="Carro" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>

                        <div class="mt-2" v-if="canEdit">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Selecione uma garagem (opcional)
                            </label>
                            <VueMultiselect v-model="driverForm.garagem_id" :options="$page.props.garages"
                                :multiple="false" :close-on-select="true" selectedLabel="atual" placeholder="Garagens"
                                :custom-label="garageName" track-by="id" selectLabel="Selecionar"
                                deselectLabel="Remover" />

                            <div v-if="$page.props.errors.garagem_id"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                {{ $page.props.errors.garagem_id }}
                            </div>
                        </div>
                        <div class="relative -mt-1" v-else>
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Garagem (local)
                                <Link v-if="props.driver.garage"
                                    :href="route('frota.garages.show', props.driver.garage)">
                                <mdicon name="open-in-new" size="20" />
                                </Link>
                            </label>
                            <input readonly type="text" :value="props.driver.garage?.branch.name"
                                placeholder="Garagem" maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>
                        
                        <div class="mt-1 pl-1.5">
                            <div class="flex w-full mb-5">
                                <label for="deleted_at" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="deleted_at" class="sr-only" v-model="driverForm.deleted_at"
                                            :disabled="!canEdit" />
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div class="dot absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition"
                                            :class="!canEdit ? 'dot-dis' : ''">
                                        </div>
                                    </div>
                                    <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                        Inativar?
                                    </div>
                                </label>
                            </div>
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
                            <button type="button" @click="saveDriver"
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