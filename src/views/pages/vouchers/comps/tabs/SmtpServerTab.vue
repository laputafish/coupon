<template>
  <b-tab class="bg-white py-2">
    <template v-slot:title>
      SMTP Server
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