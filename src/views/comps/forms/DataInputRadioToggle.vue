<template>
  <div :class="'col-sm-' + width">
    <div class="form-group">
      <label :for="id">{{ inputLabel }}</label>
      <data-radio-toggle
        :options="options"

      <input class="form-control"
             :id="id"
             :name="id"
             :type="type"
             :value="value"
             @input="$event=>$emit('input',$event.target.value)"/>
    </div>
  </div>
</template>

<script>
  export default {
    model: {
      prop: 'value',
      event: 'input'
    },
    props: {
      type: {
        type: String,
        default: 'text'
      },
      id: {
        type: String,
        default: ''
      },
      label: {
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
      },
      options: {
        type: Array,
        default () {
          return []
        }
      }
    },
    computed: {
      inputLabel () {
        const vm = this
        var result = vm.label
        if (vm.labelTag !== '') {
          result = vm.$t(vm.labelTag)
        }
        return result
      }
    }
  }
</script>