<template>
  <div class="px-4 py-10 text-center text-gray-700 dark:text-gray-200">
    <router-view />
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue'
import { useRouter } from 'vue-router'

export default defineComponent({
  setup() {
    console.log('app created')
    const router = useRouter()
    router.push('/')
  },
})
</script>
