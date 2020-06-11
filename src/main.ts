import Vue from 'vue'
import {BootstrapVue, IconsPlugin} from 'bootstrap-vue'
import App from './App.vue'
import {library, dom} from '@fortawesome/fontawesome-svg-core'
import {far} from '@fortawesome/free-regular-svg-icons'
import {fas} from '@fortawesome/free-solid-svg-icons'
import {FontAwesomeIcon} from '@fortawesome/vue-fontawesome'

// declare global {
// 	interface Window { jQuery: any }
// }

// import $ from 'jquery'
// window.$ = window.jQuery = $

// import 'admin-lte/dist/css/adminlte.css'

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
import VuejsDialogMixin from 'vuejs-dialog/dist/vuejs-dialog-mixin.min.js'
import VModal from 'vue-js-modal'
import Toaster from 'v-toaster'
import VueClipboard from 'vue-clipboard2'
import VueCarousel from 'vue-carousel'
import VueLoading from 'vue-loading-overlay'
// import VuejsProgressBar from 'vuejs-progress-bar'
// import VueCropper from 'vue-cropper'

// include the default style
import 'vuejs-dialog/dist/vuejs-dialog.min.css'
import 'v-toaster/dist/v-toaster.css'
import 'vue-loading-overlay/dist/vue-loading.css'

import {ValidationProvider, extend} from 'vee-validate'
import {required, email, confirmed} from 'vee-validate/dist/rules'
import {localize} from 'vee-validate'

// import VuejsDialogMixin from 'vuejs-dialog/dist/vuejs-dialog-mixin.min.js'

// custom.scss
Vue.use(BootstrapVue)
Vue.use(IconsPlugin)
Vue.use(VueAxios, axios)
Vue.use(Datatable)
Vue.use(VuejsDialog)
Vue.use(VModal, 'dialog')
Vue.use(Toaster, {timeout: 3000})
// Vue.use(Toaster, {timeout: 3000})
Vue.use(VueClipboard)
Vue.use(VueCarousel)
Vue.use(VueLoading)

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
extend('required', {...required, message: 'This field is required.'})
extend('confirmed', {...confirmed, message: 'Password not matched.'})
extend('nonzero', value => {
  return value !== 0
})
Vue.component('vue-loading', VueLoading)
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('validationProvider', ValidationProvider)

Vue.config.productionTip = false

store.dispatch('FETCH_CONSTANTS')
// store.dispatch('FETCH_TOKEN').then(
//     () => store.dispatch('FETCH_AGENTS')
// )
// store.dispatch('FETCH_SYSTEM_CONFIG')

new Vue({
  router,
  store,
  // mixins: [VuejsDialogMixin],
  i18n,
  render: h => h(App)
}).$mount('#app')
