<template>
  <div class="btn-group btn-group-sm btn-group-gap">
    <button v-for="(btn,index) in buttons"
            :key="index"
            class="btn"
            :class="btn.btnClass"
            @click="processCommand(btn.command, btn.needConfirm)">
      <i v-if="processing(btn.command)" class="fa fa-fw fa-spinner fa-spin"></i>
      <i v-else class="fa fa-fw" :class="btn.iconClass"></i>
    </button>
  </div>
</template>

<script>
import helpers from '@/helpers'

export default {
  data () {
    return {
      buttons: []
    }
  },
  props: ['row', 'nested', 'xprops'],
  mounted () {
    const vm = this
    // console.log('mounted starts')
    if (vm.xprops['buttons']) {
      vm.buttons = []
      for (var i = 0; i < vm.xprops.buttons.length; i++) {
        // console.log('i= ' + i)
        let key = vm.xprops.buttons[i]
        switch (key) {
          case 'update':
            vm.buttons.push({
              iconClass: 'fa-save',
              btnClass: 'btn-success',
              command: 'update'
            })
            break
          case 'edit':
            vm.buttons.push({
              iconClass: 'fa-edit',
              btnClass: 'btn-primary',
              command: 'edit'
            })
            break
          case 'duplicate':
            vm.buttons.push({
              iconClass: 'fa-copy',
              btnClass: 'btn-info',
              command: 'duplicate'
            })
            break
          case 'delete':
            vm.buttons.push({
              iconClass: 'fa-close',
              btnClass: 'btn-danger',
              command: 'delete'
            })
            break
          case 'print':
            vm.buttons.push({
              iconClass: 'fa-print',
              btnClass: 'btn-info',
              command: 'print'
            })
            break
          case 'download':
            vm.buttons.push({
              iconClass: 'fa-download',
              btnClass: 'btn-info',
              command: 'download'
            })
        }
      }
    }
    // console.log('mounted ends')
  },
  methods: {
    processing (command) {
      let vm = this
      let mapping = {
        print: 'printing'
      }
      let result = false
      if (vm.xprops['statuses']) {
        if (mapping[command]) {
          let commandStr = mapping[command] + ':' + vm.row['id']
          if (vm.xprops['statuses'] && commandStr) {
            result = vm.xprops.statuses.indexOf(commandStr) >= 0
          }
        }
      }
      return result
    },
    processCommand (command, needConfirm) {
      let vm = this
      // console.log('tdCommonOpt :: processCommand')
      if (typeof needConfirm === 'undefined') {
        needConfirm = false
      }
      if (needConfirm) {
        // alert('tdCommonOpt :: processCommand => call showConfirmDialog')
        helpers.showConfirmDialog(vm, () => {
          // alert('tdCommonOpt :: processCommand :: helpers.showConfirmDialog :: callback')
          // console.log('tdCommonOpt :: processCommand showConfirmDialog.callback')
          vm.doProcessCommand(command)
        })
        // alert('tdCommonOpt :: processCommand => after call showConfirmDialog')
      } else {
        // alert('tdCommonOpt :: processCommand (no need confirm)')
        vm.doProcessCommand(command)
      }
      // alert('tdCommonOPt :: processCommand ends')
    },

    doProcessCommand (command) {
      let vm = this
      vm.xprops.eventbus.$emit('onRowCommand', {
        command: command,
        row: vm.row
      })
    }
  }
}
</script>

<style>
  .-nested-comp-open-btn {
    color: #fff !important;
    background-color: #337ab7 !important;
  }
</style>
