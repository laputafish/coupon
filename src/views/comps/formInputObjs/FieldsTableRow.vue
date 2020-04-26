<template>
  <tr>
    <td class="align-middle line-height-1">
      <div v-if="label">{{ label }}</div>
      <slot name="label"></slot>
    </td>
    <td>
      <input :type="type"
             :value="value"
             class="form-control"
             @input="$event=>updateField(fieldName, $event.target.value)"/>
    </td>
  </tr>
</template>

<script>
export default {
  model: {
    prop: 'value',
    event: 'input'
  },
  prop: {
    label: {
      type: String,
      value: ''
    },
    value: {
      type: {String,Number},
      value: ''
    },
    type: {
      type: String,
      value: 'text'
    },
    fieldName: {
      type: String,
      value: ''
    }
  },
  methods: {
    updateField (fieldName, fieldValue) {
      this.$emit('onCommand', {
        command: 'updateField',
        fieldName: fieldName,
        fieldValue: fieldValue
      })
    }
  }
}
</script>