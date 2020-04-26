<template>
  <div class="btn-toolbar object-type-list">
    <button v-for="buttonObj in inputObjTypes"
            :key="buttonObj.type"
            type="button"
            class="btn btn-primary text-center"
            :class="{'btn-primary':buttonObj.isInut, 'btn-success':!buttonObj.isInput}"
            @click="onButtonClicked(buttonObj.type)">
      <i v-if="buttonObj.icon"
         :class="buttonObj.icon"></i>
      <small v-else>{{ buttonObj.text }}</small>
      <br/>
      <small>{{ buttonObj.label }}</small>
    </button>
  </div>
</template>

<script>
export default {
  computed: {
    inputObjTypes () {
      return this.$store.getters.inputObjTypes
    }
  },
  methods: {
    onButtonClicked (inputObjType) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'newInputObj',
        value: inputObjType
      })
    }
  }
}
</script>