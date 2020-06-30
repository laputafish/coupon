<template>
<div class="d-flex flex-row m-2">
  <div class="d-flex flex-column">
     <div class="section-icon-item"
          @click="updateActiveSection(section)"
          v-for="section in sections"
          :key="section.key"
          :class="{'active':activeSection===section}">
        <div class="smtp-server-icon-container">
          <img v-if="activeSection===section"
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
      <h3 v-if="activeSection" class="m-0 py-1 px-2 app-heading">{{ activeSection.caption }}</h3>
    </div>
    <div v-if="activeSection">
      <send-emails-section
          ref="sendEmailsSection"
          :voucher="record"
          :smtpServer="activeSmtpServer"
          @onCommand="onCommandHandler"
          :pusherChannel="pusherChannel"
          v-if="activeSection.key=='send-emails'"></send-emails-section>
      <voucher-smtp-servers-section
          :voucher="record"
          :smtpServers="smtpServers"
          @onCommand="onCommandHandler"
          v-if="activeSection.key==='email-servers'"></voucher-smtp-servers-section>
      <email-basic-info-section
          :voucher="record"
          @onCommand="onCommandHandler"
          v-if="activeSection.key==='email-basic-info'"></email-basic-info-section>
      <email-template-section
          :voucher="record"
          :smtpServer="activeSmtpServer"
          @onCommand="onCommandHandler"
          v-if="activeSection.key==='email-template'"></email-template-section>
    </div>
  </div>
</div>
</template>

<script>
import sendEmailsSection from './page_email/SendEmailsSection'
import voucherSmtpServersSection from './page_email/VoucherSmtpServersSection'
import emailTemplateSection from './page_email/EmailTemplateSection'

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
    },
    activeSectionKey: {
      type: String,
      default: ''
    },
    pusherChannel: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      agentTag: '',
      smtpServers: [],

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
        // {
        //   caption: 'Email Basic Info',
        //   iconSrc: '/img/email-basic-info.png',
        //   iconOffSrc: '/img/email-basic-info_off.png',
        //   key: 'email-basic-info'
        // },
        {
          caption: 'Email Template',
          iconSrc: '/img/email_template.png',
          iconOffSrc: '/img/email_template_off.png',
          key: 'email-template'
        }
      ]
    }
  },
  computed: {
    activeSection () {
      const vm = this
      var result = null
      for (var i = 0; i < vm.sections.length; i++) {
        if (vm.sections[i].key === vm.activeSectionKey) {
          result = vm.sections[i]
          break
        }
      }
      return result
    },
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
    }
    // ,
    // smtpServers () {
    //   const vm = this
    //   // var result = []
    //   // if (vm.agentSmtpServers) {
    //   //   for (var i = 0; i < vm.agentSmtpServers.length; i++) {
    //   //     vm.agentSmtpServers[i]['tag'] = vm.agentTag
    //   //   }
    //   // }
    //   return vm.agentSmtpServers
    // }
  },
  methods: {
    updateStatus (data) {
      const vm = this
      vm.$refs.sendEmailsSection.updateStatus(data)
    },

    updateActiveSection (section) {
      this.$emit('onCommand', {
        command: 'updateEmailPageSectionKey',
        value: section.key
      })
    },
    onCommandHandler (payload) {
      this.$emit('onCommand', payload)
    },
    loadAgentSmtpServers (callback) {
      const vm = this
      if (vm.record && vm.record.agent_id !== 0) {
        const data = {
          urlCommand: '/agents/' + vm.record.agent_id + '/' + 'smtp_servers'
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            var smtpServers = []
            for (var i = 0; i < response.smtpServers.length; i++) {
              var smtpServer = response.smtpServers[i]
              smtpServer['is_system'] = 0
              smtpServer['tag'] = ''
              smtpServers.push(smtpServer)
            }
            for (var j = 0; j < response.systemSmtpServers.length; j++) {
              var smtpServer = response.systemSmtpServers[j]
              smtpServer['is_system'] = 1
              smtpServer['tag'] = 'SYSTEM'
              smtpServers.push(smtpServer)
            }
            vm.smtpServers = smtpServers
            vm.agentTag = response.tag
            if (typeof callback === 'function') {
              callback()
            }

          },
          error => {
            console.log('error: ')
            console.log(error)
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
      // console.log('mounted :: loadAgentSmtpServers.then => updateEmailPageSection')
      if (vm.activeSectionKey==='') {
        vm.$emit('onCommand', {
          command: 'updateEmailPageSectionKey',
          value: vm.sections[0].key
        })
      }
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
      cursor: pointer;
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