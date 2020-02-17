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
      data: [],
      total: 0,
      query: {
        filter: '',
        sort: '',
        order: ''
      },
      xprops: {
        buttons: ['edit','view','delete'],
        eventbus: new Vue(),
        actionButtonSize: 'xs'
      },
      HeaderSettings: false,
      searchInputTimer: 0
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
    codeInfos: function (newValue) {
      const vm = this
      vm.setTableData(newValue)
    },
    codeFieldsStr: function (newValue) {
      // codeFields is string in format:
      //
      // Code:string|Serial No:string|activate_date:date
      //
      const vm = this
      console.log('watch(codeFieldsStr) :: newValue: ', newValue)
      vm.setColumns(newValue)
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
          vm.$dialog().configm(vm.$t('messages.are_you_sure'))
            .then(dialog => {
              vm.record.code_infos.splice(payload.index, 1)
            })
          alert('onRowCommandHandler :: delete')
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
      vm.columns.push({
        title: vm.$t('general.key'),
        tdComp: 'TdKey',
        field: 'key'
      })
      vm.columns.push({
        title: vm.$t('vouchers.sent_on'),
        tdComp: 'TdCommon',
        field: 'sent_on'
      })
      vm.columns.push({
        title: vm.$t('general.status'),
        tdComp: 'TdCommonStatus',
        field: 'status'
      })
      vm.columns.push({
        title: vm.$t('general.action'),
        tdComp: 'TdCommonOpt',
        field: 'id'

      })
    },

    setTableData (codeInfos) {
      const vm = this
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
        obj['sent_on'] = codeRecord['sent_on']
        result.push(obj)
      }
      vm.data = result
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
      console.log('onUploaded :: result: ', result)
      const vm = this
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
        data: '{' + helpers.str2token('code_', result.fields[0].title) + '}'
      })
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
