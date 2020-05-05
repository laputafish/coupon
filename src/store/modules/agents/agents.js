import Vue from 'vue'
import * as types from './agents_types'

const state = {
  agents: [],
  agentsLoaded: false
}

const getters = {
  agents: (state) => {
    console.log('getters :: agents: ', state.agents)
    return state.agents
  }
}

const mutations = {
  setAgents (state, payload) {
    console.log('setAgents :: payload: ', payload)
    state.agents = payload
    state.agentsLoaded = true
  }
}

const actions = {
  [types.FETCH_AGENTS] ({commit, rootGetters, dispatch}) {
    return new Promise((resolve, reject) => {
      console.log('FETCH_AGENTS')
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
