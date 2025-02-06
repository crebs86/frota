<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import FrotaMenu from '@/Components/Admin/Menus/Frota/FrotaMenu.vue';
import { Head, useForm } from '@inertiajs/vue3';
import moment from 'moment';
import { onMounted, ref } from 'vue';

const props = defineProps({
    history: Object | null,
    de: String | null,
    para: String | null,
    car: String | null
})

const form = useForm({
    de: '',
    para: ''
})

const historyFill = ref();

function filterDate() {
    form.get(route('frota.load-history-fill', [props.car, form.de, form.para]))
}

onMounted(() => {
    historyFill.value = props.history
    form.de = props.de
    form.para = props.para
})

</script>

<template>

    <Head title="histórico de Abastecimentos" />

    <AuthenticatedLayout>

        <template #inner_menu>
            <FrotaMenu />
        </template>
        <SubSection>
            <template #header>
                Veículos
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5">
                    <!--                     <Link
                        v-if="has(
                            $page.props.auth.permissions, ['Carro Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                        class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                        :href="route('frota.cars.create')" title="Novo Carro">
                    <mdicon name="car-arrow-right" />
                    <div>
                        Novo Veículo
                    </div>
                    </Link> -->

                    <div class="grid grid-cols-1 md:grid-cols-2">
                        <div class="grid grid-cols-1 col-span-2 md:col-span-1">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                De
                            </label>
                            <input type="date" v-model="form.de"
                                class="rounded border border-black h-[41px] mt-0.5 text-gray-700" />

                            <div v-if="form.de?.errors"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in form.de.errors">{{ error }} </small>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 col-span-2 md:col-span-1">
                            <label class="text-sm text-gray-500 dark:text-gray-400">
                                Para
                            </label>
                            <input type="date" v-model="form.para"
                                class="rounded border border-black h-[41px] mt-0.5 text-gray-700" />

                            <div v-if="form.para?.errors"
                                class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                                <small v-for="error in form.para.errors">{{ error }} </small>
                            </div>
                        </div>
                        <button type="button" @click="filterDate"
                            class="border border-green-500 bg-green-500 text-white hover:text-green-800 rounded-md px-4 py-2 m-2 transition duration-300 ease select-none hover:bg-green-200 focus:outline-none focus:shadow-outline col-span-2 md:col-span-1">
                            Filtrar Data
                        </button>
                    </div>
                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <table class="min-w-full">
                            <thead>
                                <tr>
                                    <th v-for=" (value, index) in ['Veículo', 'Placa', 'Motorista', 'Quantidade', 'Valor', 'Local', 'Data']"
                                        :key="index + '' + value"
                                        class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-left leading-4 tracking-wider"
                                        :class="$page.props.app.settingsStyles.main.container">
                                        {{ value }}
                                    </th>
                                </tr>
                            </thead>
                            <tbody :class="$page.props.app.settingsStyles.main.body">
                                <tr v-for="( c, i ) in historyFill" :key="i">
                                    <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ c.car_model.modelo }}
                                    </td>
                                    <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ c.car_model.placa }}
                                    </td>
                                    <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ c.driver.user.name }}
                                    </td>
                                    <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ c.quantidade }}
                                    </td>
                                    <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ c.valor }}
                                    </td>
                                    <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ c.local }}
                                    </td>
                                    <td class="px-3 py-1.5 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        {{ moment(c.hora).format('DD/MM/YYYY HH:mm') }}
                                    </td>
                                    <!--                                     <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                                        <div class="flex justify-center gap-1">
                                            <Link :href="route('frota.cars.show', c.id)" title="Ver"
                                                v-if="has(
                                                    $page.props.auth.permissions, ['Carros Editar', 'Carros Ver', 'Carros Criar', 'Carros Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="car-info" />
                                            </Link>
                                            <Link :href="route('frota.cars.edit', c.id)" title="Editar"
                                                v-if="has(
                                                    $page.props.auth.permissions, ['Carros Editar', 'Carros Apagar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="car-cog" />
                                            </Link>
                                            <Link
                                                :href="route('frota.load-history-fill', [c.id, moment().format('YYYY-MM-DD')])"
                                                title="Histórico de Abastecimento"
                                                v-if="has(
                                                    $page.props.auth.permissions, ['Combistivel Editar', 'Combistivel Apagar', 'Combustivel Ver', 'Combustivel Criar']) || has($page.props.auth.roles, ['Super Admin'])">
                                            <mdicon name="gas-station" />
                                            </Link>
                                        </div>
                                    </td> -->
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
