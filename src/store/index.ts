import { createLogger, createStore } from 'vuex'
import app from './modules/app'
import getters from './getters'

const debug = process.env.NODE_ENV !== 'production'

export default createStore({
  modules: { app },
  getters,
  strict: debug,
  plugins: debug ? [createLogger()] : [],
})
