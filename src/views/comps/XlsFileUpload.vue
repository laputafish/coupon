<template>
      <file-upload
          :input-id="inputId"
          extensions="xlsx"
          accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          name="file"
          class="btn btn-primary min-width-100"
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
      default: 'Import'
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
    }
  },
  data () {
    return {
      edit: false,
      files: []
    }
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
      return vm.$store.getters.apiUrl + vm.uploadUrl
    }
  },
  methods: {
    inputFilter (newFile, oldFile, prevent) {
      // console.log('inputFilter')
      if (newFile && !oldFile) {
        // Filter non-image file
        if (!/\.(xlsx)$/i.test(newFile.name)) {
          alert('you file is not excel file.')
          return prevent()
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
      console.log('XlsFileUpload :: uploadFile')
      vm.$nextTick(function () {
        console.log('XlsFileUpload :: nextTick')
        vm.$emit('onUploading')
        vm.$refs[vm.inputId].active = true
      })
    }
  }
}
</script>