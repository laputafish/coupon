<template>
  <div class="row">
    <div class="col-12">
      <div class="d-flex flex-row align-items-stretch">

        <tinymce
            ref="yoovEditor"
            class="flex-grow-1 bg-muted"
            @editorInit="onEditorInit()"
            style="min-height:480px;"
            id="yoovEditor"
            :toolbar1="tinymceToolbar1"
            :other_options="tinymceOtherOptions"
            :options="tinymceOptions"
            v-model="record.template"></tinymce>
        <template-key-list
            class="flex-grow-0 p-2 bg-muted ml-2"
            :voucher="record"
            @onCommand="onCommandHandler"></template-key-list>
        <!--<div class="flex-grow-0 p-2 bg-muted ml-2">-->
        <!--<b-button @click="showCopyTemplateDialog"-->
        <!--class="btn btn-primary mb-3 w-100">-->
        <!--{{ $t('vouchers.copyTemplateFrom') }}-->
        <!--</b-button>-->
        <!--<h6>Token List</h6>-->
        <!--<div v-for="keyGroup in templateKeyGroups"-->
        <!--:key="keyGroup['name']">-->
        <!--{{ $t('vouchers.' + keyGroup['name']) }}-->
        <!--<ul class="token-list list-unstyled px-2 mb-1">-->
        <!--<li v-for="templateKey in keyGroup.keys"-->
        <!--:key="templateKey">-->
        <!--<div @click="insertKey(templateKey)"-->
        <!--class="badge badge-warning"><i class="fas fa-plus"></i>&nbsp;{{ '{'+templateKey+'}' }}-->
        <!--</div>-->
        <!--</li>-->
        <!--</ul>-->
        <!--</div>-->
        <!--</div>-->
        <div class="fullscreen-token-list-panel d-flex flex-column"
             v-if="tinyMCEInFullScreen">
                  <template-key-list
                      class="flex-grow-1 p-2 bg-muted"
                      :voucher="record"
                      @onCommand="onCommandHandler"></template-key-list>
          <!--<div class="flex-grow-1 p-2 bg-muted">-->
          <!--&lt;!&ndash;<b-button @click="$bvModal.show('voucherSelectDialog')"&ndash;&gt;-->
          <!--&lt;!&ndash;class="btn btn-primary mb-3 w-100">&ndash;&gt;-->
          <!--&lt;!&ndash;{{ $t('vouchers.copyTemplateFrom') }}&ndash;&gt;-->
          <!--&lt;!&ndash;</b-button>&ndash;&gt;-->
          <!--<b-button @click="showingCopyTemplateDialog"-->
          <!--class="btn btn-primary mb-3 w-100">-->
          <!--{{ $t('vouchers.copyTemplateFrom') }}-->
          <!--</b-button>-->
          <!--<h6>Token List</h6>-->
          <!--<div v-for="keyGroup in templateKeyGroups"-->
          <!--:key="keyGroup['name']">-->
          <!--{{ $t('vouchers.' + keyGroup['name']) }}-->
          <!--<ul class="token-list list-unstyled px-2 mb-1">-->
          <!--<li v-for="templateKey in keyGroup.keys"-->
          <!--:key="templateKey">-->
          <!--<div @click="insertKey(templateKey)"-->
          <!--class="badge badge-warning"><i class="fas fa-plus"></i>&nbsp;{{ '{'+templateKey+'}' }}-->
          <!--</div>-->
          <!--</li>-->
          <!--</ul>-->
          <!--</div>-->
          <!--</div>-->
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import appMixin from '@/mixins/AppMixin'
import tinymce from 'vue-tinymce-editor'
import templateTagList from '@/views/comps/TemplateTagList'
// import helpers from '@/helpers'

export default {
  mixins: {
    appMixin
  },
  components: {
    tinymce,
    templateTagList
  },
  props: {
    record: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      // defaultTemplateKeyGroups: [],
      tinymceOptions: {
        twoWay: true
      },
      tinymceOtherOptions: {
        'relative_urls': false,
        'remove_script_host': false,
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
      tinyMCEInFullScreen: false,
    }
  },
  // computed: {
  //   templateKeyGroups () {
  //     const vm = this
  //     const result = JSON.parse(JSON.stringify(vm.defaultTemplateKeyGroups))
  //     if (vm.codeFields.length > 0) {
  //       result.push({
  //         name: 'code',
  //         keys: []
  //       })
  //     }
  //     const lastIndex = result.length - 1
  //     for (let i = 0; i < vm.codeFields.length; i++) {
  //       const key = helpers.str2token('code_', vm.codeFields[i])
  //       result[lastIndex]['keys'].push(key)
  //     }
  //     return result
  //   },
  //   codeFields () {
  //     const vm = this
  //     let result = []
  //     if (vm.record.code_fields !== null && vm.record.code_fields !== '') {
  //       // console.log('codeFields :: codeFields = ' + vm.record.code_fields)
  //       const arKeyPairs = helpers.getKeyPairArray(vm.record.code_fields)
  //       // console.log('codeFields :: arKeyPairs: ', arKeyPairs)
  //       result = arKeyPairs.map(keyPair => keyPair[0])
  //     }
  //     return result
  //   }
  // },
  // mounted () {
  //   const vm = this
  //   vm.fetchDefaultTemplateKeys()
  // },
  methods: {
    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'insertTag':
          console.log('onCommandHandler :: insertTag :: payload: ', payload)
          tinyMCE.get('yoovEditor').execCommand('mceInsertContent', false, '{' + payload.value + '}')
          break
        default:
          vm.$emit('onCommand', payload)
      }
    },
    // fetchDefaultTemplateKeys () {
    //   const vm = this
    //   vm.defaultTemplateKeyGroups = []
    //   vm.$store.dispatch('AUTH_GET', '/template_keys').then(
    //     response => {
    //       for (let i = 0; i < response.length; i++) {
    //         const responseItem = response[i]
    //         const category = responseItem.category
    //         const key = responseItem.key
    //         const keyGroup = vm.defaultTemplateKeyGroups.find(group => {
    //           return group.name === category
    //         })
    //         if (keyGroup) {
    //           // console.log('keyGroup is true: ', keyGroup)
    //           keyGroup.keys.push(key)
    //         } else {
    //           // console.log('keyGroup is false: ', keyGroup)
    //           vm.defaultTemplateKeyGroups.push({
    //             name: category,
    //             keys: [key]
    //           })
    //         }
    //       }
    //     },
    //     () => {
    //       vm.showSessionExpired('template keys')
    //       // vm.$dialog.alert('Template Keys: ' + vm.$t('messages.error_during_loading'))
    //     }
    //   )
    // },


    onEditorInit () {
      const vm = this
      tinyMCE.get('yoovEditor').setContent(vm.record.template ? vm.record.template : '')
      tinyMCE.get('yoovEditor').save()
      tinyMCE.get('yoovEditor').on('fullscreenStateChanged', function (e) {
        vm.tinyMCEInFullScreen = e.state
      })
      const editor = tinyMCE.get('yoovEditor')
      editor.on('blur', function (e) {
        editor.selection.collapse(false);
        // console.log('yooveditor.on(blur) e: ', e)
      })
      // tinymce.get('yoovEditor').setContent('<p>hello world</p>')
      // console.log('tinymce: ', tinymce)
      // vm.$refs.yoovEditor.setContent('<p>hello world</p>')
      // console.log('template: ', vm.record.template)

      vm.addTinyMCEButtonEvents(tinyMCE.get('yoovEditor'))
    },
    addTinyMCEButtonEvents (editor) {
      const vm = this

      //*****************
      // Upload Image
      //*****************
      var editorObj = $('#yoovEditor')
      var inpUpload = $(editorObj).parent().find('input#tinymce-uploader')
      $(inpUpload).off('change').on('change', function () {
        vm.uploadImage(inpUpload, editor)
      })
      const objTinymce = $('#yoovEditor').prev('.mce-tinymce')
      const btnSelectImage = $(objTinymce).find('.mce-select-image button')

      //*****************
      // Select Image
      //*****************
      $(btnSelectImage).off('click').on('click', function () {
        vm.$emit('onCommand', {
          command: 'showImageSelectDialog',
          imageScope: 'tinymce'
        })
        // vm.imageScope = 'tinymce'
        // vm.showingImageSelectDialog = true
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
    insertImage (imageId) {
      const vm = this
      const url = vm.$store.getters.appHost + '/media/image/' + imageId
      const editor = tinyMCE.get('yoovEditor')
      editor.insertContent('<img class="content-img" src="' + url + '"/>');
      vm.$toaster.success('Image Added')
    },
    addTinyMCEButtonEmbedImage (editor, buttonName) {
      const vm = this
      // alert('addTinyMCEButtonEmbedImage')
      // var inpEmbed = $('<input id="tinymce-embedder" type="file" name="pic" accept="image/*" style="display:none">')
      // $(editor.getElement()).parent().append(inpEmbed)
      //
      // inpEmbed.on("change", function () {
      //   var input = inpEmbed.get(0)
      //   var file = input.files[0]
      //   var fr = new FileReader()
      //   fr.onload = function () {
      //     var img = new Image()
      //     img.src = fr.result
      //     editor.insertContent('<img src="' + img.src + '"/>')
      //     inpEmbed.val('')
      //   }
      //   fr.readAsDataURL(file);
      // })
      //
      // editor.addButton(buttonName, {
      //   tooltip: 'Embed Image',
      //   icon: 'upload',
      //   onclick: function () {
      //     inpEmbed.trigger('click')
      //   }
      // })
    }
  }
}
</script>