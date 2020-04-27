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
      for (var i = 0; i < vm.record.inputObjs.length; i++) {
        if (vm.record.inputObjs[i].id === id) {
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
      console.log('resetOptionIds :: vm.record.inputObjs: ', vm.record.inputObjs)
      for (var i = 0; i < vm.record.inputObjs.length; i++) {
        vm.record.inputObjs[i].id = i + 1
      }
    },

    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      var currentIndex = -1

      switch (command) {
        case 'newInputObj':
          var inputObjType = payload.value
          var newObj = vm.getNewInputObj(inputObjType)
          currentIndex = vm.getSelectedObjIndex(payload.id)
          if (currentIndex === -1) {
            vm.record.inputObjs.push(newObj)
          } else {
            vm.record.inputObjs.splice(currentIndex + 1, 0, newObj)
          }
          vm.resetOptionIds()
          break
        case 'updateField':
          currentIndex = vm.getSelectedObjIndex(payload.id)
          if (currentIndex !== -1) {
            vm.record.inputObjs[currentIndex][payload.fieldName] = payload.fieldValue
          }
          break
        case 'removeOptionByIndex':
          currentIndex = vm.getSelectedObjIndex(payload.id)
          if (currentIndex !== -1 && index <= vm.record.inputObjs[currentIndex].options.length) {
            vm.record.inputObjs[currentIndex].options.splice(index, 1)
          }
          break
        case 'appendBlankOption':
          currentIndex = vm.getSelectedObjIndex(payload.id)
          if (currentIndex !== -1) {
            vm.record.inputObjs[currentIndex].options.push('')
          }
          break
        case 'updateOptionByIndex':
          var optionIndex = payload.index
          currentIndex = vm.getSelectedObjIndex(payload.id)
          if (currentIndex !== -1) {
            var newOptionList = JSON.parse(JSON.stringify(vm.record.inputObjs[currentIndex].options))
            if (optionIndex !== -1 && optionIndex <= newOptionList.length) {
              newOptionList[optionIndex] = payload.fieldValue
            }
            vm.record.inputObjs[currentIndex].options = newOptionList
          }
          break
      }
    }
  }
}

export default FormInputObjMixin
