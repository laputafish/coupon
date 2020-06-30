<template>
  <div class="text-center line-height-1">
    <div v-if="value==='voucher'" class="d-flex flex-row">
      <div class="badge badge-primary">Voucher</div>
      <div v-if="row['has_one_code']" class="ml-1" data-toggle="tooltip"
        title="Single Code">
        <div class="badge badge-warning">
          <font-awesome-icon icon="ticket-alt" class=""></font-awesome-icon>
        </div>
      </div>
      <div v-else class="ml-1" data-toggle="tooltip"
        title="Multiple Codes">
        <div class="badge badge-success">
          <font-awesome-icon icon="ticket-alt" class="mr-1"></font-awesome-icon>
          <font-awesome-icon icon="ticket-alt" class="mr-1"></font-awesome-icon>...
        </div>
      </div>
    </div>
    <div v-else>
      <div class="badge badge-success">Form <i class="fas fa-caret-right"></i> Voucher</div>
      <div data-toggle="tooltips" title="Current / Goals"><small>{{ countDetails }}</small></div>
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
