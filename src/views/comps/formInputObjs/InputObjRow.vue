<template>
  <div class="flex-grow-1 d-flex flex-row">
    <input-obj-icon :inputObjType="inputObj.inputType"></input-obj-icon>
    <div class="d-flex flex-column flex-grow-1">
      <input-obj-title
          :inputObj="inputObj"></input-obj-title>
      <div class="d-flex flex-row mt-1">
        <small class="pr-1">Question</small>
        <div class="input-obj-question badge badge-info">{{ inputObj.question }}</div>
      </div>
      <div v-if="inputObj.options.length>0" class="d-flex flex-row mt-1">
        <small class="pr-1">Options</small>
        <div class="input-obj-options line-height-1">
          <div v-for="(option, index) in inputObj.options"
               class="p-0 m-0"
               :key="index">
            <div class="input-obj-option m-0 badge badge-secondary">{{ option }}</div>
          </div>
        </div>
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
    }
  }
}
</script>

<style>
  .input-obj-question {
    white-space: normal;
    font-weight: normal;
    text-align: left;
  }

  .input-obj-option {
    white-space: normal;
    font-weight: normal;
    text-align: left;
  }
</style>
