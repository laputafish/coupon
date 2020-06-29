import AppMixin from "./AppMixin";

const DtTableMixin = {
  methods: {
    addXpropsStatus (commandStatus) {
      const vm = this
      if (vm.xprops.statuses.indexOf(commandStatus) === -1) {
        vm.xprops.statuses.push(commandStatus)
      }
    },

    removeXpropsStatus (commandStatus) {
      const vm = this
      const index = vm.xprops.statuses.indexOf(commandStatus)
      if (index >= 0) {
        vm.xprops.statuses.splice(index, 1)
      }
    }

  }
}

export default DtTableMixin
