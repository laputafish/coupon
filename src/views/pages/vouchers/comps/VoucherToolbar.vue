<template>
  <div class="voucher-toolbar">
    <voucher-toolbar-button class="toolbar-button-wrapper"
      v-for="button in buttons"
      :key="button.command"
      @click="onClick(button)"
      :selected="activeButton===button"
      :button="button">
    </voucher-toolbar-button>
  </div>
</template>

<script>
import voucherToolbarButton from './VoucherToolbarButton'

export default {
  components: {
    voucherToolbarButton
  },
  data () {
    return {
    }
  },
  props: {
    buttons: {
      type: Array,
      default () {
        return []
      }
    },
    activeButton: {
      type: Object,
      default: null
    }
  },
  methods: {
    onClick (button) {
      const vm = this
      console.log('onClick :: button: ', button)
      vm.$emit('click', button)
    }
  }
}
</script>

<style>
  .voucher-toolbar {
    border-top: 1px solid rgba(127,127,127,.2);
    border-bottom: 4px solid #9fcdff;
    border-left: none;
    border-right: none;
    padding: 10px 2px 0 2px;
  }
</style>