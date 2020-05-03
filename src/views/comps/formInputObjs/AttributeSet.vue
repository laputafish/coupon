<template>
  <div>
    <div v-for="(attributeGroup,index) in userAttributes"
         class="mb-3"
         :key="attributeGroup.caption">
      <u v-if="attributeGroup.caption !== ''">{{ attributeGroup.caption }}</u>
      <attribute-table
          :optionIndex="index"
          :inputStyle="options[index]"
          @onCommand="onCommandHandler"
          :attributeKeys="attributeGroup.attributeKeys"></attribute-table>
    </div>
  </div>
</template>

<script>
import attributeTable from './AttributeTable'

export default {
  components: {
    attributeTable
  },
  computed: {
    // attributeInfos () {
    //   return this.$store.getters.attributeInfos
    // },
    userAttributes () {
      const vm = this
      const result = this.$store.getters.userAttributes[vm.attributeSet]
      return result ? result : []
    }
  },
  data () {
    return {
      options: []
      // ,
      // specificAttributes: [],
      // [
      //    'width' => '10%',
      //    'height' => '20px'
      // ]
    }
  },
  props: {
    attributeSet: {
      type: String,
      default () {
        return ''
      }
    },
    value: {
      type: Array,
      default () {
        return []
      }
    }
  },
  watch: {
    value: function() {
      this.refresh()
    }
  },
  mounted () {
    const vm = this
    vm.refresh()
  },
  methods: {
    refresh () {
      const vm = this
      vm.options = []

      // console.log('AttributeSet :: mounted :: vm.userAttributes: ', vm.userAttributes)
      // console.log('AttributeSet :: mounted :: vm.value: ', vm.value)

      for (var i = 0; i < vm.userAttributes.length; i++) {
        vm.options.push('')
        // console.log('options.length = ' + vm.options.length)
        // console.log('vm.options[' + i + '] = ' + vm.options[i])
      }
      // console.log('vm.value.length = ' + vm.value.length)
      for (var j = 0; j < vm.value.length; j++) {
        // console.log('vm.value[' + j + '] = ' + vm.value[j])
        vm.options[j] = vm.value[j]
      }
      //
      // for (var i = 0; i < vm.userAttributes.length; i++) {
      //   var attributes = vm.userAttributes[i].attributes
      // }
    },
    strToKeyValues (str) {
      str = str.trim()
      console.log('strToKeyValues: str: ', str)
      var result = {}
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
    keyValuesToStr (keyValues) {
      console.log('keyValuesToStr: keyValues: ', keyValues)
      var result = ''
      if (Object.keys(keyValues).length >0) {
        for (var key in keyValues) {
          result += key + ':' + keyValues[key] + ';'
        }
      }
      return result
    },
    onCommandHandler (payload) {
      const vm = this
      const command = payload.command

      var optionIndex
      var userKeyValues
      var updatedKeyValues

      var keyValues

      var originalUserKeyValues
      var originalUserKeys
      var newUserKeyValues
      var newUserKeys

      var updatedKeyValues;

      switch (command) {
        case 'updateOtherStyle':
          optionIndex = payload.optionIndex

          originalUserKeyValues = vm.strToKeyValues(payload.userStyle)
          originalUserKeys = Object.keys(originalUserKeyValues)

          newUserKeyValues = vm.strToKeyValues(payload.value)
          newUserKeys = Object.keys(newUserKeyValues)

          updatedKeyValues = {}
          keyValues = vm.strToKeyValues(vm.options[optionIndex])
          for (var key in keyValues) {
            console.log('> key = ' + key)
            if (originalUserKeys.indexOf(key) >= 0) {
              console.log('> in originaluserKeys')
              // if not in original and new, that's specific attributes
              if (newUserKeys.indexOf(key) >= 0) {
                console.log('> in newUserKeys ==> add')
                updatedKeyValues[key] = newUserKeyValues[key]
              } else {
                console.log('> not in newUserKeys ==> add')
              }
            } else {
              console.log('> not in originaluserKeys')
              // add new
              if (newUserKeys.indexOf(key) >= 0) {
                updatedKeyValues[key] = newUserKeyValues[key]
              } else {
                updatedKeyValues[key] = keyValues[key]
              }
            }
          }

          console.log('AttributeSet :: onCommandHandler :: optionIndex = ' + optionIndex)
          console.log('AttributeSet :: onCommandHandler :: originalUserKeyValues: ', originalUserKeyValues)
          console.log('AttributeSet :: onCommandHandler :: originalUserKeys: ', originalUserKeys)
          console.log('AttributeSet :: onCommandHandler :: newUserKeyValues: ', newUserKeyValues)
          console.log('AttributeSet :: onCommandHandler :: newUserKeys: ', newUserKeys)

          console.log('AttributeSet :: onCommandHandler :: keyValues: ', keyValues)
          console.log('AttributeSet :: onCommandHandler :: userKeyValues: ', userKeyValues)
          console.log('AttributeSet :: onCommandHandler :: updatedKeyValues: ', updatedKeyValues)

          vm.options[optionIndex] = vm.keyValuesToStr(updatedKeyValues)
          vm.$emit('onCommand', {
            command: 'updateOptions',
            options: vm.options
          })
          break
          break
        case 'updateStyle':
          // payload = {
          //    command,
          //    optionGroup, [option1 | option2]
          //    styleName,
          //    value
          // }
          switch (payload.optionGroup) {
            case 'option1':
              console.log('AttributeSet :: updateStyle :: vm.options[0]: ', vm.options[0])

              keyValues = vm.strToKeyValues(vm.options[0])
              keyValues[payload.styleName] = payload.value
              vm.options[0] = vm.keyValuesToStr(keyValues)

              console.log('AttributeSet :: updateStyle :: keyValues: ', keyValues)
              console.log('AttributeSet :: updateStyle :: vm.options[0]: ', vm.options[0])

              vm.$emit('onCommand', {
                command: 'updateOptions',
                options: vm.options
              })
              break
            case 'option2':
              keyValues = vm.strToKeyValues(vm.options[1])
              keyValues[payload.styleName] = payload.value
              vm.options[1] = vm.keyValuesToStr(keyValues)
              vm.$emit('onCommand', {
                command: 'updateOptions',
                options: vm.options
              })
              break
          }
          break
      }
    }
  }
}
</script>