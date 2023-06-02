<script setup>

const props = defineProps(['titles']);

</script>
<template>
    <table class="min-w-full dark:bg-gray-600">
        <thead>
            <tr>
                <th v-for="(value, index) in props.titles" :key="index + '' + value"
                    class="px-3 py-1.5 md:px-6 md:py-3 bg-gray-100 border-b-2 border-gray-300 text-left leading-4 text-blue-500 tracking-wider dark:bg-gray-700 dark:text-gray-300">
                    {{ value }}
                </th>
            </tr>
        </thead>
        <tbody class="bg-white dark:bg-gray-600">
            <!-- <tr v-for="(v, i) in clientsList?.data" :key="i"> -->
            <tr>
                <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500">
                    <!-- <td class="px-3 py-1.5 md:px-6 md:py-3 whitespace-no-wrap border-b border-gray-500"
                    v-for="(value, index) in v" :key="i.id + '' + index"> -->
                    <div class="text-sm leading-5 text-blue-900 dark:text-gray-300">
                        <!-- {{ value }} -->
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
</template>