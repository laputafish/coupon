<template>
<div :class="'col-sm-'+width">
  <div class="form-group">
    <label :for="id">{{ $t(labelTag) }}</label>
    <select class="form-control"
            :id="id"
            :name="id"
            :value="value"
            @input="$event=>$emit('input',parseInt($event.target.value))">
      <option v-for="item in options"
              :key="item[optionValueField]"
              :value="item[optionValueField]">{{ item[optionLabelField] }}
      </option>
    </select>
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
        type: Number,
        default: 0
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
      },
      optionLabelField: {
        type: String,
        default: 'label'
      },
      optionValueField: {
        type: String,
        default: 'id'
      }
    }
  }
</script>