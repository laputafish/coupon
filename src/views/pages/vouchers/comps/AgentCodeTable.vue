<template>
<div style="background-color:#e5f8ff" class="py-2 px-3 agent-code-table">
  <div class="toolbar d-flex justify-content-between mb-1">
    <div class="d-flex flex-row justify-content-end py-1 align-items-center">
      <div class="mr-2">
        {{ $t('vouchers.code_list') }}
      </div>
      <div v-if="codeInfos.length>0" class="badge badge-warning">{{ codeInfos.length }}</div>
    </div>
    <file-upload
        extensions="xlsx"
        accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        name="file"
        class="btn btn-primary"
        :post-action="postAction"
        :drop="!edit"
        :headers="authHeaders"
        v-model="files"
        @success="onSuccess()"
        @input-filter="inputFilter"
        @input-file="inputFile"
        ref="upload">
      <i class="fa fa-upload"></i>
      Upload File
    </file-upload>
  </div>
  <div v-if="codeInfos.length>0" id="code-table" >
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
</div>
</template>

<script>
import Vue from 'vue'
import fileUpload from 'vue-upload-component'
import dtCommon from '@/views/comps/datatable'
import dtComps from './dtComps'
import helpers from '@/helpers'

export default {
  components: {
    fileUpload,
    ...dtCommon,
    ...dtComps,
    helpers
  },
  data () {
    return {
      files: [],
      edit: false,
      columns: [],
      allData: [],
      data: [],
      total: 0,
      query: {
        filter: '',
        sort: '',
        order: ''
      },
      xprops: {
        buttons: ['view','delete'],
        // buttons: ['edit','view','delete'],
        eventbus: new Vue(),
        actionButtonSize: 'xs'
      },
      HeaderSettings: false,
      searchInputTimer: 0,
      selectedRow: null,
      defaultColumns: [
        {title: 'general.key', thComp: 'ThCommonHeader', tdComp: 'TdKey', field: 'key', sortable: true},
        {title: 'general.remark', thComp: 'ThCommonHeader', tdComp: 'TdCommonInput', field: 'remark'},
        {title: 'vouchers.sent_on', thComp: 'ThCommonHeader', tdComp: 'TdCommonInputDate',field: 'sent_on', sortable: true},
        {title: 'general.status', thComp: 'ThCommonHeader', tdComp: 'TdCommonStatus',field: 'status', sortable: true},
        {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt',field: 'id', sortable: true}
      ]
    }
  },
  props: {
    codeInfos: {
      type: Array,
      default () {
        return []
      }
    },
    codeFieldsStr: {
      type: String,
      default: ''
    },
  },
  computed: {
    authHeaders () {
      const vm = this
      return {
        Authorization: 'bearer ' + vm.$store.getters.accessToken
      }
    },
    postAction () {
      const vm = this
      return vm.$store.getters.apiUrl + '/agent_codes/upload'
    }
  },
  watch: {
    codeInfos: {
      handler: function (newValue) {
        console.log('AgentCodeTable :: watch(codeInfos) :: newValue: ', newValue)
        const vm = this
        vm.setTableData(newValue)
        vm.refreshList()
      },
      deep: true
    },
    codeFieldsStr: function (newValue) {
      // codeFields is string in format:
      //
      // Code:string|Serial No:string|activate_date:date
      //
      const vm = this
      console.log('watch(codeFieldsStr) :: newValue: ', newValue)
      vm.setColumns(newValue)
    },
    query: {
      handler: function (newValue) {
        const vm = this
        vm.refreshList()
      },
      deep: true
    }
  },
  mounted () {
    const vm = this
    vm.setColumns(vm.codeFieldsStr)
    vm.setTableData(vm.codeInfos)
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
    refreshList () {
      const vm = this
      console.log('AgentCodeTable :: refreshList :: query: ', vm.query)
      let end = vm.query.offset + vm.query.limit
      if (end > vm.total) {
        end = vm.total
      }
      console.log('AgentCodeTable :: refreshList :: allDAta.length = ' + vm.allData.length)
      console.log('AgentCodeTable :: refreshList :: offset = ' + vm.query.offset)
      console.log('AgentCodeTable :: refreshList :: vm.total = ' + vm.total)
      console.log('AgentCodeTable :: refreshList :: vm.query.limit = ' + vm.query.limit)
      console.log('AgentCodeTable :: refreshList :: end = ' + end)

      vm.data = vm.allData.slice(vm.query.offset, end)
      console.log('AgentCodeTable :: watch(query)')
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
        "extra_fields": extraFieldsArray.join('|'),
        key: row.key,
        remark: row.remark,
        "sent_on": row.sent_on,
        status: row.status
      }
    },
    onRowCommandHandler (payload) {
      const vm = this
      console.log('AgentCodeTable :: onRowCommandHandler :: payload: ', payload)
      switch (payload.command) {
        case 'edit':
          alert('onRowCommandHandler :; edit')
          break
        case 'view':
          vm.$emit('onCommand', {
            command: 'view_temp_leaflet',
            row: payload.row
          })
          break
        case 'delete':
          vm.$dialog.confirm(vm.$t('messages.are_you_sure'))
            .then(dialog => {
              vm.$emit('onCommand', {
                command: 'delete_code_info',
                index: payload.index
              })
            })
          break
        case 'updateField':
          vm.$emit('onCommand', {
            command: 'update_code_info_field',
            row: vm.row2CodeInfo(payload.row),
            fieldName: payload.fieldName,
            fieldValue: payload.fieldValue
          })
          break
      }
    },
    getCodeFieldsFromStr (fieldStr) {
      const result = []
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
      return result
    },

    setColumns (fieldsStr) {
      // Input : fieldsStr
      //
      // Code:string|Serial No:string|activate_date:date
      //
      const vm = this
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
        let tdClass = 'text-left'
        let thClass = 'text-left'
        switch (field['type']) {
          case 'date':
          case 'integer':
            tdClass = 'text-center'
            thClass = 'text-center'
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

    setTableData (codeInfos) {
      const vm = this
      console.log('AgentCodeTable :: setTableData :: codeInfos: ', codeInfos)
      const result = []
      if (vm.columns)
      for (let i = 0; i < codeInfos.length; i++) {
        const codeRecord = codeInfos[i]
        const fieldsStr = codeRecord['code'] + '|' + codeRecord['extra_fields']
        const arFieldValues = fieldsStr.split('|')

        const obj = {
          id: i
        }
        for (let j = 0; j < arFieldValues.length; j++) {
          obj['field'+j] = arFieldValues[j]
        }
        obj['status'] = codeRecord['status']
        obj['key'] = codeRecord['key']
        obj['remark'] = codeRecord['remark']
        obj['sent_on'] = codeRecord['sent_on']
        result.push(obj)
      }
      vm.allData = result
      vm.total = result.length
    },

    // getCodeData (values) {
    //   console.log('getCodeData :: values: ', values)
    //   const records = []
    //   for (let i = 0; i < values.length; i++) {
    //     const record = {}
    //     const loopRecord = values[i]
    //     for (let j = 0; j < loopRecord.length; j++) {
    //       record['id'] = j
    //       record['field' + j] = loopRecord[j]
    //     }
    //     records.push(record)
    //   }
    //   console.log('getCodeData :: records: ', records)
    //   return records
    // },

    inputFile (newFile, oldFile) {
      const vm = this
      // console.log('inputFile :: newFile: ' + (newFile ? 'yes' : 'no'))
      // console.log('inputFile :: oldFile: ' + (oldFile ? 'yes' : 'no'))
      if (newFile && !oldFile) {
        // console.log('newFile')
        this.$nextTick(function () {
          this.edit = true
          this.$refs.upload.active = true
        })
      }
      if (!newFile && oldFile) {
        // console.log('not newFile')
        this.edit = false
      }
      if (newFile && newFile.success) {
        vm.onUploaded(newFile.response.result)
        // vm.setColumns(fields);
        // vm.data = vm.getCodeData(values)
        // vm.total = vm.data.length
      } else {
        // console.log('not newFile')
      }
    },

    onUploaded (result) {
      const vm = this
      // result = {
      //    fields: [
      //      {title: 'PCC', type: 'string'},
      //      {title: 'PCC', type: 'string'},
      //      {title: 'PCC', type: 'string'},
      //      {title: 'PCC', type: 'string'}
      //    ],
      //    values: [ ... ]
      // }
      //
      const newCodeFieldsStr = vm.getCodeFieldsStrFromArray(result.fields)
      let goAhead = true
      console.log('codeFieldsStr = [' + vm.codeFieldsStr + ']')
      console.log('newCodeFieldsStr = [' + newCodeFieldsStr + ']')
      if (vm.codeFieldsStr !== '' && vm.codeFieldsStr !== null) {
        if (newCodeFieldsStr !== vm.codeFieldsStr) {
          goAhead = false
          const options = {
            okText: vm.$t('buttons.continue'),
            cancelText: vm.$t('buttons.cancel')
          }
          vm.$dialog.confirm(vm.$t('messages.fields_not_matched_please_delete_all_first')).then(
            dialog => {
              vm.$emit('onCommand', {
                command: 'clear_all_code_info',
                callback: () => {
                  vm.importCodes(result)
                }
              })
            }
          )
        } else {
          vm.importCodes(result)
        }
      } else {
        vm.importCodes(result)
      }
    },

    importCodes (result) {
      const vm = this
      const newCodeFieldsStr = vm.getCodeFieldsStrFromArray(result.fields)

      console.log('codeFieldsStr: ' + vm.codeFieldsStr)
      console.log('newCodeFieldsStr = ' + newCodeFieldsStr)

      console.log('equal: ' + (vm.codeFieldsStr === newCodeFieldsStr ? 'yes' : 'no'))
      vm.$emit('onCommand', {
        command: 'setCodeFields',
        value: result.fields
      })
      vm.$emit('onCommand', {
        command: 'setCodeDataRows',
        value: result.allData
      })

      vm.$emit('onCommand', {
        command: 'setQrCodeComposition',
        data: helpers.str2token('code_', result.fields[0].title)
      })
    },
    getCodeFieldsStrFromArray (fields) {
      const vm = this
      const result = []
      for (let i = 0; i < fields.length; i++) {
        result.push(fields[i].title + ':' + fields[i].type)
      }
      return result.join('|')
    },
    onSuccess () {
      // alert('success')
    },

    inputFilter (newFile, oldFile, prevent) {
      // console.log('inputFilter')
      if (newFile && !oldFile) {
        // Filter non-image file
        if (!/\.(xlsx)$/i.test(newFile.name)) {
          alert('you file is not excel file.')
          return prevent()
        }
      }
      //
      // if (newFile && (!oldFile || newFile.file !== oldFile.file)) {
      //   // Create a blob field
      //   newFile.blob = ''
      //   let URL = window.URL || window.webkitURL
      //   if (URL && URL.createObjectURL) {
      //     newFile.blob = URL.createObjectURL(newFile.file)
      //   }
      // }
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
  width: 120px;
}
</style>
