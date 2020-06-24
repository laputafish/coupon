<template>
  <div class="input-group">
    <input class="form-control"
           @input="($event)=>{updateFieldValue($event.target.value)}"
           v-model="userData"/>
    <button class="input-group-append btn-success"
      @click="onButtonClicked">
      <font-awesome-icon icon="save"></font-awesome-icon>
    </button>
  </div>
</template>

<script>
import helpers from '@/helpers'

export default {
  data () {
    return {
      userData: ''
    }
  },
  props: ['row', 'value', 'nested', 'xprops', 'field'],
  watch: {
    value: function (newValue) {
      this.userData = newValue
    }
  },
  mounted () {
    const vm = this
    vm.userData = vm.value
  },
  methods: {
    onButtonClicked () {
      const vm = this
      vm.xprops.eventbus.$emit('onRowCommand', {
        command: 'saveField',
        row: vm.row,
        fieldName: vm.field,
        fieldValue: vm.value
      })
    },
    updateFieldValue (newValue) {
      const vm = this
      // console.log('TdCommonInput :: updateFieldValue : newValue: ', newValue)
      vm.xprops.eventbus.$emit('onRowCommand', {
        command: 'updateField',
        row: vm.row,
        fieldName: vm.field,
        fieldValue: newValue
      })
    },
    processCommand (command, needConfirm) {
      const vm = this
      // console.log('tdCommonOpt :: processCommand')
      if (typeof needConfirm === 'undefined') {
        needConfirm = false
      }
      if (needConfirm) {
        // alert('tdCommonOpt :: processCommand => call showConfirmDialog')
        helpers.showConfirmDialog(vm, () => {
          // alert('tdCommonOpt :: processCommand :: helpers.showConfirmDialog :: callback')
          // console.log('tdCommonOpt :: processCommand showConfirmDialog.callback')
          vm.doProcessCommand(command)
        })
        // alert('tdCommonOpt :: processCommand => after call showConfirmDialog')
      } else {
        // alert('tdCommonOpt :: processCommand (no need confirm)')
        vm.doProcessCommand(command)
      }
      // alert('tdCommonOPt :: processCommand ends')
    },

    doProcessCommand (command) {
      const vm = this
      vm.xprops.eventbus.$emit('onRowCommand', {
        command: command,
        row: vm.row
      })
    }
  }
}
</script>
