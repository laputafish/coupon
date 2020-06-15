<template>
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
</template>

<script>
import formParticipantsTable from './comps/FormParticipantsTable'

export default {
  components: {
    formParticipantsTable
  },
  props: {
    record: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      inputObjs: []
    }
  },
  mounted () {
    const vm = this
    vm.setInputObjs()
  },
  methods: {
    updateInputObjs () {
      const vm = this
      vm.setInputObjs()
    },
    onCommandHandler (payload) {
      this.$emit('onCommand', payload)
    },
    setInputObjs () {
      const vm = this
      if (vm.record) {
        console.log('ParticipantsPage :: inputObjs :: vm.record')
        switch (vm.record.voucher_type) {
          case 'form':
            console.log('inputObjs :: vm.record.voucher_type === form')
            if (vm.record.form_configs && vm.record.form_configs.inputObjs) {
              vm.inputObjs = vm.record.form_configs.inputObjs
            }
            break
          case 'voucher':
            console.log('ParticipantsPage :: setInputObjs :: vm.record.voucher_type === voucher')
            console.log('ParticipantsPage :: setInputObjs :: vm.record.participant_configs: ', vm.record.participant_configs)
            console.log('ParticipantsPage :: setInputObjs :: vm.record.participant_configs.inputObjs: ', vm.record.participant_configs.inputObjs)

            if (vm.record.participant_configs && vm.record.participant_configs.inputObjs) {
              console.log('ParticipantsPage :: participant_configs and inputObjs: => assign participant_configs.inputObjs: ', vm.record.participant_configs.inputObjs)
              vm.inputObjs = vm.record.participant_configs.inputObjs
            } else {
              console.log('ParticipantsPage :: setInputObjs :: no pparticipant_configs')
            }
            break
          default:
            alert('Invalid voucher_type: ' + vm.record.voucher_type)
        }
      }
    }
  },
  watch: {
    'record.form_configs': function () {
      // alert('ParticipantsPage :: watch(record.form_configs)')
      const vm = this
      if (vm.record.voucher_type === 'form') {
        vm.setInputObjs()
      }
    },
    'record.participant_configs': function () {
      // alert('ParticipantsPage :: watch(record.participant_configs)')
      const vm = this
      if (vm.record.voucher_type === 'voucher') {
        vm.setInputObjs()
      }
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
    inputObjs2 () {
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
  }
}
</script>
