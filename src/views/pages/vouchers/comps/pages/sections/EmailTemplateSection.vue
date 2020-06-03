<template>
  <div class="pl-2">
    <template-editor
      ref="emailTemplateEditor"
      id="emailTemplateEditor"
      :content="voucher.email_template"
      :templateTagGroups="templateTagGroups"
      @onCommand="onCommandHandler"></template-editor>
  </div>
</template>

<script>
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

  computed: {
    participantTags () {
      const vm = this
      var result = []
      const participantConfigs = vm.voucher.participant_configs
      if (vm.voucher && vm.voucher.participant_configs) {
        // console.log('participantKeys :: vm.voucher.participant_conifgs: ',
        //   vm.voucher.participant_configs)
        var inputObjs = vm.voucher.participant_configs['inputObjs'];
        for (var i = 0; i < inputObjs.length; i++) {
          var inputObj = inputObjs[i]
          result.push(inputObj.name.toLowerCase().replace(' ', '_'))
        }
      }
      return result
    }
  },
  methods: {
    onTemplateTagGroupsReady (tagGroups) {
      const vm = this
      console.log('EmailTemplateSection :: onTemplateTagGroupsReady :: tagGroup: ', tagGroups)
      console.log('EmailTemplateSection :: onTemplateTagGroupsReady :: participantTags: ', vm.participantTags)

      tagGroups.push({
        name: 'participants',
        tags: vm.participantTags
      })
      return tagGroups
    },

    // updateContent (content) {
    //   const vm = this
    //   this.$emit('onCommand', {
    //     command: 'updateField',
    //     fieldName: 'email_template',
    //     fieldValue: content
    //   })
    // },

    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'updateTemplateContent':
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'email_template',
            fieldValue: payload.fieldValue
          })
          break
        case 'clearTemplate':
          console.log('EmailTemplateSection :: onCommandHandler :: command == clearTemplate')
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'email_template',
            fieldValue: '',
            callback: payload.callback
          })
          break
        case 'changeEditorFullscreenState':
          vm.isFullScreenEditorMode = payload.isFullScreen
          break
        // case 'insertTag':
        //   vm.$refs.htmlEditor.insertTag(payload.value)
        //   break
        default:
          vm.$emit('onCommand', payload)
      }
    }
  }
}
</script>