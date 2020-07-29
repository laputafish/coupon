<template>
  <base-dialog
    id="redemptionLocationDialog"
    :title="dialogTitle"
    size="md"
    modalType="confirmation"
    :okButtonState="true"
    @onCommand="onCommandHandler"
    :value="value"
    @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <validation-observer ref="observer" v-slot="{invalid, passes, reset}" tag="form">
        <div class="container-fluid">
          <div v-if="redemptionLocation" class="row">
            <v-data-input id="name"
                        rules="required"
                        width="12"
                        label="Name"
                        v-model="redemptionLocation.name"></v-data-input>
            <div class="col-sm-6">
              <div class="row">
                <v-data-input id="qrcode"
                            label="QR Code"
                            rules="required"
                            width="12"
                            v-model="redemptionLocation.qrcode"></v-data-input>
                <v-data-input id="locationCode"
                            label="Location Code"
                            rules="required"
                            width="12"
                            v-model="redemptionLocation.location_code"></v-data-input>
                <v-data-input-password id="password"
                            label="Password"
                            rules="required"
                            width="12"
                            v-model="redemptionLocation.password"></v-data-input-password>
                </div>
            </div>
            <div class="col-sm-6 mt-3 text-center">
                  <qrcode-vue
                      :value="qrcodeLink"
                      :size="120"
                      level="M"></qrcode-vue>
            </div>
          </div>
          <div v-else class="row">
            <div class="col-sm-12 text-center">
              <font-awesome-icon icon="spinner" class="fa-spin"></font-awesome-icon>
            </div>
          </div>
        </div>
      </validation-observer>
    </template>
  </base-dialog>
</template>

<script>
import baseDialog from '@/views/comps/BaseDialog'
import formInputs from '@/views/comps/forms'
import qrcodeVue from 'qrcode.vue'

export default {
  data () {
    return {
      showingPassword: false,
      redemptionLocation: null
    }
  },
  components: {
    baseDialog,
    ...formInputs,
    qrcodeVue
  },
  props: {
    value: {
      type: Boolean,
      default: false
    },
    params: {
      type: Object,
      default: null
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  computed: {
    qrcodeLink () {
      const vm = this
      return vm.$store.getters.appHost + '/redeem/' + btoa(vm.redemptionLocation.qrcode)
    },
    dialogTitle () {
      const vm = this
      var result = []
      if (vm.redemptionLocation) {
        result.push(vm.redemptionLocation.name)
        if (vm.redemptionLocation.id === 0) {
          result.push( '[NEW]')
        }
      }
      return result.length === 0 ? '' : result.join(' ')
    }
  },
  watch: {
    params: {
      handler: function(newValue) {
        const vm = this
        vm.redemptionLocation = JSON.parse(JSON.stringify(newValue.redemptionLocation))
        requestAnimationFrame(() => {
          this.$refs.observer.reset();
        });
      },
      deep: true
    }
  },
  mounted () {
    const vm = this
    console.log('RedemptionLocationDialog :: mounted :: vm.params: ', vm.params)

    if (vm.params && vm.params.redemptionLocation) {
      console.log('RedemptionLocationDialog :: mounted :: vm.params.redemptionLocation: ', vm.params.redemptionLocation)

      vm.redemptionLocation = JSON.parse(JSON.stringify(vm.params.redemptionLocation))
      requestAnimationFrame(() => {
        this.$refs.observer.reset();
      });
      // vm.reset()
    }
  },
  methods: {
    // reset () {
    //   const vm = this
    //   if (vm.$refs.observer) {
    //     vm.$refs.observer.reset()
    //   }
    // },
    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'ok':
          vm.$refs.observer.validate().then(
            isValid => {
              if (isValid) {
                vm.$emit('onCommand', {
                  command: 'redemptionLocationDialogConfirm',
                  redemptionLocation: vm.redemptionLocation
                })
                vm.closeDialog()
              } else {
                vm.$dialog.alert('Some field(s) is missing!')
              }
            }
          )
          break
      }
    },
    closeDialog () {
      const vm = this
      vm.$emit('input', false)
      vm.$bvModal.hide('redemptionLocationDialog')
    }
  }
}
</script>