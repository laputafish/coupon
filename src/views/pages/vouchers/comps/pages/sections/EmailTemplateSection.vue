<template>
  <div class="pl-2">
    <div class="row form-inline">
      <div class="col-sm-6">
        <div class="form-group my-1">
          <label for="subject" class="mr-2">Subject</label>
          <input type="text" class="flex-grow-1 form-control" :value="voucher.email_subject"
            @input="$event=>updateValue('email_subject', $event.target.value)"/>
        </div>
      </div>
      <div class="col-sm-3">
        <div class="form-group my-1">
          <label for="cc" class="mr-2">cc</label>
          <input type="text" class="flex-grow-1 form-control" :value="voucher.email_cc"
                 @input="$event=>updateValue('email_cc', $event.target.value)"/>
        </div>
      </div>
      <div class="col-sm-3">
        <div class="form-group my-1">
          <label for="bcc" class="mr-2">bcc</label>
          <input type="text" class="flex-grow-1 form-control" :value="voucher.email_bcc"
                 @input="$event=>updateValue('email_bcc', $event.target.value)"/>
        </div>
      </div>
      <div class="col-sm-6">
        <div class="form-group my-1">
          <label for="testEmail" class="mr-2">Email Testing</label>
          <div class="input-group">
            <input type="mail" class="flex-grow-1 form-control" v-model="testEmail"/>
            <button class="input-group-append"
              @click="sendTestEmail">
              <i class="fas fa-paper-plane"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
    <hr class="my-1"/>
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
  data () {
    return {
      testEmail: ''
    }
  },
  props: {
    voucher: {
      type: Object,
      default: null
    },
    smtpServer: {
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
    sendTestEmail () {
      const vm = this
      if (!vm.smtpServer) {
        vm.$toaster.warning('SMTP server not defined')
        return
      }
      if (!vm.testEmail) {
        vm.$toaster.warning('Email not defined!')
        return
      }
      const postData = {
        urlCommand: '/email_templates/test',
        data: {
          template: vm.voucher.email_template,
          email: vm.testEmail,
          smtpServer: vm.smtpServer,
          tagGroups: vm.templateTagGroups
        }
      }
      vm.$store.dispatch('AUTH_POST', data).then(
        response => {
          console.log('sendTestEmail: response: ', response)
        }
      )
    },

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

    updateValue (fieldName, fieldValue) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateField',
        fieldName: fieldName,
        fieldValue: fieldValue
      })
    },

    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'previewTemplate':
          vm.previewTemplate()
          break
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
    },
    previewTemplate () {
      const vm = this
      const postData = {
        urlCommand: '/email_template/create_preview',
        data: {
          content: vm.voucher.email_template
        }
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        (result) => {
          const key = result.key
          const url = vm.$store.getters.appHost+ '/m/preview/_' + key
          window.open(url, '_blank')
        }
      )
      voucher.email_template
    }
  }
}
</script>