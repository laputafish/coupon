import Vue from 'vue'
import * as types from './states_types'
import helpers from '@/helpers.js'

const state = {
  states: []
}
const getters = {
  states: state => {
    return state.states
  }
}

const mutations = {
  addState (state, payload) {
    if (state.states.indexOf(payload) === -1) {
      state.states.add(payload)
    }
  },
  removeState (state, payload) {
    const index = state.states.indexOf(payload)
      if (index >= 0) {
      state.states.splice(index, 1)
    }
  }
}
const mutations = {}

const actions = {
  [types.ADD_STATE] ({}, payload) {
    commit('addState', payload)
  },

  [types.REMOVE_STATE] ({}, payload) {
    commit('removeState', payload)
  }
}