<script setup>
import VueMultiselect from "vue-multiselect";
import {onMounted, ref} from "vue";
import {branchName} from "@/helpers";
import {validateDate} from "@/validates/validates";
import validateUpRt from "@/validates/createUpdateRoute";
import axios from "axios";
import {toast} from "@/toast";

const props = defineProps({
    routeForEdition: Object,
    _checker: String
})

const emit = defineEmits(['routeUpdated'])

const passengersEditModel = ref('')

function setEditPassenger(remove = false, passenger = null) {
    props.routeForEdition.errors.passengers = ''
    if (remove) {
        props.routeForEdition.passengers.splice(props.routeForEdition.passengers.indexOf(passenger), 1)
    } else if (passengersEditModel.value) {
        props.routeForEdition.passengers.push(passengersEditModel.value)
        passengersEditModel.value = ''
    } else {
        props.routeForEdition.errors.passengers = 'Vazio.'
    }
}


function updateRoute() {
    let val = validateUpRt(props.routeForEdition)
    if (val._run) {
        axios.put(route('frota.routes.route.update', props.routeForEdition.id), {
            id: props.routeForEdition.id,
            branch: props.routeForEdition.branch,
            currentBranch: props.routeForEdition.currentBranch,
            time: props.routeForEdition.time,
            duration: props.routeForEdition.duration,
            passengers: props.routeForEdition.passengers,
            obs: props.routeForEdition.obs,
            local: props.routeForEdition.local,
            ignore: props.routeForEdition.ignore,
            _checker: props._checker,
        })
            .then(() => {
                emit('routeUpdated', true)
            })
            .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    props.routeForEdition.errors = e.response.data.error
                } else if (e.response?.status === 422) {
                    toast.error(e.response.data.message)
                    props.routeForEdition.errors = e.response.data.errors
                } else if (e.response?.status === 409) {
                    props.routeForEdition.ignoreQuestion = true
                    toast.error('Todos os campos são obrigatórios.')
                    props.routeForEdition.errors = e.response.data.errors
                } else if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    props.routeForEdition.errors = e.response.data
                }
            })
    } else {
        props.routeForEdition.errors = val
        toast.error('Preencha todos os campos para atualizar a rota');
    }
}

onMounted(() => {
    props.routeForEdition.ignore = false
    props.routeForEdition.ignoreQuestion = false
    axios.get(route('frota.tasks.get-route-details', props.routeForEdition.id))
        .then((r) => {
            props.routeForEdition.obs = r.data.obs
        })
        .catch((e) => {
                if (e.response?.status === 403) {
                    toast.error(e.response.data.error)
                    props.routeForEdition.errors = e.response.data.error
                } else if (e.response?.status === 503) {
                    toast.error(e.response.data)
                    props.routeForEdition.errors = e.response.data
                }
            }
        )
        .finally(() => {

        })
})

</script>

<template>
    <!--Modal editar rota-->
    <div class="fixed inset-0 flex items-center justify-center overflow-hidden mx-1">
        <div class="fixed inset-0 transition-opacity">
            <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
        </div>
        <div v-if="props.routeForEdition"
             class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600 p-4">

            <div class="overflow-x-auto grid grid-cols-3 gap-3">

                <div class="col-span-3 md:col-span-1">
                    <label class="text-sm">
                        Hora
                    </label>
                    <VueMultiselect v-model="props.routeForEdition.time" :options="$page.props.timetables"
                                    :multiple="false" :close-on-select="true" selectedLabel="atual"
                                    placeholder="Hora" selectLabel="Selecionar"
                                    deselectLabel="Remover"/>
                    <div v-if="props.routeForEdition.errors?.time"
                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.time">{{ error }}</small>
                    </div>
                    <div v-if="props.routeForEdition.ignoreQuestion">
                        <label for="_ignore" class="p-1.5 text-amber-500 font-bold">Ignorar conflito e agendar</label>
                        <input type="checkbox" id="_ignore" v-model="props.routeForEdition.ignore"
                               class="text-red-400"/>
                    </div>
                </div>

                <div class="col-span-3 md:col-span-2">
                    <label class="text-sm">
                        Unidade
                    </label>
                    <VueMultiselect v-model="props.routeForEdition.branch" :options="$page.props.branches"
                                    :multiple="false" :close-on-select="true" placeholder="Unidade"
                                    label="name"
                                    track-by="id" selectLabel="Selecionar" deselectLabel="Remover"
                                    @select="$page.props.errors.date = null"
                                    :custom-label="branchName"/>

                    <div v-if="props.routeForEdition.errors?.branch"
                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.branch">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-3" v-if="props.routeForEdition.branch?.id === 1">
                    <label class="text-sm">
                        Local*
                    </label>
                    <input type="text" v-model="props.routeForEdition.local"
                           class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                    <div v-if="props.routeForEdition.errors?.local"
                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.local">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-3 md:col-span-1">
                    <label class="text-sm">
                        Duração*
                    </label>
                    <input type="time" v-model="props.routeForEdition.duration"
                           class="w-full rounded border h-[41px] mt-0.5 text-gray-700">

                    <div v-if="props.routeForEdition.errors?.duration"
                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.routeForEdition.errors?.duration">{{ error }}</small>
                    </div>
                </div>
                <div class="col-span-3 md:col-span-3">
                    <div class="grid grid-cols-6">
                        <label class="text-sm col-span-6">
                            Incluir Passageiro*
                        </label>
                        <div class="inline-flex col-span-6">
                            <input type="text" v-model="passengersEditModel"
                                   class="w-full rounded border border-black h-[41px] mt-0.5 text-gray-700"/>
                            <button type="button" @click="setEditPassenger(false)"
                                    :disabled="passengersEditModel?.length < 3"
                                    class="border rounded-md px-4 py-2 my-0.5 transition duration-500 ease select-none focus:outline-none focus:shadow-outline"
                                    :class="passengersEditModel?.length < 4 ? 'border-gray-700 bg-gray-400 text-gray-100' : 'border-blue-600 bg-blue-500 text-blue-100 hover:bg-blue-700'">
                                Incluir
                            </button>
                        </div>
                        <div v-if="props.routeForEdition.errors?.passengers"
                             class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                            <small v-for="error in props.routeForEdition.errors?.passengers">
                                {{ error }}
                            </small>
                        </div>
                    </div>
                </div>
                <div class="col-span-3 mb-4 -mt-2">
                    <span v-for="(p, i) in props.routeForEdition.passengers" :key="'ps_' + i"
                          class=" inline-flex">
                        {{ p }}
                        <button @click="setEditPassenger(true, p)">
                            <mdicon name="close" class="text-red-400"/>
                        </button>
                    </span>
                </div>
                <div class="col-span-3 md:col-span-2 grid grid-cols-1">
                    <label class="text-sm text-gray-500 dark:text-gray-400 col-span-6">
                        Obs.:
                    </label>
                    <textarea class="rounded text-gray-600" v-model="props.routeForEdition.obs"></textarea>
                    <div v-if="props.routeForEdition.errors?.obs"
                         class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit col-span-6">
                        <small v-for="error in props.routeForEdition.errors?.obs">{{ error }}</small>
                    </div>
                </div>
                <div class="h-[10rem] mx-2 col-span-2 mt-2">
                    <div class="text-center mt-3" v-if="props.routeForEdition.errors?._checker">
                        <span class="border border-red-500 bg-red-400 rounded max-w-fit px-3">
                            {{ props.routeForEdition.errors?._checker[0] }}
                        </span>
                    </div>
                </div>
            </div>

            <div class="dark:bg-gray-500 px-4 py-3 sm:px-6 flex gap-1">
                <button type="button"
                        class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm"
                        @click="updateRoute()">
                    Salvar
                </button>
                <slot name="close_button"></slot>
            </div>
        </div>
    </div>
</template>

<style scoped>

</style>
