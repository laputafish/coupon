import Vue from 'vue'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import App from './App.vue'
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

// Import TinyMCE
// import tinymce from 'tinymce/tinymce';
//
// // A theme is also required
// import 'tinymce/themes/silver';
//
// // Any plugins you want to use has to be imported
// import 'tinymce/plugins/paste';
// import 'tinymce/plugins/link';
//
// // Initialize the app
// tinymce.init({
// 	selector: '#tiny',
// 	plugins: ['paste', 'link']
// });


// import $ from 'jquery'
// $ = require('jquery')
// window.$ = window.jQuery = require('jquery')

import 'admin-lte/dist/css/adminlte.css'

dom.watch()
library.add(fas)

import router from './router'
import store from './store'
import i18n from './i18n'
import axios from 'axios'
import VueAxios from 'vue-axios'
import Datatable from 'vue2-datatable-component'

// custom.scss
Vue.use(BootstrapVue)
Vue.use(IconsPlugin)
Vue.use(VueAxios, axios)
Vue.use(Datatable)

Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.config.productionTip = false

new Vue({
  router,
  store,
  i18n,
  render: h => h(App)
}).$mount('#app')
