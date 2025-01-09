<script setup>
import { toast } from '@/toast';
import axios from 'axios';
import { defineEmits, onMounted } from 'vue';

const abastecerModalStatus = defineEmits(['abastecerModalStatus'])

function statusModal(status) {
    abastecerModalStatus('abastecerModalStatus', status)
}

function loadLastFill() {
    axios.get(route('frota.load-last-fill', 1))
        .then((r) => {
            console.log(r.data)
        })
        .catch((e) => {
            toast.error(e.response.data)
        })
}

onMounted(() => {
    loadLastFill()
})

</script>
<template>
    <div
        class="overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none justify-center items-center flex pt-52 md:pt-0 ">
        <div class="relative my-6 mx-auto w-11/12 md:w-9/12 max-w-6xl h-5/6">
            <!--content-->
            <div class="border-0 rounded-lg shadow-lg relative flex flex-col w-full outline-none focus:outline-none"
                :class="$page.props.app.settingsStyles.main.innerSection">
                <!--header-->
                <div class="flex items-start justify-between p-5 border-b border-solid border-slate-200 rounded-t">
                    <h3 class="text-xl font-semibold uppercase">
                        Abastecimento
                    </h3>
                    <button @click="statusModal(false)"
                        class="absolute -top-3 -right-3 bg-red-500 hover:bg-red-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white">
                        &cross;
                    </button>
                </div>
                <!--body-->
                <div class="relative p-6 flex-auto">
                    corpo
                </div>
                <!--footer-->
                <div class="flex items-center justify-end p-6 border-t border-solid border-slate-200 rounded-b">
                    <slot name="button"></slot>
                    <button type="button" @click="statusModal(false)"
                        class="border border-red-500 bg-red-500 text-white hover:text-red-800 rounded-md px-4 py-2 m-2 transition duration-300 ease select-none hover:bg-red-200 focus:outline-none focus:shadow-outline">
                        Fechar
                    </button>
                </div>
            </div>
        </div>
    </div>
    <slot name="back" />
</template>