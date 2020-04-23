<template>
  <div class="btn-group">
    <button type="button"
            class="btn"
            v-for="option in options"
            :key="option.name"
            @click="$emit('input', option.value)"
            :class="{'btn-success': option.value === value, 'btn-light': option.value !== value}">
      {{ option.name }}
    </button>
  </div>
</template>

<script>
export default {
  model: {
    prop: 'value',
    event: 'input'
  },
  props: {
    value: {
      type: [String, Number],
      default: ''
    },
    options: {
      type: Array,
      default () {
        return []
      }
    }
  }
}
</script>