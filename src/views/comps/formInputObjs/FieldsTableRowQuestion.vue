<template>
  <fields-table-row
      label="Question"
      :value="value"
      fieldName="question"
      @onCommand="onCommandHandler"></fields-table-row>
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