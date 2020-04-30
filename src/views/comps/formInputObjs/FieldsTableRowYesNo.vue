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
                @click="updateField('1')"
                :class="{'btn-primary':value==='1','btn-light':value!=='1'}">Yes</button>
        <button type="button"
                class="btn"
                @click="updateField('0')"
                :class="{'btn-primary':value!=='1','btn-light':value==='1'}">No</button>
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
      type: String,
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