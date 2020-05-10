<template>
  <div class="btn-group">
    <button type="button"
            class="btn"
            v-for="option in options"
            :key="option.name"
            @click="selectOption(option.value)"
            :class="getButtonClasses(option)">
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
    btnClass: {
      type: String,
      default: ''
    },
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
  methods: {
    getButtonClasses (option) {
      const vm = this
      var result = []
      if  (vm.btnClass !== '') {
        result.push(vm.btnClass)
      }
      if (option.value === vm.value) {
        result.push('btn-success')
      } else {
        result.push('btn-light')
      }
      return result.join(' ')
    },
    selectOption (value) {
      const vm = this
      console.log('DataRadioToggle :: selectOption :: value: ', value)
      vm.$emit('input', value)
    }
  }
}
</script>