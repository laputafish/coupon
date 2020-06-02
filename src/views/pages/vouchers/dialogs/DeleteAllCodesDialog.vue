<template>
  <base-dialog
      id="deleteAllCodesDialog"
      title="Delete All Codes"
      size="md"
      modalType="confirmation"
      :okButtonState="true"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div>Participants exists. Do you want to remove all codes or partcipants as well?</div>
    </template>
    <template v-slot:buttonBar>
      <button class="px-2 min-width-80 btn btn-danger" @click="deleteCodesOnly">Delete Codes Only</button>
      <button class="px-2 min-width-80 btn btn-danger" @click="deleteCodesAndParticipants">Delete Codes & Participants</button>
      <button class="px-2 btn btn-secondary" @click="closeDialog">Cancel</button>
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
      // title: '',
      // fieldValue: '',
      // callbackCommand: '',
      // idParams: {},
    }
  },
  props: {
    value: {
      type: Boolean,
      default: false
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  methods: {
    onCommandHandler (payload) {
      this.$emit('onCommand', payload)
    },
    closeDialog () {
      const vm = this
      vm.$emit('input',false)
      vm.$bvModal.hide('deleteAllCodesDialog')
    },
    // init (title, callbackCommand, idParams, fieldValue) {
    //   const vm = this
    //   vm.fieldValue = fieldValue
    //   vm.idParams = idParams
    //   vm.value = true
    // },
    deleteCodesOnly () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'deleteAllCodes',
        callback: () => {
          vm.$bvModal.hide('deleteAllCodesDialog')
        }
      })
    },
    deleteCodesAndParticipants () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'deleteAllCodesAndParticipants',
        callback: () => {
          vm.$bvModal.hide('deleteAllCodesDialog')
        }
      })
    }
    // ,
    // onCommandHandler (payload) {
    //   const vm = this
    //   const command = payload.command
    //   switch (command) {
    //     case 'ok':
    //       vm.$emit('onCommand', {
    //         command: vm.callbackCommand,
    //         idParams: vm.idParams,
    //         fieldValue: vm.fieldValue
    //       })
    //       vm.value = false
    //   }
    // }
  }

}
</script>