<template>
  <div>
    {{ status }}
  </div>
</template>

<script>
export default {
  props: ['value', 'row', 'xprops'],
  computed: {
    status () {
      let vm = this
      let label = vm.$t('status.' + vm.value)
      if (vm.xprops.statusOptions) {
        for (var i = 0; i < vm.xprops.statusOptions.length; i++) {
          let option = vm.xprops.statusOptions[i]
          if (option.value === vm.value) {
            label = vm.$t(option.labelTag)
            break
          }
        }
      }
      return label
    }
  }
}
</script>
