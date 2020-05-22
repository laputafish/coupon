<template>
  <base-dialog
      id="codeImportDialog"
      title="Code Import"
      size="md"
      modalType="confirmation"
      :okButtonState="true"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div class="container-fluid">
      <div class="row bg-lightblue mb-1">
        <div class="col-sm-3" style="overflow-x:hidden;white-space:nowrap;text-overflow:ellipsis;">Column Name</div>
        <div class="col-sm-3">Code Table</div>
        <div class="col-sm-6">Participant Table</div>
      </div>
      <div class="import-code-content" style="max-height:640px;overflow-y:scroll;overflow-x:hidden;">
        <div>
          <div class="row mb-1" v-for="fieldInfo in fieldInfos"
               :key="fieldInfo.title">
            <div class="col-sm-3">{{ fieldInfo.title }}</div>
            <div class="col-sm-3">
              <div class="btn-group">
                <button type="button" class="btn btn-sm"
                        :class="{'btn-primary':fieldInfo.fieldType===fieldType.value,'btn-light':fieldInfo.fieldType!==fieldType.value}"
                        @click="selectFieldType(fieldInfo, 'code', fieldType.value)"
                        v-for="fieldType in codeFieldTypes"
                        :key="fieldType.value">{{ fieldType.label }}</button>
              </div>
            </div>
            <div class="col-sm-6">
              <div class="btn-group">
                <button type="button" class="btn btn-sm"
                        :class="{'btn-success': fieldInfo.fieldType===fieldType.value,'btn-light':fieldInfo.fieldType!==fieldType.value}"
                        @click="selectFieldType(fieldInfo, 'participant', fieldType.value)"
                        v-for="fieldType in participantFieldTypes"
                        :key="fieldType.value">{{ fieldType.label }}</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!--<table class="no-border table code-import-table">-->
        <!--<thead>-->
          <!--<tr>-->
            <!--<td></td>-->
            <!--<td>Code Table</td>-->
            <!--<td>Participant Table</td>-->
          <!--</tr>-->
        <!--</thead>-->
        <!--<tbody>-->
          <!--<tr v-for="fieldInfo in fieldInfos"-->
              <!--:key="fieldInfo['value']">-->
            <!--<td>{{ fieldInfo.title }}<td >-->
              <!--<div class="btn-group">-->
                <!--<button type="button" class="btn btn-sm"-->
                        <!--:class="{'btn-primary':fieldInfo.type===fieldType.value,'btn-light':fieldInfo.type!==fieldType.value}"-->
                        <!--v-for="fieldType in codeFieldTypes"-->
                        <!--:key="fieldType.value">{{ fieldType.label }}</button>-->
              <!--</div>-->
            <!--</td>-->
            <!--<td>-->
              <!--<div class="btn-group">-->
                <!--<button type="button" class="btn btn-sm"-->
                        <!--:class="{'btn-success': fieldInfo.type===fieldType.value,'btn-light':fieldInfo.type!==fieldType.value}"-->
                        <!--v-for="fieldType in participantFieldTypes"-->
                        <!--:key="fieldType.value">{{ fieldType.label }}</button>-->
              <!--</div>-->
            <!--</td>-->
          <!--</tr>-->
        <!--</tbody>-->
      <!--</table>-->
      </div>
    </template>
  </base-dialog>
</template>

<script>
import baseDialog from '@/views/comps/BaseDialog'

export default {
  components: {
    baseDialog
  },
  data () {
    return {
      title: '',
      fieldInfos: [],
      tempFileKey: '',
      codeFieldTypes: [
        {label: 'Code', value:'code'},
        {label: 'Other', value:'code-other'}
      ],
      participantFieldTypes: [
        {label: 'Name', value:'name'},
        {label: 'Phone', value:'phone'},
        {label: 'Email', value:'email'},
        {label: 'Other', value:'participant-other'}
      ]
    }
  },
  props: {
    value: {
      type: Boolean,
      default: false
    },
    callbackCommand: {
      type: String,
      default: 'noCommand'
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  watch: {
    value: function() {
      const vm = this
      vm.$nextTick(() => {

      })
    }
  },
  methods: {
    selectFieldType (fieldInfo, group, fieldType) {
      const vm = this
      if (fieldType === 'code-other' || fieldType === 'participant-other') {
        fieldInfo.fieldType = fieldType
        return
      }

      var otherType = 'code-other'
      switch (fieldType) {
        case 'code':
          break
        default:
          otherType = 'participant-other'
      }
      for (var i = 0; i < vm.fieldInfos.length; i++) {
        if (vm.fieldInfos[i].fieldType === fieldType) {
          if (vm.fieldInfos[i] !== fieldInfo) {
            vm.fieldInfos[i].fieldType = otherType
          }
        } else {
          if (vm.fieldInfos[i] === fieldInfo) {
            vm.fieldInfos[i].fieldType = fieldType
          }
        }
      }
    },
    preInit (fieldInfos, tempFileKey) {
      const vm = this
      vm.fieldInfos = JSON.parse(JSON.stringify(fieldInfos))
      for(var i = 0; i < vm.fieldInfos.length; i++) {
        if (i === 0) {
          vm.fieldInfos[i].fieldType = 'code'
        } else {
          vm.fieldInfos[i].fieldType = 'code-other'
        }
      }
      vm.tempFileKey = tempFileKey
    },
    onCommandHandler (payload) {
      const vm = this
      console.log('CodeImportDialog :: onCommandHandler :: payload: ', payload)
      console.log('CodeImportDialog :: onCommandHandler :: callbackCommand: ', vm.callbackCommand)
      console.log('CodeImportDialog :: onCommandHandler :: key: ', vm.tempFileKey)
      console.log('CodeImportDialog :: onCommandHandler :: fieldInfos: ', vm.fieldInfos)
      const command = payload.command
      if (command === 'ok') {
        vm.$emit('onCommand', {
          command: vm.callbackCommand,
          key: vm.tempFileKey,
          fieldInfos: vm.fieldInfos
        })
        vm.$emit('input',false)
      }
    }
  }

}
</script>

<style>
  .table.code-import-table tr td:not(:first-child) {
    text-align: center;
  }
  .table.code-import-table tr td {
    white-space: nowrap;
    text-overflow: unset;
    padding-top: 2px;
    padding-bottom: 2px;
    padding-right: 0;
  }
  #codeImportDialog > .modal-dialog .modal-body {
    padding: 0.5rem;
  }

  #codeImportDialog .import-code-content div.row > div:not(:first-child) {
    padding:0 0.05rem !important;
  }
  .table.code-import-table thead th {
    background-color: darkgray;

  }
</style>