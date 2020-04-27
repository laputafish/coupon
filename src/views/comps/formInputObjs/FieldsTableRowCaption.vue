<template>
  <fields-table-row :value="value" fieldName="name" @onCommand="onCommandHandler">
    <div slot="labelSlot">Caption<br/><small class="text-muted">* for self reference</small></div>
  </fields-table-row>
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