import Vue from 'vue'
import * as types from './system_types'

const state = {
  accessToken: '',
}

const getters = {
  accessToken: state => {
    return state.accessToken
  }
}

const mutations = {
  setAccessToken (state, payload) {
    state.accessToken = payload
    const localToken = localStorage.getItem('accessToken')
    if (payload !== localToken) {
      localStorage.setItem('accessToken', payload)
    }
  }
}

const actions = {
  async [types.FETCH_TOKEN] ({commit}) {
    /*const promise = */
    // new Promise((resolve) => {
      const accessToken = localStorage.getItem('accessToken') || ''
      console.log('localStorage(accessToken) = ' + accessToken)
      commit('setAccessToken', accessToken)
    //   resolve(accessToken)
    // })
  },
  [types.REFRESH_TOKEN] ({commit, rootGetters, getters}) {
    /*const promise = */
    return new Promise((resolve, reject) => {
      const url = rootGetters.apiUrl + '/auth/refresh'
      if (getters.accessToken === '') {
        resolve(getters.accessToken)
      } else {
        const auth = {
          headers: {
            'Authorization': 'Bearer ' + getters.accessToken,
            'Accept': 'application/json'
          }
        }
        console.log('REFRESH_TOKEN :: auth: ', auth)
        Vue.axios.post(url, {}, auth).then(response => {
          console.log('REFRESH_TOKEN => response: ', responses)
          if (response.message && response.message==='Unauthenticated') {
            const accessToken = response.access_token
            commit('setAccessToken', accessToken)
            resolve(accessToken)
          } else {
            commit('setAccessToken', '')
            reject(response)
          }
        }).catch(error => {
          commit('setAccessToken', '')
          reject(error.response)
        })
      }
    })
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
