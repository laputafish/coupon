const FormInputObjMixin = {
  computed: {
    inputObjTypes () {
      return this.$store.getters.inputObjTypes
    }
  },
  methods: {
    getSelectedObjIndex (id) {
      const vm = this
      var result = -1
      for (var i = 0; i < vm.record.form_configs.inputObjs.length; i++) {
        if (vm.record.form_configs.inputObjs[i].id === id) {
          result = i
          break
        }
      }
      return result
    },

    getInputObjType (type) {
      const vm = this
      var result = null
      for (var i = 0; i < vm.inputObjTypes.length; i++) {
        var inputObjType = vm.inputObjTypes[i]
        if (inputObjType.type === type) {
          result = inputObjType
          break
        }
      }
      return result
    },

    getNewInputObj (type) {
      const vm = this
      var inputObjType = vm.getInputObjType(type)
      var result = {
        id: 0,
        name: inputObjType.label,
        fixed: false,
        inputType: type,
        question: '',
        required: true,
        options: [],
        notes: ''
      }
      return result
    },

    resetOptionIds () {
      const vm = this
      console.log('resetOptionIds :: vm.record.form_configs.inputObjs: ', vm.record.form_configs.inputObjs)
      for (var i = 0; i < vm.record.form_configs.inputObjs.length; i++) {
        vm.record.form_configs.inputObjs[i].id = i + 1
      }
    },
// ?????? ?<-- merge onCommandHandler with VoucherRecord.vue
    onInputObjCommandHandler (payload) {
      const vm = this
      const command = payload.command
      console.log('onInputObjCommandHandler: payload: ', payload)

      switch (command) {
        case 'newInputObj':
          vm.newInputObj(payload)
          break
        case 'deleteInputObj':
          vm.deleteInputObj(payload)
          break
        case 'updateInputObjField':
          console.log('FormInputObjMixin :: onInputObjCommandHandler :: updateInputObjField: payload: ', payload)
          vm.updateInputObjField(payload)
          break
        case 'removeInputObjOption':
          vm.removeInputObjOption(payload)
          break
        case 'appendInputObjOption':
          vm.appendInputObjOption(payload)
          break
        case 'updateInputObjOptionByIndex':
          vm.updateInputObjOptionByIndex(payload)
          break
        case 'replaceInputObjs':
          vm.replaceInputObjs(payload)
          break
        case 'updatePageConfigField':
          vm.updatePageConfigField(payload)
          break
        case 'previewQuestionForm':
          vm.previewQuestionForm()
          break

      }
    },

    previewQuestionForm () {
      const vm = this
      const postData = {
        urlCommand: '/form_questions/preview/create',
        data: {
          formConfigs: vm.record.form_configs
        }
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        response => {
          console.log('previewQuestionForm :: repsonse: ', response)
          var route = vm.$router.resolve({
            name: 'QuestionFormPreview',
            params: {key: '_' + response.key}
          })
          var url = window.location.origin + route.href
          url = vm.$store.getters.appHost + '/q/_' + response.key
          console.log('previewQuestionForm :: window.location.origin = ' + window.location.origin)
          console.log('previewQuestionForm :: route.href = ' + route.href)
          console.log('previewQuestionForm :: url = ' + url)

          console.log('previewQuestionForm :: route: ', route)
          // get the key for temporary form
          window.open(url, '_blank')
        },
        error => {

        }
      )
    },

    newInputObj (payload) {
      const vm = this
      var inputObjType = payload.value
      var newObj = vm.getNewInputObj(inputObjType)
      var currentIndex = payload.objIndex
      var inputObjs = JSON.parse(JSON.stringify(vm.record.form_configs.inputObjs))

      if (currentIndex === -1) {
        inputObjs.push(newObj)
      } else {
        inputObjs.splice(currentIndex + 1, 0, newObj)
      }
      vm.resetOptionIds()
      vm.record.form_configs.inputObjs = inputObjs
      // vm.$forceUpdate()
    },
    deleteInputObj (payload) {
      const vm = this
      var currentIndex = payload.objIndex
      if (currentIndex !== -1) {
        vm.record.form_configs.inputObjs.splice(currentIndex, 1)
      }
    },
    updateInputObjField (payload) {
      const vm = this
      var currentIndex = payload.objIndex
      if (currentIndex !== -1) {
        vm.record.form_configs.inputObjs[currentIndex][payload.fieldName] = payload.fieldValue
      }
    },
    removeInputObjOption (payload) {
      const vm = this
      var currentIndex = vm.getSelectedObjIndex(payload.id)
      var optionIndex = payload.objIndex
      if (currentIndex !== -1 && optionIndex <= vm.record.form_configs.inputObjs[currentIndex].options.length) {
        vm.record.form_configs.inputObjs[currentIndex].options.splice(optionIndex, 1)
      }
    },
    appendInputObjOption (payload) {
      const vm = this
      var currentIndex = payload.objIndex
      var value = payload.value ? payload.value : ''
      if (currentIndex !== -1) {
        vm.record.form_configs.inputObjs[currentIndex].options.push(value)
      }
    },
    updateInputObjOptionByIndex (payload) {
      const vm = this
      var optionIndex = payload.index
      var currentIndex = payload.objIndex
      if (currentIndex !== -1) {
        var newOptionList = JSON.parse(JSON.stringify(vm.record.form_configs.inputObjs[currentIndex].options))
        if (optionIndex !== -1 && optionIndex <= newOptionList.length) {
          newOptionList[optionIndex] = payload.fieldValue
        }
        vm.record.form_configs.inputObjs[currentIndex].options = newOptionList
      }
    },

    replaceInputObjs (payload) {
      const vm = this
      vm.record.form_configs.inputObjs = payload.value
    },

    updatePageConfigField (payload) {
      console.log('FormInputObjMixin :: updatePageConfigField')
      const vm = this
      vm.record.form_configs.pageConfig[payload.fieldName] = payload.fieldValue
    }

  }
}

export default FormInputObjMixin
