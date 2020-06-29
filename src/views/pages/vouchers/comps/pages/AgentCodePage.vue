<template>
  <div class="row">
    <div class="col-12">
      <agent-code-table
          ref="agentCodeTable"
          :pusherChannel="pusherChannel"
          @onCommand="onCommandHandler"
          :record="record"></agent-code-table>
      <!--<agent-code-table-->
      <!--ref="agentCodeTable"-->
      <!--@onCommand="onCommandHandler"-->
      <!--:codeInfos="record.code_infos"-->
      <!--:codeFieldsStr="record.code_fields"></agent-code-table>-->
    </div>
  </div>
</template>

<script>
import agentCodeTable from './page_codes/AgentCodeTable'

export default {
  components: {
    agentCodeTable
  },
  props: {
    record: {
      type: Object,
      default: null
    },
    pusherChannel: {
      type: Object,
      default: null
    }
  },
  methods: {
    onCommandHandler (payload) {
      const vm = this
      vm.$emit('onCommand', payload)
    },
    refresh () {
      this.$refs.agentCodeTable.refresh()
    }
  }
}
</script>