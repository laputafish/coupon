<template>
  <div class="row">
    <div class="col-12">
      <agent-code-table
          ref="agentCodeTable"
          @onCommand="onCommandHandler"
          :record="record"
          :codeFieldsStr="record.code_fields"></agent-code-table>
      <!--<agent-code-table-->
      <!--ref="agentCodeTable"-->
      <!--@onCommand="onCommandHandler"-->
      <!--:codeInfos="record.code_infos"-->
      <!--:codeFieldsStr="record.code_fields"></agent-code-table>-->
    </div>
  </div>
</template>

<script>
import agentCodeTable from '../AgentCodeTable'

export default {
  components: {
    agentCodeTable
  },
  props: {
    record: {
      type: Object,
      default: null
    }
  },
  methods: {
    onCommandHandler (payload) {
      return this.$emit('onCommand', payload)
    },
    refresh () {
      this.$refs.agentCodeTable.reloadCodeList()
    }
  }
}
</script>