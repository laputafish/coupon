<template>
  <base-dialog
      id="imageSelectDialog"
      :title="title"
      modalType="confirmation"
      :okButtonState="selectedImage!==null"
      size="xl"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div class="right-pane">
        <div class="right-pane-scroll">
          <image-item
              v-for="image in images"
              :key="image.id"
              :imageItem="image"
              @onCommand="onCommandHandler"
              :activeImage="selectedImage">
          </image-item>
        </div>
      </div>
    </template>
  </base-dialog>
</template>

<script>
  import baseDialog from '@/views/comps/BaseDialog'
  import appMixin from '@/mixins/AppMixin'
  import imageItem from './comps/ImageItem'

  export default {
    mixins: [appMixin],
    components: {
      baseDialog,
      imageItem
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
      value: {
        type: Boolean,
        default: false
      },
      initialAgentId: {
        type: Number,
        default: 0
      },
      scope: {
        type: String,
        default: ''
      }
    },
    computed: {
      agents () {
        return this.$store.getters.agents
      }
    },
    model: {
      prop: 'value',
      event: 'input'
    },
    watch: {
      value: function (newValue) {
        const vm = this
        console.log('ImageSelectDialog :: watch(value)')
        vm.fetchImages()
      }
    },
    data () {
      return {
        objectFitMode: 'cover',
        loading: false,
        // selectedAgent: null,
        selectedImage: null,
        images: []
      }
    },
    // watch: {
    //   initialAgentId: function () {
    //     console.log('watch(initialAgentId)')
    //     this.setInitialAgent()
    //   },
    //   'selectedAgent.id': function (newValue) {
    //     const vm = this
    //     console.log('watch(selectedAgent) :: selectedAgent.id = ' + newValue)
    //     vm.selectedVoucher = null
    //     vm.fetchAgentVouchers()
    //   }
    // },
    methods: {
      fetchImages () {
        const vm = this
        const data = {
          urlCommand: '/medias',
          options: {
            params: {
              scope: vm.scope
            }
          }
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            vm.images = response
          }
        )
      },
      onCommandHandler (payload) {
        const vm = this
        console.log('VoucherSelectDialog :; onCommandHandler :: payload: ', payload)
        const command = payload.command
        switch (command) {
          case 'onImageSelected':
            vm.selectedImage = payload.image
            break
          case 'ok':
            if (vm.selectedImage) {
              vm.$emit('onCommand', {
                command: 'selectImage',
                imageId: vm.selectedImage.id
              })
            }
            break
        }
      }
      // setInitialAgent () {
      //   const vm = this
      //   console.log('setInitialAgent :: initialAGentId = ' + vm.initialAgentId)
      //   console.log('setInitialAgent :: agents.length = ' + vm.agents.length)
      //   if (vm.initialAgentId === 0) {
      //     vm.selectedAgent = null
      //   } else {
      //     for (let i = 0; i < vm.agents.length; i++) {
      //       if (vm.agents[i].id === vm.initialAgentId) {
      //         vm.selectedAgent = vm.agents[i]
      //         break
      //       }
      //     }
      //   }
      //   console.log('selectedAgent: ', vm.selectedAgent)
      // },
      // fetchAgentVouchers () {
      //   const vm = this
      //   if (vm.selectedAgent) {
      //     const data = {
      //       urlCommand: '/vouchers',
      //       options: {
      //         params: {
      //           agentId: vm.selectedAgent.id,
      //           type: 'selection'
      //         }
      //       }
      //     }
      //     vm.loading = true
      //     vm.$store.dispatch('AUTH_GET', data).then(
      //       response => {
      //         vm.loading = false
      //         vm.vouchers = response
      //         console.log('GET vouchers')
      //       },
      //       () => {
      //         vm.loading = false
      //         vm.showSessionExpired()
      //         // vm.$dialog.alert('Vouchers: ' + vm.$t('messages.error_during_loading'))
      //       }
      //     )
      //   }
      // }
      // fetchAgents () {
      //   const vm = this
      //   vm.$store.dispatch('AUTH_GET', '/agents').then(
      //     response => {
      //       // console.log('fetchAgents: redsponse: ', response)
      //       vm.agents = response
      //     },
      //     error => {
      //       vm.$dialog.alert('Agents: ' + vm.$t('messages.error_during_loading'))
      //     }
      //   )
      // }
    }
  }
</script>

<style>
  /*************************/
  /* Content Configuration */
  /*************************/
  #imageSelectDialog .left-pane {
    display: none;
    padding-right: 10px;
    width: 40%;
  }

  #imageSelectDialog .right-pane {
    width: 100%;
  }

  #imageSelectDialog .left-pane .left-pane-scroll {
    overflow-y: scroll;
    height: 0;
    min-height: 100%;
  }

  #imageSelectDialog .right-pane .right-pane-scroll {
    overflow-y: scroll;
    height: 0;
    min-height: 100%;
  }

  /************************/
  /* Dialog Configuration */
  /************************/
  #imageSelectDialog {
    display: flex !important;
    flex-direction: column;
  }

  #imageSelectDialog .modal-dialog {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    width: 100%;
  }

  #imageSelectDialog .modal-dialog [role=document] {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
  }

  #imageSelectDialog .modal-dialog [role=document] .modal-body {
    flex-grow: 1;
    display: flex;
    flex-direction: row;
  }

  #imageSelectDialog .list-group-item {
    cursor: pointer;
  }

  #imageSelectDialog .list-group-item.voucher-item {
    padding: 0.35rem 0.7rem;
  }

  #imageSelectDialog .list-group-item .voucher-note {
    color: rgba(0, 0, 0, .3);
  }

  #imageSelectDialog .list-group-item .voucher-note .note-value {
    color: black
  }

  #imageSelectDialog .list-group-item.active .voucher-note {
    color: rgba(255, 255, 255, .5);
  }

  #imageSelectDialog .list-group-item.active .voucher-note .note-value {
    color: white;
  }

</style>
