import * as types from './constants_types'

const state = {
  constants: '',
}

const getters = {
  constants: state => {
    return state.constants
  }
}

const mutations = {
  setConstants (state, payload) {
    state.constants = payload
  }
}

const actions = {
  [types.FETCH_CONSTANTS] ({commit}) {
    const promise = new Promise((resolve, reject) => {
      const env = {
        apiUrl: process.env.VUE_APP_API_URL
      }
      console.log('FETCH_CONSTANTS :: env: ', env)
      commit('setConstants', env)
      resolve(env)
    })
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
