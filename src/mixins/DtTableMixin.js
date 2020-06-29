import AppMixin from "./AppMixin";

const DtTableMixin = {
  methods: {
    addXpropsStatus (commandStatus) {
      const vm = this
      if (vm.xprops.statuses.indexOf(commandStatus) === -1) {
        vm.xprops.statuses.push(commandStatus)
      }
    }
  }
}

export default DtTableMixin
