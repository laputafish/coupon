<template>
    <date-picker :value="value"
                 valueType="format"
                 @input="newValue=>updateValue(newValue)"></date-picker>
</template>

<script>
import datePicker from 'vue2-datepicker'

export default {
  components: {
    datePicker
  },
  props: ['value', 'xprops', 'row', 'field'],
  computed: {
    dateFormat () {
      const vm = this
      let result = 'yy-mm-dd'
      if (vm.xprops.dateFormat) {
        result = vm.xprops.dateFormat
      }
      return result
    },
  },
  methods: {
    updateValue (newValue) {
      const vm = this
      vm.xprops.eventbus.$emit('onRowCommand', {
        command: 'updateField',
        row: vm.row,
        fieldName: vm.field,
        fieldValue: newValue
      })
    }
  }
}
</script>

<style>
    .mx-datepicker {
        width: auto;
    }
</style>
