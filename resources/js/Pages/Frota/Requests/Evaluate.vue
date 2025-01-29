<script setup>
import has from '@/arrayHelpers';
import { getRouteStatus, getStyles } from '@/contrasts';
import axios from 'axios';
import { onMounted, ref } from 'vue';

const requests = ref([])

onMounted(() => {
    axios.get(route('frota.requests.evaluate'))
        .then((r) => {
            console.log(r.data)
            requests.value = r.data
        })
        .catch((e) => {
            console.log(e)
        })
        .finally()
})
</script>

<template>
    <div :class="$page.props.app.settingsStyles.main.subSection" class="mx-0.5 min-h-[calc(100vh/1.75)]">
        <h2 class="text-xl text-center">Avaliar Solicitações</h2>
        <div :class="$page.props.app.settingsStyles.main.innerSection" class="py-0.5 rounded">
            <table class="min-w-full" :class="$page.props.app.settingsStyles.main.body">
                <thead>
                    <tr>
                        <th
                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                            Motorista
                        </th>
                        <th
                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                            Hora
                        </th>
                        <th
                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                            Destino
                        </th>
                        <th
                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                            Passageiros
                        </th>
                        <th
                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                            Duração
                        </th>
                        <th
                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                            Status
                        </th>
                        <th
                            class="p-1.5 md:px-3 md:py-3 border-b-2 border-gray-300 text-center leading-4 tracking-wider">
                            Ações
                        </th>
                    </tr>
                </thead>
                <tbody class="border border-black">
                    <tr v-for="(r, i) in requests" :key="'reqs_' + i">
                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                            {{ r.driver }}
                        </td>
                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                            {{ r.time }}
                        </td>
                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center"
                            :class="r.to === 1 || r.b === 1 ? 'underline underline-offset-8' : ''">
                            {{ r.branch }}
                            <mdicon name="circle" class="float-right text-red-500" v-if="r.to === 1 || r.b === 1" />
                        </td>
                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                            {{ Object.values(JSON.parse(r.passengers ?? '[]')).length }}
                        </td>
                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                            {{ r.duration }}
                        </td>
                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                            <p class="mx-auto text-sm px-2 rounded-md border" :class="getStyles(r.type, r.status)">
                                {{
                                    getRouteStatus(false, r.status)
                                }}
                                <br>
                                <span class="text-[10px]">
                                    {{
                                        r.created_at ? moment(r.created_at).format('DD/MM/YYYY HH:mm:ss') :
                                            ''
                                    }}
                                </span>
                            </p>
                        </td>
                        <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500 text-center">
                            <button @click="setRouteToEdit(r)"
                                v-if="(has($page.props.auth.permissions, ['Solicitacao Editar', 'Solicitacao Apagar']) || has($page.props.auth.roles, ['Super Admin']))">
                                <mdicon name="source-branch-check" class="hover:text-green-500 dark:hover:text-blue-300" />
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<style scoped></style>
