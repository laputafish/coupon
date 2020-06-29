<template>
  <button :disabled="disabled"
          class="btn"
          :class="button.btnClass"
          @click="processCommand">
    <!--command: {{ button.command }}-->
    <!--[row.buttons: {{ row.buttons}}]-->
      <font-awesome-icon v-if="processing"
                         icon="spinner"
                         class="fa-fw fa-spin"></font-awesome-icon>
      <font-awesome-icon v-else
                         class="fa-fw"
                         :icon="button.iconClass"></font-awesome-icon>
  </button>
</template>

<script>
import helpers from '@/helpers'

export default {
  props: {
    statuses: {
      type: Array,
      default () {
        return []
      }
    },
    button: {
      type: Object,
      default: null
    },
    xprops: {
      type: Object,
      default: null
    },

    row: {
      type: Object,
      default () {
        return null
      }
    }
  },

  computed: {
    disabled () {
      const vm = this
      return vm.row.buttons && vm.row.buttons.indexOf(vm.button.command)===-1
    },
    processing () {
      const vm = this
      const command = vm.button.command
      const mapping = {
        print: 'printing'
      }
      let result = false
      if (vm.statuses) {
        var mappedCommand = command
        if (mapping[command]) {
          mappedCommand = mapping[command]
        }
        const commandStr = mappedCommand + ':' + vm.row['id']
        if (vm.statuses && commandStr) {
          result = vm.statuses.indexOf(commandStr) >= 0
        }
      }
      return result
    }
  },
  methods: {
    processCommand () {
      const vm = this
      const command = vm.button.command
      var needConfirm = false
      // console.log('tdCommonOpt :: processCommand')
      if (typeof vm.button.needConfirm === 'undefined') {
        needConfirm = false
      } else {
        needConfirm = vm.button.needConfirm
      }

      if (needConfirm) {
        helpers.showConfirmDialog(vm, () => {
          vm.doProcessCommand(command)
        })
      } else {
        vm.doProcessCommand(command)
      }
    },

    doProcessCommand (command) {
      const vm = this
      vm.xprops.eventbus.$emit('onRowCommand', {
        command: command,
        row: vm.row
      })
    }
  }
}
</script>