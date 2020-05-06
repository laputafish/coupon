<template>
  <div class="w-100">
    <div class="badge badge-info mr-1 font-weight-normal"
         v-for="item in items"
        :key="item">
      {{ item }}
    </div>
  </div>
</template>

<script>
export default {
  props: ['value','field','row','xprops'],
  computed: {
    items () {
      const vm = this

      console.log('TdSingleChoice :: computed :: value: ', vm.value)
      console.log('TdSingleChoice :: computed :: field: ', vm.field)
      console.log('TdSingleChoice :: computed :: row: ', vm.row)
      console.log('TdSingleChoice :: computed :: xprops: ', vm.xprops)


      const options = vm.xprops['optionalChoices'][vm.field]
      var result = []
      var itemIndices = vm.value.split(',').map(item => parseInt(item))
      for (var i = 0; i < itemIndices.length; i++) {
        result.push(options[itemIndices[i]])
      }
      return result
    }
  }
}
</script>