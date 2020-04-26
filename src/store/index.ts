import Vue from 'vue'
import Vuex from 'vuex'

import agents from './modules/agents/agents'
import common from './modules/common/common'
import constants from './modules/constants/constants'
import inputObjTypes from './modules/inputObjTypes/inputObjTypes'
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
	  agents,
	  common,
	  constants,
	  inputObjTypes,
	  system
  }
})
