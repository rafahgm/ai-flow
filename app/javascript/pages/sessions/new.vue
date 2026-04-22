<script setup lang="ts">
import { Head, useForm, Link } from '@inertiajs/vue3';
import Button from 'primevue/button';
import InputText from 'primevue/inputtext';
import Message from 'primevue/message';
import Password from 'primevue/password';


const form = useForm({
    email: '',
    password: ''
})

const submit = () => {
    form.post('/login')
}
</script>
<template>
    <Head title="Login" />
    <div class="min-h-screen flex items-center justify-center bg-surface-50 px-40">
        <div class="w-full max-w-md bg-white rounded-2xl shadow p-6">
            <h1 class="text-2xl font-semibold mb-1">Entrar</h1>
            <p class="text-sm text-surface-500 mb-6">
                Acesse sua conta para continuar
            </p>
            
            <form class="flex flex-col gap-4" @submit.prevent="submit">
                <div class="flex flex-col gap-1">
                    <InputText id="email" v-model="form.email" type="email" fluid placeholder="E-mail" />
                    <Message v-if="form.errors.email" severity="error" size="small" variant="simple">{{ form.errors.email }}</Message>
                </div>
                <div class="flex flex-col gap-1">
                    <Password id="password" placeholder="Senha" v-model="form.password" fluid toggle-mask :feedback="false" />
                    <Message v-if="form.errors.password" severity="error" size="small" variant="simple">{{ form.errors.password }}</Message>
                </div>
                <Button type="submit" label="Entrar" :loading="form.processing" fluid />
            </form>

            <div class="mt-6 text-sm text-center">
                <Link href="/signup" class="text-primary no-underline">Criar conta</Link>
            </div>
        </div>
    </div>
</template>