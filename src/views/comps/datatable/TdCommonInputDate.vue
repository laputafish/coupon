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
    width: auto !important;
  }

  .mx-datepicker .mx-input-wrapper input.mx-input {
    height: 34px;
  }

  .mx-datepicker .mx-input-wrapper input.mx-input:focus {
    color: #495057;
    background-color: #ffffff;
    border-color: #80bdff;
    outline: 0;
    /*box-shadow: inset 0 0 0 rgba(0, 0, 0, 0), none;*/
    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
  }
</style>
