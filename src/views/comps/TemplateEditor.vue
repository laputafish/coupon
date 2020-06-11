<template>
<div class="d-flex flex-row align-items-stretch">
  <div class="flex-grow-1">
    <div class="toolbar p-1 text-right d-flex flex-row align-items-end justify-content-end">
      <div class="btn-group mx-3">

        <button class="btn btn-outline-info btn-sm" @click="copyContent">
          <font-awesome-icon icon="copy" class="mr-1"/>Copy</button>
        <button class="btn btn-outline-info btn-sm" @click="pasteContent($event)">
          <font-awesome-icon icon="paint-brush" class="mr-1"/>Paste</button>
      </div>
      <button type="button"
              class="btn btn-danger min-width-100"
              @click="clearTemplate">
        <i class="fas fa-trash mr-1"></i>Clear
      </button>
      <button type="button"
              class="btn btn-warning"
              @click="copyFile">
        <i class="fas fa-copy mr-1"></i>Copy From ...
      </button>
      <button type="button"
              class="btn btn-primary"
              style="border-bottom-right-radius: 0;border-top-right-radius:0;border-right: 1px darkgray solid;"
              @click="gotoBeeFreeIo">
      <i class="fas fa-cubes mr-1"></i>Bee</button>

      <xls-file-upload
          style="margin-left:0;border-top-left-radius:0;border-bottom-left-radius:0;"
          inputId="uploadTemplate"
          uploadUrl="/html_file/upload_zip"
          fileType="zip"
          :postData="{}"
          @onUploading="onUploadingHandler"
          @onUploaded="onUploadedHandler">
      </xls-file-upload>
      <button type="button"
              class="btn btn-success"
              @click="showPreview">
        <i class="fas fa-mask mr-1"></i>Preview
      </button>
    </div>
    <html-editor
        ref="htmlEditor"
        id="emailTemplateEditor"
        :content="content"
        @onCommand="onCommandHandler"
        @input="value=>updateContent(value)">
    </html-editor>
  </div>
  <div v-if="!isFullScreenEditorMode">
     <template-tag-list
         class="flex-grow-0 p-2 bg-muted ml-2"
         :templateTagGroups="templateTagGroups"met
         @onCommand="onCommandHandler"></template-tag-list>
  </div>
  <div v-else
       class="fullscreen-token-list-panel d-flex flex-column">
      <template-tag-list
          class="flex-grow-0 p-2 bg-muted ml-2"
          :templateTagGroups="templateTagGroups"
          @onCommand="onCommandHandler"></template-tag-list>
  </div>
</div>
</template>

<script>
import htmlEditor from '@/views/comps/HtmlEditor'
import templateTagList from '@/views/comps/TemplateTagList'
import xlsFileUpload from '@/views/comps/XlsFileUpload'

export default {
  components: {
    htmlEditor,
    templateTagList,
    xlsFileUpload
  },
  props: {
    id: {
      type: String,
      default: 'customTemplate'
    },
    content: {
      type: String,
      default: ''
    },
    templateTagGroups: {
      type: Array,
      default () {
        return []
      }
    },
    voucher: {
      type: Object,
      default: null
    }
    // customTemplate: {
    //   type: Object,
    //   default () {
    //     return {
    //       id: 0,
    //       name: '',
    //       content: '',
    //       system: false
    //     }
    //   }
    // }
  },
  computed: {
    agents () {
      return this.$store.getters.agents
    },
    agent () {
      const vm = this
      var result = {
        name: '',
        web: ''
      }
      if (vm.voucher && vm.voucher.agent_id !== 0) {
        const agent = vm.agents.find(agent => agent.id==vm.voucher.agent_id)
        if (agent) {
          result.name = agent.name
          result.web = agent.web
        }
      }
      return result
    }
  },
  data () {
    return {
      isFullScreenEditorMode: false
    }
  },
  methods: {
    onPaste (evt) {
      const vm = this
      console.log('pasteContent : $event: ', evt)
      evt.preventDefaults();
      evt.stopPropagation();
    },
    copyContent () {
      const vm = this
      vm.$copyText(vm.content)
      vm.$toaster.success('Template content copyied to clipboard successfull')
    },

    pasteContent ($event) {
      const vm = this
      navigator.clipboard.readText().then(
        text => {
          vm.setContent(text)
        }
      ).catch(
        err => {
          vm.$toaste.error('Error: cannot paste content in clipboard!')
        }
      )
      // console.log('pasteContent :: dummy: ', vm.$refs.dummy.$el)
      // vm.$refs.dummy.exec
      // console.log('pasteContent : $event: ', $event)
      // const clipboardData = window.clipboardData || event.clipboardData || event.originalEvent && event.originalEvent.clipboardData;
      // const pastedText = clipboardData.getData("Text") || clipboardData.getData("text/plain");
      //
      // if (!pastedText && pastedText.length) {
      //   return;
      // }
      //
      // vm.setContent(pastedText);
    },
    onUploadingHandler () {
    },

    onUploadedHandler (result) {
      const vm = this
      if (vm.content.trim()==='') {
        vm.setContent(result.content)
      } else {
        vm.$dialog.confirm(vm.$t('messages.existingContentWillBeCleared')).then(
          () => {
            vm.setContent(result.content)
          }
        )
      }
    },

    setContent (content) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateTemplateContent',
        fieldValue: content
      })
    },

    copyFile () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'copyTemplate',
        contentType: 'email_template'
      })
    },

    uploadBeeFile () {
      const vm = this

    },

    showPreview () {
      const vm = this
      // vm.$emit('onCommand', {
      //   command: 'previewTemplate'
      // })
      vm.previewTemplate()
    },

    previewTemplate () {
      const vm = this
      const postData = {
        urlCommand: '/templates/create_preview',
        data: {
          content: vm.content,
          tagListGroups: vm.templateTagGroups,
          tagValues: {
            'qrcode': '12345678',
            'barcode': '12345678',
            'voucher_description': vm.voucher.description,
            'voucher_activation_date': vm.voucher.activation_date,
            'voucher_expiry_date': vm.voucher.expiry_date,
            'agent_name': vm.agent.name,
            'agent_web': vm.agent.web
          }
        }
      }

      vm.$store.dispatch('AUTH_POST', postData).then(
        (result) => {
          const key = result.key
          const url = vm.$store.getters.appHost+ '/t/preview/_' + key
          window.open(url, '_blank')
        }
      )
    },

    updateContent (content) {
      const vm = this
      console.log('TemplateEditor :: updateContent :: content: ', content)
      vm.$emit('onCommand', {
        command: 'updateTemplateContent',
        fieldValue: content
      })
    },

    updateTemplateName (value) {
      const vm = this
      vm.$emit('onCommand', {
        'command': 'updateTemplateName',
        'id': vm.customTemplate.id,
        'value': value
      })
    },
    updateTemplateContent (value) {
      const vm = this
      vm.$emit('onCommand', {
        'command': 'updateTemplateContent',
        'id': vm.customTemplate.id,
        'value': value
      })
    },

    clearTemplate () {
      const vm = this
      vm.$dialog.confirm(vm.$t('messages.areYouSure')).then(
        () => {
          vm.$emit('onCommand', {
            'command': 'clearTemplate',
            'callback': () => {
              console.log('TemplateEditor :: clearTemplate :: callback vm: ', vm)
              vm.$refs.htmlEditor.clearContent()
            }
          })
        }
      )
    },

    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'changeEditorFullscreenState':
          vm.isFullScreenEditorMode = payload.isFullScreen
          break
        case 'insertTag':
          vm.$refs.htmlEditor.insertTag(payload.value)
          break
        default:
          vm.$emit('onCommand', payload)
      }
    },

    gotoBeeFreeIo () {
      window.open('https://beefree.io/templates/', '_blank');
    }
  }
}
</script>