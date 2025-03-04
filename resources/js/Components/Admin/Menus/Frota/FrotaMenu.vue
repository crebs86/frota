<script setup>
import {Link} from '@inertiajs/vue3';
import has from '@/arrayHelpers'
</script>
<template>
    <div
        class="grid grid-cols-6 justify-items-center rounded-2xl bg-teal-50 drop-shadow-md m-1 mt-0.5 py-1 dark:drop-shadow-xl dark:bg-gray-400 min-w-full md:min-w-[50%] lg:min-w-[35%] mx-auto">
        <div
            v-if="has($page.props.auth.permissions, ['Motorista Editar', 'Motorista Ver', 'Motorista Criar', 'Motorista Apagar']) || has($page.props.auth.roles, ['Super Admin'])"
            class="col-span-1 flex flex-col items-center">
            <Link :href="route('frota.drivers.index')" class="flex flex-col items-center max-w-fill"
                  :class="route().current('frota.drivers.*') ? 'text-emerald-500 dark:text-lime-300' : 'text-gray-600 hover:text-emerald-600 dark:hover:text-lime-300'">
                <!--<mdicon name="account-multiple" title="Motoristas" />-->
                <img src="/icons/drivers.svg" alt="Motoristas" class="w-8">
                <span class="text-[10px] font-bold text-center">
                Motoristas
            </span>
            </Link>
        </div>
        <div
            v-if="has($page.props.auth.permissions, ['Garagem Editar', 'Garagem Ver', 'Garagem Criar', 'Garagem Apagar']) || has($page.props.auth.roles, ['Super Admin'])"
            class="col-span-1 flex flex-col items-center">
            <Link :href="route('frota.garages.index')" class="flex flex-col items-center max-w-fill"
                  :class="route().current('frota.garages.*') ? 'text-emerald-500 dark:text-lime-300' : 'text-gray-600 hover:text-emerald-600 dark:hover:text-lime-300'">
                <!--<mdicon name="garage-open-variant" title="Garagens"/>-->
                <img src="/icons/garages_2.svg" alt="Garagens" class="w-8">
                <span class="text-[10px] font-bold text-center">
                Garagens
            </span>
            </Link>
        </div>
        <div
            v-if="has($page.props.auth.permissions, ['Carro Editar', 'Carro Ver', 'Carro Criar', 'Carro Apagar']) || has($page.props.auth.roles, ['Super Admin'])"
            class="col-span-1 flex flex-col items-center">
            <Link :href="route('frota.cars.index')" class="flex flex-col items-center max-w-fill"
                  :class="route().current('frota.cars.*') ? 'text-emerald-500 dark:text-lime-300' : 'text-gray-600 hover:text-emerald-600 dark:hover:text-lime-300'">
                <!--<mdicon name="car-multiple" title="Carros"/>-->
                <img src="/icons/car.svg" alt="Carros" class="w-8">
                <span class="text-[10px] font-bold text-center">
                Carros
            </span>
            </Link>
        </div>
        <div
            v-if="has($page.props.auth.permissions, ['Tarefa Editar', 'Tarefa Ver', 'Tarefa Criar', 'Tarefa Apagar']) || has($page.props.auth.roles, ['Super Admin'])"
            class="col-span-1 flex flex-col items-center">
            <Link :href="route('frota.routes.index')" class="flex flex-col items-center max-w-fill"
                  :class="route().current('frota.routes.*') ? 'text-emerald-500 dark:text-lime-300' : 'text-gray-600 hover:text-emerald-600 dark:hover:text-lime-300'">
                <!--<mdicon name="routes" title="Rotas"/>-->
                <img src="/icons/route-finish.svg" alt="Rotas" class="w-8">
                <span class="text-[10px] font-bold text-center">
                Rotas
            </span>
            </Link>
        </div>
        <div class="col-span-1 flex flex-col items-center" v-if="has($page.props.auth.permissions,
            ['Solicitacao Criar', 'Solicitacao Ver', 'Solicitacao Apagar', 'Solicitacao Editar', 'Liberador'])
            || has($page.props.auth.roles, ['Super Admin'])">
            <Link :href="route('frota.requests.index')" class="flex flex-col items-center max-w-fill"
                  :class="route().current('frota.requests.*') ? 'text-emerald-500 dark:text-lime-300' : 'text-gray-600 hover:text-emerald-600 dark:hover:text-lime-300'">
                <!--<mdicon name="hand-extended" title="Solicitar carro"/>-->
                <img src="/icons/solicitar.svg" alt="Solicitar" class="w-8">
                <span class="text-[10px] font-bold text-center">
                Solicitações
            </span>
            </Link>
        </div>
        <div class="col-span-1 flex flex-col items-center" v-if="has($page.props.auth.roles, ['Motorista'])">
            <Link :href="route('frota.my-routes')" class="flex flex-col items-center max-w-fill"
                  :class="route().current('frota.my-routes') ? 'text-emerald-500 dark:text-lime-300' : 'text-gray-600 hover:text-emerald-600 dark:hover:text-lime-300'">
                <!--<mdicon name="routes-clock" title="Minha Rota"/>-->
                <img src="/icons/minhas.svg" alt="Minhas Rotas" class="w-8">
                <span class="text-[10px] font-bold text-center">
                Minhas
            </span>
            </Link>
        </div>
    </div>
</template>
