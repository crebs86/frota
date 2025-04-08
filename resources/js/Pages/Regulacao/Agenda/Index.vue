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
    postos_coleta: Object | null,
    posto_coleta: String | null,
    status: String | null,
    inicio: String | null,
    fim: String | null,
    ordem: String | null,
    direcao: String | null,
    page: null
})

const ordemOptions = ref(
    [
        { id: 0, nome: 'Posto de Coleta' },
        { id: 1, nome: 'Início' },
        { id: 2, nome: 'Fim' },
        { id: 3, nome: 'Hora Início' },
        { id: 4, nome: 'Hora Fim' },
        { id: 5, nome: 'Vagas' },
        { id: 6, nome: 'Intervalo' }
    ]
)
//http://127.0.0.1:8000/regulacao/agenda?direcao=Descendente&fim=2025-05-21&inicio=2025-04-01&ordem=4&page=2&posto_coleta=US%20Ponta%20da%20Fruta&status=Inativo
const filtro = ref({
    posto_coleta: props.postos_coleta.find((item) => item.name == props.posto_coleta) ?? null,
    status: props.status,
    inicio: props.inicio ? moment(props.inicio).format('DD/MM/YYYY') : null,
    fim: props.fim ? moment(props.fim).format('DD/MM/YYYY') : null,
    ordem: ordemOptions.value.find((item) => item.id == props.ordem) ?? null,
    direcao: props.direcao,
    hash: '',
})

function paginate(page = 0) {
    let f = ''

    f += setFiltro(f, filtro.value.posto_coleta?.name, 'posto_coleta')
    f += setFiltro(f, filtro.value.posto_coleta?.hash, 'hash')
    f += setFiltro(f, filtro.value.inicio ? moment(filtro.value.inicio, 'DD/MM/YYYY').format('YYYY-MM-DD') : null, 'inicio')
    f += setFiltro(f, filtro.value.fim ? moment(filtro.value.fim, 'DD/MM/YYYY').format('YYYY-MM-DD') : null, 'fim')
    f += setFiltro(f, filtro.value.ordem?.id, 'ordem')
    f += setFiltro(f, filtro.value.direcao, 'direcao')
    f += setFiltro(f, filtro.value.status, 'status')
    if (page == 0) {
        f += setFiltro(f, props.page, 'page')
    } else {
        f += setFiltro(f, page, 'page')
    }
    router.visit(route('regulacao.agenda.index') + `${f}`)
}

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

function setFiltro(f, valor, nomeFiltro) {
    if (!f) {
        if (valor) {
            return `?${nomeFiltro}=${valor}`
        }
        return ''
    } else {
        if (valor) {
            return `&${nomeFiltro}=${valor}`
        }
        return ''
    }
}

function filtrar() {

}

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
                            {{ filtro }} <br>
                            {{ props.posto_coleta }}
                            <br>
                            <Accordion value="1" class="min-w-full">
                                <AccordionPanel value="1">
                                    <AccordionHeader>Filtros</AccordionHeader>
                                    <AccordionContent>
                                        <div class="grid grid-cols-6 gap-2">
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Posto</InputGroupAddon>
                                                    <Select class="w-full" filter option-label="name"
                                                        v-model="filtro.posto_coleta" showClear
                                                        :options="props.postos_coleta"></Select>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Status</InputGroupAddon>
                                                    <Select class="w-full" filter v-model="filtro.status" showClear
                                                        :options="['Ativo', 'Inativo']"></Select>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>De</InputGroupAddon>
                                                    <DatePicker class="w-full" show-icon v-model="filtro.inicio" showButtonBar>
                                                    </DatePicker>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Até</InputGroupAddon>
                                                    <DatePicker class="w-full" show-icon v-model="filtro.fim" showButtonBar>
                                                    </DatePicker>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Ordenar por</InputGroupAddon>
                                                    <Select class="w-full" option-label="nome" v-model="filtro.ordem"
                                                        showClear :options="ordemOptions">
                                                    </Select>
                                                </InputGroup>
                                            </div>
                                            <div class="col-span-6 md:col-span-3">
                                                <InputGroup>
                                                    <InputGroupAddon>Direção</InputGroupAddon>
                                                    <Select class="w-full" v-model="filtro.direcao" showClear
                                                        :options="['Ascendente', 'Descendente']"></Select>
                                                </InputGroup>
                                            </div>
                                            <Button label="Filtrar" severity="success" @click="paginate(1)"
                                                class="col-span-6 w-32" />
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
                                table-style="width: 99%; min-width: 40rem" class="mt-2">

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
                                        <Tag :value="!slotProps.data.deleted_at ? 'Sim' : 'Não'"
                                            :severity="!slotProps.data.deleted_at ? 'success' : 'warn'" />
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
