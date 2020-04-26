<template>
  <li class="list-group-item d-flex flex-row align-items-center"
      @click="selectInputObj"
    :class="{'bg-primary':selected,'bg-muted':!selected}">
    <!-- simple-text -->
    <input-obj-row v-if="inputObj.inputType==='simple-text'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- number -->
    <input-obj-row v-if="inputObj.inputType==='number'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- email -->
    <input-obj-row v-if="inputObj.inputType==='email'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- text -->
    <input-obj-row v-if="inputObj.inputType==='text'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- name -->
    <input-obj-row v-if="inputObj.inputType==='name'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- phone -->
    <input-obj-row v-if="inputObj.inputType==='phone'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- single-choice -->
    <input-obj-row v-if="inputObj.inputType==='single-choice'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- multiple-choice -->
    <input-obj-row v-if="inputObj.inputType==='multiple-choice'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- image -->
    <input-obj-row v-if="inputObj.inputType==='image'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- label -->
    <input-obj-row v-if="inputObj.inputType==='label'"
                   :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-row>

    <!-- Delete Button -->
    <div class="pl-1">
      <button class="btn btn-sm btn-danger btn-circle"
              @click="deleteObj(inputObj)">
        <i class="fas fa-times"></i>
      </button>
    </div>
  </li>
</template>

<script>
import inputObjRow from './InputObjRow'

export default {
  components: {
    inputObjRow
  },
  props: {
    inputObj: {
      type: Object,
      default: null
    },
    selected: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    // inputObjTypes () {
    //   return this.$store.getters.inputObjTypes
    // }
  },
  methods: {
    selectInputObj () {
      const vm = this
      console.log('FormInputObj :: selectInputObj')
      vm.$emit('onCommand', {
        command: 'selectInputObj',
        value: vm.inputObj
      })
    },
    onCommandHandler (payload) {

    }
    // ,
    // inputObjTypeName (inputType) {
    //   const vm = this
    //   var result = '(Unknown)'
    //   for (var i = 0; i < vm.inputObjTypes.length; i++) {
    //     var obj = vm.inputObjTypes[i]
    //     if (obj.type === inputType) {
    //       result = obj.label
    //       break
    //     }
    //   }
    //   return result
    // }
  }
}
</script>
