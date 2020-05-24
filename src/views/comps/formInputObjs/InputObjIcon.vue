<template>
  <div class="input-object-icon">
    <!--<i v-if="isIcon"-->
       <!--class="fa-fw"-->
       <!--:class="activeInputObjType.icon"></i>-->
    <font-awesome-icon v-if="isIcon" :icon="['fas', activeInputObjType.newIcon]"/>
    <small v-else>
      {{ activeInputObjType ? activeInputObjType.text : '' }}
    </small>
  </div>
</template>

<script>
export default {
  props: {
    inputObjType: {
      type: String,
      default: ''
    }
  },
  computed: {
    inputObjTypes () {
      return this.$store.getters.inputObjTypes
    },
    activeInputObjType () {
      const vm = this
      var result = null
      for (var i = 0; i < vm.inputObjTypes.length; i++) {
        var objType = vm.inputObjTypes[i]
        if (objType.type === vm.inputObjType) {
          result = objType
          break
        }
      }
      if (!result) {
        console.log('The input type "' + vm.inputObjType +'" not exist.')
      }
      return result
    },
    isIcon () {
      const vm = this
      var result = false
      if (vm.activeInputObjType) {
        result = vm.activeInputObjType.icon !== ''
      }
      return result
    }

  }
}
</script>

<style>
  .input-object-icon {
    width: 30px;
    text-align: center;
  }
</style>
