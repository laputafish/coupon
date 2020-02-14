import Vue from 'vue'
import Vuex from 'vuex'

import constants from './modules/constants/constants'
import common from './modules/common/common'
import system from './modules/system/system'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
  },
  mutations: {
  },
  actions: {
  },
  modules: {
    constants,
    common,
    system
  }
})
