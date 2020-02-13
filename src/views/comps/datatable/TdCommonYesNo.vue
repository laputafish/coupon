<template>
  <div>
    <button class="btn btn-sm btn-width-50"
            :class="{'btn-primary': value, 'btn-outline-primary': !value}"
            @click="toggleEnabled(true)">
      <i class="fa fa-check fa-fw"></i>
    </button>
    <button class="btn btn-sm btn-width-50"
            :class="{'btn-primary': !value, 'btn-outline-primary': value}"
            @click="toggleEnabled(false)">
      <i class="fa fa-close fa-fw"></i>
    </button>
  </div>
</template>

<script>
export default {
  props: ['field', 'value', 'row', 'xprops'],
  methods: {
    toggleEnabled (value) {
      const vm = this
      console.log('TdYesNo :: field: ', vm.field)
      console.log('TdYesNo :: value: ', vm.value)
      console.log('TdYesNo :: row: ', vm.row)
      console.log('TdYesNo :: xprops: ', vm.xprops)
      vm.xprops.eventBus.$emit('toggle_enabled', {
        target: vm.row,
        field: vm.field,
        value: value
      })
    }
  }
}
</script>

<style>

</style>
