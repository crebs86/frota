<script setup>
import FrotaLayout from '@/Layouts/Frota/FrotaLayout.vue';
import BreadCrumbs from '@/Components/Frota/BreadCrumbs.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import hasPermission from '@/permissions';
import { ref } from 'vue';

const props = defineProps({
    canEdit: Boolean,
    garage: Object
});

const garageForm = useForm({
    deleted_at: props.garage[0].deleted_at === null ? true : false
});

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
                    <template v-if="$page.props.canEdit">
                        <div class="relative">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Matrícula (opcional)
                            </label>
                            <input type="text" :v-model="props.garage[0].branch.name" name="name" placeholder="Matrícula"
                                maxlength="25"
                                class="w-full px-4 mb-3 rounded-md border py-[9px] text-[#35495e] text-[14px] placeholder-[#adadad]" />
                        </div>
                        <div v-if="$page.props.errors.deleted_at" class="text-sm text-red-500">
                            {{ $page.props.errors.name }}
                        </div>

                    </template>

                    <template v-else>
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
                        <div class="mt-2 pl-1.5">
                            <div class="flex w-full mb-5">
                                <label for="cnh" class="flex items-center cursor-pointer">
                                    <div class="relative">
                                        <input type="checkbox" id="cnh" class="sr-only"
                                            :checked="garageForm.deleted_at === null ? true : false" disabled
                                            v-model="garageForm.deleted_at" />
                                        <div class="bg-teal-200 dark:bg-gray-500 w-10 h-4 rounded-full shadow-inner">
                                        </div>
                                        <div
                                            class="dot-dis absolute w-6 h-4 bg-white rounded-full shadow -left-1 -top-0 transition">
                                        </div>
                                    </div>
                                    <div class="ml-3 text-gray-500 dark:text-gray-400 text-sm">
                                        Garagem Ativa?
                                    </div>
                                </label>
                            </div>
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