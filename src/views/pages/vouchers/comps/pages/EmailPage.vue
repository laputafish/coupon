<template>
<div class="d-flex flex-row m-2">
  <div class="d-flex flex-column">
     <div class="section-icon-item"
          @click="selectedSection=section"
          v-for="section in sections"
          :key="section.key"
          :class="{'active':selectedSection===section}">
        <div class="smtp-server-icon-container">
          <img v-if="selectedSection===section"
               :src="section.iconSrc"/>
          <img v-else
               style="opacity:0.3;"
               :src="section.iconOffSrc"/>
        </div>
        <div class="smtp-server-title">
          {{ section.caption }}
        </div>
     </div>
  </div>
  <div class="ml-3 rounded border flex-grow-1 d-flex flex-column justify-content-stretch overflow-hidden">
    <div class="p-0">
      <h3 v-if="selectedSection" class="m-0 py-1 px-2 app-heading">{{ selectedSection.caption }}</h3>
    </div>
    <div v-if="selectedSection">
      <send-emails-section
          :voucher="record"
          :smtpServer="activeSmtpServer"
          @onCommand="onCommandHandler"
          v-if="selectedSection.key=='send-emails'"></send-emails-section>
      <voucher-smtp-servers-section
          :voucher="record"
          :smtpServers="smtpServers"
          @onCommand="onCommandHandler"
          v-if="selectedSection.key==='email-servers'"></voucher-smtp-servers-section>
      <email-template-section
          :voucher="record"
          @onCommand="onCommandHandler"
          v-if="selectedSection.key==='email-template'"></email-template-section>
    </div>
  </div>
</div>
</template>

<script>
import sendEmailsSection from './sections/SendEmailsSection'
import voucherSmtpServersSection from './sections/VoucherSmtpServersSection'
import emailTemplateSection from './sections/EmailTemplateSection'

export default {
  components: {
    sendEmailsSection,
    voucherSmtpServersSection,
    emailTemplateSection
  },
  props: {
    record: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      agentTag: '',
      agentSmtpServer: [],

      sections: [
        {
          caption: 'Send Emails',
          iconSrc: '/img/send_email.png',
          iconOffSrc: '/img/send_email_off.png',
          key: 'send-emails'
        },
        {
          caption: 'Email Servers',
          iconSrc: '/img/email-servers.png',
          iconOffSrc: '/img/email-servers_off.png',
          key: 'email-servers'
        },
        {
          caption: 'Email Template',
          iconSrc: '/img/email_template.png',
          iconOffSrc: '/img/email_template_off.png',
          key: 'email-template'
        }
      ],
      selectedSection: null
    }
  },
  computed: {
    activeSmtpServer () {
      const vm = this
      var result = null
      if (vm.smtpServers) {
        for (var i = 0; i < vm.smtpServers.length; i++) {
          if (vm.smtpServers[i].id === vm.record.smtp_server_id) {
            result = vm.smtpServers[i]
            break
          }
        }
      }
      return result
    },
    smtpServers () {
      const vm = this
      // var result = []
      // if (vm.agentSmtpServers) {
      //   for (var i = 0; i < vm.agentSmtpServers.length; i++) {
      //     vm.agentSmtpServers[i]['tag'] = vm.agentTag
      //   }
      // }
      return vm.agentSmtpServers
    }
  },
  methods: {
    onCommandHandler (payload) {
      console.log('onCommandHandler :: payload: ', payload)
      this.$emit('onCommand', payload)
    },
    loadAgentSmtpServers (callback) {
      const vm = this
      console.log('loadAgentSmtpServers :: record: ', vm.record)
      if (vm.record && vm.record.agent_id !== 0) {
        const data = {
          urlCommand: '/agents/' + vm.record.agent_id + '/' + 'smtp_servers'
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            console.log('AUTH_GET.then :: response: ', response)
            vm.agentSmtpServers = response.smtpServers
            vm.agentTag = response.tag
            if (typeof callback === 'function') {
              callback()
            }

          }
        )
      } else {
        if (typeof callback === 'function') {
          callback()
        }
      }
    }
  },
  mounted () {
    const vm = this
    vm.loadAgentSmtpServers(() => {
      vm.selectedSection = vm.sections[0]
    })
  }

}
</script>

<style>
    .section-icon-item.active {
      background-color: rgba(127,127,127,.2);
    }

    .section-icon-item {
      text-align: center;
      padding: 10px 20px;
      margin-bottom: 5px;
      display: inline-block;
      width: 180px;
      height: 130px;
      border-radius: 0.5rem;
    }

    .smtp-server-icon-container {
      padding: 5px 30px;
    }

    .smtp-server-icon-container img {
      width: 100%;

      height: auto;
      object-fit: contain;
    }

    .smtp-server-title {
      line-height: 1;
      margin-bottom: 5px;
      padding: 0;
      margin:0;
    }
</style>