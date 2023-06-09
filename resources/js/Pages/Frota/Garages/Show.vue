<script setup>
import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';
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

    <FrotaLayout>

        <template #currentPage>
            <BreadCrumbs
                :breadCrumbs="[{ label: 'Garagens', link: route('garages.index') }, { label: $page.props.garage[0].branch.name, link: '' }]">
            </BreadCrumbs>
        </template>

        <template #contentMain>
            <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                <div class="p-2 rounded-lg h-[calc(100vh/1.33)]" :class="$page.props.app.settingsStyles.main.innerSection">

                    <div class="relative">
                        <label class="text-sm text-gray-500 dark:text-gray-400 flex">
                            Nome (local)
                            <Link :href="route('branches.show', props.garage[0].id)">
                            <mdicon name="open-in-new" />
                            </Link>
                        </label>
                        <input readonly type="text" :value="props.garage[0].branch.name" placeholder="Nome" maxlength="25"
                            class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad] bg-slate-300">
                    </div>
                    <div class="mt-2 pl-1.5">
                        <div class="flex w-full mb-5">
                            <label for="cnh" class="flex items-center cursor-pointer">
                                <div class="relative">
                                    <input type="checkbox" id="cnh" class="sr-only" :checked="garageForm.deleted_at"
                                        disabled />
                                    <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                    </div>
                                    <div class="absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition"
                                        :class="!canEdit ? 'dot-dis' : 'dot'">
                                    </div>
                                </div>
                                <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                    Garagem Ativa?
                                </div>
                            </label>
                        </div>
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