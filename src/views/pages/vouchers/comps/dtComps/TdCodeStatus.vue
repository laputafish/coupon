<template>
  <div class="td-code-status line-height-1">
    <div class="badge min-width-80"
         :class="'badge-' + activeStatus.variant">{{ activeStatus.label }}

      <div v-if="value==='hold'"
           class="ml-1 d-inline change-status"
           data-toggle="tooltip"
           title="Release"
           @click="changeStatus('pending')">
        <font-awesome-icon size="sm" icon="circle"></font-awesome-icon>
      </div>

      <div v-else-if="value==='pending'"
           class="ml-1 d-inline change-status"
           data-toggle="tooltip"
           title="Hold"
           @click="changeStatus('hold')">
        <font-awesome-icon size="sm" icon="check-circle"></font-awesome-icon>
      </div>

      <div v-if="value==='completed' || value==='fails'"
           class="ml-1 d-inline change-status"
           data-toggle="tooltip"
           title="Reset"
            @click="resetStatus">
        <font-awesome-icon size="sm" icon="redo"></font-awesome-icon>
      </div>
    </div>
    <!--<button v-if="value==='completed'" class="btn btn-xs btn-danger line-height-1 rounded px-2">-->
      <!---->
    <!--</button>-->
    <br/>
    <div v-if="value==='fails'"
         class="badge badge-muted bg-gray-light" >{{ row['error_message'] }}</div>
    <div v-if="value==='completed'"
         class="badge badge-muted bg-gray-light">{{ row['sent_on'] }}</div>

    <!--<select class="form-control" :value="value"-->
      <!--@input="$event=>updateStatus($event.target.value)">-->
      <!--<option v-for="(option, index) in options"-->
              <!--:value="option.value"-->
        <!--:key="index">{{ option.label }}</option>-->
    <!--</select>-->
  </div>
</template>

<script>
  export default {
    data () {
      return {
        statusOptions: [
          {value: 'pending', label: 'Pending', variant: 'info'},
          {value: 'processing', label: 'Processing', variant: 'warning'},
          {value: 'ready', label: 'Ready to Send', variant: 'primary'},
          {value: 'completed', label: 'Completed', variant: 'success'},
          {value: 'fails', label: 'Fails', variant: 'danger'},
          {value: 'hold', label: 'On Hold', variant: 'muted'}
        ]
      }
    },
    props: ['value', 'row', 'xprops'],
    // methods: {
    //   updateStatus (status) {
    //     console.log('TdCodeStatus :: updateStatus: status = ' + status)
    //     const vm = this
    //     vm.xprops.eventbus.$emit('onRowCommand', {
    //       command: 'updateField',
    //       row: vm.row,
    //       fieldName: 'status',
    //       fieldValue: status
    //     })
    //   }
    // },
    methods: {
      changeStatus (status) {
        const vm = this
        console.log('TdCodeStatus :: changeStatus :: stauts: ', status)
        vm.xprops.eventbus.$emit('onRowCommand', {
          command: 'changeCodeStatus',
          row: vm.row,
          status: status
        })
      },
      // release () {
      //   const vm = this
      //   vm.xprops.eventbus.$emit('onRowCommand', {
      //     command: 'resetStatus',
      //     row: vm.row,
      //     status: 'pending'
      //   })
      // },
      //
      // hold () {
      //   const vm = this
      //   vm.xprops.eventbus.$emit('onRowCommand', {
      //     command: 'resetStatus',
      //     row: vm.row,
      //     status: 'hold'
      //   })
      // },
      resetStatus () {
        const vm = this
        vm.$dialog.confirm(vm.$t('messages.reset_status')).then(
          () => {
            vm.changeStatus('pending')
            // vm.xprops.eventbus.$emit('onRowCommand', {
            //   command: 'resetStatus',
            //   row: vm.row,
            //   status: 'pending'
            // })
          }
        )
      }
    },
    computed: {
      activeStatus () {
        const vm = this
        var result = ''
        for (let i = 0; i < vm.statusOptions.length; i++) {
          const statusOption = vm.statusOptions[i]
          if (statusOption.value === vm.value) {
            result = statusOption
            break
          }
        }
        return result
      },
      status () {
        const vm = this
        let label = vm.$t('status.' + vm.value)
        if (vm.options) {
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

  .td-code-status .change-status:hover {
    /*font-size: 14px;*/
  }
  .td-code-status .change-status {
    cursor: pointer;
  }
</style>
