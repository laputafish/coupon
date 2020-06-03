<template>
<div class="d-flex flex-row align-items-stretch">
  <div class="flex-grow-1">
    <div class="toolbar p-1 text-right">
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
      <xls-file-upload
          inputId="uploadCodes"
          uploadUrl="/agent_codes/upload"
          fileType="zip"
          :postData="{id: voucherId}"
          @onUploading="onUploadingHandler"
          @onUploaded="onUploadedHandler"></xls-file-upload>
      </button>
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
         :templateTagGroups="templateTagGroups"
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

  },
  data () {
    return {
      isFullScreenEditorMode: false
    }
  },
  methods: {
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
    }
  }
}
</script>