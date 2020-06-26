<template>
  <div class="btn-group data-radio-toggle"
    :class="{'disabled':!enabled}">
    <button type="button"
            class="btn"
            :disabled="!enabled"
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
    },
    enabled: {
      type: Boolean,
      default: true
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
      if (vm.enabled) {
        // console.log('DataRadioToggle :: selectOption :: value: ', value)
        vm.$emit('input', value)
      }
    }
  }
}
</script>

<style>
  .data-radio-toggle .btn-success {

  }
  .data-radio-toggle.disabled .btn-success {
    background-color: rgba(200,200,200,.5);
    border: transparent;
  }
</style>