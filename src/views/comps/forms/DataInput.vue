<template>
<div :class="'col-sm-' + width">
  <div class="form-group">
    <label :for="id">{{ $t(labelTag) }}</label>
    <input class="form-control"
           :id="id"
           :name="id"
           type="text"
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
    }
  }
</script>