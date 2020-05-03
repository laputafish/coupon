<template>
  <table class="w-100">
    <tr v-for="keyPair in keyPairs"
        :key="keyPair.key">
      <td class="label-cell">
        {{ attributeInfos[keyPair.key].caption }}
      </td>
      <td class="value-cell">
        <input class="form-control" :value="keyPair.value"
          @input="$event=>updateKeyPair(keyPair.key, $event.target.value)"/>
      </td>
    </tr>
    <tr>
      <td class="label-cell">
        Style
      </td>
      <td class="value-cell">
        <input class="form-control"
               :value="userStyle"
               @input="$event=>updateOtherStyle($event.target.value)"/>
      </td>
    </tr>
  </table>
</template>

<script>
export default {
  data () {
    return {
      keyPairs: [],
      userStyle: ''
    }
  },
  computed: {
    attributeInfos () {
      return this.$store.getters.attributeInfos
    }
  },
  props: {
    inputStyle: {
      type: String,
      default: ''
    },
    attributeKeys: {
      type: Array,
      default () {
        return []
      }
    },
    optionIndex: {
      type: Number,
      default: 0
    }
  },
  watch: {
    inputStyle: function () {
      this.refresh()
    },
    attributeKeys: function () {
      this.refresh()
    }
  },
  methods: {
    updateOtherStyle (value) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateOtherStyle',
        optionIndex: vm.optionIndex,
        userStyle: vm.userStyle,
        value: value
      })
    },
    updateKeyPair (key, value) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateStyle',
        optionGroup: vm.attributeInfos[key].optionGroup,
        styleName: vm.attributeInfos[key].styleName,
        value: value
      })
    },
    refresh () {
      const vm = this

      // init keyPairs
      vm.keyPairs = []
      if (vm.attributeKeys.length > 0) {
        for (var i = 0; i < vm.attributeKeys.length; i++) {
          vm.keyPairs.push({
            key: vm.attributeKeys[i],
            value: ''
          })
        }
      }
      var keys = vm.keyPairs.map(item => item.key)

      // extract option to keypair array
      var optionStyleKeyPairs = []
      if (vm.inputStyle !== '') {
        const styleKeyValueList = vm.inputStyle.split(';');
        for (var j = 0; j < styleKeyValueList.length; j++) {

          var styleKeyValueStr = styleKeyValueList[j].trim();

          if (styleKeyValueStr !== '') {
            var segs = styleKeyValueStr.split(':')
            if (segs.length > 1) {
              optionStyleKeyPairs[segs[0]] = segs[1]
            }
          }
        }
      }

      // extract user key pairs
      var usedStyleAttributeNames = [];
      if (vm.attributeKeys.length > 0) {
        for (var k = 0; k < vm.attributeKeys.length; k++) {
          var attributeKey = vm.attributeKeys[k]
          var attributeInfo = vm.attributeInfos[vm.attributeKeys[k]]
          if (attributeInfo) {
            const styleAttributeName = attributeInfo.styleName
            const keyIndex = keys.indexOf(attributeKey);
            vm.keyPairs[keyIndex].value = ''

            if (optionStyleKeyPairs[styleAttributeName] !== undefined) {
              usedStyleAttributeNames.push(styleAttributeName)

              if (keyIndex >= 0) {
                vm.keyPairs[keyIndex].value = optionStyleKeyPairs[styleAttributeName]
              }
            }
          }
        }
      }

      // evaluate remaining styles
      vm.userStyle = ''
      for (var attributeName in optionStyleKeyPairs) {
        if (usedStyleAttributeNames.indexOf(attributeName) == -1) {
          vm.userStyle += attributeName + ':' + optionStyleKeyPairs[attributeName] + ';'
        }
      }
    }
  },
  mounted () {
    this.refresh()
  }
}
</script>