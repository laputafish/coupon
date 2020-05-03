const FormInputObjMixin = {
  computed: {
    inputObjTypes () {
      return this.$store.getters.inputObjTypes
    },
    DEFAULT_FORM_CONFIGS () {
      return this.$store.getters.DEFAULT_FORM_CONFIGS
    }
  },
  methods: {
    newFormKey () {
      return (Date.now() + Math.random()).toString(36).replace('.', '')
    },
    getSelectedObjIndex (id, formConfigs) {
      const vm = this
      var result = -1
      for (var i = 0; i < formConfigs.inputObjs.length; i++) {
        if (formConfigs.inputObjs[i].id === id) {
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

    // resetOptionIds () {
    //   const vm = this
    //   console.log('resetOptionIds :: vm.record.form_configs.inputObjs: ', vm.record.form_configs.inputObjs)
    //   for (var i = 0; i < vm.record.form_configs.inputObjs.length; i++) {
    //     vm.record.form_configs.inputObjs[i].id = i + 1
    //   }
    // },
// ?????? ?<-- merge onCommandHandler with VoucherRecord.vue
    onInputObjCommandHandler (payload) {
      const vm = this
      const command = payload.command
      console.log('onInputObjCommandHandler: payload: ', payload)
      var formConfigs = vm.getFormConfigsByKey(payload.key)
      if (formConfigs) {
        switch (command) {
          case 'newInputObj':
            vm.newInputObj(payload, formConfigs)
            break
          case 'deleteInputObj':
            vm.deleteInputObj(payload, formConfigs)
            break
          case 'updateInputObjField':
            console.log('FormInputObjMixin :: onInputObjCommandHandler :: updateInputObjField: payload: ', payload)
            vm.updateInputObjField(payload, formConfigs)
            break
          case 'removeInputObjOption':
            vm.removeInputObjOption(payload, formConfigs)
            break
          case 'appendInputObjOption':
            vm.appendInputObjOption(payload, formConfigs)
            break
          case 'updateInputObjOptions':
            vm.updateInputObjOptions(payload, formConfigs)
            break
          case 'updateInputObjOptionByIndex':
            vm.updateInputObjOptionByIndex(payload, formConfigs)
            break
          case 'removeInputObjOptionByIndex':
            vm.removeInputObjOptionByIndex(payload, formConfigs)
            break
          case 'replaceInputObjs':
            vm.replaceInputObjs(payload, formConfigs)
            break
          case 'updatePageConfigField':
            vm.updatePageConfigField(payload, formConfigs)
            break
          case 'exportFormConfigs':
            vm.exportFormConfigs(payload, formConfigs)
            break
          case 'clearForm':
            vm.clearForm(payload.key);
            break
          case 'previewQuestionForm':
            vm.previewQuestionForm(payload, formConfigs)
            break
        }
      }
    },

    clearForm (key) {
      const vm = this
      switch (key) {
        case 'question':
          vm.record.form_configs = vm.DEFAULT_FORM_CONFIGS
          break
        default:
          for (var i = 0; i < vm.record.custom_forms.length; i++) {
            var customForm = vm.record.custom_forms[i]
            if (customForm.form_key === key) {
              vm.record.custom_forms[i].form_configs = vm.DEFAULT_FORM_CONFIGS
              break
            }
          }
      }
    },

    exportFormConfigs (payload, formConfigs) {
      const vm = this
      const postData = {
        urlCommand: '/form_questions/temp/create',
        data: {
          formConfigs: formConfigs
        }
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        response => {
          const url = vm.$store.getters.appHost + '/d/_' + response.key
          window.open(url, '_blank')
        },
        error => {vm.$toaster.error(error.message)}
      )
    },

    // selectFormConfigs (key, callback) {
    //   const vm = this
    //   var formConfigs = null
    //   switch (key) {
    //     case 'question':
    //       formConfigs = vm.record.form_configs
    //       break
    //     case 'thankyou':
    //       formConfigs = vm.record.thankyou_configs
    //       break
    //     case 'sorry':
    //       formConfigs = vm.record.sorry_configs
    //       break
    //   }
    //   if (formConfigs !== null) {
    //     callback(formConfigs)
    //   } else {
    //     vm.$toaster.error('Form configs not defined!')
    //   }
    // },

    getFormConfigsByKey (key) {
      const vm = this
      var formConfigs = null
      switch (key) {
        case 'question':
          formConfigs = vm.record.form_configs
          break
        default:
          for (var i = 0; i < vm.record.custom_forms.length; i++) {
            var customForm = vm.record.custom_forms[i]
            if (customForm.form_key === key) {
              formConfigs = customForm.form_configs
              break
            }
          }
      }
      return formConfigs
    },

    previewQuestionForm (payload, formConfigs) {
      const vm = this
      const postData = {
        urlCommand: '/form_questions/temp/create',
        data: {
          formConfigs: formConfigs
        }
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        response => {
          const url = vm.$store.getters.appHost + '/q/_' + response.key
          window.open(url, '_blank')
        },
        error => {
          vm.$toaster.error(error.message)
        }
      )
    },

    newInputObj (payload, formConfigs) {
      const vm = this
      console.log('FormInputObjMixin :: newInputObj: payload: ', payload)
      console.log('FormInputObjMixin :: newInputObj: formConfigs: ', formConfigs)

      var inputObjType = payload.value
      var newObj = vm.getNewInputObj(inputObjType)
      var currentIndex = payload.objIndex
      var inputObjs = JSON.parse(JSON.stringify(formConfigs.inputObjs))

      if (currentIndex === -1) {
        inputObjs.push(newObj)
      } else {
        inputObjs.splice(currentIndex + 1, 0, newObj)
      }
      formConfigs.inputObjs = inputObjs
    },

    deleteInputObj (payload, formConfigs) {
      const vm = this
      var currentIndex = payload.objIndex
      if (currentIndex !== -1) {
        formConfigs.inputObjs.splice(currentIndex, 1)
      }
    },

    updateInputObjField (payload, formConfigs) {
      const vm = this
      console.log('FormInputObjMixin :: updateInputObjField :: payload: ', payload)
      var currentIndex = payload.objIndex
      if (currentIndex !== -1) {
        formConfigs.inputObjs[currentIndex][payload.fieldName] = payload.fieldValue.replace(/[\n\r]/g, '|');
      }
    },

    removeInputObjOption (payload, formConfigs) {
      const vm = this
      var currentIndex = vm.getSelectedObjIndex(payload.id, formConfigs)
      var optionIndex = payload.objIndex
      if (currentIndex !== -1 && optionIndex <= formConfigs.inputObjs[currentIndex].options.length) {
        formConfigs.inputObjs[currentIndex].options.splice(optionIndex, 1)
      }
    },
    appendInputObjOption (payload, formConfigs) {
      const vm = this
      var currentIndex = payload.objIndex
      var value = payload.value ? payload.value : ''
      if (currentIndex !== -1) {
        formConfigs.inputObjs[currentIndex].options.push(value)
      }
    },

    updateInputObjOptions (payload, formConfigs) {
      const vm = this
      var currentIndex = payload.objIndex
      if (currentIndex !== -1) {
        formConfigs.inputObjs[currentIndex].options = payload.options
      }
    },

    removeInputObjOptionByIndex (payload, formConfigs) {
      console.log('removeInputObjOptionByIndex :: payload: ', payload)
      const vm = this
      var optionIndex = payload.index
      var currentIndex = payload.objIndex
      if (currentIndex !== -1) {
        var newOptionList = JSON.parse(JSON.stringify( formConfigs.inputObjs[currentIndex].options))
        newOptionList.splice(optionIndex, 1)
        formConfigs.inputObjs[currentIndex].options = newOptionList
      }
    },

    updateInputObjOptionByIndex (payload, formConfigs) {
      const vm = this
      var optionIndex = payload.index
      var currentIndex = payload.objIndex
      if (currentIndex !== -1) {
        var newOptionList = JSON.parse(JSON.stringify(formConfigs.inputObjs[currentIndex].options))
        if (optionIndex !== -1 && optionIndex <= newOptionList.length) {
          newOptionList[optionIndex] = payload.fieldValue
        }
        formConfigs.inputObjs[currentIndex].options = newOptionList
      }
    },

    replaceInputObjs (payload, formConfigs) {
      const vm = this
      formConfigs.inputObjs = payload.value
    },

    updatePageConfigField (payload, formConfigs) {
      console.log('FormInputObjMixin :: updatePageConfigField')
      const vm = this
      formConfigs.pageConfig[payload.fieldName] = payload.fieldValue
    }

  }
}

export default FormInputObjMixin
