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
        :voucher="voucher"
        @onCommand="onCommandHandler"
        @input="value=>updateContent(value)">
    </html-editor>
  </div>
  <div v-if="!isFullScreenEditorMode">
     <invalid-tag-list
       class="flex-grow-0 p-2 bg-danger ml-2"
       @onCommand="onCommandHandler"
       :invalidTags="invalidTags"></invalid-tag-list>
     <template-tag-list
         class="flex-grow-0 p-2 bg-muted ml-2"
         :templateTagGroups="templateTagGroups"met
         @onCommand="onCommandHandler"></template-tag-list>
  </div>
  <div v-else
       class="fullscreen-token-list-panel d-flex flex-column">
       <invalid-tag-list
         class="flex-grow-0 p-2 bg-danger ml-2"
         @onCommand="onCommandHandler"
         :invalidTags="invalidTags"></invalid-tag-list>
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
import invalidTagList from '@/views/comps/InvalidTagList'
import xlsFileUpload from '@/views/comps/XlsFileUpload'

export default {
  components: {
    htmlEditor,
    templateTagList,
    invalidTagList,
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
      isFullScreenEditorMode: false,
      invalidTags: null
    }
  },
  methods: {
    getAllTags () {
      const vm = this
      var result = []
      for(var i = 0; i < vm.templateTagGroups.length; i++) {
        result = [...result, ...vm.templateTagGroups[i]['tags']]
      }
      return result
    },
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
      var proceed = false

      if (vm.content.trim() !== '') {
        vm.$dialog.confirm('It will overwrite existing content. Are you sure?').then(
          () => {
            vm.doPasteContent()
          }
        )
      } else {
        vm.doPasteContent()
      }
    },

    doPasteContent () {
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
      vm.checkTags()
      vm.previewTemplate()
    },

    previewTemplate () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'save',
        callback: vm.doPreviewTemplate
      })
    },

    doPreviewTemplate() {
      const vm = this
      const postData = {
        urlCommand: '/templates/create_preview',
        data: {
          content: vm.content,
          tagListGroups: vm.templateTagGroups,
          voucherId: vm.voucher.id,
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
              vm.$refs.htmlEditor.clearContent()
            }
          })
        }
      )
    },

    checkTags () {
      const vm = this
      const founds = [...vm.content.matchAll(/{([^:^}^;]+?)}/g)]
      // console.log('TemplateEditor :: onCommandHandler :: founds: ', founds)
      var userTags = founds.map(item => item[1])
      var allTags = vm.getAllTags()

      var invalidTags = userTags
        .filter(item => allTags.indexOf(item)===-1)
        .map(item => '{' + item + '}')
        .sort()

      vm.invalidTags = {}
      for (var i = 0; i < invalidTags.length; i++) {
        var tag = invalidTags[i]
        if (Object.keys(vm.invalidTags).indexOf(tag) === -1) {
          vm.invalidTags[tag] = 1
        } else {
          vm.invalidTags[tag]++
        }
      }
    },

    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'checkTags':
          vm.checkTags()
          break
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