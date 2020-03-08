<template>
  <div class="td-code-status input-group">
    <select class="form-control" :value="value"
      @input="$event=>updateStatus($event.target.value)">
      <option v-for="(option, index) in options"
              :value="option.value"
        :key="index">{{ option.label }}</option>
    </select>
  </div>
</template>

<script>
  export default {
    data () {
      return {
        options: [
          {value: 'pending', label: 'Pending'},
          {value: 'ready', label: 'Ready'},
          {value: 'completed', label: 'Completed'}
        ]
      }
    },
    props: ['value', 'row', 'xprops'],
    methods: {
      updateStatus (status) {
        console.log('TdCodeStatus :: updateStatus: status = ' + status)
        const vm = this
        vm.xprops.eventbus.$emit('onRowCommand', {
          command: 'updateField',
          row: vm.row,
          fieldName: 'status',
          fieldValue: status
        })
      }
    },
    computed: {
      status () {
        const vm = this
        let label = vm.$t('status.' + vm.value)
        if (vm.xprops.statusOptions) {
          for (let i = 0; i < vm.xprops.statusOptions.length; i++) {
            const  option = vm.xprops.statusOptions[i]
            if (option.value === vm.value) {
              label = vm.$t(option.labelTag)
              break
            }
          }
        }
        return label
      }
    }
  }
</script>

<style>
  .td-code-status select.form-control {

  }
</style>
