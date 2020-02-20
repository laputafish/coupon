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
      // console.log('localStorage(accessToken) = ' + accessToken)
      commit('setAccessToken', accessToken)
    //   resolve(accessToken)
    // })
  },
  [types.SET_TOKEN] ({commit, getters}, payload) {
    return new Promise((resolve) => {
      if (getters.accessToken !== payload) {
        localStorage.setItem('accessToken', payload)
        commit('setAccessToken', payload)
        resolve()
      }
    })
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
        // console.log('REFRESH_TOKEN :: auth: ', auth)
        Vue.axios.post(url, {}, auth).then(response => {
          // console.log('REFRESH_TOKEN => response: ', response)
          const result = response.data.result
          // console.log('REFRESH_TOKEN => result: ', result)
          const accessToken = result.access_token

          localStorage.setItem('accessToken', accessToken)
          commit('setAccessToken', accessToken)
          resolve(accessToken)
        }).catch(error => {
          // console.log('REFRESH_TOKEN :: error: ', error)
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
