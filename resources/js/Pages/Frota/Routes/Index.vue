<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import VueMultiselect from 'vue-multiselect';
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import hasPermission from '@/permissions';
import { toast } from '@/toast'

const filter = useForm({
    date: '',
    branch: '',
    driver: ''
});

const page = usePage();

function drivers(id) {
    return id.user.name
}

function filtering() {
    if (!filter.date || (!filter.branch && !filter.driver)) {
        page.props.errors.date = 'Informe uma data e, uma unidade ou motorista para prosseguir.'
    } else {
        filter.post(route('frota.tasks.filter'), {
            onSuccess: () => {
                if(page.props.flash.error){
                    toast.warning(page.props.flash.error)
                }
            },
            onError: () => {
                toast.error('Erro ao processar solicitação.');
            }
        })
    }
}

function clean(model) {
    if (model === 'branch') {
        filter.driver = ''
    } else if (model === 'driver') {
        filter.branch = ''
    }
}

</script>

<template>

    <Head title="Rotas" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Rotas
                <Link :href="route('frota.routes.create')" class="mt-0.5">
                <mdicon name="plus" />
                </Link>
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 h-[calc(100vh/1.66)]">
                    <p class="text-lg mb-1.5">Filtrar Rotas</p>
                    <div class="p-2 rounded-lg grid grid-cols-1 md:grid-cols-5 gap-4">
                        <div class="relative z-0 mb-6 w-full group">
                            <div>&nbsp;</div>
                            <input type="date" name="name" id="name" v-model="filter.date"
                                class="block py-2.5 px-0 w-full text-sm bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:border-gray-600 dark:focus:border-blue-300 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                :class="page.props.errors.date ? 'border-red-600' : ''" required placeholder=" " />
                            <label for="name"
                                class="absolute text-lg duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-300 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                Data*
                            </label>
                        </div>
                        <div class="relative z-10 mb-6 w-full md:col-span-2">
                            <div>Unidade</div>
                            <VueMultiselect v-model="filter.branch" :options="$page.props.branches" :multiple="false"
                                :close-on-select="true" placeholder="Unidade" label="name" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover" @select="clean('branch')" />
                        </div>
                        <div class="relative z-10 mb-6 w-full md:col-span-2">
                            <div>Motorista</div>
                            <VueMultiselect v-model="filter.driver" :options="$page.props.drivers" :multiple="false"
                                :close-on-select="true" placeholder="Motorista" :custom-label="drivers" track-by="id"
                                selectLabel="Selecionar" deselectLabel="Remover" @select="clean('driver')" />
                        </div>

                        <div v-if="$page.props.errors.date" class="text-sm text-red-500 md:col-span-5">
                            {{ $page.props.errors.date }}
                        </div>
                        <div>
                            <button type="button" @click="filtering" :disabled="filter.processing"
                                class="border border-green-600 bg-green-500 text-green-100 rounded-md px-4 py-2 transition duration-500 ease select-none hover:bg-green-700 focus:outline-none focus:shadow-outline"
                                :class="filter.processing ? 'bg-yellow-300 text-yellow-600' : ''">
                                Filtrar
                            </button>
                        </div>
                    </div>

                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <table class="min-w-full">
                            <thead>
                                <tr>
                                    <th v-for=" (value, index) in ['Motorista', 'Ações']" :key="index + '' + value"
                                        class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider"
                                        :class="$page.props.app.settingsStyles.main.container">
                                        {{ value }}
                                    </th>
                                </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                                <tr v-for="( s, i ) in $page.props.schedule " :key="i">
                                    <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ s.driver_name.user.name }}
                                    </td>
                                    <td
                                        class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-left">
                                        <div class="flex gap-1">

                                            <Link :href="route('frota.schedules.show', s.driver)" title="Ver"
                                                v-if="hasPermission(
                                                    $page.props.auth.permissions, ['Carros Editar', 'Carros Apagar', 'Carros Ver']) || hasPermission($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="car-search" />
                                            </Link>

                                            <Link :href="route('frota.schedules.edit', s.driver)" title="Editar"
                                                v-if="hasPermission(
                                                    $page.props.auth.permissions, ['Carros Editar', 'Carros Apagar']) || hasPermission($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="car-wrench" />
                                            </Link>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
