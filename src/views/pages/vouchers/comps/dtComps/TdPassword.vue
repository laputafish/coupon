<template>
  <div class="d-inline-block">
    {{ outputValue }}
  </div>
</template>

<script>
export default {
  props: ['value', 'row', 'xprops'],
  computed: {
    outputValue () {
      const vm = this
      const len = vm.value.length
      return '*'.repeat(len)
    }
  }
}
</script>