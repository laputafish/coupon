import Vue from 'vue'

const state = {
  inputObjTypes: [
    {icon: 'fas fa-i-cursor', text: '', label: '1-line Text', type: 'simple-text', isInput: true},
    {icon: '', text: '123', label: 'Number', type: 'number', isInput: true},
    {icon: 'fas fa-envelope', text: '', label: 'Email', type: 'email', isInput: true},
    {icon: 'fas fa-align-justify', text: '', label: 'n-line Text', type: 'text', isInput: true},
    {icon: 'fas fa-user', text: '', label: 'Name', type: 'name', isInput: true},
    {icon: 'fas fa-phone', text: '', label: 'Phone', type: 'phone', isInput: true},
    {icon: 'fas fa-check-square', text: '', label: 'Choice', type: 'single-choice', isInput: true},
    {icon: 'fas fa-tasks', text: '', label: 'Multi-Choice', type: 'multiple-choice', isInput: true},
    {icon: 'fas fa-image', text: '', label: 'Image', type: 'image', isInput: false},
    {icon: '', text: 'ABC', label: 'Remark', type: 'remark', isInput: false},
    {icon: 'fas fa-bolt', text: '', label: 'Submit Btn', type: 'submit', isInput: false}

  ]
}

const getters = {
  inputObjTypes: (state) => {
    return state.inputObjTypes
  },
  iconList: (state) => {
    var result = []
    for (var i = 0; i < state.inputObjTypes.length; i++) {
      var buttonObj = state.inputObjTypes[i]
      result[buttonObj.type] = {
        icon: buttonObj.icon,
        text: buttonObj.text
      }
    }
    return result
  }
}

const mutations = {
}

const actions = {

}


export default {
state,
getters,
mutations,
actions
}
