<template>
<div style="background-color:#e5f8ff" class="py-2 px-3">
  <div class="toolbar d-flex justify-content-between mb-1">
    <div class="d-flex flex-row justify-content-end py-1 align-items-center">
      <div class="mr-2">
        {{ $t('vouchers.email_list') }}
      </div>
      <div class="badge badge-warning">{{ total }}</div>
    </div>
    <file-upload
        extensions="xlsx"
        accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        name="file"
        class="btn btn-primary"
        post-action="http://evoucherapi/agent_codes/upload"
        :drop="!edit"
        v-model="files"
        @success="onSuccess()"
        @input-filter="inputFilter"
        @input-file="inputFile"
        ref="upload">
      <i class="fa fa-upload"></i>
      Upload File
    </file-upload>
  </div>
  <div id="email-table">
     <datatable v-cloak v-bind="$data"></datatable>
  </div>
</div>
</template>

<script>
import Vue from 'vue'
import fileUpload from 'vue-upload-component'
import dtCommon from '@/views/comps/datatable'

export default {
  components: {
    fileUpload,
    ...dtCommon
  },
  data () {
    return {
      files: [],
      columns: (() => {
        const cols = [
          {title: 'general.number', thComp: 'ThCommonHeader', tdComp: 'TdCommonIndex', field: 'id'},
          {title: 'general.name', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'name'},
          {title: 'general.email', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'email'},
          {title: 'general.tel_no', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'tel_no'},
          {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
        ]
        return cols
      })(),      data: [],
      total: 0,
      edit: false,
      query: {
        filter: '',
        sort: '',
        order: ''
      },
      xprops: {
        buttons: ['edit','view','delete'],
        eventbus: new Vue()
      },
      HeaderSettings: false,
      searchInputTimer: 0
    }
  },
  props: {
    voucherId: {
      type: Number,
      default: 0
    }
  },
  methods: {
    setColumns (fields) {
      const vm = this
      vm.columns = [{
        title: vm.$t('general.number'),
        tdClass: 'text-center',
        thClass: 'text-center',
        tdComp: 'TdCommonIndex',
        field: 'id'
      }];

      for (let i = 0; i < fields.length; i++) {
        const field = fields[i]
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
          tdClass: tdClass,
          thClass: thClass,
          field: 'field' + i
        })
      }
      vm.columns.push({
        title: vm.$t('general.action'),
        tdComp: 'TdCommonOpt',
        field: 'field0'

      })
    },

    getCodeData (values) {
      console.log('getCodeData :: values: ', values)
      const records = []
      for (let i = 0; i < values.length; i++) {
        const record = {}
        const loopRecord = values[i]
        for (let j = 0; j < loopRecord.length; j++) {
          record['id'] = j
          record['field' + j] = loopRecord[j]
        }
        records.push(record)
      }
      console.log('getCodeData :: records: ', records)
      return records
    },

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
        // console.log('inputFile :: newfile.success')
        // console.log('inputFile :: newFile.response: ', newFile.response)

        const fields = newFile.response.result.fields
        const values = newFile.response.result.data

        vm.setColumns(fields);
        vm.data = vm.getCodeData(values)
        vm.total = vm.data.length
      } else {
        // console.log('not newFile')
      }
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
