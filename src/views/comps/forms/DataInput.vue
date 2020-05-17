<template>
<div :class="'col-sm-' + width">
  <div class="form-group">
    <label :for="id">{{ inputLabel }}</label>
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
        type: [String, Number],
        default: ''
      },
      width: {
        type: String,
        default: ''
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