<template>
      <file-upload
          :input-id="inputId"
          :extensions="filterInfo.extensions"
          :accept="filterInfo.accept"
          name="file"
          class="btn min-width-100"
          :class="'btn-'+variant"
          :post-action="postAction"
          :drop="!edit"
          :data="postData"
          :headers="authHeaders"
          v-model="files"
          @click="checkCodeExists"
          @input-filter="inputFilter"
          @input-file="inputFile"
          :ref="inputId">
    <!--<font-awesome-icon v-if="uploading" icon="spinner" class="fa-spin" />-->
      <i :class="iconClass"></i>
    {{ title }}
  </file-upload>
</template>

<script>
import fileUpload from 'vue-upload-component'

export default {
  components: {
    fileUpload
  },
  props: {
    inputId: {
      type: String,
      default: 'file1'
    },
    refName: {
      type: String,
      default: 'upload'
    },
    title: {
      type: String,
      default: 'Upload'
    },
    iconClass: {
      type: String,
      default: 'fas fa-upload'
    },
    postData: {
      type: Object,
      default () {
        return {}
      }
    },
    uploadUrl: {
      type: String,
      default: ''
    },
    fileType: {
      type: String,
      default: 'excel'
    },
    variant: {
      type: String,
      default: 'primary'
    }
  },
  data () {
    return {
      edit: false,
      files: []
    }
  },
  computed: {
    filterInfo () {
      const vm = this
      switch (vm.fileType) {
        case 'excel':
          return {
            extensions: 'xlsx',
            accept: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          }
        case 'zip':
          return {
            extensions: 'zip',
            accept: 'application/zip'
          }
        case 'image':
          return {
            extensions: 'png',
            accept: 'image/png'
          }
      }
    },
    authHeaders () {
      const vm = this
      return {
        Authorization: 'bearer ' + vm.$store.getters.accessToken
      }
    },
    postAction () {
      const vm = this
      return vm.$store.getters.apiUrl + vm.uploadUrl
    }
  },
  methods: {
    inputFilter (newFile, oldFile, prevent) {
      const vm = this
      // console.log('inputFilter')
      if (newFile && !oldFile) {
        // Filter non-image file
        switch (vm.fileType) {
          case 'excel':
            if (!/\.(xlsx)$/i.test(newFile.name)) {
              alert('you file is not ' + vm.fileType + ' file.')
              return prevent()
            }
            break
          case 'zip':
            if (!/\.(zip)$/i.test(newFile.name)) {
              alert('you file is not ' + vm.fileType + ' file.')
              return prevent()
            }
            break
          case 'image':
            if (!/\.(png)$/i.test(newFile.name)) {
              alert('you file is not ' + vm.fileType + ' file.')
              return prevent()
            }
            break
        }
      }
    },
    checkCodeExists () {
      alert('check')
    },
    inputFile (newFile, oldFile) {
      const vm = this
      if (newFile && !oldFile) {
        vm.edit = true
        vm.uploadFile()
      }
      if (!newFile && oldFile) {
        this.edit = false
      }
      if (newFile && newFile.success) {
        console.log('inputFile => onUploaded')
        vm.$emit('onUploaded', newFile.response.result)
      } else {
        // console.log('not newFile')
      }
    },

    uploadFile () {
      const vm = this
      vm.$nextTick(function () {
        vm.$emit('onUploading')
        vm.$refs[vm.inputId].active = true
      })
    }
  }
}
</script>