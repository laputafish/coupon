import helpers from '@/helpers'

const TemplateMixin = {
  data () {
    return {
      defaultTemplateTagGroups: [],
      templateTagGroups: []
    }
  },
  computed: {
    // templateTagGroups () {
    //   const vm = this
    //   var result = []
    //
    //   console.log('computed(templateTagGroups) :: vm.defaultTemplateTagGroups: ', vm.defaultTemplateTagGroups)
    //
    //   if (vm.defaultTemplateTagGroups) {
    //     const result = JSON.parse(JSON.stringify(vm.defaultTemplateTagGroups))
    //     if (vm.codeFields.length > 0) {
    //       result.push({
    //         name: 'code',
    //         keys: []
    //       })
    //     }
    //     console.log('computed(templateTagGroups) :: result: ', result)
    //
    //     var lastIndex = result.length - 1
    //     for (let i = 0; i < vm.codeFields.length; i++) {
    //       const key = helpers.str2token('code_', vm.codeFields[i])
    //       result[lastIndex]['keys'].push(key)
    //     }
    //
    //     // if (vm.extraKeyGroup !== null) {
    //     //   result.push({
    //     //     name: vm.extraKeyGroup.groupName,
    //     //     keys: []
    //     //   })
    //     //   lastIndex = result.length - 1
    //     //   for (let j = 0; j < vm.extraKeyGroup.keys.length; j++) {
    //     //     var key = vm.extraKeyGroup.keys[j]
    //     //     result[lastIndex]['keys'].push(key)
    //     //   }
    //     // }
    //     console.log('computed(templateTagGroups): ', result)
    //     if (typeof vm.onTemplateTagGorupsReady === 'function') {
    //       result = vm.onTemplateTagGroupsReady(result)
    //     }
    //   }
    //   return result
    // },
    codeFields () {
      const vm = this
      let result = []
      // result = [
      //    'code',
      //    'serial',
      //    'ticket_link'
      // ]
      if (vm.voucher.code_fields !== null && vm.voucher.code_fields !== '') {
        // console.log('codeFields :: codeFields = ' + vm.voucher.code_fields)
        const arKeyPairs = helpers.getKeyPairArray(vm.voucher.code_fields)
        // console.log('codeFields :: arKeyPairs: ', arKeyPairs)
        result = arKeyPairs.map(keyPair => keyPair[0])
      }
      result.push('ticket_link')
      return result
    }
  },
  mounted () {
    const vm = this
    vm.fetchDefaultTemplateKeys()
  },
  methods: {
    getTemplateTagGroups () {
      const vm = this
      var result = []

      if (vm.defaultTemplateTagGroups) {
        result = JSON.parse(JSON.stringify(vm.defaultTemplateTagGroups))


        // Apend code fields tag
        if (vm.codeFields.length > 0) {
          result.push({
            name: 'code',
            tags: []
          })
        }

        var lastIndex = result.length - 1
        for (let i = 0; i < vm.codeFields.length; i++) {
          const key = helpers.str2token('code_', vm.codeFields[i])
          result[lastIndex]['tags'].push(key)
        }

        if (typeof vm.onTemplateTagGroupsReady === 'function') {
          result = vm.onTemplateTagGroupsReady(result)
        }
      }
      return result
    },
    fetchDefaultTemplateKeys () {
      const vm = this
      vm.defaultTemplateTagGroups = []
      vm.$store.dispatch('AUTH_GET', '/template_keys').then(
        response => {
          for (let i = 0; i < response.length; i++) {
            const responseItem = response[i]
            const category = responseItem.category
            const key = responseItem.key
            const keyGroup = vm.defaultTemplateTagGroups.find(group => {
              return group.name === category
            })
            if (keyGroup) {
              // console.log('keyGroup is true: ', keyGroup)
              keyGroup.tags.push(key)
            } else {
              // console.log('keyGroup is false: ', keyGroup)
              vm.defaultTemplateTagGroups.push({
                name: category,
                tags: [key]
              })
            }
          }
          vm.templateTagGroups = vm.getTemplateTagGroups()
        },
        () => {
          vm.showSessionExpired('template keys')
          // vm.$dialog.alert('Template Keys: ' + vm.$t('messages.error_during_loading'))
        }
      )
    }
  }
}

export default TemplateMixin