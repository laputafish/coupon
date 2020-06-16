import Vue from 'vue'
import * as types from './system_types'
import Pusher from 'pusher-js'

const state = {
  accessToken: '',
  user: null,
  team: {
    id: 1
  },
  pusher: null,
  systemConfigs: [],
  systemConfigsLoaded: false
}

const getters = {
  accessToken: state => {
    return state.accessToken
  },
  user: state => {
    return state.user
  },
  team: state => {
    return state.team
  },
  pusher: state => {
    return state.pusher
  },
  systemConfigs: state => {
    return state.systemConfigs
  },
  systemConfigsLoaded: state => {
    return state.systemConfigsLoaded
  }
}

const mutations = {
  setUser (state, payload) {
    state.user = payload
  },
  setAccessToken (state, payload) {
    state.accessToken = payload
    console.log('setAccessToken payload = ' + payload)
    console.log('setAccessToken state.accessToken = (' + state.accessToken + ')')
    const localToken = localStorage.getItem('accessToken')
    if (payload !== localToken) {
      localStorage.setItem('accessToken', payload)
    }
  },
  setSystemConfigs (state, payload) {
    state.systemConfigs = payload
    state.systemConfigsLoaded = true

    if (payload.pusher_key === 'websocketsyoov') {
      state.pusher = new Pusher(payload.pusher_key, {
        cluster: payload.pusher_cluster,
        httpHost: payload.pusher_host,
        httpPort: parseInt(payload.push_port)
      })
    } else {
      state.pusher = new Pusher(payload.pusher_key, {
        encrypted: true,
        cluster: payload.pusher_cluster
      })
    }
  }
}

const actions = {
  async [types.FETCH_TOKEN] ({commit}) {
    return new Promise(resolve => {
      // new Promise((resolve) => {
      const accessToken = localStorage.getItem('accessToken') || ''
      /*const promise = */
      console.log('system.js :: FETCH_TOKEN :: accessToken = ' + accessToken)
      console.log('localStorage(accessToken) = ' + accessToken)
      commit('setAccessToken', accessToken)
      //   resolve(accessToken)
      // })
      resolve(accessToken);
    })
  },

  [types.SET_TOKEN] ({commit, getters}, payload) {
    return new Promise((resolve) => {
      console.log('SET_TOKEN :: payload: ', payload)
      console.log('SET_TOKEN :: getters.accessToken = ' + getters.accessToken)
      if (getters.accessToken !== payload) {
        localStorage.setItem('accessToken', payload)
        commit('setAccessToken', payload)
        // console.log('SET_TOKEN :: token = ' + payload)
        resolve(payload)
      } else {
        resolve(payload)
      }
    })
  },

  [types.SET_USER] ({commit, getters}, payload) {
    return new Promise((resolve) => {
      console.log('SET_USER :: payload: ', payload)
      console.log('SET_USER :: getters.user = ' + getters.user)
      if (getters.user !== payload) {
        commit('setUser', payload)
        resolve(payload)
      } else {
        resolve(payload)
      }
    })
  },

  [types.FETCH_USER] ({commit, dispatch}) {
    return new Promise((resolve, reject) =>  {
      // console.log('FETCH_USER')
      dispatch('AUTH_POST', '/auth/me').then(
        response => {
          // console.log('FETCH_USER :: response: ', response)
          commit('setUser', response)
          resolve(response)
        },
        error => {
          reject(error)
        }
      )
    })
  },

  [types.FETCH_SYSTEM_CONFIGS] ({commit, rootGetters, dispatch}) {
    const data = {
      urlCommand: '/system/configs'
    }
    dispatch('AUTH_GET', data).then(response => {
      console.log('FETCH_SYSTEM_CONFIGS :: AUTH_GET :: response: ', response)
      commit('setSystemConfigs', response)
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
