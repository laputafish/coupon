import Vue from 'vue'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import App from './App.vue'
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { far } from '@fortawesome/free-regular-svg-icons'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

// import $ from 'jquery'
// $ = require('jquery')
// window.$ = window.jQuery = require('jquery')

import 'admin-lte/dist/css/adminlte.css'

dom.watch()
library.add(fas)
library.add(far)

import router from './router'
import store from './store'
import i18n from './i18n'
import axios from 'axios'
import VueAxios from 'vue-axios'
import Datatable from 'vue2-datatable-component'
import VuejsDialog from 'vuejs-dialog'
import { ValidationProvider, extend } from 'vee-validate'
import { required, email, confirmed } from 'vee-validate/dist/rules';
import { localize } from 'vee-validate';

// import VuejsDialogMixin from 'vuejs-dialog/dist/vuejs-dialog-mixin.min.js'

// custom.scss
Vue.use(BootstrapVue)
Vue.use(IconsPlugin)
Vue.use(VueAxios, axios)
Vue.use(Datatable)
Vue.use(VuejsDialog)

localize({
  en: {
    names: {
      'email': 'Email Address'
    }
  }
})

extend('email', {
  ...email,
  message: 'The email address is not valid.'
})
extend('required', { ...required, message: 'This field is required.' })
extend('confirmed', { ...confirmed, message: 'Password not matched.' }
)
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('validationProvider', ValidationProvider)

Vue.config.productionTip = false

store.dispatch('FETCH_CONSTANTS')
console.log('main.ts :: FETCH_CONSTANTS')

store.dispatch('FETCH_TOKEN')
console.log('main.ts :: FETCH_TOKEN')

new Vue({
  router,
  store,
  // mixins: [VuejsDialogMixin],
  i18n,
  render: h => h(App)
}).$mount('#app')
