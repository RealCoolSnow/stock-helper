<template>
  <div>
    <van-cell center :title="t('tray_show_stock')">
      <template #right-icon>
        <van-switch v-model="state.trayShowStock" size="24" />
      </template>
    </van-cell>
  </div>
</template>
<script lang="ts">
import { defineComponent, reactive } from 'vue'
import { useI18n } from 'vue-i18n'
export default defineComponent({
  setup() {
    const { t } = useI18n()
    const state = reactive({
      trayShowStock: false,
    })
    return { t, state }
  },
})
</script>
