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
      <div class="col-sm-12">
        <div class="form-group my-1">
          <label for="testEmail" class="mr-2">Email Testing</label>
          <div class="input-group">
            <input type="mail" class="flex-grow-1 form-control" v-model="testEmail"/>
            <button class="input-group-append"
              @click="sendTestEmail">
              <font-awesome-icon v-if="sendingTestEmail" icon="spinner" class="mr-1 fa-spin"></font-awesome-icon>
              <font-awesome-icon v-else icon="paper-plane" class="mr-1"></font-awesome-icon>
            </button>
          </div>
          <div v-if="sendingTestEmailResult" class="ml-3"
            :class="{'text-danger': !sendingTestEmailResult['status']}">{{ sendingTestEmailResult['message'] }}</div>
        </div>
      </div>
    </div>
    <hr class="my-1"/>
    <template-editor
      :voucher="voucher"
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
      sendingTestEmail: false,
      sendingTestEmailResult: null,
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
      // const participantConfigs = vm.voucher.participant_configs
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
      vm.sendingTestEmail = true
      const postData = {
        urlCommand: '/email_templates/send_test_email',
        data: {
          voucherId: vm.voucher.id,
          template: vm.voucher.email_template,
          email: vm.testEmail,
          smtpServer: vm.smtpServer,
          tagGroups: vm.templateTagGroups,
          subject: vm.voucher.email_subject,
          cc: vm.voucher.email_cc,
          bcc: vm.voucher.email_bcc
        }
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        response => {
          console.log('sendTestEmail: response: ', response)
          vm.sendingTestEmail = false
          vm.$dialog.alert('Test email sent successfully.')
          // vm.sendingTestEmailResult = {
          //   status: true,
          //   message: 'Test email sent successfully.'
          // }
        },
        error => {
          vm.sendingTestEmail = false
          vm.$dialog.alert(error.message)
          // vm.sendingTestEmailResult = {
          //   status: false,
          //   message: error.message
          // }
        }
      )
    },

    onTemplateTagGroupsReady (tagGroups) {
      const vm = this
      tagGroups.push({
        name: 'participant',
        tags: vm.participantTags
      })
      return tagGroups
    },

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
        case 'copyTemplate':
          console.log('EmailTemplateSection :: onCommandHandler :: payload: ', payload)
          vm.$emit('onCommand', {
            command: 'copyTemplate',
            copyTemplateFor: 'email_template'
          })
          break
        case 'updateTemplateContent':
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'email_template',
            fieldValue: payload.fieldValue
          })
          break
        case 'clearTemplate':
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
        default:
          vm.$emit('onCommand', payload)
      }
    }
  }
}
</script>