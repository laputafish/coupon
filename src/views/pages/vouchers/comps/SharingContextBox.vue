<template>
  <div class="sharing-context-box">
    <div v-if="title" class="pt-2 px-2">
      <div class="mx-1">
        <h4 class="bg-dark mx-2 my-0 px-2 py-1">{{ title }}</h4>
      </div>
    </div>

    <div class="p-2 d-flex flex-row justify-content-start">
      <div class="mx-1 d-inline-block">
        <div class="image-wrapper m-2">
          <div class="image-bkgd">
            <img :src="sharingImageSrc"/>
          </div>
        </div>
        <div class="btn-toolbar mt-1 justify-content-center">
          <!-- upload sharing image -->
          <file-upload
              extensions="jpg,jpeg,gif,png"
              accept="image/png,image/gif,image/jpeg,image/webp"
              input-id="imageFile"
              name="file"
              class="btn btn-primary"
              :post-action="sharingImagePostAction"
              :drop="!editingUploadFile"
              :data="{id: record.id}"
              :headers="authHeaders"
              v-model="files"
              @input-filter="inputFilter"
              @input-file="inputImageFile"
              ref="uploadSharingImage">
            <!--<font-awesome-icon v-if="uploading" icon="spinner" class="fa-spin" />-->
            <font-awesome-icon icon="upload"></font-awesome-icon>
            Upload
          </file-upload>
          <button type="button"
                  @click="removeSharingImage"
                  class="btn btn-danger m-x-1">
            <i class="fas fa-times"></i>&nbsp;Remove
          </button>
        </div>
        <div class="mx-2">
          <small>* Safe resolution: 256x256</small>
        </div>
      </div>
      <div class="mx-2 flex-grow-1">
        <div class="row">
          <div class="col-sm-12">
            <div class="form-group mb-1">
              <div class="float-right">
                <small>* max. 35 chars for safety.</small>
              </div>
              <label for="sharingTitle">{{ $t('general.title') }}
                <div class="badge badge-primary">{{ sharingTitleCharCount }}</div>
              </label>
              <input class="form-control"
                     name="sharingTitle"
                     type="text"
                     :value="record[sharingTitleField]"
                     @input="$event=>updateField(sharingTitleField, $event.target.value)"/>

            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-12">
            <div class="form-group mb-1">
              <div class="float-right">
                <small>* max. 65 chars for safety.</small>
              </div>
              <label for="sharingDescription">{{ $t('general.description') }}
                <div class="badge badge-primary">{{ sharingDescriptionCharCount }}</div>
              </label>
              <textarea rows="6"
                        class="form-control"
                        name="sharingDescription"
                        type="text"
                        @input="$event=>updateField(sharingDescriptionField, $event.target.value)"
                        :value="record[sharingDescriptionField]"></textarea>
            </div>
          </div>
        </div>
        <div class="row" v-if="record">
          <div class="col-sm-12">
            <div class="d-flex flex-row justify-content-start align-items-center"
                 @click="copySharingLink()">
              <div class="pr-2">
                Link for testing
              </div>
              <div class="badge badge-info test-link-url">
                {{ testLink }}
              </div>
              <div class="px-1 d-inline-block copy-link" @click="copySharingLink()">
                <font-awesome-icon icon="copy"/>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import fileUpload from 'vue-upload-component'

export default {
  components: {
    fileUpload
  },
  data () {
    return {
      editingUploadFile: false,
      files: [],
      testLink: ''
    }
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    record: {
      type: Object,
      default: null
    },
    sharingTitleField: {
      type: String,
      default: ''
    },
    sharingDescriptionField: {
      type: String,
      default: ''
    },
    sharingImageIdField: {
      type: String,
      default: ''
    },
    sharingType: {
      type: String,
      default: 'coupons'
    }
  },
  computed: {
    sharingImagePostAction () {
      const vm = this
      return vm.$store.getters.apiUrl + '/media/upload'
    },
    authHeaders () {
      const vm = this
      return {
        Authorization: 'bearer ' + vm.$store.getters.accessToken
      }
    },
    sharingImageSrc () {
      const vm = this
      let result = ''
      if (vm.record) {
        result = vm.$store.getters.appHost + '/media/image/' + vm.record[vm.sharingImageIdField]
      }
      return result
    },
    sharingTitleCharCount () {
      const vm = this
      let result = 0
      if (vm.record) {
        result = vm.record[vm.sharingTitleField].length
      }
      return result
    },

    sharingDescriptionCharCount () {
      const vm = this
      let result = 0
      if (vm.record) {
        result = vm.record[vm.sharingDescriptionField].length
      }
      return result
    }
  },

  mounted () {
    const vm = this
    vm.testLink = window.location.origin + '/' + vm.sharingType + '/' + vm.record.id + '/' + new Date().getTime()
  },

  methods: {
    copySharingLink () {
      const vm = this
      vm.$copyText(vm.testLink)
      vm.$toaster.info(vm.$t('messages.link_copied_to_clipboard'))
    },

    updateField (fieldName, fieldValue) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateField',
        fieldName: fieldName,
        fieldValue: fieldValue
      })
    },

    removeSharingImage () {
      const vm = this
      const data = {
        urlCommand: '/medias/' + vm.record[vm.sharingImageIdField],
        data: {
          type: 'temp'
        }
      }
      vm.$store.dispatch('AUTH_PUT', data).then(
        () => {
          vm.$toaster.success(vm.$t('messages.deleteSuccessfully'))
          vm.$emit('onCommand', {
            command: 'setRecordField',
            fieldName: vm.sharingImageIdField,
            fieldValue: 0
          })
          // vm.record.sharing_media_id = 0
        }
      )
    },
    inputFilter (newFile, oldFile, prevent) {
      const vm = this
      if (newFile && !oldFile) {
        // Filter non-image file
        if (!/\.(jpg|jpeg|png|gif)$/i.test(newFile.name)) {
          vm.$toaster.warning('Invalid Image File Format!')
          return prevent()
        }
      }
    },

    inputImageFile (newFile, oldFile) {
      const vm = this
      console.log('inputImageFile')
      if (newFile && !oldFile) {
        this.$nextTick(function () {
          this.editingUploadFile = true
          this.uploading = true
          this.$refs.uploadSharingImage.active = true
        })
      }
      if (!newFile && oldFile) {
        this.edit = false
      }
      if (newFile && newFile.success) {
        vm.onUploaded(newFile.response.result)
      }
    },

    onUploaded (result) {
      const vm = this
      console.log('onUploaded :: result: ', result)
      vm.$emit('onCommand', {
        'command': 'cropImage',
        'imageType': vm.sharingType,
        'imageId': result.imageId,
        'imageIdField': vm.sharingImageIdField
      })
      // vm.selectedTempMediaId = result.imageId
      // // sharingImageSrc = vm.$store.getters.appHost + '/media/image/' + result.imageId
      // vm.$bvModal.show('imageCropperDialog')
      // // vm.showingImageCropperDialog = true
      // vm.$nextTick(() => {
      //   vm.$refs.imageCropperDialog.startCrop()
      // })
    }
  }
}
</script>

<style>
.sharing-context-box .image-wrapper .image-bkgd img {
  margin-top: auto;
  align-self: center;
  margin-bottom: auto;
  width: 100%;
  height: auto;
  object-fit: contain;
}

.sharing-context-box .copy-link,
.sharing-context-box .test-link-url {
  cursor: pointer;
}

.sharing-context-box .btn-toolbar .btn {
  margin: 0 1px !important;
}

.sharing-context-box .image-wrapper {
  border: 1px solid darkgray;
}

.sharing-context-box .image-wrapper .image-bkgd {
  width: 200px;
  height: 200px;
  display: flex;
  flex-direction: column;
  background-color: lightgray;
}
</style>