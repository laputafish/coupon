<template>
  <tr>
    <td class="align-middle line-height-1 label-cell">
      <div>{{ label }}</div>
      <small class="field-notes" v-if="notes !== ''">{{ notes }}</small>
    </td>
    <td class="value-cell">
      <div class="btn-group">
        <button type="button"
                class="btn"
                @click="updateField(true)"
                :class="{'btn-primary':value,'btn-light':!value}">Yes</button>
        <button type="button"
                class="btn"
                @click="updateField(false)"
                :class="{'btn-primary':!value,'btn-light':value}">No</button>
      </div>
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
      type: Boolean,
      value: true
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
    updateField (fieldValue) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateField',
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