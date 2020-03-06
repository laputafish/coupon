<template>
<div style="background-color:#e5f8ff" class="py-2 px-3 agent-code-table">
  <div class="toolbar d-flex justify-content-between mb-1">
    <div class="d-flex flex-row justify-content-end align-items-center">
      <h4 class="d-inline-block mr-2 my-0">
         <font-awesome-icon icon="search" />
      </h4>
      <form @submit.prevent="search()">
        <div class="form-group m-0 d-inline-block" style="">
          <div class="input-group">
            <input class="form-control" v-model="searchValue">
            <div class="input-group-append">
              <button type="button" @click="setSearchValue('')">
                <i class="fas fa-fw fa-times"></i>
              </button>
            </div>
          </div>
        </div>
      </form>
      <h3 v-if="loading" class="d-inline-block ml-3 my-0 mr-auto">
         <font-awesome-icon icon="spinner" class="fa-spin"/>
      </h3>
      <!--<div v-if="codeInfos.length>0" class="badge badge-warning">{{ codeInfos.length }}</div>-->
    </div>
    <div class="">
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
        <i class="fas fa-times"></i>
        <span class="ml-2">{{ $t('buttons.export') }}</span>
      </button>
      <file-upload
          extensions="xlsx"
          accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          name="file"
          class="btn btn-primary"
          :post-action="postAction"
          :drop="!edit"
          :data="{id: voucherId}"
          :headers="authHeaders"
          v-model="files"
          @success="onSuccess()"
          @input-filter="inputFilter"
          @input-file="inputFile"
          ref="upload">
        <i v-if="uploading" class="fa fa-fw fa-spinner fa-spin"></i>
        <i v-else class="fa fa-upload"></i>
        Upload File
      </file-upload>
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
    ...dtComps
    // ,
    // helpers
  },
  data () {
    return {
      uploading: false,
      loading: false,
      files: [],
      edit: false,
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
        buttons: ['view', 'delete'],
        // buttons: ['edit','view','delete'],
        eventbus: new Vue(),
        actionButtonSize: 'xs'
      },
      HeaderSettings: false,
      selectedRow: null,
      defaultColumns: [
        {title: 'general.key', thComp: 'ThCommonHeader', tdClass: 'align-middle', tdComp: 'TdKey', field: 'key', sortable: true},
        {title: 'general.remark', thComp: 'ThCommonHeader', tdClass: 'align-middle', tdComp: 'TdCommonInput', field: 'remark'},
        {
          title: 'vouchers.sent_on',
          thComp: 'ThCommonHeader',
          tdClass: 'align-middle',
          tdComp: 'TdCommonInputDate',
          field: 'sent_on',
          sortable: true
        },
        {title: 'general.status', thComp: 'ThCommonHeader', tdClass: 'align-middle', tdComp: 'TdCommonStatus', field: 'status', sortable: true},
        {title: 'general.action', thComp: 'ThCommonHeader', tdClass: 'align-middle', tdComp: 'TdCommonOpt', field: 'id', sortable: true}
      ],
      searchValue: '',
      searchInputTimer: 3000,
      filterFields: '*',
      codeInfos: {
        type: Array,
        default () {
          return []
        }
      }
    }
  },
  props: {
    voucherId: {
      type: Number,
      default: 0
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
    codeInfos: {
      handler: function (newValue) {
        // console.log('AgentCodeTable :: watch(codeInfos) :: newValue: ', newValue)
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
      // console.log('watch(codeFieldsStr) :: newValue: ', newValue)
      vm.setColumns(newValue)
    },
    voucherId: {
      handler: function (newValue) {
        const vm = this
        if (vm.voucherId !== 0) {
          console.log('watch(voucherId) :: voucherId = ' + newValue)
          vm.onQueryChangedHandler(newValue)
        }
      }
    },
    query: {
      handler: function (newValue) {
        const vm = this
        if (vm.voucherId !== 0) {
          console.log('watch(query) && voucherId !== 0: ', vm.voucherId)
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
    vm.setTableData(vm.codeInfos)
    vm.query.page = 1
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
    exportExcel () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'export'
      })
    },
    deleteAll () {
      const vm = this
      vm.$dialog.confirm(vm.$t('messages.areYouSure')).then(
        () => {
          vm.doDeleteAll()
          vm.$emit('onCommand', {
            command: 'setRecordField',
            fieldName: 'code_count',
            fieldValue: 0
          })

          // vm.$emit('onCommand', {
          //   command: 'clear_all_code_info',
          //   callback: () => {
          //     vm.$toaster.success('All codes are deleted.')
          //   }
          // })
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

    // getFilteredData (filterValue) {
    //   const vm = this
    //   const codeFields = vm.getCodeFieldsFromStr(vm.codeFieldsStr);
    //   const filtered = vm.allData.filter(item => {
    //     let valid = false
    //     for (let i = 0; i < codeFields.length; i++) {
    //       const fieldName = 'field' + i
    //       if (item[fieldName].indexOf(filterValue) >= 0) {
    //         valid = true
    //         break
    //       }
    //     }
    //     return valid
    //   })
    //   return filtered
    // },

    onQueryChangedHandler (query) {
      const vm = this
      if (vm.voucherId !== 0) {
        console.log('onQueryChangedHandler :: voucherId = ' + vm.voucherId)
        if (typeof query === 'undefined') {
          query = vm.query
        }
        if (vm.voucherId === 0) {
          alert('vm.voucherId = 0')
          return;
        }
        const data = {
          urlCommand: '/vouchers/' + vm.voucherId + '/codes',
          query: query
        }
        vm.$store.dispatch('AUTH_GET', data).then(response => {
          console.log('AUTH_GET :: response: ', response)
          vm.total = response.total
          vm.data = vm.parseCodeInfoData(response.data)
          vm.$forceUpdate()
        })
      }
    },

    // refreshList2 () {
    //   const vm = this
    //   console.log('AgentCodeTable :: refreshList :: query: ', vm.query)
    //   const filterValue = vm.getFilterValue(vm.query.filter)
    //   let filtered = []
    //
    //   vm.loading = true
    //
    //   if (filterValue === '') {
    //     filtered = vm.allData
    //   } else {
    //     filtered = vm.getFilteredData(filterValue)
    //   }
    //   vm.total = filtered.length
    //   let end = vm.query.offset + vm.query.limit
    //   if (end > vm.total) {
    //     end = vm.total
    //   }
    //   // console.log('AgentCodeTable :: refreshList :: allDAta.length = ' + vm.allData.length)
    //   // console.log('AgentCodeTable :: refreshList :: offset = ' + vm.query.offset)
    //   // console.log('AgentCodeTable :: refreshList :: vm.total = ' + vm.total)
    //   // console.log('AgentCodeTable :: refreshList :: vm.query.limit = ' + vm.query.limit)
    //   // console.log('AgentCodeTable :: refreshList :: end = ' + end)
    //
    //   vm.data = filtered.slice(vm.query.offset, end)
    //   vm.loading = false
    //   // console.log('AgentCodeTable :: watch(query)')
    // },
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
            .then( () => {
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
            id: i
          }
          for (let j = 0; j < arFieldValues.length; j++) {
            obj['field' + j] = arFieldValues[j]
          }
          obj['status'] = codeRecord['status']
          obj['key'] = codeRecord['key']
          obj['remark'] = codeRecord['remark']
          obj['sent_on'] = codeRecord['sent_on']
          result.push(obj)
        }
      } else {
        result = infoData
      }
      return result
    },

    setTableData (tableData) {
      const vm = this
      // console.log('AgentCodeTable :: setTableData :: codeInfos: ', codeInfos)
      // const result = []
      // if (vm.columns)
      //   for (let i = 0; i < tableData.length; i++) {
      //     const codeRecord = tableData[i]
      //     const fieldsStr = codeRecord['code'] + '|' + codeRecord['extra_fields']
      //     const arFieldValues = fieldsStr.split('|')
      //
      //     const obj = {
      //       id: i
      //     }
      //     for (let j = 0; j < arFieldValues.length; j++) {
      //       obj['field' + j] = arFieldValues[j]
      //     }
      //     obj['status'] = codeRecord['status']
      //     obj['key'] = codeRecord['key']
      //     obj['remark'] = codeRecord['remark']
      //     obj['sent_on'] = codeRecord['sent_on']
      //     result.push(obj)
      //   }
      vm.allData = vm.parseCodeInfoData(tableData)
      vm.total = vm.allData.length
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
          this.uploading = true
          this.$refs.upload.active = true
        })
      }
      if (!newFile && oldFile) {
        // console.log('not newFile')
        this.edit = false
      }
      if (newFile && newFile.success) {
        // newFile.response.result = {
        //    data: ...
        //    fields: ...
        // }
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
      //    code_fields: "barcode:string|serialno:string|actdate:date|exdate:date"
      //    new: 9
      //    updated: 0
      // }
      //
      if (result.codeFields) {
        const newCodeFieldsStr = result.codeFields
        if (vm.codeFieldsStr !== '' && vm.codeFieldsStr !== null) {
          if (newCodeFieldsStr !== vm.codeFieldsStr) {
            // goAhead = false
            const options = {
              cancelText: vm.$t('buttons.close')
            }
            vm.$dialog.warning(vm.$t('messages.fields_not_matched_please_delete_all_first'), options)
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
            vm.uploading = false
          }
          vm.onQueryChangedHandler(vm.query)
        } else {
          vm.onQueryChangedHandler(vm.query)
        }
      } else {
        vm.$dialog.warning(vm.$t('messages.error_occurred'))
      }
    },

    onUploaded2 (result) {
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
      console.log('onUploaded :: newCodeFieldsStr: ', newCodeFieldsStr)
      // let goAhead = true
      // console.log('codeFieldsStr = [' + vm.codeFieldsStr + ']')
      // console.log('newCodeFieldsStr = [' + newCodeFieldsStr + ']')
      if (vm.codeFieldsStr !== '' && vm.codeFieldsStr !== null) {
        if (newCodeFieldsStr !== vm.codeFieldsStr) {
          // goAhead = false
          const options = {
            okText: vm.$t('buttons.continue'),
            cancelText: vm.$t('buttons.cancel')
          }
          vm.$dialog.confirm(vm.$t('messages.fields_not_matched_please_delete_all_first'), options).then(
            () => {
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
      console.log('importCodes :: result: ', result)
      const vm = this
      // const newCodeFieldsStr = vm.getCodeFieldsStrFromArray(result.fields)

      // console.log('codeFieldsStr: ' + vm.codeFieldsStr)
      // console.log('newCodeFieldsStr = ' + newCodeFieldsStr)

      // console.log('equal: ' + (vm.codeFieldsStr === newCodeFieldsStr ? 'yes' : 'no'))
      vm.$emit('onCommand', {
        command: 'setCodeFields',
        value: result.fields
      })
      vm.$emit('onCommand', {
        command: 'setCodeDataRows',
        value: result.data
      })

      vm.$emit('onCommand', {
        command: 'setQrCodeComposition',
        data: helpers.str2token('code_', result.fields[0].title)
      })
    },
    getCodeFieldsStrFromArray (fields) {
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
    },

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
  width: 120px;
}
</style>
