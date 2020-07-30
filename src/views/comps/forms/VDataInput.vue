<template>
<div :class="'col-sm-' + width">
  <validation-provider ref="provider" :rules="rules" v-slot="{errors,invalid}">
    <div class="form-group">
      <label :for="id">{{ inputLabel }}</label>
      <input class="form-control"
             :class="{'border-danger':errors.length>0}"
             :id="id"
             :name="id"
             autocomplete="false"
             :type="type"
             :value="value"
             @input="$event=>$emit('input',$event.target.value)"/>
    </div>
  </validation-provider>
</div>
</template>

<script>
  export default {
    model: {
      prop: 'value',
      event: 'input'
    },
    props: {
      rules: {
        type: String,
        default: ''
      },
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