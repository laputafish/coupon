import Vue from 'vue'
import Vuex from 'vuex'

import constants from './modules/constants/constants'
import common from './modules/common/common'
import system from './modules/system/system'
import agents from './modules/agents/agents'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
  },
  mutations: {
  },
  actions: {
  },
  modules: {
	  agents,
	  constants,
	  common,
	  system
  }
})
