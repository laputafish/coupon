<template>
  <div class="input-object-icon">
    <i v-if="isIcon"
       class="fa-fw"
       :class="activeInputObjType.icon"></i>
    <small v-else>
      {{ activeInputObjType.text }}
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
      return result
    },
    isIcon () {
      const vm = this
      return vm.activeInputObjType.icon !== ''
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
