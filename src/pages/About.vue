<template>
  <LocaleSwitch />
  <div>
    <router-link to="/">
      <label class="text-blue-500">{{ t('home') }}</label>
    </router-link>
    <span class="p-1">|</span>
    <span>{{ t('about') }}</span>
  </div>
  <img src="/@/assets/images/svg/earth.svg" class="m-auto">
  <h1 class="font-sans text-lg text-gray-800 text-center m-10">
    {{ t('about_msg') }}
  </h1>
</template>
<script lang="ts">
import { defineComponent } from 'vue'
import { useI18n } from 'vue-i18n'
export default defineComponent({
  setup() {
    const { t } = useI18n()
    return { t }
  },
})
</script>
