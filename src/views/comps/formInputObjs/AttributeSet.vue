<template>
  <div>
    <div v-for="(attributeGroup,index) in objAttributeInfo"
         class="mb-3"
         :key="attributeGroup.caption">
      <u v-if="attributeGroup.caption !== ''">{{ attributeGroup.caption }}</u>
      <attribute-table
          :optionIndex="index"
          :keyValues="keyValueLists[index]"
          :userStyle="userStyles[index]"
          @onCommand="onCommandHandler"
          :attributeKeys="attributeGroup.attributeKeys"></attribute-table>
      <!--<attribute-table-->
          <!--:optionIndex="index"-->
          <!--:inputStyle="options[index]"-->
          <!--:userStyle="userStyles[index]"-->
          <!--@onCommand="onCommandHandler"-->
          <!--:attributeKeys="attributeGroup.attributeKeys"></attribute-table>-->
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
    objAttributeInfo () {
      const vm = this
      const result = this.$store.getters.objAttributeGroups[vm.attributeSet]
      return result ? result : []
    },
    attributeInfos () {
      return this.$store.getters.attributeInfos
    }
  },
  data () {
    return {
      // options: [],
      keyValueLists: [],
      userStyles: [],
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
    options: {
      type: Array,
      default () {
        return []
      }
    }
  },
  watch: {
    options: function() {
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
      var i = 0
      var clones = JSON.parse(JSON.stringify(vm.options))
      var userStyles = ['', '']
      var userStyleKeyValues = [{}, {}]
      var keyValueLists = [[], []]

      for (i = 0; i < clones.length; i++) {
        userStyles[i] = clones[i]
      }
      userStyleKeyValues[0] = vm.strToKeyValues(userStyles[0])
      userStyleKeyValues[1] = vm.strToKeyValues(userStyles[1])

      // userStyles contains [elementStyleStr, containerStyleStr]

      for (i = 0; i < vm.objAttributeInfo.length; i++) {
        var objAttributeSection = vm.objAttributeInfo[i]
        var sectionAttributeKeys = objAttributeSection['attributeKeys']

        for (var j = 0; j < sectionAttributeKeys.length; j++) {
          var attributeKey = sectionAttributeKeys[j]
          var attributeInfo = vm.attributeInfos[attributeKey]
          var styleName = attributeInfo['styleName']

          switch (attributeInfo['optionGroup']) {
            case 'elementGroup':
              keyValueLists[0].push({
                attributeKey: attributeKey,
                value: userStyleKeyValues[0][styleName]
              })
              delete userStyleKeyValues[0][styleName]
              break
            case 'containerGroup':
              keyValueLists[1].push({
                attributeKey: attributeKey,
                value: userStyleKeyValues[1][styleName]
              })
              delete userStyleKeyValues[1][styleName]
              break
          }
        }
      }

      vm.userStyles = [
        vm.keyValuesToStr(userStyleKeyValues[0]),
        vm.keyValuesToStr(userStyleKeyValues[1])
      ]

      vm.keyValueLists = [
        keyValueLists[0],
        keyValueLists[1]
      ]
    },
    // refresh () {
    //   const vm = this
    //   vm.options = []
    //
    //   // console.log('AttributeSet :: mounted :: vm.userAttributes: ', vm.userAttributes)
    //   // console.log('AttributeSet :: mounted :: vm.value: ', vm.value)
    //
    //
    //   // for (var i = 0; i < vm.userAttributes.length; i++) {
    //   //   vm.options.push('')
    //   // }
    //   // for (var j = 0; j < vm.value.length; j++) {
    //   //   vm.options[j] = vm.value[j]
    //   // }
    //   //
    //   // for (var i = 0; i < vm.userAttributes.length; i++) {
    //   //   var attributes = vm.userAttributes[i].attributes
    //   // }
    // },
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
    onCommandHandler (payload) {
      const vm = this

      console.log('AttributeSet :: onCommandHandler :: payload: ', payload)
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

          console.log('AttributeSet :: onCommandHandler :: originalUserKeyValues: ', originalUserKeyValues)
          console.log('AttributeSet :: onCommandHandler :: originalUserKeys: ', originalUserKeys)
          console.log('AttributeSet :: onCommandHandler :: newUserKeyValues: ', newUserKeyValues)
          console.log('AttributeSet :: onCommandHandler :: newUserKeys: ', newUserKeys)
          
          updatedKeyValues = {}
          console.log('AttributeSet :: onCommandHandler :: vm.options[optionIndex]: ', vm.options[optionIndex])

          keyValues = vm.strToKeyValues(vm.options[optionIndex])

          console.log('AttributeSet :: onCommandHandler :: options keyValues: ', keyValues)
          keyValues = {...keyValues, ...newUserKeyValues}
          console.log('AttributeSet :: onCommandHandler :: options keyValues + newUserKeyValues: ', keyValues)

          for (var key in keyValues) {
            if (originalUserKeys.indexOf(key) >= 0) {
              // if not in original and new, that's specific attributes
              if (newUserKeys.indexOf(key) >= 0) {
                updatedKeyValues[key] = newUserKeyValues[key]
              } else {
              }
            } else {
              // add new
              if (newUserKeys.indexOf(key) >= 0) {
                updatedKeyValues[key] = newUserKeyValues[key]
              } else {
                updatedKeyValues[key] = keyValues[key]
              }
            }
          }

          console.log('AttributeSet :: onCommandHandler :: updatedKeyValues: ', updatedKeyValues)
          
          //
          // console.log('AttributeSet :: onCommandHandler :: optionIndex = ' + optionIndex)
          // console.log('AttributeSet :: onCommandHandler :: originalUserKeyValues: ', originalUserKeyValues)
          // console.log('AttributeSet :: onCommandHandler :: originalUserKeys: ', originalUserKeys)
          // console.log('AttributeSet :: onCommandHandler :: newUserKeyValues: ', newUserKeyValues)
          // console.log('AttributeSet :: onCommandHandler :: newUserKeys: ', newUserKeys)
          //
          // console.log('AttributeSet :: onCommandHandler :: keyValues: ', keyValues)
          // console.log('AttributeSet :: onCommandHandler :: userKeyValues: ', userKeyValues)
          // console.log('AttributeSet :: onCommandHandler :: updatedKeyValues: ', updatedKeyValues)

          vm.options[optionIndex] = vm.keyValuesToStr(updatedKeyValues)
          vm.$emit('onCommand', {
            command: 'updateOptions',
            options: vm.options
          })
          break
        case 'updateStyle':
          // payload = {
          //    command,
          //    optionGroup, [option1 | option2]
          //    styleName,
          //    value
          // }
          // console.log('AttributeSet :: onCommand :: updateStyle : payload: ', payload)
          switch (payload.optionGroup) {
            case 'elementGroup':
              vm.updateStyleValue(0 /* optionIndex */, payload.styleName, payload.value)
              break
            case 'containerGroup':
              vm.updateStyleValue(1 /* optionIndex */, payload.styleName, payload.value)
              // keyValues = {}
              // if (vm.options.length > 1) {
              //   keyValues = vm.strToKeyValues(vm.options[1])
              // }
              // keyValues[payload.styleName] = payload.value
              // vm.options[1] = vm.keyValuesToStr(keyValues)
              // vm.$emit('onCommand', {
              //   command: 'updateOptions',
              //   options: vm.options
              // })
              break
          }
          break
      }
    },
    updateStyleValue (optionIndex, styleName, value) {
      const vm = this
      var options = ['', '']

      if (vm.options.length > 0) {
        for (var i = 0; i < vm.options.length; i++) {
          options[i] = JSON.parse(JSON.stringify(vm.options[i]))
        }
      }
      var keyValues = vm.strToKeyValues(options[optionIndex])
      keyValues[styleName] = value

      console.log('updateStyleValue :: styleName = ' + styleName)
      console.log('updateStyleValue :: value = ' + value)

      options[optionIndex] = vm.keyValuesToStr(keyValues, false) // false = don't keep if blank

      console.log('Attribute :: updateStyleValue :: optionIndex = ' + optionIndex)
      console.log('Attribute :: updateStyleValue :: ' + styleName + ' => ' + value)
      console.log('Attribute :: options: ', options)


      vm.$emit('onCommand', {
        command: 'updateOptions',
        options: options
      })

    }
  }
}
</script>