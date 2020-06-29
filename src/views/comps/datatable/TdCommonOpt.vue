<template>
  <div class="text-nowrap action-btn-group btn-group-gap"
    :class="customClass">
    <template v-for="(btn,index) in buttons">
      <action-button
          :statuses="xprops['statuses']"
          :key="index"
          :button="btn"
          :row="row"
          :xprops="xprops"></action-button>
    </template>
    <!--<button v-for="(btn,index) in buttons"-->
            <!--:key="index"-->
            <!--:disabled="row.buttons && row.buttons.indexOf(btn.command)===-1"-->
            <!--class="btn"-->
            <!--:class="btn.btnClass"-->
            <!--@click="processCommand(btn.command, btn.needConfirm)">-->
      <!--<font-awesome-icon v-if="processing(btn.command)"-->
                         <!--icon="spinner"-->
                         <!--class="fa-fw fa-spin"></font-awesome-icon>-->
      <!--<font-awesome-icon v-else-->
                         <!--class="fa-fw"-->
                         <!--:icon="btn.iconClass"></font-awesome-icon>-->
    <!--</button>-->
  </div>
</template>

<script>
import helpers from '@/helpers'
import actionButton from '@/views/comps/ActionButton'

export default {
  components: {
    actionButton
  },
  data () {
    return {
      buttons: []
    }
  },
  computed: {
    customClass () {
      const vm = this
      let result = 'btn-group-sm'
      if (vm.xprops.actionButtonSize) {
        result = 'btn-group-' + vm.xprops.actionButtonSize
      }
      return result
    }
  },
  props: ['row', 'nested', 'xprops'],
  mounted () {
    const vm = this
    // console.log('mounted starts')
    if (vm.xprops['buttons']) {
      vm.buttons = []
      for (let i = 0; i < vm.xprops.buttons.length; i++) {
        // console.log('i= ' + i)
        const key = vm.xprops.buttons[i]
        switch (key) {
          case 'view':
            vm.buttons.push({
              iconClass: 'file-alt',
              btnClass: 'btn-info',
              command: 'view'
            })
            break
          case 'update':
            vm.buttons.push({
              iconClass: 'save',
              btnClass: 'btn-success',
              command: 'update'
            })
            break
          case 'edit':
            vm.buttons.push({
              iconClass: 'edit',
              btnClass: 'btn-primary',
              command: 'edit'
            })
            break
          case 'duplicate':
            vm.buttons.push({
              iconClass: 'copy',
              btnClass: 'btn-info',
              command: 'duplicate'
            })
            break
          case 'delete':
            vm.buttons.push({
              iconClass: 'times',
              btnClass: 'btn-danger',
              command: 'delete'
            })
            break
          case 'print':
            vm.buttons.push({
              iconClass: 'print',
              btnClass: 'btn-info',
              command: 'print'
            })
            break
          case 'download':
            vm.buttons.push({
              iconClass: 'download',
              btnClass: 'btn-info',
              command: 'download'
            })
          case 'email':
            vm.buttons.push({
              iconClass: 'envelope',
              btnClass: 'btn-warning',
              command: 'email'
            })
        }
      }
    }
    // console.log('mounted ends')
  },
  methods: {
    // processing (command) {
    //   const vm = this
    //   const mapping = {
    //     print: 'printing'
    //   }
    //   let result = false
    //   if (vm.xprops['statuses']) {
    //     var mappedCommand = command
    //     if (mapping[command]) {
    //       mappedCommand = mapping[command]
    //     }
    //     const commandStr = mappedCommand + ':' + vm.row['id']
    //     if (vm.xprops['statuses'] && commandStr) {
    //       result = vm.xprops.statuses.indexOf(commandStr) >= 0
    //     }
    //   }
    //   return result
    // },
    // processCommand (command, needConfirm) {
    //   const vm = this
    //   // console.log('tdCommonOpt :: processCommand')
    //   if (typeof needConfirm === 'undefined') {
    //     needConfirm = false
    //   }
    //   if (needConfirm) {
    //     // alert('tdCommonOpt :: processCommand => call showConfirmDialog')
    //     helpers.showConfirmDialog(vm, () => {
    //       // alert('tdCommonOpt :: processCommand :: helpers.showConfirmDialog :: callback')
    //       // console.log('tdCommonOpt :: processCommand showConfirmDialog.callback')
    //       vm.doProcessCommand(command)
    //     })
    //     // alert('tdCommonOpt :: processCommand => after call showConfirmDialog')
    //   } else {
    //     // alert('tdCommonOpt :: processCommand (no need confirm)')
    //     vm.doProcessCommand(command)
    //   }
    //   // alert('tdCommonOPt :: processCommand ends')
    // },
    //
    // doProcessCommand (command) {
    //   const vm = this
    //   // console.log('TdCommonOpt :: doProcessCommand :: command: ', command)
    //   vm.xprops.eventbus.$emit('onRowCommand', {
    //     command: command,
    //     row: vm.row
    //   })
    // }
  }
}
</script>

<style>
  .-nested-comp-open-btn {
    color: #fff !important;
    background-color: #337ab7 !important;
  }
  .action-btn-group .btn {
    margin-right: 1px;
  }

  .btn-group-xs > .btn {
    padding: 0.1rem 0.3rem;
  }
</style>
