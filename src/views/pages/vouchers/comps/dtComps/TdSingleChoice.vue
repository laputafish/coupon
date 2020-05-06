<template>
  <div class="w-100">
    <div class="badge badge-info font-weight-normal">
      {{ item }}
    </div>
  </div>
</template>

<script>
export default {
  props: ['value','field','row','xprops'],
  computed: {
    item () {
      const vm = this
      console.log('TdSingleChoice :: computed :: value: ', vm.value)
      console.log('TdSingleChoice :: computed :: field: ', vm.field)
      console.log('TdSingleChoice :: computed :: row: ', vm.row)
      console.log('TdSingleChoice :: computed :: xprops: ', vm.xprops)

      const options = vm.xprops['optionalChoices'][vm.field]
      var itemIndex = parseInt(vm.value)
      return options[itemIndex]
    }
  }
}
</script>