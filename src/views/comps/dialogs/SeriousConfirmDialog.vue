<template>
  <base-dialog :id="id"
               :title="params.title"
               modalType="confirmation"
               :okButtonState="userMessage.toLowerCase()===params.confirmWord.toLowerCase()"
               size="sm"
               :value="value"
               @onCommand="onCommandHandler"
               @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <p>{{ params.message }}</p>
      <input class="form-control text-capitalize" v-model="userMessage"/>
      <small>{{ $t('messages.type__to_proceed', {word: params.confirmWord}) }}</small>
    </template>
  </base-dialog>
</template>

<script>
import baseDialog from '@/views/comps/BaseDialog'

export default {
  components: {
    baseDialog
  },
  props: {
    id: {
      type: String,
      default: ''
    },
    title: {
      type: String,
      default: ''
    },
    message: {
      type: String,
      default: ''
    },
    confirmWord: {
      type: String,
      default: ''
    },
    command: {
      type: String,
      default: ''
    },
    value: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      userMessage: '',
      params: {
        title: '',
        message: '',
        confirmWord: '',
        command: ''
      }
    }
  },
  watch: {
    value: function(newValue) {
      const vm = this
      console.log('watch(value) : newValue: ', newValue)
      console.log('watch(value) : vm.id = ' + vm.id)

      if (newValue) {
        vm.$bvModal.show(vm.id)
      } else {
        vm.$bvModal.hide(vm.id)
      }
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  mounted () {
    const vm = this
    if (vm.title !== '') vm.params.title = vm.title
    if (vm.title !== '') vm.params.message = vm.message
    if (vm.title !== '') vm.params.confirmWord = vm.confirmWord
    if (vm.title !== '') vm.params.command = vm.command
  },
  methods: {
    closeDialog () {
      const vm = this
      vm.$emit('input', false)
      vm.$bvModal.hide(vm.id)
    },
    init (params) {
      const vm = this
      console.log('SeriousConfirmDialog :: init')
      vm.params.title = params.title
      vm.params.message = params.message
      vm.params.confirmWord = params.confirmWord
      vm.params.command = params.command
    },
    onCommandHandler (payload) {
      const vm = this
      console.log('onCommandHandler :: payload: ', payload)
      switch(payload.command) {
        case 'ok':
          vm.$emit('onCommand', {
            command: vm.params.command,
            callback: () => {
              vm.$emit('input', false)
              vm.$bvModal.hide(vm.id)
            }
          })
      }
    }
    // ,
    // handleOk () {
    //   const vm = this
    //   if (vm.userMessage.toUpperCase() === vm.confirmWord.toUppercase()) {
    //     vm.$emit('onCommand', {
    //       command: command
    //     })
    //   }
    // }
  }
}
</script>