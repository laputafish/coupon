<template>
  <fields-table-row
      label="Caption"
      notes="* used as header of export file"
      :value="value"
      fieldName="name" @onCommand="onCommandHandler"></fields-table-row>
</template>

<script>
import fieldsTableRow from './FieldsTableRow'

export default {
  components: {
    fieldsTableRow
  },
  props: {
    value: {
      type: String,
      default: ''
    }
  },
  methods: {
    onCommandHandler(payload) {
      this.$emit('onCommand', payload)
    }
  }
}
</script>