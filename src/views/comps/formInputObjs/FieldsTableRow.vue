<template>
  <tr>
    <td class="align-middle line-height-1">
      <div>{{ label }}</div>
      <small class="field-notes" v-if="notes !== ''">{{ notes }}</small>
    </td>
    <td>
      <input :type="type"
             :value="value"
             class="form-control"
             @input="$event=>{updateField($event.target.value)}"/>
    </td>
  </tr>
</template>

<script>
export default {
  model: {
    prop: 'value',
    event: 'input'
  },
  props: {
    label: {
      type: String,
      value: ''
    },
    notes: {
      type: String,
      value: ''
    },
    value: {
      type: String,
      value: ''
    },
    type: {
      type: String,
      value: 'text'
    },
    fieldName: {
      type: String,
      value: ''
    },
    scope: {
      type: String,
      value: ''
    }
  },
  methods: {
    updateField (fieldValue) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateField',
        scope: vm.scope,
        fieldName: vm.fieldName,
        fieldValue: fieldValue
      })
    }
  }
}
</script>

<style>
  .field-notes {
    color: rgb(160,160,160);
  }
</style>