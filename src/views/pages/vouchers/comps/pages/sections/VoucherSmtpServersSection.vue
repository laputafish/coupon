<template>
  <div class="container-fluid">
    <icon-item
        iconKey="smtp-server"
        :disabled="voucher.smtp_server_id!==server.id"
        :tag="server.tag"
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
    },
    smtpServers: {
      type: Array,
      default () {
        return []
      }
    }
  },
  mounted () {
    const vm = this
  },
  methods: {
    onServerClicked (server) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateField',
        fieldName: 'smtp_server_id',
        fieldValue: server.id
      })
    }
  }
}
</script>