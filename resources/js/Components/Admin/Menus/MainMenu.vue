<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import { onMounted, ref } from 'vue';
import has from '@/arrayHelpers';

const numberMenuItems = ref(2);
const classNumberMenuItems = ref('7');
onMounted: {
    if (has(
        usePage().props.auth.permissions, ['ACL Editar', 'ACL Ver', 'ACL Criar', 'ACL Apagar', 'Usuario Editar', 'Usuario Ver', 'Usuario Criar', 'Usuario Apagar']
    )
        || has(usePage().props.auth.roles, ['Super Admin'])
    ) {
        numberMenuItems.value++
    }

    if (has(
        usePage().props.auth.permissions, ['Garagem Editar', 'Garagem Ver', 'Garagem Criar', 'Garagem Apagar', 'Ocorrência Editar', 'Ocorrência Ver', 'Ocorrência Criar', 'Ocorrência Apagar',
        'Motorista Editar', 'Motorista Ver', 'Motorista Criar', 'Motorista Apagar', 'Tarefa Editar', 'Tarefa Ver', 'Tarefa Criar', 'Tarefa Apagar'
    ]
    )
        || has(usePage().props.auth.roles, ['Super Admin'])
    ) {
        numberMenuItems.value++
    }

    if (has(
        usePage().props.auth.permissions, ['Cliente Editar', 'Cliente Ver', 'Cliente Criar', 'Cliente Apagar']
    )
        || has(usePage().props.auth.roles, ['Super Admin'])
    ) {
        numberMenuItems.value++
    }
    if (has(
        usePage().props.auth.permissions, ['Unidade Editar', 'Unidade Ver', 'Unidade Criar', 'Unidade Apagar']
    )
        || has(usePage().props.auth.roles, ['Super Admin'])
    ) {
        numberMenuItems.value++
    }
    if (has(usePage().props.auth.roles, ['Super Admin'])
    ) {
        numberMenuItems.value++
        numberMenuItems.value++
    }
    classNumberMenuItems.value = numberMenuItems.value > 8 ? parseInt(numberMenuItems.value / 2) : numberMenuItems.value;
}
const showMenuItems = 'grid grid-cols-' + classNumberMenuItems.value;

</script>
<template>
    <div class="shadow-lg pb-1 rounded-b-3xl min-w-full md:min-w-[50%] lg:min-w-[35%] mx-auto"
        :class="$page.props.app.settingsStyles.mainMenu.body">
        <div class="flex rounded-b-3xl bg-gray-100 dark:bg-gray-700 space-y-5 flex-col items-center text-[10px]">
            Olá, {{ usePage().props.auth.user.name }}!
        </div>
        <div class="px-2 py-1 items-center justify-around " :class="showMenuItems">
            <div class="flex flex-col items-center">
                <Link :href="route('dashboard')" :active="route().current('dashboard')"
                    class="col-span-1 flex flex-col items-center max-w-max"
                    :class="route().current('dashboard') ? $page.props.app.settingsStyles.mainMenu.iconsActive : $page.props.app.settingsStyles.mainMenu.icons">
                <mdicon name="view-dashboard" title="Dashboard" class="h-6 w-6" />
                <span class="text-[9px] md:text-[14px] font-medium text-center">
                    Painel
                </span>
                </Link>
            </div>
            <div v-if="has(usePage().props.auth.permissions, ['Motorista Editar', 'Motorista Ver', 'Motorista Criar', 'Motorista Apagar', 'Ocorrência Editar', 'Ocorrência Ver', 'Ocorrência Criar', 'Ocorrência Apagar', 'Tarefa Editar', 'Tarefa Ver', 'Tarefa Criar', 'Tarefa Apagar'])
                || has(usePage().props.auth.roles, ['Super Admin'])" class="flex flex-col items-center">
                <Link :href="route('frota.home')" :active="route().current('frota.*')"
                    class="col-span-1 flex flex-col items-center max-w-max"
                    :class="route().current('frota.*') ? $page.props.app.settingsStyles.mainMenu.iconsActive : $page.props.app.settingsStyles.mainMenu.icons">
                <mdicon name="garage-variant" title="Controle de Acesso" class="h-6 w-6" />
                <span class="text-[9px] md:text-[14px] font-medium text-center">
                    Frota
                </span>
                </Link>
            </div>
            <div v-if="has(usePage().props.auth.permissions, ['ACL Editar', 'ACL Ver', 'ACL Criar', 'ACL Apagar', 'Usuario Editar', 'Usuario Ver', 'Usuario Criar', 'Usuario Apagar'])
                || has(usePage().props.auth.roles, ['Super Admin'])" class="flex flex-col items-center">
                <Link :href="route('admin.acl.acl')" :active="route().current('admin.acl.*')"
                    class="col-span-1 flex flex-col items-center max-w-max"
                    :class="route().current('admin.acl.*') ? $page.props.app.settingsStyles.mainMenu.iconsActive : $page.props.app.settingsStyles.mainMenu.icons">
                <mdicon name="shield-lock-outline" title="Controle de Acesso" class="h-6 w-6" />
                <span class="text-[9px] md:text-[14px] font-medium text-center">
                    Acesso
                </span>
                </Link>
            </div>
            <div v-if="has(usePage().props.auth.permissions, ['Cliente Editar', 'Cliente Ver', 'Cliente Criar', 'Cliente Apagar'])
                || has(usePage().props.auth.roles, ['Super Admin'])" class="flex flex-col items-center">
                <Link :href="route('clients.index')" :active="route().current('clients.*')"
                    class="col-span-1 flex flex-col items-center max-w-max"
                    :class="route().current('clients.*') ? $page.props.app.settingsStyles.mainMenu.iconsActive : $page.props.app.settingsStyles.mainMenu.icons">
                <mdicon name="account-heart" title="Clientes" class="h-6 w-6" />
                <span class="text-[9px] md:text-[14px] font-medium text-center">
                    Clientes
                </span>
                </Link>
            </div>
            <div v-if="has(usePage().props.auth.permissions, ['Unidade Editar', 'Unidade Ver', 'Unidade Criar', 'Unidade Apagar'])
                || has(usePage().props.auth.roles, ['Super Admin'])" class="flex flex-col items-center">
                <Link :href="route('branches.index')"
                    :active="route().current('branches.*') || route().current('nova-unidade')"
                    class="col-span-1 flex flex-col items-center max-w-max"
                    :class="route().current('branches.*') || route().current('nova-unidade') ? $page.props.app.settingsStyles.mainMenu.iconsActive : $page.props.app.settingsStyles.mainMenu.icons">
                <mdicon name="source-branch" title="Unidades" class="h-6 w-6" />
                <span class="text-[9px] md:text-[14px] font-medium text-center">
                    Unidades
                </span>
                </Link>
            </div>
            <div v-if="has(usePage().props.auth.roles, ['Super Admin'])" class="flex flex-col items-center">
                <Link :href="route('settings.index')" :active="route().current('settings.*')"
                    class="col-span-1 flex flex-col items-center max-w-max"
                    :class="route().current('settings.*') ? $page.props.app.settingsStyles.mainMenu.iconsActive : $page.props.app.settingsStyles.mainMenu.icons">
                <mdicon name="cog" title="Configurações" class="h-6 w-6" />
                <span class="text-[9px] md:text-[14px] font-medium text-center">
                    Configurar
                </span>
                </Link>
            </div>
            <div v-if="has(usePage().props.auth.roles, ['Super Admin'])" class="flex flex-col items-center">
                <Link :href="route('audit.index')" :active="route().current('audit.*')"
                    class="col-span-1 flex flex-col items-center max-w-max"
                    :class="route().current('audit.*') ? $page.props.app.settingsStyles.mainMenu.iconsActive : $page.props.app.settingsStyles.mainMenu.icons">
                <mdicon name="lightbulb-on-outline" title="Auditar" class="h-6 w-6" />
                <span class="text-[9px] md:text-[14px] font-medium text-center">
                    Auditar
                </span>
                </Link>
            </div>
            <div class="flex flex-col items-center">
                <Link :href="route('user.account')" :active="route().current('admin.*')"
                    class="col-span-1 flex flex-col items-center max-w-max"
                    :class="route().current('user.*') ? $page.props.app.settingsStyles.mainMenu.iconsActive : $page.props.app.settingsStyles.mainMenu.icons">
                <mdicon name="account" title="Minha Conta" class="h-6 w-6" />
                <span class="text-[9px] md:text-[14px] font-medium text-center">
                    Conta
                </span>
                </Link>
            </div>
        </div>
    </div>
</template>
