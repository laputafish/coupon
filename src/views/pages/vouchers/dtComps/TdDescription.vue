<template>
  <div class="td-common-link" @click="onClick">
    <div v-if="row.notes" class="d-flex flex-column" style="line-height:1.1;">
      <div class="d-flex flex-row justify-content-start align-items-start">
        <span>{{ value }}</span>
        <div class="badge badge-info ml-2">{{ row['id'] }}</div>
      </div>
      <small class="voucher-notes">{{ row.notes }}</small>
    </div>
    <div v-else>
      {{ value }}
    </div>
  </div>
</template>

<script>
  export default {
    props: ['value', 'row', 'xprops', 'field'],
    methods: {
      onClick ( ) {
        const vm = this
        vm.xprops.eventbus.$emit('onRowCommand', {
          command: 'onClick',
          row: vm.row,
          fieldName: vm.field,
          fieldValue: vm.value
        })
      }
    }
  }
</script>

<style>
  .td-common-link:hover {
    cursor: pointer;
  }
  .voucher-notes {
    color: rgba(0,0,127,.6);
  }
  .td-common-link:hover .voucher-notes {
    color: rgba(0,0,127,.8);
  }
</style>
