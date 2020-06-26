<template>
  <base-dialog
      id="codeImportDialog"
      title="Code Import"
      size="lg"
      modalType="confirmation"
      :okButtonState="allowProceed"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div class="container-fluid">
      <!--<div>-->
        <!--<div class="row bg-lightblue mb-1">-->
        <!--<div class="col-sm-3" style="overflow-x:hidden;white-space:nowrap;text-overflow:ellipsis;">Column Name</div>-->
        <!--<div class="col-sm-3">Code Table</div>-->
        <!--<div class="col-sm-6">Participant Table</div>-->
        <!--</div>-->
        <!--</div>-->
        <div class="d-flex flex-row">
          <!-- Import Code/Participant Table -->
          <div class="flex-grow-1">
            <div class="d-flex flex-column">
              <div class="flex-grow-1 import-code-content"
                   style="max-height:640px;overflow-y:auto;overflow-x:hidden;padding-right:10px;">

                <!-- Headers -->
                <div class="row bg-lightblue" style="position:sticky;top:0;">
                  <div class="col-sm-3 text-center import-table-header"
                       style="border-right:1px solid lightgray;overflow-x:hidden;white-space:nowrap;text-overflow:ellipsis;">Column</div>
                  <div class="col-sm-3 text-center import-table-header"
                       :class="{'disabled':!enableImportCode}"
                       style="border-right:1px solid lightgray;padding-left:5px;padding-right:5px;">
                    <font-awesome-icon
                        class="cursor-pointer"
                        @click="enableImportCode=!enableImportCode"
                        :icon="enableImportCode ? 'check-square' : 'square'"/>
                    Code Table
                  </div>
                  <div class="col-sm-6 text-center import-table-header"
                       :class="{'disabled':!enableImportParticipant}">
                    <font-awesome-icon
                        class="cursor-pointer"
                        @click="enableImportParticipant=!enableImportParticipant"
                        :icon="enableImportParticipant ? 'check-square' : 'square'"/>
                    Participant Table
                  </div>
                </div>

                <!-- Error Message -->
                <div class="row" v-if="hasError">
                  <div class="col-sm-3"></div>
                  <div class="col-sm-3"><div class="badge badge-danger">{{ errorMessages[0] }}</div></div>
                  <div class="col-sm-6"><div class="badge badge-danger">{{ errorMessages[1] }}</div></div>
                </div>

                <!-- Content -->
                <div class="row content-row" v-for="fieldInfo in fieldInfos"
                     :key="fieldInfo.title">
                  <div class="col-sm-3 line-height-1 align-self-center">
                    <div class="badge" :class="getColumnClass(fieldInfo)"
                    >{{ fieldInfo.title }}</div>
                  </div>
                  <!-- Code fields -->
                  <div class="col-sm-3 import-code-table-content"
                       :class="{'disabled bg-muted':!enableImportCode}">
                    <div class="btn-group mt-1">
                      <button type="button" class="btn btn-sm"
                              :class="{'btn-primary':fieldInfo.fieldType===fieldType.value,'btn-light':fieldInfo.fieldType!==fieldType.value}"
                              @click="selectFieldType(fieldInfo, 'code', fieldType.value)"
                              v-for="fieldType in codeFieldTypes"
                              :key="fieldType.value">{{ fieldType.label }}</button>
                    </div>
                  </div>
                  <!-- Participant fields -->
                  <div class="col-sm-6 import-code-table-content"
                       :class="{'disabled bg-muted':!enableImportParticipant}">
                    <div class="btn-group ml-2 mt-1">
                      <button type="button" class="btn btn-sm"
                              :class="{'btn-success': fieldInfo.fieldType===fieldType.value,'btn-light':fieldInfo.fieldType!==fieldType.value}"
                              @click="selectFieldType(fieldInfo, 'participant', fieldType.value)"
                              v-for="fieldType in participantFieldTypes"
                              :key="fieldType.value">{{ fieldType.label }}</button>
                    </div>
                  </div>
                </div>
              </div>

              <div class="flex-grow-0">
                <!--<div style="font-size:80%;" class="mt-2 line-height-1">-->
                <!--* Import will append data only. Columns must match existing data before going ahead.-->
                <!--</div>-->
                <div v-if="singleCodeMode" style="font-size:80%;"
                     class="mt-2 line-height-1 d-flex flex-row align-items-center">
                * Single code mode - only first code will be saved.
                </div>
                <div v-if="singleCodeMode && codeCount>0" style="font-size:80%;"
                     class="mt-2 line-height-1">
                  * One code existed. Replace?
                  <data-radio-toggle
                    v-model="replaceSingleCode"
                    :enabled="enableImportCode"
                    class="ml-2"
                    btnClass="btn-sm"
                    :options="yesNoOptions"></data-radio-toggle>
                </div>
              </div>
              <!--<div class="flex-grow-0">-->
              <!--<hr/>-->
              <!--<div>-->
              <!--Import Mode-->
              <!--<data-radio-toggle-->
              <!--class="ml-2"-->
              <!--:options="importModes"-->
              <!--v-model="importMode"></data-radio-toggle>-->
              <!--</div>-->
              <!--</div>-->
            </div>
          </div>

          <!-- Existing Fields -->
          <div class="flex-grow-1 ml-1 d-flex flex-column justify-content-stretch"
               style="min-width:300px;">
            <div class="flex-grow-1 flex-grow-1 scrolling-pane">
              <div class="px-2 existing-fields-container">
                <div class="row bg-lightblue" style="position:sticky;top:0;">
                  <div class="col-sm-12 text-center">
                    Existing Fields
                  </div>
                </div>
                <div class="row bg-lightblue" style="position:sticky;top:0;">
                  <div class="col-sm-6 text-center px-2">Code Table</div>
                  <div class="col-sm-6 text-center px-2" style="white-space:nowrap;text-overflow:none;">Participant Table</div>
                </div>
                <div class="row">
                  <div class="col-sm-6">
                    <ul class="existing-field-list">
                      <li class="existing-field" v-for="(codeField, index) in codeFields">
                      {{ codeField }}
                      </li>
                    </ul>
                  </div>
                  <div class="col-sm-6">
                    <ul class="existing-field-list">
                      <li class="existing-field" v-for="(participantField, index) in participantFields">
                      {{ participantField }}
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div v-if="importing" class="backdrop d-flex flex-column justify-content-center align-items-center text-white">
          <font-awesome-icon icon="spinner"
                             class="fa-spin"></font-awesome-icon>
        </div>
      </div>
    </template>
  </base-dialog>
</template>

<script>
import baseDialog from '@/views/comps/BaseDialog'
import DataRadioToggle from "@/views/comps/forms/DataRadioToggle";

export default {
  components: {
    DataRadioToggle,
    baseDialog
  },
  computed: {
    allowProceed () {
      const vm = this
      var result = !vm.hasError && !vm.importing && (vm.enableImportCode || vm.enableImportParticipant)
      console.log('allowProceed :: hasError = ' + vm.hasError)
      console.log('allowProceed :: importing = ' + vm.importing)
      console.log('allowProceed :: includeCode = ' + vm.enableImportCode)
      console.log('allowProceed :: includeParticipant = ' + vm.enableImportParticipant)
      console.log('allowProceed :: singleCodeMode = ' + vm.singleCodeMode)
      console.log('allowProceed :: codeCount = ' + vm.codeCount)
      if (vm.enableImportCode && vm.singleCodeMode && vm.codeCount>0) {
        result = result && vm.replaceSingleCode===1
      }
      return result
    },
    userFieldStrs () {
      const vm = this
      var result = {
        code: '',
        participant: ''
      }
      var codeFieldNames = []
      var participantFieldNames = []

      for (var i = 0; i < vm.fieldInfos.length; i++) {
        const fieldInfo = vm.fieldInfos[i]
        const fieldType = fieldInfo.fieldType
        switch (fieldType) {
          case 'code':
          case 'code-other':
            codeFieldNames.push(fieldInfo.title + ':' + fieldType)
            break
          case 'name':
          case 'email':
          case 'phone':
          case 'participant-other':
            participantFieldNames.push(fieldInfo.title)
            break
        }
      }
      if (codeFieldNames.length > 0) result.code = codeFieldNames.join('|')
      if (participantFieldNames.length > 0) result.participant = participantFieldNames.join('|')

      return result
    },
    hasError () {
      return this.errorMessages[0] !== '' || this.errorMessages[1] !== ''
    },
    errorMessages () {
      const vm = this
      var messages = ['', '']

      if (vm.enableImportCode && vm.errorCode && vm.errorCode !== '') messages[0] = vm.errorCode
      if (vm.enableImportParticipant && vm.errorParticipant && vm.errorParticipant !== '') messages[1] = vm.errorParticipant

      return messages
    },

    errorCode () {
      const vm = this
      var result = ''
      if (!vm.singleCodeMode && vm.hasCode && vm.importMode === 'append' && vm.codeFieldsStr !== vm.userFieldStrs.code) {
        result = 'Mismatched'
      }
      return result
    },

    errorParticipant () {
      const vm = this
      var result = ''
      if (vm.hasParticipant && vm.importMode === 'append' && vm.participantFieldsStr !== vm.userFieldStrs.participant) {
        result = 'Mismatched'
      }
      return result
    },

    hasCode () {
      const vm = this
      return vm.codeFieldsStr && vm.codeFieldsStr !== ''
    },

    codeFields () {
      const vm = this
      var result = []
      if (vm.hasCode) {
        const codeFieldInfo = vm.codeFieldsStr.split('|')
        for (var i = 0; i < codeFieldInfo.length; i++) {
          const segs = codeFieldInfo[i].split(':')
          result.push(segs[0])
        }
      }
      return result
    },

    hasParticipant () {
      const vm = this
      return vm.participantFieldsStr && vm.participantFieldsStr !== ''
    },

    participantFields () {
      const vm = this
      var result = []
      if (vm.hasParticipant) {
        result = vm.participantFieldsStr.split('|')
      }
      return result
    }
  },
  data () {
    return {
      replaceSingleCode: 0,
      yesNoOptions: [
        {name: 'Yes', value: 1},
        {name: 'No', value: 0}
      ],
      importMode: 'new', // add or append
      importModes: [
        {name: 'New / Overwrite', value: 'new'},
        {name: 'Append', value: 'append'}
      ],
      enableImportCode: true,
      enableImportParticipant: true,
      title: '',
      fieldInfos: [],
      tempFileKey: '',
      codeFieldTypes: [
        {label: 'Code', value: 'code'},
        {label: 'Other', value: 'code-other'}
      ],
      participantFieldTypes: [
        {label: 'Name', value: 'name'},
        {label: 'Phone', value: 'phone'},
        {label: 'Email', value: 'email'},
        {label: 'Other', value: 'participant-other'}
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
    },
    codeFieldsStr: {
      type: String,
      default: ''
    },
    participantFieldsStr: {
      type: String,
      default: ''
    },
    importing: {
      type: Boolean,
      default: false
    },
    singleCodeMode: {
      type: Boolean,
      default: false
    },
    codeCount: {
      type: Number,
      default: 0
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  mounted () {
  },
  watch: {
    value: function () {
      const vm = this
      vm.$nextTick(() => {

      })
    }
  },
  methods: {
    getColumnClass (fieldInfo) {
      const vm = this
      switch (fieldInfo.fieldType) {
        case 'code':
        case 'code-other':
          return 'badge-primary'
        case 'name':
        case 'phone':
        case 'email':
        case 'participant-other':
          return 'badge-success'
      }
    },

    // group = ['code', 'participant']
    selectFieldType (fieldInfo, group, fieldType) {
      // console.log('CodeImportDialog :: selectFieldType :: fieldInfo.fieldtype = ' + fieldInfo.fieldType)
      // console.log('CodeImportDialog :: selectFieldType :: fieldType = ' + fieldType)

      const vm = this
      if (fieldInfo.fieldType === fieldType) {
        // console.log('same field clicked again => deselect it')
        fieldInfo.fieldType = 'none'
        return
      }

      var otherType = group === 'code' ? 'code-other' : 'participant-other'
      for (var i = 0; i < vm.fieldInfos.length; i++) {
        // console.log('#' + i + ': vm.fieldInfos[i]: ', vm.fieldInfos[i])
        // console.log('#' + i + ': vm.fieldInfos[i].fieldType = ' + vm.fieldInfos[i].fieldType)
        // console.log('#' + i + ': otherType = ' + otherType)

        // loop each field
        if (vm.fieldInfos[i].fieldType === fieldType) {
          // console.log('vm.fieldInfos[i].fieldType === fieldType')
          if (vm.fieldInfos[i] !== fieldInfo && fieldType !== otherType) {
            // if fieldType correct but not expected, set it to other

            // console.log('not the field in consideration')
            vm.fieldInfos[i].fieldType = otherType
          }
        } else {
          if (vm.fieldInfos[i] === fieldInfo) {
            // console.log('if it is the field in consideration')
            // if fieldType not in consideration, but the is the field should be, change it
            vm.fieldInfos[i].fieldType = fieldType
          }
        }
      }
      vm.fieldInfos = JSON.parse(JSON.stringify(vm.fieldInfos))
    },

    preInit (fieldInfos, tempFileKey) {
      const vm = this
      vm.fieldInfos = JSON.parse(JSON.stringify(fieldInfos))
      for (var i = 0; i < vm.fieldInfos.length; i++) {
        if (i === 0) {
          vm.fieldInfos[i].fieldType = 'code'
        } else {
          vm.fieldInfos[i].fieldType = 'code-other'
        }
      }
      vm.tempFileKey = tempFileKey
    }
    ,
    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      switch (command) {
        case 'ok':
          vm.$emit('onCommand', {
            command: vm.callbackCommand,
            key: vm.tempFileKey,
            fieldInfos: vm.fieldInfos,
            importMode: vm.importMode,
            includeCode: vm.enableImportCode,
            includeParticipant: vm.enableImportParticipant
          })
          vm.$emit('input', false)
          break
        case 'onShown':
          vm.enableImportCode = true
          vm.enableImportParticipant = true
          vm.importMode = 'append'
          break
      }
    }
  }

}
</script>

<style>
  /*.table.code-import-table tr td:not(:first-child) {*/
  /*text-align: center;*/
  /*}*/
  /*.table.code-import-table tr td {*/
  /*white-space: nowrap;*/
  /*text-overflow: unset;*/
  /*padding-top: 2px;*/
  /*padding-bottom: 2px;*/
  /*padding-right: 0;*/
  /*}*/
  /*#codeImportDialog > .modal-dialog .modal-body {*/
  /*padding: 0.5rem;*/
  /*}*/

  /*#codeImportDialog .import-code-content div.row > div:not(:first-child) {*/
  /*padding:0 0.05rem !important;*/
  /*}*/
  /*.table.code-import-table thead th {*/
  /*background-color: darkgray;*/

  /*}*/

  .import-code-content {
    padding-right: 16px;
  }

  .import-code-content div.row.content-row:last-child div:not(:first-child) {
    padding-bottom: 2px;
  }

  .import-code-content div.row div.import-table-header.disabled {
    background-color: rgba(255, 255, 255, .5);
  }

  .import-code-content div.row div.import-code-table-content.disabled button {
    color: rgba(128, 128, 128, .5);
  }

  .import-code-content div.row div.import-code-table-content.disabled button.btn-primary,
  .import-code-content div.row div.import-code-table-content.disabled button.btn-success {
    background-color: rgba(255, 255, 255, .1);
    border-color: rgba(0, 0, 0, 0.1);
  }

  .import-code-content div.row.content-row div:not(:first-child) {
    padding: 1px 2px 0 2px;
  }

  .import-code-content div.row:first-child {
    z-index: 1000;
  }

  #codeImportDialog .existing-field-list {
    list-style: none;
    padding-left: 0;
  }

  #codeImportDialog .existing-field {
    padding: 2px 5px;
    text-align: center;
    widdth: 100%;
    border: 1px solid lightgray;
    border-radius: 0.5rem;
    margin-top: 5px;
    background-color: rgba(250, 250, 250, .8);
  }

  #codeImportDialog .scrolling-pane {
    overflow: hidden auto;
    background-color: rgba(128, 128, 128, .2);
    border: 2px solid lightgray;
    background-color: lightblue;
    border-radius: 0.5rem;
  }

  #codeImportDialog .existing-field-container {
    border-radius: 0.5rem;
    border: 2px solid transparent;
  }
</style>