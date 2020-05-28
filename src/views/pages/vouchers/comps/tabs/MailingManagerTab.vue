<template>
  <b-tab class="bg-white py-2">
    <template v-slot:title>
      Mailing Manager
      <div class="badge badge-warning">
        2 / 30
      </div>
    </template>
    <div class="container-fluid">
      <div class="d-flex flex-row">
        <div>
           <div class="smtp-server-item"
              @click="selectedServer=server"
              :class="{'active':selectedServer===server}"
              v-for="server in smtpServers" :key="server.id">
              <div class="smtp-server-icon-container">
                <img src="/img/smtp_server.png"/>
              </div>
              <div class="smtp-server-title">
                {{ server.description }}
              </div>
              <div class="voucher-count text-center">
                <span v-if="server.voucher_count && server.voucher_count >0">
                  {{ server.voucher_count }}&nbsp;x&nbsp;<i class="fas fa-file-alt"></i>
                </span>
              </div>
            </div>
        </div>
        <div>
          <h1>Mailing Manager</h1>
        </div>
      </div>
    </div>
  </b-tab>
</template>

<script>
export default {
  data () {
    return {
      selectedServer: null,
      smtpServers: [{
        description: 'SMTP #1',
        voucher_count: 10
      }]
    }
  },

}
</script>
