<script setup>
import VueMultiselect from 'vue-multiselect';

const props = defineProps({
    request: Object
})

function branchName({ id, name }) {
    if (id === 1) {
        return `${id ? id : ''} - Não Cadastrado`
    } else {
        return `${id ? id : ''} - ${name ? name : ''}`
    }
}

</script>
<template>
    <div class="fixed inset-0 flex items-center justify-center overflow-hidden mx-1">
        <div class="fixed inset-0 transition-opacity">
            <div class="absolute inset-0 bg-gray-500 opacity-95"></div>
        </div>
        <div v-if="props.request"
            class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all w-11/12 md:max-w-[1024px] dark:bg-gray-600 p-4">

            <div class="overflow-x-auto grid grid-cols-3 gap-3">

                <div class="col-span-3 md:col-span-1">
                    <label class="text-sm">
                        Hora
                    </label>
                    <VueMultiselect v-model="props.request.time" :options="$page.props.timetables" :multiple="false"
                        :close-on-select="true" selectedLabel="atual" placeholder="Hora" selectLabel="Selecionar"
                        deselectLabel="Remover" />

                    <div v-if="props.request.errors?.time"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.request.errors?.time">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-3 md:col-span-2">
                    <label class="text-sm">
                        Destino
                    </label>
                    <VueMultiselect v-model="props.request.branch" :options="$page.props.branches" :multiple="false"
                        :close-on-select="true" placeholder="Destino" label="name" track-by="id"
                        selectLabel="Selecionar" deselectLabel="Remover" @select="$page.props.errors.date = null"
                        :custom-label="branchName" />

                    <div v-if="props.request.errors?.branch"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.request.errors?.branch">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-3" v-if="props.request.branch?.id === 1">
                    <label class="text-sm">
                        Local*
                    </label>
                    <input type="text" v-model="props.request.local"
                        class="w-full rounded border border-red-500 bg-red-100 h-[41px] mt-0.5 text-gray-700">

                    <div v-if="props.request.errors?.local"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.request.errors?.local">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-3 md:col-span-1">
                    <label class="text-sm">
                        Duração*
                    </label>
                    <input type="time" v-model="props.request.duration"
                        class="w-full rounded border h-[41px] mt-0.5 text-gray-700">

                    <div v-if="props.request.errors?.duration"
                        class="text-sm text-red-500 bg-red-200 py-[0.2px] px-2 m-0.5 rounded-md border border-red-300 max-w-fit">
                        <small v-for="error in props.request.errors?.duration">{{ error }}</small>
                    </div>
                </div>

                <div class="col-span-3 mb-4 -mt-2">
                    <span v-for="(p, i) in props.request.passengers" :key="'ps_' + i" class=" inline-flex">
                        {{ p }}
                    </span>
                </div>

                <div class="h-[10rem] mx-2 col-span-2 mt-2">
                    <div class="text-center mt-3" v-if="props.request.errors?._checker">
                        <span class="border border-red-500 bg-red-400 rounded max-w-fit px-3">
                            {{ props.request.errors?._checker[0] }}
                        </span>
                    </div>
                </div>
            </div>

            <div class="dark:bg-gray-500 px-4 py-3 sm:px-6 flex gap-1">
                <button type="button"
                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm">
                    Salvar
                </button>
                <button type="button"
                    class="w-full inline-flex transition duration-500 ease justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm">
                    Fechar
                </button>
            </div>
        </div>
    </div>
</template>