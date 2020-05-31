import Vue from 'vue'
import * as types from './agents_types'

const state = {
  agents: [],
  agentsLoaded: false,
  smtpServers: []
}

const getters = {
  agents: (state) => {
    // console.log('getters :: agents: ', state.agents)
    return state.agents
  },
  agentsLoaded: (state) => {
    return state.agentsLoaded
  },
  smtpServers: (state) => {
    return state.smtpServers
  }

}

const mutations = {
  setAgents (state, payload) {
    // console.log('setAgents :: payload: ', payload)
    state.agents = payload
    state.agentsLoaded = true
  },
  clearAgents (state, payload) {
    state.agents = []
    state.agentsLoaded = false
  },
  setSmtpServers (state, payload) {
    state.smtpServers = payload
  }
}

const actions = {
  [types.CLEAR_AGENTS] ({commit, rootGetters, dispatch}) {
    return new Promise((resolve, reject) => {
      commit('clearAgents')
      resolve([])
    })
  },

  [types.FETCH_SMTP_SERVERS] ({commit, dispatch}, payload) {
    return Promise((resolve, reject) => {
      const data = {
        urlCommand: '/agents/' + payload.agentId + '/smtp_servers'
      }
      dispatch('AUTH_GET', data).then(
        response => {
          commit('setSmtpServers', response)
          resolve(response)
        },
        error => {
          reject(error)
        }
      )
    })
  },

  [types.FETCH_AGENTS] ({commit, rootGetters, dispatch}) {
    return new Promise((resolve, reject) => {
      // console.log('FETCH_AGENTS')
      const data = {
        urlCommand: '/agents',
        options: {
          params: {
            teamId: rootGetters.team.id
          }
        }
      }
      dispatch('AUTH_GET', data).then(
        response => {
          commit('setAgents', response)
          resolve(response)
        },
        error => {
          reject(error)
        }
      )
    })
  }
}


export default {
  state,
  getters,
  mutations,
  actions
}
