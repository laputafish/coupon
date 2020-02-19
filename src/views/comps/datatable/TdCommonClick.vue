<template>
  <div class="td-common-link" @click="onClick">
    {{ value }}
  </div>
</template>

<script>
export default {
  props: ['value', 'row', 'xprops', 'field'],
  methods: {
    onClick ( ) {
      const vm = this
      vm.xprops.eventbus.$emit('onRowCommand', {
        command: 'onClick',
        row: vm.row,
        fieldName: vm.field,
        fieldValue: vm.value
      })
    }
  }
}
</script>

<style>
  .td-common-link:hover {
    cursor: pointer;
  }
</style>
