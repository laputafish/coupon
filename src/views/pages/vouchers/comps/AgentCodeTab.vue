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
      <div class="row">
        <div class="col-12">
          <agent-code-table
              ref="agentCodeTable"
              @onCommand="onCommandHandler"
              :voucherId="record.id"
              :codeFieldsStr="record.code_fields"></agent-code-table>
          <!--<agent-code-table-->
          <!--ref="agentCodeTable"-->
          <!--@onCommand="onCommandHandler"-->
          <!--:codeInfos="record.code_infos"-->
          <!--:codeFieldsStr="record.code_fields"></agent-code-table>-->
        </div>
      </div>
    </div>
  </b-tab>
</template>

<script>
import agentCodeTable from './AgentCodeTable'
export default {
  components: {
    agentCodeTable
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
    }
  }
}
</script>