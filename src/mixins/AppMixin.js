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
  created () {
    let vm = this
    vm.$validator.extend('bankCode', {
      getMessage (field, args) {
        return vm.$t('payroll.invalid_bank_code')
      },
      validate (value) {
        return new Promise(resolve => {
          let reg = /^[0-9]+[-0-9]+[0-9]+$/g
          let result = reg.test(value)
          console.log('pattern valid: ' + (result ? 'yes' : 'no'))
          if (result) {
            let valueNoHypen = value.replace(/-/g, '')
            console.log('valueNoHypen (' + valueNoHypen + ').length = ' + valueNoHypen.length)
            result = valueNoHypen.length <= 12
          }
          resolve({
            valid: result,
            data: {message: 'Invalid Bank Code'}
          })
        })
      }
    })
    vm.$validator.extend('is_time', {
      getMessage: () => vm.$t('messages.the_format_must_be_hh_mm_ss'),
      validate: (value) => new Promise(resolve => {
        let regex = new RegExp('([0-1][0-9]|2[0-3]):([0-5][0-9])(:([0-5][0-9]))?')
        console.log('is_time :: value: [' + value + ']')
        console.log('is_time :: value: ' + (value ? 'yes' : 'no'))
        console.log('is_time :: regex.test(value): ' + (regex.test(value) ? 'yes' : 'no'))
        resolve({
          valid: value && regex.test(value),
          data: {message: vm.$t('messages.the_format_must_be_hh_mm_ss')}
        })
      })
    })
    vm.$validator.extend('hkidOrPassport', {
      getMessage (field, args) {
        return vm.$t('messages.id_card_no_is_essential')
      },
      validate (value) {
        let segs = value
        // value = [index, {1st value}, {2nd value}]

        // console.log('validate(hkidOrPassport) :: validate value: ', value)
        // console.log('validate(hkidOrPassport) :: activeIdTypeIndex = ' + value[0])
        // console.log('validate(hkidOrPassport) :: segs[vm.activeIdTypeIndex] = ' + segs[vm.activeIdTypeIndex])

        // let index = vm.idCardOptions.findIndex((item) => {
        //   return item.fieldName === vm.activeIdType
        // })
        // console.log('validate(hkidOrPassport) :: validate value: ', value)
        // console.log('validate(hkidOrPassport) :: validate segs: ', segs)
        // console.log('validate(hkidOrPassport) :: validate index: ', index)

        let result = segs[value[0] + 1] !== ''
        // console.log('validate(hkidOrPassport) :: validate result = ' + result)

        return result
        // let result = false
        // for (var i = 0; i < segs.length; i++) {
        //   console.log('i=' + i + ': validate: hkidOrPassport segs[i]=' + segs[i])
        //   if (segs[i] !== '') {
        //     result = true
        //     break
        //   }
        // }
        // console.log('validator(hkidOrPassport) :: result = ' + result)
        // return result
      }
    })

    vm.$validator.extend('nonZero', {
      getMessage (field, args, params) {
        return vm.$t('messages._fieldName_is_required', {fieldName: field})
      },
      validate (value, args) {
        return value !== '' && value !== 0
      }
    })

    // vm.$validator.extend('nonZero', {
    //   getMessage (field, args, data) {
    //     console.log('validator(nonZero) :: field: ', field)
    //     console.log('validator(nonZero) :: args: ', args)
    //     console.log('validator(nonZero) :: data: ', data)
    //     let fieldName = vm.$t(args[0])
    //     return vm.$t('messages._fieldName_is_required', {fieldName: fieldName})
    //   },
    //   validate (value) {
    //     console.log('validate(nonZero) :: typeof(value): ' + (typeof value))
    //     console.log('validate(nonZero) :: value = ' + value)
    //     return value !== '' && value !== 0
    //   }
    // })
    //
    vm.$validator.extend('idCardNo', {
      getMessage (field, args) {
        return vm.$t('messages.id_card_no_is_essential')
      },
      validate (value) {
        // console.log('validator(idCardNo) :: value = ', value)
        let result = false
        for (var i = 0; i < value.length; i++) {
          if (value[i] && (value[i] !== null) && (value[i] !== '')) {
            result = true
            break
          }
        }
        // console.log('validator(idCardNo) :: result = ' + result)
        return result
      }
    })

    this.$validator.extend('futureContributionValidation', {
      getMessage (field, args) {
        return vm.$t('messages.future_contribution_error')
        // + 'the_field_value_must_be_100_percent_if_not_zero', {fieldName: fieldName})
      },
      validate (value) {
        // value = ["123:10, 137:20, 140: 30, 22:40", "123:10, 137:20, 140: 30, 22:40"]
        let result = true
        // console.log('validate(futureContributionValidation)  vm.futureMpfPercentErrors: ', vm.futureMpfPercentErrors)
        if (vm.futureMpfPercentErrors) {
          // let totalPercents = 0

          let mcTotalPercents = vm.getPercentSum(value[0])
          // console.log('mcTotalPercents = ' + mcTotalPercents)
          vm.futureMpfPercentErrors[0] = mcTotalPercents !== 100

          let vcTotalPercents = vm.getPercentSum(value[1])
          // console.log('vcTotalPercents = ' + vcTotalPercents)
          vm.futureMpfPercentErrors[1] = vcTotalPercents % 100 !== 0

          for (var i = 0; i < vm.futureMpfPercentErrors.length; i++) {
            if (vm.futureMpfPercentErrors[i]) {
              result = false
              break
            }
          }
        }
        // console.log('validate(futureContributionValidation) :: result = ' + (result ? 'yes' : 'no'))
        return result
        // return result
      }
    })

    this.$validator.extend('currentContributionValidation', {
      getMessage (field, args) {
        // let fieldName = vm.$t(args[0])
        // return vm.$t('messages.the_field_value_must_be_100_percent_if_not_zero', {fieldName: fieldName})
        return vm.$t('messages.current_contribution_error')
      },
      validate (value) {
        let result = false
        let mcOut = vm.getPercentSum(value[0])
        let mcIn = vm.getPercentSum(value[1])
        let vcOut = vm.getPercentSum(value[2])
        let vcIn = vm.getPercentSum(value[3])
        vm.currentMpfPercentErrors = [false, false, false, false]

        if (mcOut > 0) {
          vm.currentMpfPercentErrors[1] = mcIn !== 100
          if (vm.currentMpfPercentErrors[1]) {
            result = true
          }
        }

        if (vcOut > 0) {
          vm.currentMpfPercentErrors[3] = vcIn !== 100
          // console.log('vcIn error: ' + (vm.currentMpfPercentErrors[3] ? 'yes' : 'no'))
          if (vm.currentMpfPercentErrors[3]) {
            result = true
          }
        }
        return !result
      }
    })

    this.$validator.extend('optionalPercent100', {
      getMessage (field, args) {
        let fieldName = vm.$t(args[0])
        return vm.$t('messages.the_field_value_must_be_100_percent_if_not_zero', {fieldName: fieldName})
      },
      validate (value) {
        let result = false
        let totalPercents = 0
        for (var i = 0; i < value.length; i++) {
          let percentTotal = vm.getPercentSum(value[i])
          totalPercents += percentTotal
        }
        result = totalPercents % 100 === 0
        return result
      }
    })
    this.$validator.extend('percentsInOutMatched', {
      getMessage (field) {
        return vm.$t('messages.percent_in_and_percent_out_not_matched')
      },
      validate (value) {
        // value = [
        //    "123:10, 137:20, 140: 30, 22:40",
        //    "123:10, 137:20, 140: 30, 22:40",
        //    "123:10, 137:20, 140: 30, 22:40",
        //    "123:10, 137:20, 140: 30, 22:40"
        // ]
        let result = true
        let mcOutTotal = vm.getPercentSum(value[0])
        let mcInTotal = vm.getPercentSum(value[1])
        let vcOutTotal = vm.getPercentSum(value[2])
        let vcInTotal = vm.getPercentSum(value[3])

        let isMcInOutMatched = mcOutTotal === mcInTotal
        let isVcInOutMatched = vcOutTotal === vcInTotal
        vm.currentPercentsValidity = [
          isMcInOutMatched,
          isMcInOutMatched,
          isVcInOutMatched,
          isVcInOutMatched
        ]

        result = (mcOutTotal === mcInTotal) && (vcOutTotal === vcInTotal)
        return result
      }
    })
  },
  methods: {
    pad (str, max) {
      str = str.toString()
      return str.length < max ? this.pad('0' + str, max) : str
    },
    validateScopes () {
      this.$validator.validateScopes()
    },
    engOrCht (engValue, chtValue) {
      let vm = this
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
      let vm = this
      let result = -1
      let theDate = dateStr.trim()
      if (theDate !== '') {
        let m = vm.$moment(theDate)
        result = m.weekday()
      }
      return result
    },
    removeStringItem (itemStr, value) {
      let vm = this
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
    }
  }
}

export default AppMixin
