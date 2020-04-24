<template>
  <div class="btn-group">
    <button type="button"
            class="btn"
            v-for="option in options"
            :key="option.name"
            @click="selectOption(option.value)"
            :class="{'btn-success': option.value === value, 'btn-light': option.value !== value}">
      {{ option.name }}
    </button>
  </div>
</template>

<script>
export default {
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
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  methods: {
    selectOption (value) {
      const vm = this
      vm.$emit('input', value)
    }
  }
}
</script>