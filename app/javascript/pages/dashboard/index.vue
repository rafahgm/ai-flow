<script setup lang="ts">
defineProps<{user: {id: number, name: string, email: string}}>()
</script>
<template>
    {{ user.name }}
    {{ user.email }}
</template>