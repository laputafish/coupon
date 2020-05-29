<template>
  <b-tab class="bg-white py-2">
    <template v-slot:title>
      Mailing Manager
      <div class="badge badge-warning">
        2 / 30
      </div>
    </template>
    <div class="container-fluid">
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
            <send-emails-section v-if="selectedSection.key=='send-emails'"></send-emails-section>
            <email-servers-section v-if="selectedSection.key==='email-servers'"></email-servers-section>
            <email-template-section v-if="selectedSection.key==='email-template'"></email-template-section>
          </div>
        </div>
      </div>
    </div>
  </b-tab>
</template>

<script>
import sendEmailsSection from './sections/SendEmailsSection'
import emailServersSection from './sections/EmailServersSection'
import emailTemplateSection from './sections/EmailTemplateSection'

export default {
  components: {
    sendEmailsSection,
    emailServersSection,
    emailTemplateSection
  },
  data () {
    return {
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
      selectedSection: null,
      smtpServers: [{
        description: 'SMTP #1',
        voucher_count: 10
      }]
    }
  },
  mounted () {
    const vm = this
    vm.selectedSection = vm.sections[0]
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