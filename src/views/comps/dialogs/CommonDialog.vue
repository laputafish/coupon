<template>
  <base-dialog
      class="common-dialog"
      :id="id"
      :title="title"
      size="md"
      :value="value"
      @onCommand="onCommandHandler"
      modalType="confirmation"
      @input="value=>$emit('input',value)">
    <template v-if="message" v-slot:dialogBody>
      <div class="text-left">{{ message }}</div>
    </template>
    <template v-slot:buttonBar>
      <button v-for="button in buttons"
              class="btn"
              :class="buttonClass(button)"
              @click="onButtonClicked(button.command)"
              :key="button.command">{{ button.caption }}</button>
      <button :disabled="loading" class="min-width-100 btn btn-secondary"
              @click="closeDialog">Cancel</button>
    </template>
  </base-dialog>
</template>

<script>
  import baseDialog from '@/views/comps/BaseDialog'
  import appMixin from '@/mixins/AppMixin'

  export default {
    mixins: [appMixin],
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
      value: {
        type: Boolean,
        default: false
      },
      buttons: {
        type: Array,
        default () {
          return []
        }
      }
    },
    model: {
      prop: 'value',
      event: 'input'
    },
    data () {
      return {
        loading: false,
        message: ''
      }
    },
    methods: {
      setMessage (message) {
        this.message = message
      },
      close () {
        this.closeDialog()
      },
      buttonClass (button) {
        const vm = this
        var result = ['min-width-100']
        if (button.variant) {
          result.push('btn-' + button.variant)
        }
        return result.join(' ')
      },
      closeDialog () {
        const vm = this
        vm.$emit('input', false)
        vm.$bvModal.hide(vm.id)
      },
      onButtonClicked (command) {
        this.$emit('onCommand', {
          command: command
        })
      },
      onCommandHandler (payload) {
        const vm = this
        // console.log('VoucherSelectDialog :; onCommandHandler :: payload: ', payload)
        const command = payload.command
        switch (command) {
          case 'ok':
            if (vm.selectedVoucher) {
              vm.$emit('onCommand', {
                command: vm.okCommand,
                voucher: vm.selectedVoucher
              })
            }
            break
        }
      }
    }
  }
</script>

<style>
  .common-dialog .left-pane {
    display: block;
    padding-right: 10px;
    width: 40%;
  }

  .common-dialog .left-pane .left-pane-scroll {
    overflow-y: scroll;
    height: 0;
    min-height: 100%;
  }

  .common-dialog .right-pane {
    display: block;
    width: 60%;
  }

  .common-dialog .right-pane .right-pane-scroll .voucher-item-description {
    line-height: 1.1;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }

  .common-dialog .right-pane .right-pane-scroll .voucher-item-notes {
    line-height: 1;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }
  .common-dialog .right-pane .right-pane-scroll .voucher-item-notes {
    color: rgba(0,0,0,.6);
  }
  .common-dialog .right-pane .right-pane-scroll .voucher-item-title-block {
    height: 32px;
  }
  .common-dialog .right-pane .right-pane-scroll {
    overflow-y: scroll;
    height: 0;
    min-height: 100%;
  }

  .common-dialog {
    display: flex !important;
    flex-direction: column;
  }

  .common-dialog .modal-dialog {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    width: 100%;
  }

  .common-dialog .modal-dialog [role=document] {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
  }

  .common-dialog .modal-dialog [role=document] .modal-body {
    flex-grow: 1;
    display: flex;
    flex-direction: row;
  }

  .common-dialog .list-group-item.active {
    background-color: #0080ff;
  }
  .common-dialog .list-group-item.active:hover {
    background-color: #3299ff;
  }
  .common-dialog .list-group-item:hover {
    background-color: #f6f6f6;
  }
  .common-dialog .list-group-item {
    cursor: pointer;
  }
  .common-dialog
  .common-dialog .list-group-item.voucher-item {
    padding: 0.35rem 0.7rem;
  }

  .common-dialog .list-group-item .voucher-note {
    color: rgba(0,0,0,.3);
  }

  .common-dialog .list-group-item .voucher-note .note-value {
    color: black
  }

  .common-dialog .list-group-item.active .voucher-note {
    color: rgba(255,255,255,.5);
  }

  .common-dialog .list-group-item.active .voucher-note .note-value {
    color: white;
  }

</style>