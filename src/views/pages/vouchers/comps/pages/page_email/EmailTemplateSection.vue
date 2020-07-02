<template>
  <div class="pl-2">
    <validation-observer ref="sendEmailInfoObserver" v-slot="{ invalid }">
    <div class="row form-inline">
      <div class="col-sm-6">
        <div class="form-group my-1">
          <label for="subject" class="mr-2">Subject</label>
          <validation-provider name="Subject"
                               rules="required" :immediate="true" v-slot="{errors}"
                               class="d-inline-block flex-grow-1">
            <input type="text"
                   class="w-100 flex-grow-1 form-control"
                   :value="voucher.email_subject"
                   :class="{'has-error':errors.length>0}"
              @input="$event=>updateValue('email_subject', $event.target.value)"/>
          </validation-provider>
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
            <validation-provider name="Email"
                                 rules="required|email" :immediate="true" v-slot="{errors}"
                               class="d-inline-block flex-grow-1">
              <input type="mail" class="flex-grow-1 form-control" v-model="testEmail"
                     @blur="$event=>updateTestEmail($event.target.value)"
                     :class="{'has-error':errors.length>0}"/>
            </validation-provider>
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
    </validation-observer>
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

  watch: {
    'userSettings': {
      handler: function (newValue) {
        const vm = this
        vm.testEmail = newValue['test_email']
      },
      deep: true
    }
  },

  mounted () {
    const vm = this
    vm.testEmail = vm.userSettings['test_email']
  },

  computed: {
    userSettings () {
      return this.$store.getters.userSettings
    },
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
    updateTestEmail (testEmail) {
      const vm = this
      vm.$store.dispatch('UPDATE_USER_SETTING', {keyName: 'test_email', keyValue: vm.testEmail})
    },
    async validate () {
      const vm = this
      return vm.$refs.sendEmailInfoObserver.validate()
    },
    sendTestEmail () {
      const vm = this
      const invalid = vm.$refs.sendEmailInfoObserver.flags.invalid
      console.log('sendTestEmail: flags: ', vm.$refs.sendEmailInfoObserver.flags)
      if (invalid) {
        var errors = []
        for (var fieldName in vm.$refs.sendEmailInfoObserver.errors) {
          var fieldErrors = vm.$refs.sendEmailInfoObserver.errors[fieldName]
          for (var i = 0; i < fieldErrors.length; i++) {
            // console.log('sendTestEmail :: error.value:', error.value)
            errors.push(fieldErrors[i].replace('This field', fieldName))
          }
        }
        vm.$toaster.warning(errors.join('\n'))
        return
      }
      if (!vm.smtpServer) {
        vm.$toaster.warning('SMTP server not defined')
        return
      }
      if (!vm.testEmail) {
        vm.$toaster.warning('Email not defined!')
        return
      }
      vm.sendingTestEmail = true
      vm.$emit('onCommand', {
        command: 'save',
        callback: () => {
          vm.doSendTestEmail()
        }
      })
    },

    doSendTestEmail () {
      const vm = this
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