import Vue from 'vue'
import * as types from './common_types'
import helpers from '@/helpers.js'

const state = {}
const getters = {}
const mutations = {}
const actions = {
  [types.AUTH_DELETE] ({rootGetters, dispatch}, payload) {
    const token = rootGetters.accessToken
    if (typeof payload !== 'object') {
      payload = {
        urlCommand: payload
      }
    }
    if (!payload.options) {
      payload.options = {}
    }
    payload.options.headers = {Authorization: 'bearer ' + token}
    return dispatch('COMMON_DELETE', payload)
  },

  [types.COMMON_DELETE] ({rootGetters}, payload) {
    // payload = {
    //    data: {...},
    //    options: {
    //      headers: { ... }
    //    }
    // }
    //
    return new Promise((resolve, reject) => {
      let urlCommand
      let options = {}
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        // payload.urlCommand = null
        // options = {
        //    data: payload.options
        //    headers: {...}
        // }
      } else {
        urlCommand = payload
      }

      if (payload.options) {
        options = payload.options
      }

      const url = rootGetters.constants.apiUrl + urlCommand
      Vue.axios.delete(url, options).then(function (response) {
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          reject(new Error(response.data.result))
          // if (response.data.message) {
          //   reject(new Error(response.data.message))
          // } else {
          //   reject(new Error('Deletion Fails!'))
          // }
        }
      }).catch((error) => {
        reject(error.response.data.result)
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
  [types.REFRESH_AUTH_GET] ({dispatch}, payload) {
    return new Promise((resolve, reject) => {
      // console.log('AUTH_GET :: payload: ', payload)
      dispatch('AUTH_REFRESH').then(
        () => {
          // console.log('AUTH_GET :: payload: ', payload)
          if (typeof payload !== 'object') {
            payload = {
              urlCommand: payload
            }
          }
          if (!payload.options) {
            payload.options = {}
          }
          dispatch('AUTH_GET', payload)
            .then(response => {
              resolve(response)
            })
            .catch(error => {
              reject(error)
            })
          // payload.options.headers = {Authorization: 'bearer ' + token}
          // dispatch('COMMON_POST', payload)
          //   .then(response => {
          //     resolve(response)
          //   })
          //   .catch(error => {
          //     reject(error)
          //   })
        }
      )
    })
  },

  [types.AUTH_GET] ({dispatch, rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      // console.log('AUTH_GET :: payload: ', payload)
      const token = rootGetters.accessToken
      // console.log('AUTH_GET :: AUTH_REFRESH :: token = ' + token)
      if (typeof payload !== 'object') {
        payload = {
          urlCommand: payload
        }
      }
      if (!payload.options) {
        payload.options = {}
      }
      payload.options.headers = {Authorization: 'bearer ' + token}
      dispatch('COMMON_GET', payload).then(
        response => {
          // console.log('AUTH_GET > COMMON_GET.then: response: ', response)
          resolve(response)
        }
      ).catch(
        error => {
          // console.log('AUTH_GET > COMMON_GET.catch: error: ', error)
          reject(error)
        }
      )
    })
  },

  [types.COMMON_GET] ({rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      // console.log('COMMON_GET :: payload: ', payload)
      let urlCommand
      // payload = {
      //    urlCommand: '....',
      //    options: {
      //      params: {}
      //      headers: {}
      //    },
      //    query: {
      //    }
      // }
      let getPayload = {}
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        payload.urlCommand = null
        if (payload.options) {
          getPayload = {
            ...payload.options
          }
        }
        if (payload.query) {
          const paginationConfig = helpers.addPagination(payload.query)
          if (!getPayload.params) {
            getPayload.params = {}
          }
          getPayload.params = {
            ...getPayload.params,
            ...paginationConfig.params
          }
        }
      } else {
        urlCommand = payload
      }
      // console.log('COMMON_GET :: getPayload: ', getPayload)
      const url = rootGetters.apiUrl + urlCommand
      // console.log('COMMON_GET url=' + url)
      // console.log('COMMON_GET config: ', getPayload)
      Vue.axios.get(url, getPayload).then(function (response) {
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          reject(response.data.result)
          // Error('Get Record Fails! (url=' + url + ')'))
        }
      }).catch((error) => {
        reject(error)
      })
    })
  },

  [types.AUTH_REFRESH] ({rootGetters, commit, dispatch}, payload) {
    return new Promise((resolve, reject) => {
      // console.log('AUTH_REFRESH')
      let url = rootGetters.constants.apiUrl + '/auth/refresh'
      if (rootGetters.accessToken) {
        let options = {
          headers: {
            Authorization: 'bearer ' + rootGetters.accessToken
          }
        }
        Vue.axios.post(url, {}, options)
          .then(response => {
            const accessToken = response.data.result.access_token
            dispatch('SET_TOKEN', accessToken).then(() => {
              resolve(accessToken)
            })
          })
          .catch(error => {
            // Vue.$dialog(Vue.$t('messages.session_invalid_or_expired_goto_login_page'))
            //   .then(() => {
            //     Vue.$router.push({name: 'Logout'})
            //   })
            reject(error.response.data)
          })
      } else {
        reject(new Error('no access token'))
      }
    })
  },

  [types.REFRESH_AUTH_POST] ({dispatch}, payload) {
    return new Promise((resolve, reject) => {
      dispatch('AUTH_REFRESH').then(
        () => {
          // console.log('AUTH_GET :: payload: ', payload)
          if (typeof payload !== 'object') {
            payload = {
              urlCommand: payload
            }
          }
          if (!payload.options) {
            payload.options = {}
          }
          dispatch('AUTH_POST', payload)
            .then(response => {
              resolve(response)
            })
            .catch(error => {
              reject(error)
            })
          // payload.options.headers = {Authorization: 'bearer ' + token}
          // dispatch('COMMON_POST', payload)
          //   .then(response => {
          //     resolve(response)
          //   })
          //   .catch(error => {
          //     reject(error)
          //   })
        }
      )
    })
  },

  [types.AUTH_POST] ({dispatch, rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      // console.log('AUTH_GET :: payload: ', payload)
      if (typeof payload !== 'object') {
        payload = {
          urlCommand: payload
        }
      }
      if (!payload.options) {
        payload.options = {}
      }
      // console.log('AUTH_POST :: payload: ', payload)
      payload.options.headers = {Authorization: 'bearer ' + rootGetters.accessToken}
      dispatch('COMMON_POST', payload)
        .then(response => {
          resolve(response)
        })
        .catch(error => {
          console.log('AUTH_POST error: ', error)
          reject(error)
        })
    })
  },

  [types.AUTH_POST+'0'] ({dispatch, rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      // console.log('AUTH_GET :: payload: ', payload)
      if (typeof payload !== 'object') {
        payload = {
          urlCommand: payload
        }
      }
      if (!payload.options) {
        payload.options = {}
      }
      // console.log('AUTH_POST :: payload: ', payload)
      payload.options.headers = {Authorization: 'bearer ' + rootGetters.accessToken}
      dispatch('COMMON_POST', payload)
        .then(response => {
          resolve(response)
        })
        .catch(error => {
          console.log('AUTH_POST error: ', error)
          reject(error)
        })
    })
  },

  [types.AUTH_UPLOAD_IMAGE] ({rootGetters}, payload) {
    return new Promise((resolve, reject) => {
      // console.log('AUTH_GET :: payload: ', payload)
      const url = rootGetters.apiUrl + '/media/upload_image'
      const data = payload
      const options = {
        headers: {
          Authorization: 'bearer ' + rootGetters.accessToken
        }
      }
      Vue.axios.post(url, data, options).then( response => {
        resolve(response.data)
      }, error => {
        reject(error)
      })
      // $.ajax({
      //   headers: {'Authorization': bearerToken},
      //   url: url,
      //   type: 'POST',
      //   data: payload,
      //   processData: false,
      //   contentType: false,
      //   success: function(response) {
      //     const data = response.result
      //     resolve(data)
      //   },
      //   error: function(jqXHR) {
      //     if (jqXHR.responseText) {
      //       alert('Error uploading image: ' + errors.join(',') +
      //         '.  Make sure the file is an image and has extension jpg/jpeg/png.')
      //     }
      //   }
      //
      //
      // })
      // payload.options.headers = {Authorization: 'bearer ' + rootGetters.accessToken}
      // dispatch('COMMON_POST', payload)
      //   .then(response => {
      //     resolve(response)
      //   })
      //   .catch(error => {
      //     reject(error)
      //   })
    })
  },

  [types.COMMON_POST] ({rootGetters}, payload) {
    // payload = {
    //    data: {..},
    //    options: {
    //      headers: {..}
    //    }
    // }
    return new Promise((resolve, reject) => {
      let urlCommand
      let data
      let options = {}

      // get url
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        data = payload.data
      } else {
        urlCommand = payload
      }

      if (payload.options) {
        options = payload.options
      }
      const url = rootGetters.constants.apiUrl + urlCommand
      Vue.axios.post(url, data, options).then(function (response) {
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          // console.log('response.data.status = false')
          reject(response.data.result)
          // if (response.data.result.message) {
          //   reject(response.data.result.message)
          // } else {
          //   reject(response.data.result)
          // }
        }
      }).catch((error) => {
        if (error.response.data) {
          if (error.response.data.result) {
            reject(error.response.data.result)
          }
        }
        reject(error.response.data)
      })
    })
  },

  [types.USER_GET] ({rootGetters}, payload) {
    // payload = {
    //    data: {..},
    //    options: {
    //      headers: {..}
    //    }
    // }
    return new Promise((resolve, reject) => {
      let urlCommand
      let data
      let options = {}

      // get url
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        data = payload.data
      } else {
        urlCommand = payload
      }

      if (payload.options) {
        options = payload.options
      }
      const url = rootGetters.constants.appHost + urlCommand
      Vue.axios.get(url, data, options).then(function (response) {
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          // console.log('response.data.status = false')
          reject(response.data.result)
          // if (response.data.result.message) {
          //   reject(response.data.result.message)
          // } else {
          //   reject(response.data.result)
          // }
        }
      }).catch((error) => {
        if (error.response.data) {
          if (error.response.data.result) {
            reject(error.response.data.result)
          }
        }
        reject(error.response.data)
      })
    })
  },

  [types.REFRESH_AUTH_PUT] ({dispatch}, payload) {
    return new Promise((resolve, reject) => {
      dispatch('AUTH_REFRESH').then(
        () => {
          // console.log('AUTH_GET :: payload: ', payload)
          if (typeof payload !== 'object') {
            payload = {
              urlCommand: payload
            }
          }
          if (!payload.options) {
            payload.options = {}
          }
          dispatch('AUTH_PUT', payload)
            .then(response => {
              resolve(response)
            })
            .catch(error => {
              reject(error)
            })
          // payload.options.headers = {Authorization: 'bearer ' + token}
          // dispatch('COMMON_POST', payload)
          //   .then(response => {
          //     resolve(response)
          //   })
          //   .catch(error => {
          //     reject(error)
          //   })
        }
      )
    })
  },

  [types.AUTH_PUT] ({rootGetters, dispatch}, payload) {
    return new Promise((resolve, reject) => {
      if (typeof payload !== 'object') {
        payload = {
          urlCommand: payload
        }
      }
      if (!payload.options) {
        payload.options = {}
      }
      payload.options.headers = {Authorization: 'bearer ' + rootGetters.accessToken}
      dispatch('COMMON_PUT', payload).then(
        response => {
          resolve(response)
        }
      ).catch(
        error => {
          reject(error)
        }
      )
    })
  },

  [types.COMMON_PUT] ({rootGetters}, payload) {
    // payload = {
    //    urlCommand: {...},
    //    data: {...},
    //    options: {
    //      headers: { ... }
    //    }
    // }
    //
    return new Promise((resolve, reject) => {
      let urlCommand
      let data
      let options = {}

      // get url
      if (typeof payload === 'object') {
        urlCommand = payload.urlCommand
        data = payload.data
      } else {
        urlCommand = payload
      }

      if (payload.options) {
        options = payload.options
      }

      const url = rootGetters.constants.apiUrl + urlCommand
      Vue.axios.put(url, data, options).then(function (response) {
        if (response.data.status) {
          resolve(response.data.result)
        } else {
          reject(new Error(response.data.result))
          // if (response.data.result.message) {
          //   reject(new Error(response.data.result.message))
          // } else {
          //   reject(new Error(response.data.result))
          // }
        }
      }).catch((error) => {
        reject(error.response)
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
