<script lang="ts">
interface DashboardProps {
user: {id: number, name: string, email: string}
workspaces: any
}
</script>
<script setup lang="ts">
import WorkspaceForm from "@/components/WorkspaceForm.vue";
import {Link} from "@inertiajs/vue3"
defineProps<DashboardProps>()
</script>
<template>
    {{ user.name }}
    {{ user.email }}
    <WorkspaceForm />
    <ul>
        <li v-for="workspace in workspaces">
            <Link :href="`/workspace/${workspace.id}`">{{ workspace.name }}</Link>
        </li>
        <li><Link href="/logout" method="delete">Logout</Link></li>
    </ul>
    
</template>