<template>
  <div class="w-100 d-flex flex-column justify-content-center align-items-start" style="height:34px;">
    <div v-if="value===''" class="d-inline badge badge-secondary">
      {{ $t('vouchers.available_after_saving') }}
    </div>
    <template v-else>
      <copy-link :link="link"
                 :label="codeKey"
        :variant="variant"></copy-link>
      <div v-if="row.participant_name && row.participant_email">
        <div class="participant-name line-height-1" style="margin-top:-4px;">
          {{ participantName }}
          <div v-if="participantEmail!==''"
               class="ml-1 badge badge-warning bg-gray font-weight-normal"
               style="padding:1px 3px;">{{ participantEmail }}</div>
        </div>
      </div>
      <div v-else-if="row.participant_email">
        <div class="participant-email line-height-1" style="margin-top:-4px;">
          {{ participantEmail }}
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import copyLink from '@/views/comps/CopyLink.vue'

export default {
  components: {
    copyLink
  },
  props: ['row', 'value', 'xprops', 'field'],
  computed: {
    goalType () {
      const vm = this
      var result = 'none'
      if (vm.xprops.record) {
        result = vm.xprops.record.goal_type
      }
      return result
    },
    codeKey () {
      const vm = this
      return vm.value
    },
    link () {
      const vm = this
      return vm.$store.getters.appHost + '/coupons/' + vm.value
    },
    variant () {
      const vm = this
      var result = 'primary'
      if (vm.goalType==='codes' && vm.participantName !== '') {
        result = 'success'
      }
      return result
    },
    participantName () {
      const vm = this
      var result = ''
      if (vm.row['participant_name']) {
        result = vm.row['participant_name']
      }
      return result;
    },
    participantEmail () {
      const vm = this
      var result = ''
      if (vm.row['participant_email']) {
        result = vm.row['participant_email']
      }
      return result;
    }
  }
}
</script>

<style>
.copy-link,
.key-value {
  cursor: pointer;
}

.copy-link {
  color: darkgray;
}

.copy-link:hover {
  color: rgb(10,10,10);
}
</style>