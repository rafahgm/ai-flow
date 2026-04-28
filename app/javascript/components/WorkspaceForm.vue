<script setup lang="ts">
import { useForm } from "@inertiajs/vue3";
import Dialog from "primevue/dialog"
import Button from "primevue/button"
import InputText from "primevue/inputtext";
import {ref} from "vue"

const open = ref(false)

const form = useForm({
    name: ''
})

function submit() {
    form.post('/workspaces', {
        preserveScroll: true,
        onSuccess: () => {
            open.value = false
            form.reset()
        }
    })
}
</script>
<template>
    <Button label="Criar novo workspace" @click="open = true"/>
    
    <Dialog v-model:visible="open" modal header="Criar workspace">
        <form @submit.prevent="submit" class="space-y-4">
            <div>
                <label class="mb-2 block text-sm font-medium">Nome</label>
                <InputText v-model="form.name"class="w-full" autofocus />
                <Message v-if="form.errors.name"
                    severity="error"
                    size="small"
                    variant="simple"
                    class="mt-2"
                    >
                    {{ form.errors.name }}
                </Message>
            </div>
            <div class="flex justify-end gap-2">
          <Button
            type="button"
            label="Cancelar"
            severity="secondary"
            @click="open = false"
          />

          <Button
            type="submit"
            label="Criar"
            :loading="form.processing"
          />
        </div>
        </form>
    </Dialog>
</template>