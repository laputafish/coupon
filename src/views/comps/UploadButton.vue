<template>
  <div :class="cssClass">
    <xls-file-upload
        inputId="uploadCodes"
        uploadUrl="/agent_codes/upload"
        :postData="{id: record.id}"
        :title="title"
        :size="size"
        cssClass="btn-circle"
        @onUploading="onUploadingHandler"
        @onUploaded="onUploadedHandler"></xls-file-upload>
    <code-import-dialog
        id="codeImportDialog"
        ref="codeImportDialog"
        :importing="uploading"
        :codeFieldsStr="codeFieldNamesStr"
        :codeCount="record.code_count"
        :singleCodeMode="record.has_one_code===1"
        :participantFieldsStr="participantFieldNamesStr"
        callbackCommand="confirmCodeImport"
        @onCommand="onCommandHandler"></code-import-dialog>
  </div>
</template>

<script>
import xlsFileUpload from '@/views/comps/XlsFileUpload'
import codeImportDialog from '@/views/comps/dialogs/CodeImportDialog'

export default {
  components: {
    xlsFileUpload,
    codeImportDialog
  },
  data () {
    return {
      uploading: false
    }
  },
  props: {
    record: {
      type: Object,
      default: null
    },
    title: {
      type: String,
      default: ''
    },
    size: {
      type: String,
      default: 'md'
    },
    cssClass: {
      type: String,
      default: ''
    }
  },
  computed: {
    codeFieldsStr () {
      const vm = this
      return vm.record.code_fields
    },
    codeFieldNamesStr () {
      const vm = this
      var result = ''
      var fieldInfos = []
      if (vm.codeFieldsStr && vm.codeFieldsStr !== '') {
        fieldInfos = vm.codeFieldsStr.split('|')
        var fieldNames = []
        for (var i = 0; i < fieldInfos.length; i++) {
          const segs = fieldInfos[i].split(':')
          const tag = i === 0 ? 'code' : 'code-other'
          fieldNames.push(segs[0] + ':' + tag)
        }
        result = fieldNames.join('|')
      }
      return result
    },
    participantFieldNamesStr () {
      const vm = this
      var result = []
      if (vm.record.participant_configs && vm.record.participant_configs['inputObjs']) {
        const inputObjs = vm.record.participant_configs['inputObjs']
        for (var i = 0; i < inputObjs.length; i++) {
          result.push(inputObjs[i].name);
        }
      }
      return result.join('|')
    }
  },
  methods: {
    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'confirmCodeImport':
          vm.onParsingCodes(payload)
          break
      }
    },
    onUploadingHandler () {
      const vm = this
      vm.uploading = true
      vm.$bvModal.hide('codeImportDialog')
    },

    onParsingCodes (payload) {
      const vm = this
      const postData = {
        urlCommand: '/agent_codes/parse/' + payload.key,
        data: {
          fieldInfos: payload.fieldInfos,
          includeCode: payload.includeCode,
          includeParticipant: payload.includeParticipant,
          singleCodeMode: vm.record.has_one_code
        }
      }

      vm.uploading = true
      vm.$store.dispatch('AUTH_POST', postData).then(
        result => {
          vm.uploading = false

          var msgs = []
          if (result.codeFields) {
            vm.updateCodeFields(result)
            if (result.existing > 0) {
              msgs.push(result.existing + ' code(s) are duplicated')
            } else {
              msgs.push('No code(s) is duplicated')
            }
            if (result.new > 0) {
              msgs.push(result.new + ' code(s) are added')
            } else {
              msgs.push('no code(s) are added')
            }
          }

          if (result.participantConfigs) {
            vm.updateParticipantFields(result)
            msgs.push(result.participantIds.length + ' participant(s) are added')
          }
          vm.$dialog.alert(msgs.join('<br/>'), {html: true})
          vm.$bvModal.hide('codeImportDialog')
          vm.$emit('onCommand', {
            command: 'onUploadCompleted'
          })
          // vm.reloadAll()
        },
        error => {
          vm.uploading = false
          console.log('error: ', error)
        }
      )
    },

    updateCodeFields (result) {
      const vm = this
      const newCodeFieldsStr = result.codeFields
      if (vm.codeFieldsStr !== newCodeFieldsStr) {
        vm.$emit('onCommand', {command: 'setCodeFields', value: newCodeFieldsStr})
      }
      vm.$emit('onCommand', {command: 'setRecordField', fieldName: 'code_count', fieldValue: result.codeCount })
      if (result.code_composition) {
        vm.$emit('onCommand', {command: 'setQrCodeAndBarcodeComposition', data: result.code_composition })
      }
    },

    updateParticipantFields (result) {
      // result = {
      //    participantConfigs
      //    participantIds
      // }
      const vm = this
      const newParticipantConfigs = result.participantConfigs
      const newParticipantCount = result.participantCount
      if (JSON.stringify(vm.record.participant_configs) !== JSON.stringify(newParticipantConfigs)) {
        vm.$emit('onCommand', {
          command: 'updateField',
          fieldName: 'participant_configs',
          fieldValue: newParticipantConfigs
        })
      }
      vm.$emit('onCommand', {command: 'updateField', fieldName: 'participant_count', fieldValue: newParticipantCount })
    },

    onUploadedHandler (result) {
      const vm = this
      // console.log('onUploaded');
      // result = {
      //    codeFields: "barcode:string|serialno:string|actdate:date|exdate:date"
      //    new: 9
      //    updated: 0
      // }
      //
      vm.uploading = false
      // vm.showingCodeImportDialog = true
      vm.$refs.codeImportDialog.preInit(result.fields, result.key)
      vm.$bvModal.show('codeImportDialog')
      // vm.$refs.codeImportDialog.toggle()
    }
  }
}
</script>