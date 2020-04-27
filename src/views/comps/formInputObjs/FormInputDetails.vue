<template>
  <div>
    <!-- simple-text | number | email | text -->
    <div v-if="isInputElement(inputObj)" class="d-flex flex-column border">
      <div class="p-2 border bg-primary">
        <input-obj-title :inputObj="inputObj"></input-obj-title>
      </div>
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row label="Caption" notes="* for self reference" :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Question" :value="inputObj.question" fieldName="question" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row label="Notes" :value="inputObj.notes" fieldName="notes" @onCommand="onCommandHandler"></fields-table-row>
        </table>
      </div>
    </div>

    <!-- name -->
    <div v-else-if="inputObj.inputType==='name'" class="d-flex flex-column border">
      <div class="p-2 border bg-primary">
        <input-obj-title :inputObj="inputObj"></input-obj-title>
      </div>
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row label="Caption" notes="* for self reference" :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Question" :value="inputObj.question" fieldName="question" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row label="Notes" :value="notes1" notes="* first name" fieldName="notes1" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Notes" :value="notes2" notes="* last name" fieldName="notes2" @onCommand="onCommandHandler"></fields-table-row>
        </table>
      </div>
    </div>

    <!-- phone -->
    <div v-else-if="inputObj.inputType==='phone'" class="d-flex flex-column border">
      <div class="p-2 border bg-primary">
        <input-obj-title :inputObj="inputObj"></input-obj-title>
      </div>
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row label="Caption" notes="* for self reference" :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Question" :value="inputObj.question" fieldName="question" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row label="Notes" :value="notes1" notes="* first name" fieldName="notes1" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Notes" :value="notes2" notes="* last name" fieldName="notes2" @onCommand="onCommandHandler"></fields-table-row>
        </table>
      </div>
    </div>

    <!-- single-choice -->
    <div v-else-if="inputObj.inputType==='single-choice'" class="d-flex flex-column border">
      <div class="p-2 border bg-primary">
        <input-obj-title :inputObj="inputObj"></input-obj-title>
      </div>
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row label="Caption" notes="* for self reference" :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Question" :value="inputObj.question" fieldName="question" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row-options label="Options" :value="inputObj.options" fieldName="options" @onCommand="onCommandHandler"></fields-table-row-options>
        </table>
      </div>
    </div>

    <!-- multiple-choice -->
    <div v-else-if="inputObj.inputType==='multiple-choice'" class="d-flex flex-column border">
      <div class="p-2 border bg-primary">
        <input-obj-title :inputObj="inputObj"></input-obj-title>
      </div>
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row label="Caption" notes="* for self reference" :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Question" :value="inputObj.question" fieldName="question" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row-options label="Options" :value="inputObj.options" fieldName="options" @onCommand="onCommandHandler"></fields-table-row-options>        </table>
      </div>
    </div>

    <!-- image -->
    <div v-else-if="inputObj.inputType==='image'" class="d-flex flex-column border">
      <div class="p-2 border bg-primary">
        <input-obj-title :inputObj="inputObj"></input-obj-title>
      </div>
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row label="Caption" notes="* for self reference" :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row-image label="Image Link"
                                  :value="inputObj.question"
                                  @onCommand="onCommandHandler"></fields-table-row-image>
        </table>
      </div>
    </div>

    <!-- label -->
    <div v-else-if="inputObj.inputType==='label'" class="d-flex flex-column border">
      <div class="p-2 border bg-primary">
        <input-obj-title :inputObj="inputObj"></input-obj-title>
      </div>
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row label="Caption" notes="* for self reference" :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row-textarea label="Remark" :value="inputObj.question" fieldName="question" @onCommand="onCommandHandler"></fields-table-row-textarea>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import inputObjTitle from './InputObjTitle'
import fieldsTableRow from './FieldsTableRow'
import fieldsTableRowYesNo from './FieldsTableRowYesNo'
import fieldsTableRowOptions from './FieldsTableRowOptions'
import fieldsTableRowTextarea from './FieldsTableRowTextarea'
import fieldsTableRowImage from './FieldsTableRowImage'

// import fieldsTableRowCaption from './FieldsTableRowCaption'

export default {
  components: {
    inputObjTitle,
    fieldsTableRow,
    fieldsTableRowYesNo,
    fieldsTableRowOptions,
    fieldsTableRowTextarea,
    fieldsTableRowImage
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
    },
    multiNotes () {
      const vm = this
      var result = ['','']
      var segs = vm.inputObj.notes.split('|')
      result[0] = segs[0]
      if (segs.length > 1) {
        result[1] = segs[1]
      }
      return result
    },
    notes1 () {
      return this.multiNotes[0]
    },
    notes2 () {
      return this.multiNotes[1]
    }
  },
  methods: {
    updateImageLink (imgSrc) {

    },
    isInputElement (inputObj) {
      const inputTypes = ['simple-text','number','email','text']
      return inputTypes.indexOf(inputObj.inputType) >= 0
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
      const vm = this
      vm.$emit('onCommand', payload)
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