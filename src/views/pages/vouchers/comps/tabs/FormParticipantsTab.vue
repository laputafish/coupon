<template>
  <b-tab class="bg-white py-2">
    <template v-slot:title>
      {{ title }}
      <div v-if="participantCount>0"
           class="badge badge-warning">
        {{ participantCount }}
      </div>
    </template>
    <div class="container-fluid">
      <div class="row">
        <div class="col-12">
          <form-participants-table
              ref="formParticipantsTable"
              @onCommand="onCommandHandler"
              :voucherId="record.id"
              :inputObjs="inputObjs">
          </form-participants-table>
        </div>
      </div>
    </div>
  </b-tab>
</template>

<script>
import formParticipantsTable from '../pages/page_participants/FormParticipantsTable'
export default {
  components: {
    formParticipantsTable
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
  computed: {
    participantCount () {
      const vm = this
      var result = 0
      if (vm.record && vm.record.participant_count > 0) {
        result = vm.record.participant_count
      }
      return result
    },
    inputObjs () {
      const vm = this
      var result = []
      console.log('inputObjs')
      if (vm.record) {
        console.log('inputObjs :: vm.record')
        switch (vm.record.voucher_type) {
          case 'form':
            console.log('inputObjs :: vm.record.voucher_type === form')
            if (vm.record.form_configs && vm.record.form_configs.inputObjs) {
              result = vm.record.form_configs.inputObjs
            }
            break
          case 'voucher':
            console.log('inputObjs :: vm.record.voucher_type === voucher')
            if (vm.record.participant_configs && vm.record.participant_configs.inputObjs) {
              result = vm.record.participant_configs.inputObjs
            }
            break
          default:
            console.log('inputObjs :: vm.voucher_type unknown')
        }
      }
      console.log('computed(inputObjs) :: inputObjs.length = ' + vm.record.partipiant-length)
      return result
    }
  },
  methods: {
    onCommandHandler (payload) {
      this.$emit('onCommand', payload)
    }
  }
}
</script>

<style>

</style>
