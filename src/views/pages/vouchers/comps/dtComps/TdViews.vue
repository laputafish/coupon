<template>
  <div class="td-views line-height-1">
    <span v-if="value===0">0</span>
    <div v-else class="badge badge-warning">
      {{ value }}
     <div class="ml-2 d-inline inline-button"
          data-toggle="tooltip"
          title="Reset"
          @click="resetView">
        <font-awesome-icon size="sm" icon="redo"></font-awesome-icon>
     </div>
    </div>
  </div>
</template>

<script>
  export default {
    props: ['value', 'row', 'xprops'],
    methods: {
      resetViewCount (count) {
        const vm = this
        vm.xprops.eventbus.$emit('onRowCommand', {
          command: 'resetViewCount',
          row: vm.row
        })
      },
      resetView () {
        const vm = this
        vm.$dialog.confirm(vm.$t('messages.reset_view_count')).then(
          () => {
            vm.resetViewCount(0)
          }
        )
      }
    }
  }
</script>

<style>
  .inline-button {
    cursor: pointer;
  }
</style>
