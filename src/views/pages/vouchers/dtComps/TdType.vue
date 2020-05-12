<template>
  <div class="text-center line-height-1">
    <div v-if="value==='voucher'"
      class="badge badge-primary">Voucher
    </div>
    <div v-else>
      <div class="badge badge-success">Form <i class="fas fa-caret-right"></i> Voucher</div>
      <div><small>{{ countDetails }}</small></div>
    </div>
  </div>
</template>


<script>
export default {
  props: ['row','value','field','xprops'],
  computed: {
    countDetails () {
      const vm = this
      var result = vm.row['participant_count']
      if (vm.value === 'form') {
        switch (vm.row['goal_type']) {
          case 'codes':
            result = result + ' / ' + vm.row['code_count']
            break
          case 'fixed':
            result = result + ' / ' + vm.row['goal_count']
            break
        }
      }
      return result
    }
  }
}
</script>
