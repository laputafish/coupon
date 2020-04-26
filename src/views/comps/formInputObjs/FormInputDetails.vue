<template>
  <div>
    <!-- simple-text | number | email -->
    <div v-if="useInputElement(inputObj)" class="d-flex flex-column">
      <div class="p-2 border bg-primary">
        <input-obj-title :inputObj="inputObj"></input-obj-title>
      </div>
      <table class="table table-hover details-field-table">
        <fields-table-row-caption :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row-caption>
        <fields-table-row :label="Question" :value="inputObj.question" fieldName="question" @onCommand="onCommandHandler"></fields-table-row>
        <fields-table-row :label="Notes" :value="inputObj.notes" fieldName="notes" @onCommand="onCommandHandler"></fields-table-row>
      </table>
    </div>

    <!-- text -->
    <div v-else-if="inputObj.inputType==='text'"
      class="d-flex flex-column">
      <input-obj-title :inputObj="inputObj"></input-obj-title>
    </div>

    <!-- name -->
    <div v-else-if="inputObj.inputType==='name'"
         class="d-flex flex-column border">
      <input-obj-title :inputObj="inputObj"></input-obj-title>
      <div>
        <div class="badge badge-warning">{{ inputObjTypeName(inputObj.inputType) }}</div>
      </div>

    </div>

    <!-- phone -->
    <div v-else-if="inputObj.inputType==='phone'"
         class="d-flex flex-column">
      <input-obj-title :inputObj="inputObj"></input-obj-title>
    </div>

    <!-- single-choice -->
    <div v-else-if="inputObj.inputType==='single-choice'"
         class="d-flex flex-column">
      <h1>Single Choice</h1>
    </div>

    <!-- multiple-choice -->
    <div v-else-if="inputObj.inputType==='multiple-choice'"
         class="d-flex flex-column">
      <h1>Multiple Choice</h1>
    </div>

    <!-- image -->
    <div v-else-if="inputObj.inputType==='image'"
         class="d-flex flex-column">
      <h1>Image</h1>
    </div>

    <!-- label -->
    <div v-else-if="inputObj.inputType==='label'"
         class="d-flex flex-column">
      <h1>Label</h1>
    </div>
  </div>
</template>

<script>
import inputObjTitle from './InputObjTitle'
import fieldsTableRow from './FieldsTableRow'
import fieldsTableRowCaption from './FieldsTableRowCaption'

export default {
  components: {
    inputObjTitle,
    fieldsTableRow,
    fieldsTableRowCaption
  },
  props: {
    inputObj: {
      type: Object,
      default:  null
    }
  },
  computed: {
    inputObjTypes () {
      return this.$store.getters.inputObjTypes
    }
  },
  methods: {
    useInputElement (inputObj) {
      const inputTypes = ['simple-input','number','email']
      return inputTypes.indexOf(inputObj.input_type) >= 0
    },
    inputObjTypeName (inputType) {
      const vm = this
      var result = '(Unknown)'
      for (var i = 0; i < vm.inputObjTypes.length; i++) {
        var obj = vm.inputObjTypes[i]
        if (obj.type === inputType) {
          result = obj.label
          break
        }
      }
      return result
    },
    onCommandHandler (payload) {
      this.$meit('onCommand', payload)
    }
  }
}
</script>

<style>
  table.details-field-table tr td {
    border: none !important;
    padding: 3px;
  }
</style>