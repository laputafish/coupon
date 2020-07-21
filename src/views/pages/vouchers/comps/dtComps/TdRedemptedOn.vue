<template>
  <div class="text-center">{{ value }}
    <button v-if="value && value!==''" type="button" style="padding:0.1rem 0.3rem;"
      class="btn btn-danger"
      @click="resetStatus">
      <font-awesome-icon class="fa-fw" icon="times"></font-awesome-icon>
    </button>
    <span class="text-muted" v-else>Available</span>
  </div>
</template>

<script>
export default {
  props: ['value','field','row','xprops'],
  computed: {
    item () {
      const vm = this
      // console.log('TdSingleChoice :: computed :: value: ', vm.value)
      // console.log('TdSingleChoice :: computed :: field: ', vm.field)
      // console.log('TdSingleChoice :: computed :: row: ', vm.row)
      // console.log('TdSingleChoice :: computed :: xprops: ', vm.xprops)

      const options = vm.xprops['optionalChoices'][vm.field]
      var itemIndex = parseInt(vm.value)
      return options[itemIndex]
    }
  },
  methods: {
    resetStatus () {
      const vm = this
      vm.xprops.eventbus.$emit('onRowCommand', {
        command: 'resetRedemptionStatus',
        row: vm.row
      })
    }
  }
}
</script>