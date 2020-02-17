<template>
  <div>{{ trimDate }}</div>
</template>

<script>
export default {
  props: ['value'],
  computed: {
    trimDate () {
      const vm = this
      let result = '-'
      if (vm.value) {
        if (vm.value === '') {
          result = '-'
        } else {
          result = vm.value.substr(0, 10)
        }
      }
      return result
    }
  }
}
</script>
