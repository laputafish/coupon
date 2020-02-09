import Vue from 'vue'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import App from './App.vue'
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
// import $ from 'jquery'
// $ = require('jquery')
// window.$ = window.jQuery = require('jquery')

import 'admin-lte/dist/css/adminlte.css'

dom.watch()
library.add(fas)

import router from './router'
import store from './store'

// custom.scss
Vue.use(BootstrapVue)
Vue.use(IconsPlugin)

Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
