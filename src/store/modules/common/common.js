import Vue from 'vue'
import * as types from './common_types'
import helpers from '@/helpers.js'

const state = {}
const getters = {}
const mutations = {}
const actions = {
  [types.COMMON_DELETE] ({rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      let urlCommand
      let options = {}
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        payload.urlCommand = null
        options = {
          data: payload.options
        }
      } else {
        urlCommand = payload
      }
      let url = rootGetters.constants.apiUrl + urlCommand

      Vue.axios.delete(url, options).then(function (response) {
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          if (response.data.message) {
            reject(new Error(response.data.message))
          } else {
            reject(new Error('Deletion Fails!'))
          }
        }
      }).catch((error) => {
        reject(error)
      })
    })
  },

  // [types.COMMON_GET] ({rootGetters}, payload) {
  //   return new Promise((resolve, reject) => {
  //     // console.log('COMMON_GET :: payload: ', payload)
  //     let urlCommand
  //     let config = {}
  //     if (typeof payload === 'object') {
  //       urlCommand = payload.urlCommand
  //       payload.urlCommand = null
  //       config = {
  //         ...payload.options
  //       }
  //     } else {
  //       urlCommand = payload
  //     }
  //     let url = rootGetters.constants.apiUrl + urlCommand
  //     if (payload.query) {
  //       let paginationConfig = helpers.addPagination(payload.query)
  //       config = {
  //         params: {
  //           ...config.params,
  //           ...paginationConfig.params
  //         }
  //       }
  //     }
  //     // console.log('COMMON_GET url=' + url)
  //     // console.log('COMMON_GET config: ', config)
  //     Vue.axios.get(url, config).then(function (response) {
  //       if (url === '/pay_centers') {
  //         console.log('common_get: response: ', response)
  //       }
  //       if (response.data.status) {
  //         resolve(response.data.result)
  //       } else {
  //         reject(new Error('Get Record Fails! (url=' + url + ')'))
  //       }
  //     }).catch((error) => {
  //       reject(error)
  //     })
  //   })
  // },

  [types.COMMON_GET] ({rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      // console.log('COMMON_GET :: payload: ', payload)
      let urlCommand
      let config = {}
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        payload.urlCommand = null
        config = {
          ...payload.options
        }
      } else {
        urlCommand = payload
      }
      let url = rootGetters.constants.apiUrl + urlCommand
      if (payload.query) {
        let paginationConfig = helpers.addPagination(payload.query)
        config = {
          params: {
            ...config.params,
            ...paginationConfig.params
          }
        }
      }
      // console.log('COMMON_GET url=' + url)
      // console.log('COMMON_GET config: ', config)
      Vue.axios.get(url, config).then(function (response) {
        if (url === '/pay_centers') {
          console.log('common_get: response: ', response)
        }
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          reject(new Error('Get Record Fails! (url=' + url + ')'))
        }
      }).catch((error) => {
        reject(error)
      })
    })
  },

  [types.COMMON_POST] ({rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      let urlCommand
      let data
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        data = payload.data
      } else {
        urlCommand = payload
      }

      let url = rootGetters.constants.apiUrl + urlCommand
      Vue.axios.post(url, data).then(function (response) {
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          if (response.data.message) {
            reject(new Error(response.data.message))
          } else {
            reject(new Error('Post Record Fails!'))
          }
        }
      }).catch((error) => {
        reject(error)
      })
    })
  },

  [types.COMMON_PUT] ({rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      let urlCommand
      let data
      let config

      // console.log('COMMON_PUT')
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        data = payload.data
        config = payload.config
      } else {
        urlCommand = payload
      }

      let url = rootGetters.constants.apiUrl + urlCommand
      // console.log('COMMON_PUT :: url: ', url)
      // console.log('COMMON_PUT :: data: ', data)
      // console.log('COMMON_PUT :: config: ', config)
      Vue.axios.put(url, data, config).then(function (response) {
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          if (response.data.message) {
            reject(new Error(response.data.message))
          } else {
            reject(new Error('Put Record Fails!'))
          }
        }
      }).catch((error) => {
        reject(error)
      })
    })
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
