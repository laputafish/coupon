<template>
<div class="input-object-title px-1 d-flex flex-row align-items-center">
  <div class="badge"
       :class="{'badge-primary':isInput, 'badge-success':!isInput}">{{ inputObjTypeLabel }}</div>
  <div class="flex-grow-1 pl-1">{{ inputObj.name }}</div>
</div>
</template>

<script>
export default {
  props: {
    inputObj: {
      type: Object,
      default: null
    }
  },
  computed: {
    inputObjTypes () {
      return this.$store.getters.inputObjTypes
    },
    inputObjType () {
      const vm = this
      var result = '(Unknown)'
      for (var i = 0; i < vm.inputObjTypes.length; i++) {
        var obj = vm.inputObjTypes[i]
        if (obj.type === vm.inputObj.inputType) {
          result = obj
          break
        }
      }
      return result
    },
    inputObjTypeLabel () {
      return this.inputObjType.label
    },
    isInput () {
      return this.inputObjType.isInput
    }

  }
}
</script>

<style>
.input-object-title {
  background-color: rgba(200,200,200,.8);
  color: rgb(100,100,100);
  border-radius: 0.5rem;
}
</style>