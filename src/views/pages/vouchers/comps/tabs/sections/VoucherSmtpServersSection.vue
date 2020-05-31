<template>
  <div class="container-fluid">
    <icon-item
        iconKey="smtp-server"
        :selected="selectedServer===server"
        :item="server"
        v-for="server in smtpServers"
        :description="server.description"
        @click="onServerClicked"
        :key="server.id"></icon-item>
  </div>
</template>

<script>
import iconItem from '@/views/comps/IconItem'

export default {
  components: {
    iconItem
  },
  props: {
    voucher: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      smtpServers: []
    }
  },
  mounted () {
    const vm = this
    vm.loadSmtpServers()
  },
  methods: {
    onServerClicked (server) {

    },
    loadSmtpServers () {
      console.log('loadSmtpServers')
      const vm = this
      if (vm.voucher && vm.voucher.agent_id !== 0) {
        console.log('loadSmtpServers :: AUTH_GET')
        const data = {
          urlCommand: '/agents/' + vm.voucher.agent_id + '/' + 'smtp_servers'
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            console.log('AUTH_GET.then :: response: ', response)
            vm.smtpServers = response
          }
        )
      }
    }
  }
}
</script>