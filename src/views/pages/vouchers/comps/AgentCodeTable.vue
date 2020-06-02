<template>
<div class="py-2 px-3 agent-code-table">
  <div class="toolbar d-flex justify-content-between mb-1">
    <search-field
        :searchValue="searchValue"
        :appLoading="appLoading"
        @onCommand="onCommandHandler"></search-field>
    <div>
      <button type="button"
              class="btn btn-outline-primary min-width-100 mr-1"
              @click="reloadCodeList()">
        <i class="fas fa-recycle"></i>
        <span class="ml-2">Refresh</span>
      </button>
      <button type="button"
              :disabled="data.length===0"
              class="btn btn-danger min-width-100 mr-1"
              @click="deleteAll()">
        <i class="fas fa-times"></i>
        <span class="ml-2">{{ $t('buttons.deleteAll') }}</span>
      </button>
      <button type="button"
              :disabled="data.length===0"
              class="btn btn-warning min-width-100 mr-1"
              @click="exportExcel()">
        <i class="fas fa-download"></i>
        <span class="ml-2">{{ $t('buttons.export') }}</span>
      </button>
      <xls-file-upload
          inputId="uploadCodes"
          uploadUrl="/agent_codes/upload"
          :postData="{id: voucherId}"
          @onUploading="onUploadingHandler"
          @onUploaded="onUploadedHandler"></xls-file-upload>
    </div>
  </div>
  <div v-if="data.length>0" id="code-table">
     <datatable v-cloak v-bind="$data"
                :columns="columns"></datatable>
  </div>
  <!--<b-modal id="codeInfoDialog"-->
  <!--v-model="selectedRow"-->
  <!--:title="$t('general.coupon')+': '+selectedRow.code">-->
  <!--<div class="container-fluid">-->
  <!--<div class="row">-->
  <!--<div class="col-12">-->
  <!--<div class="form-group">-->
  <!--</div>-->
  <!--</div>-->
  <!--</div>-->
  <!--</div>-->
  <!--</b-modal>-->
  <vue-loading
      :active.sync="uploading"
      :can-cancel="true"></vue-loading>
  <div v-if="loading" id="loadingMask" class="text-center">
    <h3 class="d-inline-block mr-auto">
       <font-awesome-icon icon="spinner" class="fa-spin fa-3x"/>
    </h3>
  </div>

  <code-import-dialog
      ref="codeImportDialog"
      v-model="showingCodeImportDialog"
      callbackCommand="confirmCodeImport"
      @onCommand="onCommandHandler"></code-import-dialog>

  <delete-all-codes-dialog
    ref="deleteAllCodesDialog"
    v-model="showingDeleteAllCodesDialog"
    @onCommand="onCommandHandler"></delete-all-codes-dialog>

</div>
</template>

<script>
import Vue from 'vue'
import dtCommon from '@/views/comps/datatable'
import dtComps from './dtComps'
import xlsFileUpload from '@/views/comps/XlsFileUpload'
import searchField from './comps/SearchField'
import codeImportDialog from '../dialogs/CodeImportDialog'
import deleteAllCodesDialog from '../dialogs/DeleteAllCodesDialog'

// import helpers from '@/helpers'

export default {
  components: {
    ...dtCommon,
    ...dtComps,
    xlsFileUpload,
    searchField,
    codeImportDialog,
    deleteAllCodesDialog
    // ,
    // helpers
  },
  data () {
    return {
      showingDeleteAllCodesDialog: false,
      showingCodeImportDialog: false,
      importedFileKey: '',
      importedFieldInfos: [],
      uploadRoute: '/agent_codes/upload',
      appLoading: false,
      uploading: false,
      loading: false,

      columns: [],
      allData: [],
      data: [],
      total: 0,
      query: {
        filter: '',
        sort: '',
        order: '',
        page: 0
      },
      xprops: {
        buttons: ['view', 'delete', 'update'],
        // buttons: ['edit','view','delete'],
        eventbus: new Vue(),
        actionButtonSize: 'xs'
      },
      HeaderSettings: false,
      selectedRow: null,
      defaultColumns: [
        {
          title: 'general.key',
          thComp: 'ThCommonHeader',
          tdClass: 'align-middle',
          tdComp: 'TdKey',
          field: 'key',
          sortable: true
        },
        {
          title: 'general.remark',
          thComp: 'ThCommonHeader',
          tdClass: 'align-middle',
          tdComp: 'TdCommonInput',
          field: 'remark'
        },
        // {
        //   title: 'vouchers.sent_on',
        //   thComp: 'ThCommonHeader',
        //   tdClass: 'align-middle',
        //   tdComp: 'TdCommonInputDate',
        //   field: 'sent_on',
        //   sortable: true
        // },
        {
          title: 'general.status',
          thComp: 'ThCommonHeader',
          thClass: 'text-center',
          tdClass: 'align-middle text-center',
          tdComp: 'TdCodeStatus',
          field: 'status',
          sortable: true
        },
        {
          title: 'general.action',
          thComp: 'ThCommonHeader',
          tdClass: 'align-middle',
          tdComp: 'TdCommonOpt',
          field: 'id',
          sortable: true
        }
      ],
      searchValue: '',
      searchInputTimer: 3000,
      filterFields: '*'
      // ,      codeInfos: {
      //   type: Array,
      //   default () {
      //     return []
      //   }
      // }
    }
  },
  computed: {
    voucherId () {
      const vm = this
      var result = 0
      if (vm.record) {
        result = vm.record.id
      }
      return result
    },
    codeFieldsStr () {
      const vm = this
      return vm.record.code_fields
    }
  },
  props: {
    // voucherId: {
    //   type: Number,
    //   default: 0
    // },
    // codeFieldsStr: {
    //   type: String,
    //   default: ''
    // },
    record: {
      type: Object,
      default: null
    }
  },
  watch: {
    files: {
      handler: function () {
        const vm = this
        if (vm.voucherId === 0) {
          alert('voucherId === 0')
          vm.$emit('onCommand', {
            command: 'save',
            callback: response => {
              vm.voucherId = response.id
            }
          })
        }
      },
      deep: true
    },
    // codeInfos: {
    //   handler: function (newValue) {
    //     // console.log('AgentCodeTable :: watch(codeInfos) :: newValue: ', newValue)
    //     const vm = this
    //     vm.setTableData(newValue)
    //     vm.refreshList()
    //   },
    //   deep: true
    // },
    codeFieldsStr: function (newValue) {
      // codeFields is string in format:
      //
      // Code:string|Serial No:string|activate_date:date
      //
      // console.log('watch(codeFieldsStr) : newValue: ' + newValue)
      const vm = this
      // console.log('watch(codeFieldsStr) :: newValue: ', newValue)
      vm.setColumns(newValue)
    },
    voucherId: {
      handler: function (newValue) {
        const vm = this
        if (vm.voucherId !== 0) {
          // console.log('watch(voucherId) :: voucherId = ' + newValue)
          vm.onQueryChangedHandler(newValue)
        }
      }
    },
    query: {
      handler: function (newValue) {
        const vm = this
        if (vm.voucherId !== 0) {
          // console.log('watch(query) && voucherId !== 0: ', vm.voucherId)
          vm.onQueryChangedHandler(newValue)
        }
        // console.log('AGentCodeTable :: watch(query): ', newValue)
        // vm.refreshList()
      },
      deep: true
    },
    searchValue: function () {
      const vm = this
      // console.log('AgentCodeTable :: searchValue = ' + newValue)
      if (vm.filterFields && vm.filterFields !== null) {
        if (vm.searchInputTimer !== 0) {
          clearTimeout(vm.searchInputTimer)
        }
        vm.searchInputTimer = setTimeout(vm.setSearchValue, 2000)
        // console.log('AgentCodeTable :: searchInputTimer: ', vm.searchInputTimer)
      } else {
        vm.alert('No filter fields defined!')
      }
    }
  },
  mounted () {
    const vm = this
    vm.setColumns(vm.codeFieldsStr)
    // vm.setTableData(vm.codeInfos)
    vm.query.page = 1
    vm.xprops.record = vm.record
    vm.showingCodeImportDialog = false
    vm.showingDeleteAllCodesDialog = false
  },
  created () {
    const vm = this
    vm.xprops.eventbus.$on('onRowCommand', vm.onRowCommandHandler)
  },
  destroyed () {
    const vm = this
    vm.xprops.eventbus.$off('onRowCommand')
  },
  methods: {
    onCommandHandler (payload) {
      const vm = this
      // console.log('AgentCodeTable :: onCommandHandler :: payload: ', payload)
      const command = payload.command
      switch (command) {
        case 'search':
          vm.searchValue = payload.searchValue
          break
        case 'confirmCodeImport':
          vm.onParsingCodes(payload)
          break
        case 'deleteAllCodes':
          vm.doDeleteAll()
          if (typeof payload.callback === 'function') {
            payload.callback()
          }
          break
        case 'deleteAllCodesAndParticipants':
          vm.doDeleteAll()
          vm.doDeleteAllParticipants()

          if (typeof payload.callback === 'function') {
            payload.callback()
          }
      }
    },
    saveCodeInfo (row) {
      // console.log('saveCodeInfo : row: ', row)
      const vm = this
      const codeInfo = vm.row2CodeInfo(row)
      const data = {
        urlCommand: '/vouchers/' + vm.voucherId + '/codes/' + row.id,
        data: codeInfo
      }
      vm.$store.dispatch('AUTH_PUT', data).then(
        () => {
          vm.$toaster.success(vm.$t('messages.saved_successfully'))
        }
      ).catch(
        () => {
          vm.$toaster.danger(vm.$t('messages.saved_failed'))
        }
      )
    },

    exportExcel () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'export'
      })
    },

    deleteAll () {
      const vm = this
      if (vm.record.participant_count > 0) {
        vm.showingDeleteAllCodesDialog = true
      } else {
        vm.$dialog.confirm(vm.$t('messages.areYouSure')).then(
          () => {
            vm.doDeleteAll()
            vm.$emit('onCommand', {
              command: 'setRecordField',
              fieldName: 'code_count',
              fieldValue: 0
            })
          }
        )
      }
    },

    doDeleteAllParticipants () {
      const vm = this
      const data = {
        urlCommand: '/vouchers/' + vm.voucherId + '/participants'
      }
      vm.$store.dispatch('AUTH_DELETE', data).then(() => {
        vm.$toaster.success(vm.$t('messages.all_participants_are_removed'))
        vm.onQueryChangedHandler(vm.query)
        vm.$emit('onCommand', {
          command: 'setRecordField',
          fieldName: 'participant_count',
          fieldValue: 0
        })

      })
    },

    doDeleteAll () {
      const vm = this
      const data = {
        urlCommand: '/vouchers/' + vm.voucherId + '/codes'
      }
      vm.$store.dispatch('AUTH_DELETE', data).then(() => {
        vm.$toaster.success(vm.$t('messages.all_codes_are_removed'))
        vm.$emit('onCommand', {
          command: 'setQrCodeComposition',
          data: ''
        })
        vm.$emit('onCommand', {
          command: 'setCodeFields',
          value: ''
        })
        vm.$emit('onCommand', {
          command: 'setRecordField',
          fieldName: 'code_count',
          fieldValue: 0
        })
        vm.onQueryChangedHandler(vm.query)
      })
    },
    setSearchValue (search) {
      const vm = this

      // console.log('setSearchValue : search: ', search)
      if (typeof search === 'undefined') {
        search = vm.searchValue
      } else {
        vm.searchValue = search
      }
      if (search) {
        vm.query.filter = vm.filterFields + ':' + search
      } else {
        vm.query.filter = ''
      }
      vm.searchInputTimer = 0
    },
    clearSearch () {
      const vm = this
      vm.query.filter = vm.filterFields + ':'
      vm.onQueryChangedHandler(vm.query)
    },

    getFilterValue (filter) {
      // const vm = this
      const filterItems = filter.split(';')
      let result = ''
      for (let i = 0; i < filterItems.length; i++) {
        const keyValue = filterItems[i].split(':')
        if (keyValue[0] === '*') {
          result = keyValue[1]
          break
        }
      }
      return result
    },

    onQueryChangedHandler (query) {
      const vm = this
      vm.reloadCodeList(query)
    },

    reloadCodeList (query) {
      const vm = this
      vm.loading = true
      if (typeof query === 'undefined') {
        query = vm.query
      }
      if (vm.voucherId === 0) {
        alert('vm.voucherId = 0')
        return
      }
      const data = {
        urlCommand: '/vouchers/' + vm.voucherId + '/codes',
        query: query
      }
      vm.$store.dispatch('AUTH_GET', data).then(response => {
        // console.log('AUTH_GET :: response: ', response)
        vm.total = response.total
        vm.data = vm.parseCodeInfoData(response.data)
        vm.$forceUpdate()
        vm.loading = false
      })
    },

    row2CodeInfo (row) {
      const vm = this
      const codeFields = vm.getCodeFieldsFromStr(vm.codeFieldsStr);
      const codeFieldCount = codeFields.length
      const code = row['field0']
      const extraFieldsArray = []
      for (let i = 1; i < codeFieldCount; i++) {
        const fieldName = 'field' + i
        extraFieldsArray.push(row[fieldName])
      }

      return {
        id: row.id,
        order: row.order,
        code: code,
        'extra_fields': extraFieldsArray.join('|'),
        key: row.key,
        remark: row.remark,
        'sent_on': row.sent_on,
        status: row.status
      }
    },
    onRowCommandHandler (payload) {
      const vm = this
      // console.log('AgentCodeTable :: onRowCommandHandler :: payload: ', payload)
      switch (payload.command) {
        case 'edit':
          alert('onRowCommandHandler :; edit')
          break
        case 'view':
          vm.$emit('onCommand', {
            command: 'view_leaflet',
            row: payload.row
          })
          break
        case 'delete':
          vm.$dialog.confirm(vm.$t('messages.areYouSure'))
            .then(() => {
              vm.$emit('onCommand', {
                command: 'delete_code_info',
                index: payload.index
              })
            })
          break
        case 'update': // = save
          vm.saveCodeInfo(payload.row);
          break
        case 'resetStatus':
          vm.resetStatus(payload)
          break
          // vm.$emit('onCommand', {
          //   command: 'resetStatus',
          //   row: payload.row
          // })
        case 'updateField':
          // console.log('AgentCodeTable :: onRowCommandHandler :: updateField: payload: ', payload)
          // vm.$emit('onCommand', {
          vm.setCodeFieldValue(
            payload.row,
            // vm.row2CodeInfo(payload.row),
            payload.fieldName,
            payload.fieldValue
          )
          // )
          //   command: 'update_code_info_field',
          //   row: vm.row2CodeInfo(payload.row),
          //   fieldName: payload.fieldName,
          //   fieldValue: payload.fieldValue
          // })
          break
      }
    },
    setCodeFieldValue (row, fieldName, fieldValue) {
      const vm = this
      for (let i = 0; i < vm.data.length; i++) {
        if (vm.data[i] == row) {
          // console.log('vm.data[' + i + '] == row')
          vm.data[i][fieldName] = fieldValue
          break
        } else {
          // console.log('vm.data[' + i + '] not equals to row')
        }
      }
    },
    setCodeFieldValue2 (row, fieldName, fieldValue) {
      const vm = this
      for (let i = 0; i < vm.data.length; i++) {
        const codeInfo = vm.data[i]
        if (codeInfo['code'] === row['code'] && codeInfo['extra_fields'] === row['extra_fields']) {
          vm.data[i][fieldName] = fieldValue
          break
        }
      }
    },

    resetStatus (payload) {
      const vm = this
      const postData = {
        urlCommand: '/agent_codes/' + payload.row.id + '/reset_status'
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        () => {
          vm.$toaster.success(vm.$t('messages.code_status_has_been_reset'))
          vm.reloadCodeList()
        }
      )
    },

    getCodeFieldsFromStr (fieldStr) {
      const result = []
      // console.log('getCodeFieldsFromStr: fieldStr = ' + fieldStr)
      if (fieldStr !== null && fieldStr !== '') {
        const arTitleType = fieldStr.split('|')
        for (let i = 0; i < arTitleType.length; i++) {
          const titleTypePair = arTitleType[i]
          const segs = titleTypePair.split(':')
          result.push({
            title: segs[0],
            type: segs[1]
          })
        }
      }
      // console.log('getCodeFieldsFromStr: result: ', result)
      return result
    },

    setColumns (fieldsStr) {
      // Input : fieldsStr
      //
      // Code:string|Serial No:string|activate_date:date
      //
      const vm = this
      // console.log('setColumns: fieldsStr = ' + fieldsStr)
      const codeFields = vm.getCodeFieldsFromStr(fieldsStr);
      // codeFields = [
      //    {
      //      title: 'title 1',
      //      type: 'number'
      //    },
      //    {
      //      title: 'title 2',
      //      type: 'string'
      //    },
      //
      //
      vm.columns = [{
        title: vm.$t('general.number'),
        tdClass: 'text-center',
        thClass: 'text-center',
        tdComp: 'TdCommonIndex',
        field: 'id'
      }];

      for (let i = 0; i < codeFields.length; i++) {
        const field = codeFields[i]
        let tdClass = 'text-left align-middle'
        let thClass = 'text-left'
        switch (field['type']) {
          case 'date':
          case 'integer':
            tdClass = 'text-center align-middle'
            thClass = 'text-center align-middle'
            break;
        }
        vm.columns.push({
          title: field['title'],
          thComp: 'ThBadgeHeader',
          tdClass: tdClass,
          thClass: thClass,
          field: 'field' + i
        })
      }
      for (let j = 0; j < vm.defaultColumns.length; j++) {
        vm.columns.push(vm.defaultColumns[j])
      }
    },

    parseCodeInfoData (infoData) {
      const vm = this
      let result = []
      if (vm.columns) {
        for (let i = 0; i < infoData.length; i++) {
          const codeRecord = infoData[i]
          const fieldsStr = codeRecord['code'] + '|' + codeRecord['extra_fields']
          const arFieldValues = fieldsStr.split('|')

          const obj = {
            id: codeRecord['id'],
            order: codeRecord['order']
          }
          for (let j = 0; j < arFieldValues.length; j++) {
            obj['field' + j] = arFieldValues[j]
          }
          obj['status'] = codeRecord['status']
          obj['key'] = codeRecord['key']
          obj['remark'] = codeRecord['remark']
          obj['error_message'] = codeRecord['error_message']
          obj['participant_name'] = codeRecord['participant'] ? codeRecord['participant']['name'] : null
          obj['participant_email'] = codeRecord['participant'] ? codeRecord['participant']['email'] : null
          obj['participant_phone'] = codeRecord['participant'] ? codeRecord['participant']['phone'] : null
          obj['sent_on'] = codeRecord['sent_on']
          result.push(obj)
        }
      } else {
        result = infoData
      }
      return result
    },

    // setTableData (tableData) {
    //   const vm = this
    //   vm.allData = vm.parseCodeInfoData(tableData)
    //   vm.total = vm.allData.length
    // },

    onUploadingHandler () {
      const vm = this
      vm.uploading = true
      vm.showingCodeImportDialog = false
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
      vm.showingCodeImportDialog = true
      vm.$refs.codeImportDialog.preInit(result.fields, result.key)
    },

    onParsingCodes (payload) {
      const vm = this
      const postData = {
        urlCommand: '/agent_codes/parse/' + payload.key,
        data: {
          fieldInfos: payload.fieldInfos
        }
      }

      vm.uploading = true
      vm.$store.dispatch('AUTH_POST', postData).then(
        result => {
          vm.uploading = false

          if (result.codeFields) {

            const newCodeFieldsStr = result.codeFields
            if (vm.codeFieldsStr == newCodeFieldsStr) {
            } else {
              vm.$emit('onCommand', {
                command: 'setCodeFields',
                value: newCodeFieldsStr
              })
              vm.$emit('onCommand', {
                command: 'setRecordField',
                fieldName: 'code_count',
                fieldValue: result.codeCount
              })
              if (result.code_composition) {
                vm.$emit('onCommand', {
                  command: 'setQrCodeComposition',
                  data: result.code_composition
                })
              }
            }

            const newParticipantConfigs = result.participantConfigs
            console.log('parse: vm.record.participant_configs: ', vm.record.participant_configs)
            console.log('parse: newParticipantConfigs: ', newParticipantConfigs)
            console.log('parse: result.participantCount: ', result.participantCount)

            if (JSON.stringify(vm.record.participant_configs) === JSON.stringify(newParticipantConfigs)) {
              console.log('participant configs no changed')
            } else {

              vm.$emit('onCommand', {
                command: 'updateField',
                fieldName: 'participant_configs',
                fieldValue: newParticipantConfigs
              })
              vm.$emit('onCommand', {
                command: 'updateField',
                fieldName: 'participant_count',
                fieldValue: result.participantCount
              })
            }

            console.log('after')
            console.log('parse: vm.record.participant_configs: ', vm.record.participant_configs)

            let msgs = []
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
            vm.$toaster.success(msgs.join(' and ') + '.')
            vm.onQueryChangedHandler(vm.query)
          } else {
            vm.$dialog.alert(vm.$t('messages.error_occurred_maybe_invalid_format'))
          }
        },
        error => {
          vm.uploading = false
          console.log('error: ', error)
        }
      )
    },
    // onUploaded2 (result) {
    //   const vm = this
    //   // result = {
    //   //    fields: [
    //   //      {title: 'PCC', type: 'string'},
    //   //      {title: 'PCC', type: 'string'},
    //   //      {title: 'PCC', type: 'string'},
    //   //      {title: 'PCC', type: 'string'}
    //   //    ],
    //   //    values: [ ... ]
    //   // }
    //   //
    //   const newCodeFieldsStr = vm.getCodeFieldsStrFromArray(result.fields)
    //   console.log('onUploaded :: newCodeFieldsStr: ', newCodeFieldsStr)
    //   // let goAhead = true
    //   // console.log('codeFieldsStr = [' + vm.codeFieldsStr + ']')
    //   // console.log('newCodeFieldsStr = [' + newCodeFieldsStr + ']')
    //   if (vm.codeFieldsStr !== '' && vm.codeFieldsStr !== null) {
    //     if (newCodeFieldsStr !== vm.codeFieldsStr) {
    //       // goAhead = false
    //       const options = {
    //         okText: vm.$t('buttons.continue'),
    //         cancelText: vm.$t('buttons.cancel')
    //       }
    //       vm.$dialog.confirm(vm.$t('messages.fields_not_matched_please_delete_all_first'), options).then(
    //         () => {
    //           vm.$emit('onCommand', {
    //             command: 'clear_all_code_info',
    //             callback: () => {
    //               vm.importCodes(result)
    //             }
    //           })
    //         }
    //       )
    //     } else {
    //       vm.importCodes(result)
    //     }
    //   } else {
    //     vm.importCodes(result)
    //   }
    // },
    //
    // importCodes (result) {
    //   console.log('importCodes :: result: ', result)
    //   const vm = this
    //   // const newCodeFieldsStr = vm.getCodeFieldsStrFromArray(result.fields)
    //
    //   // console.log('codeFieldsStr: ' + vm.codeFieldsStr)
    //   // console.log('newCodeFieldsStr = ' + newCodeFieldsStr)
    //
    //   // console.log('equal: ' + (vm.codeFieldsStr === newCodeFieldsStr ? 'yes' : 'no'))
    //   vm.$emit('onCommand', {
    //     command: 'setCodeFields',
    //     value: result.fields
    //   })
    //   vm.$emit('onCommand', {
    //     command: 'setCodeDataRows',
    //     value: result.data
    //   })
    //
    //   vm.$emit('onCommand', {
    //     command: 'setQrCodeComposition',
    //     data: helpers.str2token('code_', result.fields[0].title)
    //   })
    // },
    getCodeFieldsStrFromArray (fields) {
      const result = []
      for (let i = 0; i < fields.length; i++) {
        result.push(fields[i].title + ':' + fields[i].type)
      }
      return result.join('|')
    },
    // onSuccess () {
    //   alert('AgentCodeTable')
    //   // alert('success')
    // },

    search () {
    }

    // editSave() {
    //   console.log('editSave')
    //   this.edit = false
    //   // let file = this.files[0]
    //   // let oldFile = this.files[0]
    //   // let binStr = atob(this.cropper.getCroppedCanvas().toDataURL(oldFile.type).split(',')[1])
    //   // let arr = new Uint8Array(binStr.length)
    //   // for (let i = 0; i < binStr.length; i++) {
    //   //   arr[i] = binStr.charCodeAt(i)
    //   // }
    //   // let file = new File([arr], oldFile.name, { type: oldFile.type })
    //   this.$refs.upload.update(file.id, {
    //     file,
    //     type: file.type,
    //     size: file.size,
    //     active: true,
    //   })
    // },
  }
}
</script>

<style>
.agent-code-table #code-table .mx-input[name=date] {
  background-color: #e5f8ff;
  width: 120px;
}

#loadingMask {
  background-color: rgba(128, 128, 128, .5);
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  min-height: 480px;
  padding-top: 150px;
  font-size: 48px;
}
.agent-code-table #code-table table th {
  padding-top: 0.3rem;
  padding-bottom: 0.3rem;
}
</style>
