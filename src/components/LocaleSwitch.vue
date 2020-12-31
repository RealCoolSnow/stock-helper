<template>
  <select v-model="locale" class="m-6" @change="onChange">
    <option value="en">
      en
    </option>
    <option value="zh-CN">
      zh-CN
    </option>
  </select>
</template>
<script lang="ts">
import { defineComponent } from 'vue'
import { useI18n } from 'vue-i18n'
import { useStore } from 'vuex'
// import ActionTypes from '../store/action-types'
import MutationTypes from '../store/mutation-types'

export default defineComponent({
  setup() {
    const { locale } = useI18n()
    const store = useStore()
    const onChange = (e: any) => {
      store.commit(MutationTypes.APP.SET_LANGUAGE, e.target.value)
      // store.dispatch(ActionTypes.APP.SET_LANGUAGE, e.target.value)
    }
    return { locale, onChange }
  },
})
</script>
