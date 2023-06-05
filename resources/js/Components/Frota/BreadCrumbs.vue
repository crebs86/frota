<script setup>
const props = defineProps({
    breadCrumbs: Object
});
</script>
<template>
    <li v-for="(bc, i) in props.breadCrumbs">
        <div class="flex items-center">
            <mdicon class="text-gray-400" name="chevron-right" />
            <a :href="bc.link"
                class="ml-1 text-sm font-medium text-gray-700 hover:text-gray-900 md:ml-2 dark:text-gray-400 dark:hover:text-white">
                {{ bc.label }}
            </a>
        </div>
    </li>
</template>