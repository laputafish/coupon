const AppMixin = {
  data () {
    return {
      futureMpfPercentErrors: [false, false],
      idCardOptions: [
        {labelTag: 'general.hkid', fieldName: 'hkid'},
        {labelTag: 'general.passport_no', fieldName: 'passport'}
      ]
    }
  },
  computed: {
    isMobile () {
      return this.$mq === 'mobile'
    },
    apiUrl () {
      return this.$store.getters.constants.apiUrl
    }
  },
  methods: {
    showToaster (msgInfo) {
      // messageInfo = {
      //    variant:
      //    message:
      //    ...
      // }
      const vm = this
      var variant = 'info'
      if (msgInfo.variant) {
        variant = msgInfo.variant
      }
      switch (variant) {
        case 'warning':
          vm.$toaster.warning(msgInfo.message, {timeout: 100000})
          break
        case 'info':
          vm.$toaster.warning(msgInfo.message)
          break
        case 'success':
          vm.$toaster.warning(msgInfo.message)
          break
        case 'error':
          vm.$toaster.warning(msgInfo.message)
          break
      }
    },
    // showErrors (data) {
    //   let vm = this
    //
    //   let html = ''
    //   for (let field in data.errors) {
    //     html += '<h5>' + field + '</h5>'
    //     for (let i = 0; i < data.errors[field].length; i++) {
    //       html += data.errors[field][i] + '<br/>'
    //     }
    //   }
    //
    //   vm.$modal.show('dialog', {
    //     title: data.message,
    //     text: html,
    //     buttons: {title: 'Close'}
    //   })
    //   // vm.$dialog.alert(html, {html: true})
    // },
    showSessionExpired (module) {
      const vm = this
      vm.$dialog
        .confirm('Session expired. Please login again. (' + module + ')', {
          okText: vm.$t('messages.goto_login_page')
        })
        .then(() => {
          vm.$router.push({name: 'Logout'})
        })
        .catch(dialogRef => {
          dialogRef.close()
        })

    },
    pad (str, max) {
      str = str.toString()
      return str.length < max ? this.pad('0' + str, max) : str
    },
    validateScopes () {
      this.$validator.validateScopes()
    },
    engOrCht (engValue, chtValue) {
      const vm = this
      return vm.$i18n.locale === 'en' ? engValue : chtValue
    },
    pluralForm (value) {
      switch (value) {
        case 'enrolment':
          return 'enrolments'
        case 'remittance':
          return 'remittances'
        case 'termination':
          return 'terminations'
        default:
          return value
      }
    },
    list2Items (value) {
      let items = value.split(',')
      return items.map((item) => {
        return item.trim()
      })
    },
    date2Weekday (dateStr) {
      const vm = this
      let result = -1
      let theDate = dateStr.trim()
      if (theDate !== '') {
        let m = vm.$moment(theDate)
        result = m.weekday()
      }
      return result
    },
    removeStringItem (itemStr, value) {
      const vm = this
      let result = itemStr
      if (itemStr !== '') {
        let items = vm.list2Items(itemStr)
        let dateStrs = vm.removeArrayItem(items, value)
        result = dateStrs.join(', ')
      }
      return result
    },
    removeArrayItem (items, value) {
      let result = items
      for (var i = 0; i < items.length; i++) {
        if (items[i] === value) {
          items.splice(i, 1)
          break
        }
      }
      return result
    },
    getPercentSum (percentsStr) {
      let result = 0
      if (percentsStr && (percentsStr !== '')) {
        let keyValues = percentsStr.split(',')
        result = keyValues.reduce((total, keyValue) => {
          let segs = keyValue.split(':')
          return total + parseFloat(segs[1])
        }, 0)
      }
      return result
    },

    formatMoney (n, c, d, t) {
      c = isNaN(c = Math.abs(c)) ? 2 : c
      d = d === undefined ? '.' : d
      t = t === undefined ? ',' : t
      let s = n < 0 ? '-' : ''
      let i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c)))
      let j = i.length
      j = j > 3 ? j % 3 : 0
      return s + (j ? i.substr(0, j) + t : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, '$1' + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : '')
    },

    bytesToSize (bytes) {
      var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
      if (bytes === 0) return '0 Byte'
      var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)))
      return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i]
    },

    strToKeyValues (str) {
      var result = {}

      str = str.trim()
      if (str !== '') {
        var keyValueStrs = str.split(';')
        for (var i = 0; i < keyValueStrs.length; i++) {
          var s = keyValueStrs[i].trim()
          if (s !== '') {
            var segs = s.split(':')
            if (segs.length > 1) {
              result[segs[0]] = segs[1]
            }
          }
        }
      }
      return result
    },
    keyValuesToStr (keyValues, keepBlank) {
      if (typeof keepBlank === 'undefined') {
        keepBlank = false
      }
      var result = ''
      if (Object.keys(keyValues).length >0) {
        for (var key in keyValues) {
          if (keyValues[key]!=='' || keepBlank) {
            result += key + ':' + keyValues[key] + ';'
          }
        }
      }
      return result
    },

    ucfirst (str) {
      return str.charAt(0).toUpperCase() + str.slice(1);
    }
  }
}

export default AppMixin
