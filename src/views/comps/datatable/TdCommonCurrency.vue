<template>
  <div class="text-right">
    {{ formatMoney(parseFloat(value)) }}
  </div>
</template>

<script>
import AppMixin from '@/mixins/AppMixin'

export default {
  mixins: [AppMixin],
  props: ['value', 'row', 'xprops'],
  computed: {
    // formatted () {
    //   let vm = this
    //   let value = parseFloat(vm.value)
    //   return vm.formatMoney(value)
    // }
  }
}
</script>
