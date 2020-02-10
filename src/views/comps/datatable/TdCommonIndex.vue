<template>
  <div>
    {{ index }}
  </div>
</template>

<script>
export default {
  props: ['data', 'value', 'row', 'xprops', 'query'],
  mounted () {
  },
  computed: {
    index () {
      let vm = this
      let index = vm.data.findIndex((item) => item.id === vm.value)
      return (vm.query.offset + index + 1)
    }
  }
}
</script>
