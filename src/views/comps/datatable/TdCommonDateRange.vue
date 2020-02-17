<template>
  <div>
    <div class="badge badge-success">
      {{ date1 | trim }}
    </div>
    <template v-if="date2!==''">
      <i class="fa fa-long-arrow-right"></i>
      <div class="badge badge-success">
        {{ date2 | trim }}
      </div>
    </template>
  </div>
</template>

<script>
export default {
  props: ['value', 'row', 'xprops'],
  filters: {
    trim (value) {
      return value ? value.substr(0, 10) : '(invalid date)'
    }
  },
  computed: {
    // trimDate () {
    //   let vm = this
    //   return vm.value ? vm.value.substr(0, 10) : '(invalid date)'
    // },
    date1 () {
      const vm = this
      let result = ''
      // console.log('TdCommonDateRange :: date1')
      // console.log('TdCommonDateRange :: xprops: ', vm.xprops)
      if (vm.xprops['columnFields'] &&
        vm.xprops['columnFields']['dateRange'] &&
        vm.xprops['columnFields']['dateRange']['date1']) {
        if (vm.row[vm.xprops['columnFields']['dateRange']['date1']]) {
          let m = vm.$moment(vm.row[vm.xprops['columnFields']['dateRange']['date1']])
          result = m.format('YYYY-MM-DD')
        }
      }
      return result
    },
    date2 () {
      const vm = this
      let result = ''
      if (vm.xprops['columnFields'] &&
        vm.xprops['columnFields']['dateRange'] &&
        vm.xprops['columnFields']['dateRange']['date2']) {
        if (vm.row[vm.xprops['columnFields']['dateRange']['date2']]) {
          let m = vm.$moment(vm.row[vm.xprops['columnFields']['dateRange']['date2']])
          result = m.format('YYYY-MM-DD')
        }
      }
      return result
    }
  }
}
</script>
