<template>
  <div class="py-10 bg-gray-100 h-screen">
    <router-view />
  </div>
  <van-tabbar v-model="state.tabSelected" active-color="#1296db" inactive-color="#000" route>
    <van-tabbar-item to="/" icon="home-o">
      {{ t('stock') }}
    </van-tabbar-item>
    <van-tabbar-item to="/setting" icon="setting-o">
      {{ t('setting') }}
    </van-tabbar-item>
  </van-tabbar>
</template>
<script lang="ts">
import { defineComponent, reactive } from 'vue'
import { useI18n } from 'vue-i18n'

export default defineComponent({
  setup() {
    console.log('app created')
    const { t } = useI18n()
    const state = reactive({
      tabSelected: 0,
    })
    return { t, state }
  },
})
</script>
