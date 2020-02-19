<template>
  <div class="td-agent">
    {{ agentName }}
  </div>
</template>

<script>
export default {
  props: ['row', 'value', 'xprops'],
  computed: {
    agentName () {
      const vm = this
      return vm.value ? vm.value.name : '(' + vm.$t('general.unspecified') + ')'
    }
  }
}
</script>