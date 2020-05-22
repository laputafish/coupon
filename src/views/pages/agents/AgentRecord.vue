<template>
  <div class="container-fluid">
    <title-row :record="record"
               :titleField="titleField"
               :loading="loading"
               :buttons="['back','save']"
               @onCommand="onCommandHandler"></title-row>
    <template v-if="record">
      <div class="row mb-2">
        <data-input width="6" id="name" labelTag="general.name" v-model="record.name"></data-input>
        <data-input width="3" id="alias" labelTag="general.alias" v-model="record.alias"></data-input>
        <data-input width="3" id="contact" labelTag="general.contact" v-model="record.contact"></data-input>
        <data-input width="2" id="tel_no" labelTag="general.telNo" v-model="record.tel_no"></data-input>
        <data-input width="2" id="fax_no" labelTag="general.faxNo" v-model="record.fax_no"></data-input>
        <data-input width="4" id="web_url" labelTag="general.webUrl" v-model="record.web_url"></data-input>
        <data-input width="4" id="email" labelTag="general.email" v-model="record.email"></data-input>
        <!--<data-textarea></data-textarea>-->
      </div>
      <div class="p-2 bg-tab">
        <b-tabs content-class="py-0" class="bg-tab">
          <smtp-server-tab
            ref="smtpServerTab"
            title="SMTP Servers"
            :record="record"
            @onCommand="onCommandHandler"></smtp-server-tab>
        </b-tabs>
      </div>
    </template>

    <b-modal id="errorDialog"
             v-model="showErrorDialog"
             title="Errors">
      <div v-for="(errorGroup, index) in errorGroups"
        :key="index">
        <!--
        errorGroups: [
          {field: fieldName, errors: [...]}
          ...
        ]
        -->
        <div>{{ errorGroup.field }}</div>
        <div>
          <div class="text-gray pl-5" v-for="error in errorGroup.errors" :key="error">
            {{ error }}
          </div>
        </div>
      </div>
      <template v-slot:modal-footer>
        <div class="w-100 text-right">
          <div class="btn-toolbar justify-content-end">
            <b-button
                  variant="primary"
                  size="sm"
                  class="min-width-80"
                  @click="showErrorDialog=false">
              {{ $t('buttons.close') }}
            </b-button>
          </div>
        </div>
      </template>
    </b-modal>
  </div>
</template>

<script>
  import appMixin from '@/mixins/AppMixin'
  import titleRow from '@/views/comps/TitleRow'
  import formInputs from '@/views/comps/forms'
  import smtpServerTab from './tabs/SmtpServerTab'

  import DataRecordMixin from '@/mixins/DataRecordMixin'
  // import helpers from '@/helpers'

  export default {
    mixins: [DataRecordMixin, appMixin],
    components: {
      titleRow,
      smtpServerTab,
      ...formInputs
    },
    data () {
      return {
        showErrorDialog: false,
        apiPath: '/agents',
        titleField: 'name',
        record: null,
        loading: false,
        content: '',
        errorGroups: [],
        blankSmtpServer: {
          id: 0,
          description: '',
          mail_driver: 'smtp',
          mail_host: '',
          mail_port: 587,
          mail_username: '',
          mail_password: '',
          mail_encryption: 'tls',
          mail_from_address: '',
          mail_from_name: ''
        }
      }
    },
    props: {
      recordId: {
        type: Number,
        default: 0
      }
    },
    watch: {
      recordId: function (newValue) {
        const vm = this
        vm.refresh(newValue)
      }
    },
    mounted () {
      const vm = this

      vm.refresh(vm.recordId)
    },
    methods: {
      save () {
        const vm = this
        const data = {
          urlCommand: vm.apiPath + (vm.record.id === 0 ? '' : '/' + vm.record.id),
          data: vm.record
        }
        vm.loading = true
        const action = vm.record.id === 0 ? 'AUTH_POST' : 'AUTH_PUT'
        vm.$store.dispatch(action, data).then(
          response => {
            vm.loading = false
            vm.record.id = response.id
            vm.$store.dispatch('FETCH_AGENTS')
            vm.$toaster.success(vm.$t('messages.saved_successfully'))

            // vm.$router.go(-1);
          },
          error => {
            vm.loading = false
            vm.showErrors(error.data)
          })
      },
      showErrors (errorObj) {
        /*
        errorObj = {
          message: ...,
          errors: {
            field1: [
              '...',
              '...'
            ],
            field2: [
              '...',
              '...'
            ]
          }
         */
        const vm = this
        vm.errorGroups = []
        for (const field in errorObj.errors) {
          vm.errorGroups.push({
            field: field,
            errors: errorObj.errors[field]
          })
        }
        vm.showErrorDialog = true
      },
      newSmtpServerDescription () {
        const vm = this
        console.log('AgentRecord :: newSmtpServerDescription')
        const NEW_DESCRIPTION = 'SMTP Server'
        var result = NEW_DESCRIPTION
        var newDescription = NEW_DESCRIPTION

        var found = vm.record.smtp_servers.find(item => {
          return item.description == newDescription
        })
        if (found) {
          var count = 2

          do {
            newDescription = NEW_DESCRIPTION + ' #' + count
            found = vm.record.smtp_servers.find(item => {
              return item.description == newDescription
            })
            console.log('newSmtpServerDescription :: found: ', found)
            count++
          } while(found)
          // found = vm.record.smtp_servers.find(item => {
          //   return item.description = newDescription
          // })
          //
          // while (found) {
          //   count++
          //
          //   found = vm.record.smtp_servers.find(item => {
          //     return item.description = NEW_DESCRIPTION + ' #' + count
          //   })
          // }
          result = newDescription
        }

        return result
      },
      onCommandHandler (payload) {
        const vm = this
        // console.log('VoucherRecord :: onCommandHandler :: command = ' + payload.command)
        switch (payload.command) {
          case 'newSmtpServer':
            var newSmtpServer = JSON.parse(JSON.stringify(vm.blankSmtpServer))
            newSmtpServer.description = vm.newSmtpServerDescription()
            vm.record.smtp_servers.push(newSmtpServer)
            if (typeof payload.callback === 'function') {
              payload.callback(vm.record.smtp_servers[vm.record.smtp_servers.length-1])
            }
            break
          case 'save':
            vm.save()
            break
        }
      },
    }
  }
</script>
