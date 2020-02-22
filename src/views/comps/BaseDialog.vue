<template>
  <b-modal :id="id"
           :size="size"
           :value="value"
           :title="$t('vouchers.copyTemplateFrom')">
    <slot name="dialogBody">
    </slot>
    <template v-slot:modal-footer>
      <div class="w-100 text-right">
        <div class="btn-toolbar justify-content-end">
          <template v-if="modalType==='confirmation'">
            <b-button
                :disabled="!okButtonState"
                variant="primary"
                size="sm"
                class="min-width-80"
                @click="copyTemplate(selectedVoucher)">
              {{ $t('buttons.ok') }}
            </b-button>
            <b-button
                variant="secondary"
                size="sm"
                class="min-width-80"
                @click="closeDialog()">
              {{ $t('buttons.cancel') }}
            </b-button>
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
        }
      }
    },
    methods: {
      closeDialog () {
        const vm = this
        vm.$emit('input',false)
        vm.$bvModal.hide(vm.id)
      }
    }
  }
</script>