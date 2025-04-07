<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SubSection from '@/Components/Admin/SubSection.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import has from '@/arrayHelpers'
import { TailwindPagination } from 'laravel-vue-pagination';
import moment from 'moment';
import { Button, Column, DataTable, Tag, Accordion, AccordionHeader, AccordionContent, AccordionPanel, InputText, InputGroup, InputGroupAddon, Select, DatePicker } from 'primevue';
import { ref } from 'vue';
import JsonExcel from "vue-json-excel3"

const props = defineProps({
    agendas: Object | null,
    postos_coleta: Object | null
})

function paginate(page = 1) {
    router.visit(route('regulacao.agenda.index') + `?page=${page}`)
}

const filtro = ref({
    posto_coleta: null,
    status: null,
    inicio: null,
    fim: null,
    ordem: null,
    direcao: null,
})

const cabecalhoXLS = ref({
    "Posto de Coleta": "posto_coleta",
    "Data Início": {
        field: "vigencia_inicio",
        callback: (value) => {
            return moment(value).format('DD/MM/YYYY')
        }
    },
    "Data Fim": {
        field: "vigencia_fim",
        callback: (value) => {
            return moment(value).format('DD/MM/YYYY')
        }
    },
    "Hora Início": "hora_inicio",
    "Hora Fim": "hora_fim",
    "Ativo": {
        field: "deleted_at",
        callback: (value) => {
            return value ? 'Sim' : 'Não'
        }
    },
    "Intervalo": "intervalo",
    "Vagas": "vagas",
})

</script>

<template>

    <Head title="Agendas" />

    <AuthenticatedLayout>
        <SubSection>
            <template #header>
                Agendas
            </template>
            <template #content>
                <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.59)]">
                    <div class="inline-flex">
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.home')" title="Início Regulação">
                        <img src="/icons/home.svg" alt="Início Regulação" class="w-6">
                        </Link>
                        <Link
                            v-if="has(
                                $page.props.auth.permissions, ['Contrato Criar']) || has($page.props.auth.roles, ['Super Admin'])"
                            class="flex gap-1 max-w-max text-blue-700 hover:text-gray-700 bg-blue-200 hover:bg-blue-400 p-1.5 border m-0.5 mb-1 rounded shadow-lg"
                            :href="route('regulacao.agenda.create')" title="Criar Agenda">
                        <img src="/icons/add.svg" alt="Criar Agenda" class="w-6">
                        </Link>
                    </div>

                    <div class="p-2 rounded-lg overflow-y-auto"
                        :class="$page.props.app.settingsStyles.main.innerSection">
                        <div class="grid grid-cols-1 place-items-center">

                            <Accordion value="1" class="min-w-full">
                                <AccordionPanel value="0">
                                    <AccordionHeader>Filtrar</AccordionHeader>
                                    <AccordionContent>
                                        <div class="grid grid-cols-6 gap-2">
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Posto</InputGroupAddon>
                                                    <Select class="w-full" filter option-label="name" v-model="filtro.posto_coleta"
                                                        :options="props.postos_coleta"></Select>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Status</InputGroupAddon>
                                                    <Select class="w-full" filter v-model="filtro.status"
                                                        :options="['Ativo', 'Inativo']"></Select>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Início</InputGroupAddon>
                                                    <DatePicker class="w-full" show-icon v-model="filtro.inicio"></DatePicker>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Fim</InputGroupAddon>
                                                    <DatePicker class="w-full" show-icon v-model="filtro.fim"></DatePicker>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Ordenar por</InputGroupAddon>
                                                    <Select class="w-full" option-label="nome" v-model="filtro.ordem"
                                                        :options="[{ id: 1, nome: 'Posto de Coleta' }, { id: 1, nome: 'Início' }, { id: 1, nome: 'Fim' }, { id: 1, nome: 'Hora Início' }, { id: 1, nome: 'Hora Fim' }, { id: 1, nome: 'Vagas' }, { id: 1, nome: 'Intervalo' }]">
                                                    </Select>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Direção</InputGroupAddon>
                                                    <Select class="w-full" v-model="filtro.direcao"
                                                        :options="['Ascendente', 'Descendente']"></Select>
                                                </InputGroup>
                                            </div>
                                        </div>
                                    </AccordionContent>
                                </AccordionPanel>
                            </Accordion>

                            <JsonExcel v-if="props.agendas?.data"
                                class="p-3 m-1 mt-3 bg-[#34d399] text-black hover:opacity-70 rounded-md cursor-pointer transition duration-300 place-self-end font-medium"
                                :data="props.agendas?.data" :fields="cabecalhoXLS" worksheet="Agenda" name="agenda.xls"
                                type="xlsx">
                                Baixar Excel
                            </JsonExcel>

                            <DataTable :value="props.agendas?.data ?? []" :class="'w-full'"
                                table-style="width: 99%; min-width: 68rem" class="mt-2">

                                <Column field="posto_coleta" header="Posto Coleta" />

                                <Column field="vigencia_inicio" header="Início">
                                    <template #body="slotProps">
                                        {{ moment(slotProps.data.vigencia_inicio).format('DD/MM/YYYY') }}
                                        {{ slotProps.data.hora_inicio }}
                                    </template>
                                </Column>

                                <Column field="vigencia_fim" header="Fim">
                                    <template #body="slotProps">
                                        {{ moment(slotProps.data.vigencia_fim).format('DD/MM/YYYY') }}
                                        {{ slotProps.data.hora_fim }}
                                    </template>
                                </Column>

                                <Column field="vagas" header="Vagas Abertas" />

                                <Column field="intervalo" header="Intervalo" />

                                <Column field="deleted_at" header="Ativo">
                                    <template #body="slotProps">
                                        <Tag :value="slotProps.data.deleted_at ? 'Sim' : 'Não'"
                                            :severity="slotProps.data.deleted_at ? 'success' : 'warn'" />
                                    </template>
                                </Column>

                                <Column field="id" header="Açoes">
                                    <template #body="slotProps">
                                        {{ slotProps.data.id }}
                                    </template>
                                </Column>

                            </DataTable>

                            <TailwindPagination class="mt-3"
                                :item-classes="['bg-blue-100 text-gray-500 border-gray-400 hover:bg-white dark:bg-gray-600 dark:text-gray-100 dark:border-gray-300 dark:hover:bg-gray-800']"
                                :active-classes="['bg-white border-gray-600 text-blue-600 dark:bg-gray-300 dark:border-gray-500 dark:text-blue-500']"
                                :data="props.agendas ?? []" :limit="1" @pagination-change-page="paginate" />
                        </div>
                    </div>
                </div>
            </template>
        </SubSection>
    </AuthenticatedLayout>
</template>
