<template>
  <base-dialog
    id="singleFieldDialog"
    :title="title"
    size="sm"
    modalType="confirmation"
    :okButtonState="true"
    :value="value"
    @onCommand="onCommandHandler"
    @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <input v-model="fieldValue" class="form-control"/>
    </template>
  </base-dialog>
</template>

<script>
import baseDialog from '@/views/comps/BaseDialog'

export default {
  components: {
    baseDialog
  },
  data () {
    return {
      title: '',
      fieldValue: '',
      callbackCommand: '',
      idParams: {},
      value: false
    }
  },
  methods: {
    init (title, callbackCommand, idParams, fieldValue) {
      const vm = this
      vm.title = title
      vm.callbackCommand = callbackCommand
      vm.fieldValue = fieldValue
      vm.idParams = idParams
      vm.value = true
    },
    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      switch (command) {
        case 'ok':
          vm.$emit('onCommand', {
            command: vm.callbackCommand,
            idParams: vm.idParams,
            fieldValue: vm.fieldValue
          })
          vm.value = false
      }
    }
  }

}
</script>