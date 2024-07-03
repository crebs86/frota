<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import hasPermission from '@/permissions';
import { ref } from 'vue';
import { toast } from '@/toast';

const props = defineProps({
    canEdit: Boolean,
    garage: Object,
    _checker: String
});

const canEdit = ref(props.canEdit)

const garageForm = useForm({
    deleted_at: props.garage[0].deleted_at === null ? true : false,
    _checker: props._checker,
});

function saveGarage(status) {
    if (status) {
        garageForm.put(route('garages.update', props.garage[0].id), {
            onSuccess: () => {
                toast.success('Garagem reativada com sucesso');
            },
            onError: () => {
                toast.error('Erro ao reativar garagem');
            }
        })
    } else {
        garageForm.delete(route('garages.destroy', props.garage[0].id), {
            onSuccess: () => {
                toast.success('Garagem inativada com sucesso');
            },
            onError: () => {
                toast.error('Erro ao inativar garagem');
            }
        })
    }
}

</script>

<template>

    <Head title="Garagem " />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Garagens
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                    <div class="p-2 rounded-lg h-[calc(100vh/1.33)]"
                        :class="$page.props.app.settingsStyles.main.innerSection">

                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                                Nome (local)
                                <Link :href="route('branches.show', props.garage[0].id)">
                                <mdicon name="open-in-new" />
                                </Link>
                            </label>
                            <input readonly type="text" :value="props.garage[0].branch.name" placeholder="Nome"
                                maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                        </div>

                        <div class="p-4 mb-4 text-sm text-blue-700 bg-blue-100 rounded-lg dark:bg-blue-200 dark:text-blue-800"
                            v-if="garageForm.deleted_at" role="alert">
                            Status da garagem: <span class="font-medium">garagem ativa.</span>
                        </div>
                        <div class="p-4 mb-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800"
                            role="alert" v-else>
                            Status da garagem: <span class="font-medium">garagem inativa.</span>
                        </div>

                        <button type="button" @click="canEdit = true" v-if="!canEdit"
                            class="border border-yellow-600 bg-yellow-500 text-yellow-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-yellow-700 focus:outline-none focus:shadow-outline">
                            Editar Garagem
                        </button>

                        <template v-else>
                            <button type="button" @click="saveGarage(true)" v-if="!garageForm.deleted_at"
                                class="border border-blue-600 bg-blue-500 text-blue-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-blue-700 focus:outline-none focus:shadow-outline">
                                Reativar Garagem
                            </button>
                            <button type="button" @click="saveGarage(false)" v-else
                                class="border border-red-600 bg-red-500 text-red-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-red-700 focus:outline-none focus:shadow-outline">
                                Inativar Garagem
                            </button>
                            <button type="button" @click="canEdit = false"
                                v-if="canEdit && route().current() !== 'garages.edit'"
                                class="border border-gray-600 bg-gray-500 text-gray-100 rounded-md px-4 py-2 m-2 transition duration-500 ease select-none hover:bg-gray-700 focus:outline-none focus:shadow-outline">
                                Cancelar Edição de Garagem
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