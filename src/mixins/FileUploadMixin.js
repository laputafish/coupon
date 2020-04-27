const FileUploadMixin = {
  data () {
    return {
      edit: false,
      files: [],
      uploading: false
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
      return vm.$store.getters.apiUrl + vm.uploadRoute
    }
  },
  methods: {
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
        vm.onUploaded(newFile.response.result)
      } else {
        // console.log('not newFile')
      }
    },

    uploadFile () {
      const vm = this
      vm.$nextTick(function () {
        vm.uploading = true
        vm.$refs.upload.active = true
      })
    }
  }
}

export default FileUploadMixin
