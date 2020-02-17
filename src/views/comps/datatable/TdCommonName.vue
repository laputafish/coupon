<template>
  <div>
    {{ name }}
  </div>
</template>

<script>
export default {
  props: ['row', 'value', 'xprops'],
  computed: {
    name () {
      const vm = this
      let result = []
      if (vm.row.first_name !== '') {
        result.push(vm.row.first_name)
      }
      if (vm.row.surname !== '') {
        result.push(vm.row.surname)
      }
      return result.join(' ')
    }
  }
}
</script>
