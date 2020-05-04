<template>
  <div class="btn-toolbar object-type-list">
    <div v-for="buttonObj in inputObjTypes"
         :key="buttonObj.type">
      <button class="btn btn-primary text-center"
            :class="{'btn-primary':buttonObj.isInut, 'btn-success':!buttonObj.isInput}"
            @click="onButtonClicked(buttonObj.type)">
        <i v-if="buttonObj.icon"
           :class="buttonObj.icon"></i>
        <small v-else>{{ buttonObj.text }}</small>
        <br/>
        <small>{{ buttonObj.label }}</small>
      </button><br/>
      <div style="font-size:8pt;" class="text-center">{{ buttonObj.type }}</div>
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    inputObjTypes () {
      const vm = this
      return this.$store.getters.inputObjTypes.filter(item => {
        // // no need to show [page config]
        // var shown = !item.fixed
        //
        // if (!vm.includeInputObjs && item.isInput) {
        //   shown = false
        // } {
        //
        // }
        return !item.fixed && ((!item.isInput && item.type!=='output-submit') || vm.includeInputObjs)
      })
    }
  },
  props: {
    includeInputObjs: {
      type: Boolean,
      default: true
    }
  },
  methods: {
    onButtonClicked (inputObjType) {
      const vm = this
      console.log('InputObjButtonList :: onButtonClicked : inputObjType: ', inputObjType)
      vm.$emit('onCommand', {
        command: 'newInputObj',
        value: inputObjType
      })
    }
  }
}
</script>

<style>
.object-type-list button {
  line-height: 1.3;
  padding: 7px 0;
}
</style>