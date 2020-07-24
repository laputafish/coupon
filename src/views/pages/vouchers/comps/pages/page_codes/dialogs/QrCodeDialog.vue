<template>
  <base-dialog
      id="qrCodeDialog"
      title="Goto Link with QR Code"
      size="md"
      modalType="confirmation"
      :okButtonState="true"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div class="text-center">
        <qrcode-vue
            :value="link"
            :size="160"
            level="M"></qrcode-vue>
        <div class="d-flex flex-row justify-content-center">
          <copy-link :link="params.link"
                     @onCommand="onCommandHandler"
                     :label="params.codeKey"></copy-link>
        </div>
      </div>
    </template>
    <template v-slot:buttonBar>
      <button class="px-2 btn btn-secondary min-width-100" @click="closeDialog">Close</button>
    </template>
  </base-dialog>
</template>

<script>
import baseDialog from '@/views/comps/BaseDialog'
import qrcodeVue from 'qrcode.vue'
import copyLink from '@/views/comps/CopyLink.vue'

export default {
  components: {
    baseDialog,
    qrcodeVue,
    copyLink
  },
  computed: {
    link () {
      const vm = this
      var result = ''
      if (vm.params.link !== '') {
        result = vm.params.link.replace('http://', 'https://')
      }
      return result
    }
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
    },
    params: {
      type: Object,
      default: {
        link: '',
        codeKey: ''
      }
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  methods: {
    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'gotoLink':
          window.open(payload.link, '_blank')
          break
      }
    },
    closeDialog () {
      const vm = this
      console.log('closeDialog')
      vm.$emit('input', false)
      vm.$bvModal.hide('qrCodeDialog')
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