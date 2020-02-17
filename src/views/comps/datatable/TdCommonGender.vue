<template>
  <div>{{ gender }}</div>
</template>

<script>
export default {
  props: ['value', 'row', 'xprops'],
  computed: {
    gender () {
      const vm = this
      return vm.value === 'm' ? vm.$t('general.male') : vm.$t('general.female')
    }
  }
}
</script>
