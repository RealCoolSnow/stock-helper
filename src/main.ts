import './styles/main.css'
import { createApp } from 'vue'
import { Button, Tabbar, TabbarItem, Cell, Switch } from 'vant'
import router from './router'
import App from './App.vue'
import { createI18nWithLocale } from './locale'
import store from './store'
import 'vant/lib/index.css'

const i18n = createI18nWithLocale(store.getters.language)

const app = createApp(App)
app.use(store)
app.use(i18n)
app.use(router)
// vant
app.use(Button)
app.use(Tabbar)
app.use(TabbarItem)
app.use(Cell)
app.use(Switch)

app.mount('#app')
