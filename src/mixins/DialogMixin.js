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
    //
    // showErrors (title, errors, callback) {
    //   const vm = this
    //   let messages = ''
    //   messages += '<ul>'
    //   // console.log('dialogMixin :: showErrors: errors: ', errors)
    //   for (let fieldName in errors) {
    //     let errorMessages = errors[fieldName]
    //     messages += '<li>'
    //     messages += fieldName
    //     messages += '<ul class="message-list">'
    //     if (typeof errorMessages === 'object') {
    //       for (let j = 0; j < errorMessages.length; j++) {
    //         messages += '<li>' + vm.$t('messages.' + errorMessages[j]) + '</li>'
    //       }
    //     } else {
    //       messages += '<li>' + errorMessages + '</li>'
    //     }
    //     messages += '</ul>'
    //     messages += '</li>'
    //   }
    //   messages += '</ul>'
    //   vm.alertHtml(messages, callback, title, 'error-scroll-box')
    // },
    //
    // showConfirm (messageTag, buttons, callback) {
    //   const vm = this
    //   let message = vm.$t(messageTag)
    //
    //   vm.$dialog.alert({
    //     title: 'Confirmation',
    //     body: '<p>' + message + '</p>'
    //   }, {
    //   })
    // },
    //
    // alertHtml (message, callback, title, customClass) {
    //   const vm = this
    //
    //   if (typeof title === 'undefined') {
    //     title = vm.$t('general.warning')
    //   }
    //
    //   if (typeof customClass === 'undefined') {
    //     customClass = ''
    //   }
    //
    //   vm.$dialog.alert({
    //     title: title,
    //     body: '<p>' + message + '</p>'
    //   }, {
    //     customClass: customClass,
    //     html: true,
    //     okText: vm.$t('buttons.ok')
    //   }).then(function (dialog) {
    //     if (typeof callback === 'function') {
    //       callback()
    //     }
    //   })
    // },
    // alert (message, callback) {
    //   const vm = this
    //   vm.$dialog.alert({
    //     title: vm.$t('general.warning'),
    //     body: message
    //   }, {
    //     okText: vm.$t('buttons.ok')
    //   }).then(function (dialog) {
    //     if (typeof callback === 'function') {
    //       callback()
    //     }
    //   })
    // }
  }
}

export default dialogMixin
