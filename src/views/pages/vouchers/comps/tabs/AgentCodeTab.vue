<template>
  <b-tab class="bg-white py-2">
    <template v-slot:title>
      {{ $t('vouchers.codeTabLabel') }}
      <div v-if="record && record.code_count>0"
           class="badge badge-warning">
        {{ record.code_count }}
      </div>
    </template>
    <div class="container-fluid">
      <agent-code-page
        :record="record"
        @onCommand="onCommandHandler"></agent-code-page>
    </div>
  </b-tab>
</template>

<script>

import agentCodePage from '../pages/AgentCodePage'
// import agentCodeTable from '../AgentCodeTable'

export default {
  components: {
    // agentCodeTable
    agentCodePage
  },
  props: {
    title: {
      type: String,
      default: 'No Title'
    },
    record: {
      type: Object,
      default: null
    }
  },
  methods: {
    onCommandHandler (payload) {
      this.$emit('onCommand', payload)
    },
    refresh () {
      this.$refs.agentCodePage.reloadCodeList()
    }
  }
}
</script>