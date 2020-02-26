import * as types from './constants_types'

const state = {
  constants: {
    apiUrl: '',
    appHost: ''
  },
}

const getters = {
  constants: state => {
    return state.constants
  },
  apiUrl: state => {
    return state.constants ? state.constants.apiUrl : ''
  },
  appHost: state => {
    return state.constants ? state.constants.appHost : ''
  }
}

const mutations = {
  setConstants (state, payload) {
    state.constants = payload
  }
}

const actions = {
  async [types.FETCH_CONSTANTS] ({commit}) {
    /*const promise = */
    // new Promise((resolve) => {
    const env = {
      apiUrl: process.env.VUE_APP_API_URL,
      appHost: process.env.VUE_APP_HOST
    }
    // console.log('FETCH_CONSTANTS :: env: ', env)
    commit('setConstants', env)
      // resolve(env)
    // })
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
