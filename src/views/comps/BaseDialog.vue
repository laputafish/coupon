<template>
  <b-modal :id="id"
           :size="size"
           :value="value"
           @input="value=>$emit('input',value)"
           :title="title">
    <slot name="dialogBody">
    </slot>
    <template v-slot:modal-footer>
      <div class="w-100 text-right">
        <div class="btn-toolbar justify-content-end">
          <template v-if="modalType==='confirmation'">
            <slot name="buttonBar">
              <b-button
                  :disabled="!okButtonState"
                  variant="primary"
                  size="sm"
                  class="min-width-80"
                  @click="$emit('onCommand', {command: 'ok'})">
                {{ $t('buttons.ok') }}
              </b-button>
              <b-button
                  variant="secondary"
                  size="sm"
                  class="min-width-80"
                  @click="closeDialog()">
                {{ $t('buttons.cancel') }}
              </b-button>
            </slot>
          </template>
          <template v-else>
            <b-button
                variant="secondary"
                size="sm"
                class="min-width-80"
                @click="closeDialog()">
              {{ $t('buttons.close') }}
            </b-button>
          </template>
        </div>
      </div>
    </template>
  </b-modal>
</template>

<script>
  export default {
    model: {
      prop: 'value',
      event: 'input'
    },
    props: {
      okButtonState: {
        type: Boolean,
        default: false
      },
      modalType: {
        type: String,
        default: 'alert'
      },
      id: {
        type: String,
        default: ''
      },
      value: {
        type: Boolean,
        default: false
      },
      title: {
        type: String,
        default: '(no title)'
      },
      size: {
        type: String,
        default: 'xl'
      }
    },
    watch: {
      value: function(newValue) {
        const vm = this
        if (newValue) {
          vm.$bvModal.show(vm.id)
        } else {
          vm.$bvModal.hide(vm.id)
        }
      }
    },
    methods: {
      closeDialog () {
        const vm = this
        vm.$emit('onCommand', {
          command: 'onClosing'
        })
        vm.$emit('input',false)
        vm.$bvModal.hide(vm.id)
      }
    }
  }
</script>

<style>
  .modal-header button.close {
    display: none;
  }
</style>