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
              :inputObjs="record && record.form_configs && record.form_configs.inputObjs ? record.form_configs.inputObjs : []">
          </form-participants-table>
        </div>
      </div>
    </div>
  </b-tab>
</template>

<script>
import formParticipantsTable from '../FormParticipantsTable'
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
