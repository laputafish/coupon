<template>
<div class="data-input-date" :class="'col-sm-' + width">
    <div class="form-group">
      <label :for="id">{{ $t(labelTag) }}</label>
      <date-picker :value="value"
                   class="w-100"
                   valueType="format"
        @input="newValue=>$emit('input',newValue)"></date-picker>
    </div>
</div>
</template>

<script>
import datePicker from 'vue2-datepicker'

export default {
  components: {
    datePicker
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  props: {
    id: {
      type: String,
      default: ''
    },
    labelTag: {
      type: String,
      default: ''
    },
    value: {
      type: String,
      default: ''
    },
    width: {
      type: String,
      default: ''
    }
  },
  methods: {
    onInput (obj) {
      console.log('onInput :: obj: ', obj)
    }
  }
}
</script>

<style>
  .data-input-date .mx-datepicker {
    width: 100% !important;
  }
</style>