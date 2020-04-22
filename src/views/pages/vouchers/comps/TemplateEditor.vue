<template>
<div class="d-flex flex-row">
  <tinymce
      ref="templateEditor"
      class="flex-grow-1 bg-muted"
      @editorInit="onEditorInit()"
      style="min-height:480px;"
      id="templateEditor"
      :toolbar1="tinymceToolbar1"
      :other_options="tinymceOtherOptions"
      :options="tinymceOptions"
      :value="value"
      @input="value=>updateContent(value)"></tinymce>
  <div class="flex-grow-0 p-2 bg-muted ml-2">
    <slot name="sidePanel"></slot>
  </div>
</div>
</template>

<script>
import tinymce from 'vue-tinymce-editor'

export default {
  components: {
    tinymce
  },
  data () {
    return {
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

      tinyMCEInFullScreen: false
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  props: {
    value: {
      type: String,
      default: ''
    }
  },
  methods: {
    onEditorInit () {
      const vm = this
      tinyMCE.get('templateEditor').setContent(vm.value ? vm.value : '')
      tinyMCE.get('templateEditor').save()
      tinyMCE.get('templateEditor').on('fullscreenStateChanged', function (e) {
        vm.tinyMCEInFullScreen = e.state
      })

      vm.addTinyMCEButtonEvents(tinyMCE.get('templateEditor'))
    },
    addTinyMCEButtonEvents (editor) {
      const vm = this

      // Upload Image
      var editorObj = $('#templateEditor')
      var inpUpload = $(editorObj).parent().find('input#tinymce-uploader')
      $(inpUpload).off('change').on('change', function () {
        vm.uploadImage(inpUpload, editor)
      })

      const objTinymce = $('#templateEditor').prev('.mce-tinymce')
      console.log('VoucherRecord :: objTinymce :: ', objTinymce)

      const btnSelectImage = $(objTinymce).find('.mce-select-image button')
      console.log('VoucherRecord :: btnSelectImage :: ', btnSelectImage)

      $(btnSelectImage).off('click').on('click', function () {
        vm.showingImageSelectDialog = true
      })


      // Select Image

      //   '' +
      //   ' inpUpload = $(\'<input id="tinymce-uploader' +
      //   '' +
      //   '')
      // vm.addTinyMCEButtonEmbedImage(editor, 'embedImage')
      // vm.addTinyMCEButtonUploadImage(editor, 'uploadImage')
      // vm.tinymceToolbar1 = 'undo redo | formatselect | bold italic strikethrough forecolor backcolor | link embedImage uploadImage | alignleft aligncenter alignright alignjustify | numlist bullist outdent indent | removeformat | fullscreen'
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
      console.log('uploadImage')
      $.ajax({
        headers: {'Authorization': bearerToken},
        url: url,
        type: 'POST',
        data: data,
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request
        success: function (response, textStatus, jqXHR) {
          console.log('VoucherRecord :: uploadImage :: response :: data: ', response)
          const data = response.result
          editor.insertContent('<img class="content-img" src="' + data.imageUrl + '"/>');
        },
        error: function (jqXHR, textStatus, errorThrown) {
          console.log('VoucherRecord :: uploadImage :: error')
          if (jqXHR.responseText) {
            const errors = JSON.parse(jqXHR.responseText).errors
            alert('Error uploading image: ' + errors.join(", ") + '. Make sure the file is an image and has extension jpg/jpeg/png.');
          }
        }
      });
    },
    addTinyMCEButtonEmbedImage (editor, buttonName) {
      const vm = this
    },
    updateContent (value) {
      const vm = this
      vm.$emit('input', value)
    }
  }
}
</script>