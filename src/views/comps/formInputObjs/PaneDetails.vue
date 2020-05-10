<template>
  <div>
    <div v-if="inputObj.inputType==='system-page'" class="d-flex flex-column border">
      <div class="p-2 border bg-primary text-center">
        Page Attributes
      </div>
      <div class="p-2">
        <attribute-set
            attributeSet="system-page"
            :options="inputObj.options"
            @onCommand="onCommandHandler"></attribute-set>
      </div>
    </div>

    <!-- simple-text | number | email | text -->
    <div v-if="isInputElement(inputObj)" class="d-flex flex-column border">
      <pane-details-title :inputObj="inputObj"></pane-details-title>
      <!--<div class="p-2 border bg-primary">-->
        <!--<input-obj-title :inputObj="inputObj"></input-obj-title>-->
      <!--</div>-->
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row-caption :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row-caption>
          <fields-table-row-question :value="inputObj.question" @onCommand="onCommandHandler"></fields-table-row-question>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row label="Notes" :value="inputObj.note1" fieldName="note1" @onCommand="onCommandHandler"></fields-table-row>
        </table>
      </div>
    </div>

    <!-- name -->
    <div v-else-if="inputObj.inputType==='name'" class="d-flex flex-column border">
      <pane-details-title :inputObj="inputObj"></pane-details-title>
      <!--<div class="p-2 border bg-primary">-->
        <!--<input-obj-title :inputObj="inputObj"></input-obj-title>-->
      <!--</div>-->
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row-caption :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row-caption>
          <fields-table-row-question :value="inputObj.question" @onCommand="onCommandHandler"></fields-table-row-question>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row label="Notes" :value="inputObj.note1" notes="* first name" fieldName="note1" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Notes" :value="inputObj.note2" notes="* last name" fieldName="note2" @onCommand="onCommandHandler"></fields-table-row>
        </table>
      </div>
    </div>

    <!-- phone -->
    <div v-else-if="inputObj.inputType==='phone'" class="d-flex flex-column border">
      <pane-details-title :inputObj="inputObj"></pane-details-title>
      <!--<div class="p-2 border bg-primary">-->
        <!--<input-obj-title :inputObj="inputObj"></input-obj-title>-->
      <!--</div>-->
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row-caption :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row-caption>
          <fields-table-row-question :value="inputObj.question" @onCommand="onCommandHandler"></fields-table-row-question>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row label="Notes" :value="inputObj.note1" notes="* Region Code" fieldName="note1" @onCommand="onCommandHandler"></fields-table-row>
          <fields-table-row label="Notes" :value="inputObj.note2" notes="* Phone No." fieldName="note2" @onCommand="onCommandHandler"></fields-table-row>
        </table>
      </div>
    </div>

    <!-- single-choice -->
    <div v-else-if="inputObj.inputType==='single-choice'" class="d-flex flex-column border">
      <pane-details-title :inputObj="inputObj"></pane-details-title>
      <!--<div class="p-2 border bg-primary">-->
        <!--<input-obj-title :inputObj="inputObj"></input-obj-title>-->
      <!--</div>-->
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row-caption :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row-caption>
          <fields-table-row-question :value="inputObj.question" @onCommand="onCommandHandler"></fields-table-row-question>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row-options label="Options" :value="inputObj.options" fieldName="options" @onCommand="onCommandHandler"></fields-table-row-options>
        </table>
      </div>
    </div>

    <!-- multiple-choice -->
    <div v-else-if="inputObj.inputType==='multiple-choice'" class="d-flex flex-column border">
      <pane-details-title :inputObj="inputObj"></pane-details-title>
      <!--<div class="p-2 border bg-primary">-->
        <!--<input-obj-title :inputObj="inputObj"></input-obj-title>-->
      <!--</div>-->
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row-caption :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row-caption>
          <fields-table-row-question :value="inputObj.question" @onCommand="onCommandHandler"></fields-table-row-question>
          <fields-table-row-yes-no label="Required" :value="inputObj.required" fieldName="required" @onCommand="onCommandHandler"></fields-table-row-yes-no>
          <fields-table-row-options label="Options" :value="inputObj.options" fieldName="options" @onCommand="onCommandHandler"></fields-table-row-options>        </table>
      </div>
    </div>

    <!-- image -->
    <div v-else-if="inputObj.inputType==='output-image'" class="d-flex flex-column border">
      <pane-details-title :inputObj="inputObj"></pane-details-title>
      <!--<div class="p-2 border bg-primary">-->
        <!--<input-obj-title :inputObj="inputObj"></input-obj-title>-->
      <!--</div>-->
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row-image label="Image Link"
                                  :value="inputObj.question"
                                  :voucher="voucher"
                                  fieldName="question"
                                  @onCommand="onCommandHandler"></fields-table-row-image>
        </table>
        <attribute-set
          :attributeSet="inputObj.inputType"
          :options="inputObj.options"
          @onCommand="onCommandHandler"></attribute-set>
      </div>
    </div>

    <!-- Remark -->
    <div v-else-if="inputObj.inputType==='output-remark'" class="d-flex flex-column border">
      <pane-details-title :inputObj="inputObj"></pane-details-title>
      <!--<div class="p-2 border bg-primary">-->
        <!--<input-obj-title :inputObj="inputObj"></input-obj-title>-->
      <!--</div>-->
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <!--<fields-table-row label="Caption" notes="* for self reference" :value="inputObj.name" @onCommand="onCommandHandler"></fields-table-row>-->
          <fields-table-row-textarea label="Remark"
                                     :value="inputObj.question.replace('|', '\n')"
                                     fieldName="question"
                                     @onCommand="onCommandHandler"></fields-table-row-textarea>
        </table>
        <attribute-set
            :attributeSet="inputObj.inputType"
            :options="inputObj.options"
            @onCommand="onCommandHandler"></attribute-set>
      </div>
    </div>

    <!-- Submit Button -->
    <div v-else-if="inputObj.inputType==='output-submit'" class="d-flex flex-column border">
      <pane-details-title :inputObj="inputObj"></pane-details-title>
      <!--<div class="p-2 border bg-primary"><input-obj-title :inputObj="inputObj"></input-obj-title></div>-->
      <div class="p-2">
        <table class="table table-hover details-field-table">
          <fields-table-row label="Button Label" placeholder="Submit" :value="inputObj.question" fieldName="question" @onCommand="onCommandHandler"></fields-table-row>
        </table>
        <attribute-set
            :attributeSet="inputObj.inputType"
            :options="inputObj.options"
            @onCommand="onCommandHandler"></attribute-set>
      </div>
    </div>

  </div>
</template>

<script>
// import inputObjTitle from './InputObjTitle'
import fieldsTableRow from './FieldsTableRow'
import fieldsTableRowCaption from './FieldsTableRowCaption'
import fieldsTableRowQuestion from './FieldsTableRowQuestion'
import fieldsTableRowYesNo from './FieldsTableRowYesNo'
import fieldsTableRowOptions from './FieldsTableRowOptions'
import fieldsTableRowTextarea from './FieldsTableRowTextarea'
import fieldsTableRowImage from './FieldsTableRowImage'
import paneDetailsTitle from './PaneDetailsTitle'
import attributeSet from './AttributeSet'

// import fieldsTableRowCaption from './FieldsTableRowCaption'

export default {
  components: {
    // inputObjTitle,
    fieldsTableRow,
    fieldsTableRowCaption,
    fieldsTableRowQuestion,
    fieldsTableRowYesNo,
    fieldsTableRowOptions,
    fieldsTableRowTextarea,
    fieldsTableRowImage,
    paneDetailsTitle,
    attributeSet
  },
  props: {
    inputObj: {
      type: Object,
      default:  null
    },
    voucher: {
      type: Object,
      default: null
    }
  },
  computed: {
    inputObjTypes () {
      return this.$store.getters.inputObjTypes
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
  .label-cell {
    line-height: 1.1;
  }
  .value-cell {
    width: 70%;
  }
</style>