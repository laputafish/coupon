<template>
  <div class="flex-grow-1 d-flex flex-row">
    <input-obj-icon :inputObjType="inputObj.inputType"></input-obj-icon>
    <div class="d-flex flex-column flex-grow-1">
      <!-- Title -->
      <input-obj-title :inputObj="inputObj"></input-obj-title>

      <div class="d-flex flex-row mt-1">
        <small class="pr-1">{{ label }}</small>
        <div v-if="inputObj.question && inputObj.question!==''"
             class="input-obj-question badge badge-info"
             v-html="questionContext"></div>
        <div v-if="inputObj.required==='1' && isInput" class="badge badge-danger ml-1">
          <i class="fas fa-bahai"></i>
        </div>
      </div>

      <div v-if="inputObj.inputType==='output-image' && inputObj.question!=='' && inputObj.question !== null"
        class="p-1">
        <img class="input-obj-image-show" :src="inputObj.question"/>
      </div>

      <div v-if="(inputObj.inputType==='single-choice' || inputObj.inputType==='multiple-choice') && inputObj.options.length>0" class="d-flex flex-row mt-1">
        <small class="pr-1">Options</small>
        <div class="input-obj-options line-height-1">
          <div v-for="(option, index) in inputObj.options"
               class="p-0 m-0"
               :key="index">
            <div class="input-obj-option m-0 badge badge-secondary">{{ option }}</div>
          </div>
        </div>
      </div>
      <div v-if="inputObj.inputType.substr(0,6)==='output'">
        <small class="line-height-1 mt-1 px-1 d-block note-font-size-10" v-for="(option, index) in inputObj.options">
          {{ option }}
        </small>
      </div>
      <slot>
      </slot>
    </div>
  </div>
</template>

<script>
import inputObjIcon from './InputObjIcon'
import inputObjTitle from './InputObjTitle'

export default {
  components: {
    inputObjIcon,
    inputObjTitle
  },
  props: {
    inputObj: {
      type: Object,
      default: null
    },
    label: {
      type: String,
      default: ''
    }
  },
  computed: {
    questionContext () {
      const vm = this
      var carriageReturn = "|";
      var lines = vm.inputObj.question.split(carriageReturn);
      var result = []
      for (var i = 0; i < lines.length; i++) {
        result.push(lines[i])
      }
      return result.join('<br/>')
    },
    isInput () {
      const vm = this
      var result = true
      for (var i = 0; i < vm.inputObjTypes.length; i++) {
        var objType = vm.inputObjTypes[i]
        if (objType.type === vm.inputObj.inputType) {
          result = objType.isInput
          break
        }
      }
      return result
    },
    inputObjType () {
      const vm = this
      var result = null
      for (var i = 0; i < vm.inputObjTypes.length; i++) {
        if (vm.inputObjTypes[i].type === vm.inputObj.inputType) {
          result = vm.inputObjTypes[i]
          break
        }
      }
      return result
    },
    inputObjTypes () {
      return this.$store.getters.inputObjTypes
    }
  }
}
</script>

<style>
  .input-obj-question {
    white-space: normal;
    font-weight: normal;
    text-align: left;
    line-height: 1.2;
  }

  .input-obj-option {
    white-space: normal;
    font-weight: normal;
    text-align: left;
  }

  .input-obj-image-show {
    height: 160px;
    width: auto;
    object-fit: contain;
  }
</style>
