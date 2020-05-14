<template>
<div class="flex-grow-1 d-flex flex-column px-3" style="max-width:200px;">
  <h4 class="p-0 m-0">
    <i class="fas fa-file-alt"></i>
  </h4>
  <select class="select-custom-form rounded-2 border-blue"
    :value="value"
          :disabled="!selected"
          :class="{'disabled':!selected}"
    @input="$event=>updateSelectedCustomForm($event.target.value)">
    <option v-for="customForm in customForms"
      :key="customForm.form_key"
      :value="customForm.form_key">
      {{ customForm.name }}
    </option>
  </select>
</div>
</template>

<script>
export default {
  data () {
    return {
      value: ''
    }
  },
  methods: {
    updateSelectedCustomForm (formKey) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'selectCustomForm',
        formKey: formKey
      })
    }
  },
  props: {
    selected: {
      type: Boolean,
      default: false
    },
    customForms: {
      type: Array,
      default () {
        return []
      }
    },
    selectedCustomFormKey: {
      type: String,
      default: ''
    }
  },
  watch: {
    selectedCustomFormKey (newValue) {
      const vm = this
      vm.value = newValue
    }
  },
  mounted () {
    const vm = this
    vm.value = vm.selectedCustomFormKey
  }
}
</script>

<style>
  .select-custom-form.disabled {
    background-color: transparent;
    border-color: lightgray;
  }
</style>