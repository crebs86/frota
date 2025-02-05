<script setup>
import ApplicationLogo from '@/Components/ApplicationLogo.vue';
import { Link } from '@inertiajs/vue3';

defineProps({
    main_class: String,
    logo_class: String,
    slot_class: String
});

</script>

<template>
    <div class="min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0">
        <div>
            <Link href="/">
            <img src="/logos/logo_VV.png" class="mx-auto" width="70%" />
            </Link>
        </div>

        <div class="w-full sm:max-w-md mt-6 px-6 py-4 shadow-md overflow-hidden sm:rounded-lg slot_class text-white">
            <slot />
        </div>
    </div>
</template>
<style scoped>
.slot_class {
    border: 2px solid #105ba650 !important;
    border-radius: 20px;
    backdrop-filter: blur(28px);
}
</style>