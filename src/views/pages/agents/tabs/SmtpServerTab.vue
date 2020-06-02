<template>
  <b-tab class="bg-white py-2">
    <template v-slot:title>
      {{ title }}
      <div v-if="record && record.smtp_servers && record.smtp_servers.length>0"
           class="badge badge-warning">
        {{ record.smtp_servers.length }}
      </div>
    </template>
    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-6 px-3">
          <div class="d-flex flex-row align-items-start">
            <div class="pr-2">
              <button class="btn btn-circle btn-primary"
                @click="addSmtpServer">
                <i class="fa fa-plus"></i>
              </button>
            </div>
            <div class="flex-grow-1">

              <icon-item
                  iconKey="smtp-server"
                  :selected="selectedServer===server"
                  :item="server"
                  v-for="server in record.smtp_servers"
                  :description="server.description"
                  @click="onServerClicked"
                  :key="server.id"></icon-item>
                  <!---->
              <!--<div class="smtp-server-item"-->
                   <!--@click="selectedServer=server"-->
                   <!--:class="{'active':selectedServer===server}"-->
                <!--v-for="server in record.smtp_servers" :key="server.id">-->
                <!--<div class="smtp-server-icon-container">-->
                  <!--<img src="/img/smtp_server.png"/>-->
                <!--</div>-->
                <!--<div class="smtp-server-title">-->
                  <!--{{ server.description }}-->
                <!--</div>-->
                <!--<div class="voucher-count text-center">-->
                  <!--<span v-if="server.voucher_count && server.voucher_count >0">-->
                    <!--{{ server.voucher_count }}&nbsp;x&nbsp;<i class="fas fa-file-alt"></i>-->
                  <!--</span>-->
                <!--</div>-->
              <!--</div>-->
            </div>
          </div>
        </div>
        <div v-if="selectedServer" class="col-sm-6 border p-2 mb-3" style="background-color:#fdf3ba;">
          <div class="row mb-3">
            <div class="col-sm-12">
              <div class="d-flex flex-row bg-gray align-items-center pr-1 pl-2">
                <h4 v-if="selectedServer.description && selectedServer.description!==''" class="m-0 py-2 line-height-1 flex-grow-1">
                  {{ selectedServer.description }}
                </h4>
                <h4 v-else class="m-0 p-2 line-height-1 bg-gray flex-grow-1">
                  (New)
                </h4>
                <button class="btn btn-danger btn-sm"
                        @click="removeSmtpServer">Delete</button>
              </div>
            </div>
          </div>
          <div class="row">
            <data-input id="description" width="6" label="Description" v-model="selectedServer.description"></data-input>
            <data-input id="mailHost" width="4" label="Host" v-model="selectedServer.mail_host"></data-input>
            <data-input id="mailPort" width="2" label="Port" type="Number" v-model="selectedServer.mail_port"></data-input>
            <data-input id="mailUsername" width="4" label="Username" v-model="selectedServer.mail_username"></data-input>
            <data-input id="mailPassword" width="4" type="password" label="Password" v-model="selectedServer.mail_password"></data-input>
            <div class="col-sm-4">
              <div class="form-group">
                <label>Encryption</label>
                <data-radio-toggle
                  class="d-block"
                  :options="encryptionOptions"
                  v-model="selectedServer.mail_encryption">
                </data-radio-toggle>
              </div>
            </div>
            <data-input id="mailFromAddress" width="4" label="From Address" v-model="selectedServer.mail_from_address"></data-input>
            <data-input id="mailFromName" width="4" label="From Name" v-model="selectedServer.mail_from_name"></data-input>
            <div class="col-sm-12 d-flex flex-row align-items-center">
              <div class="p-2 d-flex flex-row align-items-center" style="background-color:#7fc9fd;">
                <div class="pr-2 font-weight-bold">Test</div>
                <input id="receiverEmailAddress" type="text"
                       @keydown="sendingResult=''"
                       class="form-control"
                       style="width:320px;"
                       v-model="receiverEmailAddress">
                <button type="button"
                        @click="sendTestEmail"
                        class="ml-1 min-width-100 btn btn-primary">Send</button>
              </div>
              <div class="ml-3">
                {{ sendingResult }}
              </div>
              <div class="flex-grow-1"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </b-tab>
</template>

<script>
import formInputs from '@/views/comps/forms'
import iconItem from '@/views/comps/IconItem'

export default {
  components: {
    ...formInputs,
    iconItem
  },
  data () {
    return {
      sendingResult: '',
      // example proper smtp server
      /*
      Array
      (
          [description] => SMTP Server
          [mail_driver] => smtp
          [mail_host] => smtp.gmail.com
          [mail_port] => 587
          [mail_username] => yoovcoupon@gmail.com
          [mail_password] => yoovYoov
          [mail_encryption] => tls
          [mail_from_address] => yoovcoupon@gmail.com
          [mail_from_name] => YOOV Ticket
      )
      */
      encryptionOptions: [
        {name: 'TLS', value: 'tls'},
        {name: 'SSL', value: 'ssl'}
      ],
      selectedServer: null,
      receiverEmailAddress: '',
      smtpServers: []
    }
  },
  mounted () {
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    record: {
      type: Object,
      default: null
    }
  },
  watch: {
    'record.smtp_servers': {
      handler () {
        const vm = this
        if (vm.record.smtp_servers.length > 0) {
          if (vm.selectedServer === null) {
            vm.selectedServer = vm.record.smtp_servers[0]
          }
        } else {
          vm.selectedServer = null
        }
      },
      deep: true
    }
  },
  methods: {
    onServerClicked (payload) {
      const vm = this
      vm.selectedServer = payload
    },
    sendTestEmail () {
      const vm = this
      if (vm.receiverEmailAddress.trim() === '') {
        vm.$dialog.alert('Receiver email address not specified!')
        return
      }
      const data = {
        urlCommand: '/email/check',
        data: {
          smtpServer: vm.selectedServer,
          receiverEmailAddress: vm.receiverEmailAddress
        }
      }
      vm.$store.dispatch('AUTH_POST', data).then(
        response => {
          vm.sendingResult = 'Sent Successfully.'
        }
      )
    },
    addSmtpServer () {
      const vm = this
      console.log('SmtpServerTab :: addSmtpServer')
      vm.$emit('onCommand', {
        command: 'newSmtpServer',
        callback: (newServer) => {
          vm.selectedServer = newServer
        }
      });
    },

    removeSmtpServer () {
      alert('removeSmtpServer not implemented!')
    }

  }
}
</script>

<style>

</style>