<template>
  <div class="flex-grow-1 bg-muted">
    <tinymce
          :ref="id"
          class="flex-grow-1 bg-muted"
          @editorInit="onEditorInit()"
          style="min-height:480px;"
          :id="id"
          :toolbar1="tinymceToolbar1"
          :other_options="tinymceOtherOptions"
          :options="tinymceOptions"
          :value="content"
          @input="value=>updateContent(value)"></tinymce>
    <!--<image-select-dialog-->
        <!--ref="imageSelectDialog"-->
        <!--title="Image Selection"-->
        <!--:voucher="voucher"-->
        <!--imageScope="local"-->
        <!--@onCommand="onCommandHandler"></image-select-dialog>-->
    <image-select-dialog
        ref="imageSelectDialog"
        title="Image Selection"
        :voucher="voucher"
        imageScope="local"
        v-model="showingImageSelectDialog"
        @onCommand="onCommandHandler"></image-select-dialog>
  </div>
</template>

<script>
import tinymce from 'vue-tinymce-editor'
import imageSelectDialog from '../pages/vouchers/dialogs/ImageSelectDialog'

export default {
  components: {
    tinymce,
    imageSelectDialog
  },
  data () {
    return {
      showingImageSelectDialog: false,
      tinymceOptions: {
        twoWay: true
      },
      tinymceOtherOptions: {
        icons: 'small',
        setup: function (editor) {
          // *********************
          // Embed Image
          //**********************
          var inpEmbed = $('<input id="tinymce-embedder" type="file" name="pic" accept="image/*" style="display:none">')
          $(editor.getElement()).parent().append(inpEmbed)

          editor.addButton('embedImage', {
            tooltip: 'Embed Image',
            icon: 'image',
            onclick: function () {
              inpEmbed.trigger('click')
            }
          })

          inpEmbed.on("change", function () {
            var input = inpEmbed.get(0)
            var file = input.files[0]
            var fr = new FileReader()
            fr.onload = function () {
              var img = new Image()
              img.src = fr.result
              editor.insertContent('<img src="' + img.src + '"/>')
              inpEmbed.val('')
            }
            fr.readAsDataURL(file);
          })

          // *********************
          // Upload Image
          //**********************
          var inpUpload = $('<input id="tinymce-uploader" type="file" name="pic" accept="image/*" style="display:none">')
          $(editor.getElement()).parent().append(inpUpload)

          editor.addButton('uploadImage', {
            tooltip: 'Upload Image',
            icon: 'upload',
            onclick: function () {
              inpUpload.trigger('click')
            }
          })

          // *********************
          // Select Image
          //**********************
          editor.addButton('selectImage', {
            tooltip: 'Select Image',
            icon: 'browse',
            classes: 'select-image'
          })

          //
          // inpUpload.on("change",function(){
          //   this.uploadImage(inpUpload, editor)
          // })
          //

        }
      },
      tinymceToolbar1: 'undo redo | ' +
      'formatselect | ' +
      'bold italic strikethrough forecolor backcolor | ' +
      'link embedImage uploadImage selectImage | ' +
      'alignleft aligncenter alignright alignjustify | ' +
      'numlist bullist outdent indent | ' +
      'removeformat | ' +
      'fullscreen',
    }
  },
  model: {
    prop: 'content',
    event: 'input'
  },
  props: {
    id: {
      type: String,
      default: 'templateEditor'
    },
    content: {
      type: String,
      default: ''
    },
    voucher: {
      type: Object,
      default: null
    }
  },
  methods: {
    clearContent () {
      const vm = this
      console.log('HtmlEditor :: clearContent')
      tinyMCE.get(vm.id).setContent('')
    },
    insertTag (tag) {
      const vm = this
      tinyMCE.get(vm.id).execCommand('mceInsertContent', false, '{' + tag + '}')
    },

    showCopyTemplateDialog () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'showCopyTemplateDialog'
      })
    },

    onCommandHandler (payload) {
      const vm = this
      console.log('HtmlEditor :: onCommandHandler :: payload: ', payload)
      switch (payload.command) {
        case 'onImageSelected':
          const url = vm.$store.getters.appHost + '/media/image/' + payload.imageId
          const editor = tinyMCE.get(vm.id)
          editor.insertContent('<img class="content-img" src="' + url + '"/>');
          vm.$toaster.success('Image Added')
          vm.showingImageSelectDialog = false
          // vm.$bvModal.hide('imageSelectDialog')
          break
      }
      // vm.$emit('onCommand', payload)
    //   switch (payload.command) {
    //     case 'onImageSelected':
    //       vm.$emit('onCommand', {
    //
    //       })
    //   }
    // }
    // case 'onImageSelected':
    //   switch (payload.imageScope) {
    //     case 'tinymce':
    //       vm.$refs.ticketsPage.insertImage(payload.imageId)
    //       break
    //
    //   console.log('HtmlEditor :: onCommandHandler :: payload: ', payload)
    },
    onEditorInit () {
      const vm = this
      tinyMCE.get(vm.id).setContent(vm.content ? vm.content : '')
      tinyMCE.get(vm.id).save()
      tinyMCE.get(vm.id).on('fullscreenStateChanged', function (e) {
        vm.$emit('onCommand', {
          command: 'changeEditorFullscreenState',
          isFullScreen: e.state
        })
      })
      vm.addTinyMCEButtonEvents(tinyMCE.get(vm.id))
    },
    addTinyMCEButtonEvents (editor) {
      const vm = this

      //**************
      // Upload Image
      //**************
      var editorObj = $('#' + vm.id)
      var inpUpload = $(editorObj).parent().find('input#tinymce-uploader')
      $(inpUpload).off('change').on('change', function () {
        vm.uploadImage(inpUpload, editor)
      })

      //**************
      // Select Image
      //**************
      const objTinymce = $('#' + vm.id).prev('.mce-tinymce')
      const btnSelectImage = $(objTinymce).find('.mce-select-image button')
      $(btnSelectImage).off('click').on('click', function () {
        vm.$refs.imageSelectDialog.fetchImages()
        vm.$refs.imageSelectDialog.toggle()
        // vm.$bvModal.show('imageSelectDialog')
        // vm.showingImageSelectDialog = true
      })
    },
    uploadImage (inpUpload, editor) {
      const vm = this
      var input = inpUpload.get(0);
      var data = new FormData();
      data.append('file', input.files[0]);
      data.append('scope', 'tinymce');
      // data.append('image[file]', input.files[0]);

      const url = vm.$store.getters.apiUrl + '/media/upload_image'
      const bearerToken = 'bearer ' + vm.$store.getters.accessToken
      $.ajax({
        headers: {'Authorization': bearerToken},
        url: url,
        type: 'POST',
        data: data,
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request
        success: function (response, textStatus, jqXHR) {
          const data = response.result
          editor.insertContent('<img class="content-img" src="' + data.imageUrl + '"/>');
        },
        error: function (jqXHR, textStatus, errorThrown) {
          if (jqXHR.responseText) {
            const errors = JSON.parse(jqXHR.responseText).errors
            alert('Error uploading image: ' + errors.join(", ") + '. Make sure the file is an image and has extension jpg/jpeg/png.');
          }
        }
      });
    },
    // addTinyMCEButtonEmbedImage (editor, buttonName) {
    //   const vm = this
    // },
    updateContent (value) {
      const vm = this
      vm.$emit('input', value)
    }
  }
}
</script>