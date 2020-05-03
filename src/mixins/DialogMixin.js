const dialogMixin = {
  methods: {
    confirmDelete (callback) {
      const vm = this
      vm.confirm(vm.$t('messages.areYouSure'), callback)
    },
    confirm (message, callback, cancelCallback) {
      const vm = this
      if (typeof message === 'function') {
        callback = message
        message = vm.$t('messages.areYouSure') + '?'
      }
      vm.$dialog.confirm({
        title: vm.$t('general.confirmation'),
        body: message
      }, {
        okText: vm.$t('buttons.ok'),
        cancelText: vm.$t('buttons.cancel')
      }).then(function (dialog) {
        if (typeof callback === 'function') {
          callback()
        }
      }).catch(function () {
        if (typeof cancelCallback === 'function') {
          cancelCallback()
        }
      })
    }
  }
}

export default dialogMixin
