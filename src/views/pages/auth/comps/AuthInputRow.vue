<template>
<div class="form-group row">
  <label :for="id" class="col-md-4 col-form-label text-md-right">
    {{ $t(labelTag) }}</label>
  <div class="col-md-6">
    <validation-provider v-slot="{errors}" :rules="rules">
    <input type="text"
           :id="id"
           :name="id"
           class="form-control"
           :value="value"
           @input="$event=>$emit('input',$event.target.value)">
      <span class="input-error">{{ errors[0] }}</span>
    </validation-provider>
  </div>
</div>
</template>

<script>
export default {
  name: 'AuthInputRow',
  model: {
    prop: 'value',
    event: 'input'
  },
  props: {
    id: {
      type: String,
      default: ''
    },
    rules: {
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
    extraAttr: {
      type: String,
      default: ''
    }
  }
}
</script>

<style>
.input-error {
  position: absolute;
  padding: 0;
  top: 100%;
  margin: 0;
  line-height: 1;
  margin-top: -0.375rem;
}
</style>