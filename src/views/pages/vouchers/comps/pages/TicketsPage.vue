<template>
  <div class="row">
    <div class="col-12">
      <template-editor
        ref="templateEditor"
        id="templateEditor"
        :content="voucher.template"
        :templateTagGroups="templateTagGroups"
        @onCommand="onCommandHandler"></template-editor>
    </div>
  </div>
</template>

<script>
// import appMixin from '@/mixins/AppMixin'
import templateMixin from "@/mixins/TemplateMixin"
import templateEditor from '@/views/comps/TemplateEditor'

export default {
  mixins: [templateMixin],
  components: {
    templateEditor
  },
  props: {
    voucher: {
      type: Object,
      default: null
    }
  },
  methods: {
    updateContent (content) {
      const vm = this
      this.$emit('onCommand', {
        command: 'updateTemplate',
        templateIndex: vm.selectedIndex,
        content: content
      })
    },
    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        // case 'previewTemplate':
        //   vm.previewTemplate()
        //   break
        case 'updateTemplateContent':
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'template',
            fieldValue: payload.fieldValue
          })
          break
        case 'clearTemplate':
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'template',
            fieldValue: '',
            callback: payload.callback
          })
          break
        case 'changeEditorFullscreenState':
          vm.isFullScreenEditorMode = payload.isFullScreen
          break
        default:
          vm.$emit('onCommand', payload)
      }
    }
    // ,
    // previewTemplate () {
    //   const vm = this
    //   const postData = {
    //     urlCommand: '/voucher_template/create_preview',
    //     data: {
    //       content: vm.voucher.email_template
    //     }
    //   }
    //   vm.$store.dispatch('AUTH_POST', postData).then(
    //     (result) => {
    //       const key = result.key
    //       const url = vm.$store.getters.appHost+ '/m/preview/_' + key
    //       window.open(url, '_blank')
    //     }
    //   )
    //   voucher.email_template
    // }
  }
}
</script>