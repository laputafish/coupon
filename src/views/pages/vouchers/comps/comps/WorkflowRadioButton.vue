<template>
<div class="d-flex flex-row align-items-stretch">
  <div
      v-for="option in options"
      :key="option"
      class="w-400 mr-2 mb-2 d-inline-block flex-column d-flex">
    <div class="btn w-100 flex-grow-1 d-flex flex-column justify-content-center"
         @click="selectActionType(option)"
         :class="{'btn-success':selectedActionType===option,'btn-light':selectedActionType!==option}">
      <div class="d-flex flex-row justify-content-center align-items-center flex-grow-1">
        <template v-if="option==='form_voucher'">
          <workflow-radio-button-form></workflow-radio-button-form>
          <div class="text-center" style="width:20px;">
            <i class="fas fa-play"></i>
          </div>
          <workflow-radio-button-voucher></workflow-radio-button-voucher>
        </template>
        <template v-else-if="option==='form_custom'">
          <workflow-radio-button-form></workflow-radio-button-form>
          <div class="text-center" style="width:20px;">
            <i class="fas fa-play"></i>
          </div>
          <workflow-radio-button-custom
              :selected="selectedActionType===option"
            :customForms="customForms"
            @onCommand="onCommandHandler"></workflow-radio-button-custom>
        </template>
        <template v-else-if="option==='custom'">
          <workflow-radio-button-custom
              :selected="selectedActionType===option"
              :customForms="customForms"
              @onCommand="onCommandHandler"></workflow-radio-button-custom>
        </template>
        <template v-else>
          <h3>None</h3>
        </template>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import workflowRadioButtonCustom from './WorkflowRadioButtonCustom'
import workflowRadioButtonForm from './WorkflowRadioButtonForm'
import workflowRadioButtonVoucher from './WorkflowRadioButtonVoucher'

export default {
  components: {
    workflowRadioButtonCustom,
    workflowRadioButtonForm,
    workflowRadioButtonVoucher,
  },
  methods: {
    selectActionType (option) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'selectActionType',
        tag: vm.tag,
        actionType: option
      })
    },
    onCommandHandler (payload) {
      console.log('WorkflowRadioButton :: onCommandHandler : payload: ', payload)
      const vm = this
      payload = {
        ...payload,
        tag: vm.tag
      }
      vm.$emit('onCommand', payload)
    }
  },
  props: {
    tag: {
      type: String,
      default: ''
    },
    options: {
      type: Array,
      default () {
        return []
      }
    },
    customForms: {
      type: Array,
      default () {
        return []
      }
    },
    selectedActionType: {
      type: String,
      default: ''
    }
  }
}
</script>