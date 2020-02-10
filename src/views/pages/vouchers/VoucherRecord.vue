<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <div class="btn-toolbar mb-1 justify-content-end" role="toolbar" aria-label="Toolbar with buttons">
          <button type="button"
                  @click="save()"
                  class="btn btn-primary">
            <i class="fas fa-save"></i>&nbsp;{{ $t('buttons.save') }}
          </button>
        </div>
      </div>
      <div class="col-5">
        <div class="upload">
          <div v-if="files.length>0">
            <span>{{files[0].name}}</span>
            <span>({{files[0].size}})</span>
            <span v-if="files[0].error">{{files[0].error}}</span>
            <span v-else-if="files[0].success">success</span>
            <span v-else-if="files[0].active">active</span>
            <span v-else-if="files[0].active">active</span>
            <span v-else></span>
          </div>
          <div class="example-btn">
            <file-upload
                extensions="xlsx"
                accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                name="file"
                class="btn btn-primary mr-1 mb-1"
                post-action="http://evoucherapi/media/upload"
                :drop="!edit"
                v-model="files"
                @success="onSuccess()"
                @input-filter="inputFilter"
                @input-file="inputFile"
                ref="upload">
              <i class="fa fa-upload"></i>
              Upload File
            </file-upload>
            <!--<button type="button" class="btn btn-success" v-if="!$refs.upload || !$refs.upload.active"-->
                    <!--@click.prevent="$refs.upload.active = true">-->
              <!--<i class="fa fa-arrow-up" aria-hidden="true"></i>-->
              <!--Start Upload-->
            <!--</button>-->
            <!--<button type="button" class="btn btn-danger" v-else @click.prevent="$refs.upload.active = false">-->
              <!--<i class="fa fa-stop" aria-hidden="true"></i>-->
              <!--Stop Upload-->
            <!--</button>-->
          </div>
        </div>
        <div class="avatar-edit" v-show="files.length && edit">
          <div class="avatar-edit-image" v-if="files.length">
            <img ref="editImage" :src="files[0].url" />
          </div>
          <div class="text-center p-4">
            <button type="button" class="btn btn-secondary" @click.prevent="$refs.upload.clear">Cancel</button>
            <button type="submit" class="btn btn-primary" @click.prevent="editSave">Save</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import fileUpload from 'vue-upload-component'

  export default {
    data () {
      return {
        files: [],
        edit: false
      }
    },
    components: {
      fileUpload
    },
    props: {
      type: Object,
      default: null
    },
    methods: {
      onSuccess () {
        alert('success')
      },
      editSave() {
        console.log('editSave')
        this.edit = false
        let file = this.files[0]
        // let oldFile = this.files[0]
        // let binStr = atob(this.cropper.getCroppedCanvas().toDataURL(oldFile.type).split(',')[1])
        // let arr = new Uint8Array(binStr.length)
        // for (let i = 0; i < binStr.length; i++) {
        //   arr[i] = binStr.charCodeAt(i)
        // }
        // let file = new File([arr], oldFile.name, { type: oldFile.type })
        this.$refs.upload.update(file.id, {
          file,
          type: file.type,
          size: file.size,
          active: true,
        })
      },

      save () {
        alert('save')
      },

      inputFile(newFile, oldFile, prevent) {
        console.log('inputFile')
        if (newFile && !oldFile) {
          console.log('newFile')
          this.$nextTick(function () {
            this.edit = true
            this.$refs.upload.active = true
          })
        }
        if (!newFile && oldFile) {
          console.log('not newFile')
          this.edit = false
        }
        if (newFile.success) {
          alert('success')
          console.log('sucess response: ', newFile.response)
        }
      },
      // inputFile: function (newFile, oldFile) {
      //   if (newFile && oldFile && !newFile.active && oldFile.active) {
      //     // Get response data
      //     console.log('response', newFile.response)
      //     if (newFile.xhr) {
      //       //  Get the response status code
      //       console.log('status', newFile.xhr.status)
      //     }
      //   }
      // },
      /**
       * Pretreatment
       * @param  Object|undefined   newFile   Read and write
       * @param  Object|undefined   oldFile   Read only
       * @param  Function           prevent   Prevent changing
       * @return undefined
       */
      inputFilter (newFile, oldFile, prevent) {
        console.log('inputFilter')
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
    }
  }
</script>
