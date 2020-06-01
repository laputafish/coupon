<template>
<div class="row">
  <div class="col-sm-12">
    <form-type-selection
        :options="formTypes"
        :value="selectedFormType"
        @onCommand="onCommandHandler"
        @input="value=>selectFormType(value)"></form-type-selection>
    <form-builder-panel-content ref="formBuilderPanelContent" v-if="selectedFormType"
                                :formType="selectedFormType"
                                :voucher="record"
                                :participantCount="record.participant_count"
                                @onCommand="onCommandHandler"></form-builder-panel-content>
  </div>
</div>
</template>

<script>
import formBuilderPanelContent from '@/views/comps/formInputObjs/FormBuilderPanelContent'
import formTypeSelection from '@/views/comps/formInputObjs/comps/FormTypeSelection'

export default {
  components: {
    formBuilderPanelContent,
    formTypeSelection
  },
  props: {
    record: {
      type: Object,
      default () {
        return null
      }
    }
  },
  data () {
    return {
      selectedFormType: null,
    }
  },
  watch: {
    formTypes: {
      handler: function(newValue) {
        const vm = this
        if (vm.selectedFormType) {
          var key = vm.selectedFormType.key
          for (var i = 0; i < vm.formTypes.length; i++) {
            if (vm.formTypes[i].key === key) {
              vm.selectedFormType = vm.formTypes[i]
              vm.$refs.formBuilderPanelContent.updateSelectedInputObj(vm.selectedFormType)
              break
            }
          }
        } else {
          vm.selectedFormType = vm.formTypes[0]
          vm.$refs.formBuilderPanelContent.updateSelectedInputObj(vm.selectedFormType)
        }
      },
      deep: true
    }
  },
  methods: {
    selectFormType (formType) {
      const vm = this
      if (formType.key === 'ADD') {
        vm.$emit('onCommand', {
          command: 'newFormType'
        })
      } else {
        vm.selectedFormType = formType
      }
    },
    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      switch (command) {
        case 'renameFormType':
        case 'removeFormType':
          vm.$emit('onCommand', payload)
          break
        default:
          payload = {
            ...payload,
            key: vm.selectedFormType.key
          }
          vm.$emit('onCommand', payload)
      }
    }
  },
  computed: {
    formTypes () {
      const vm = this

      var result = [{
        name: 'Question',
        key: 'question',
        formConfigs: vm.record.form_configs
      }]

      for (var i = 0; i < vm.record.custom_forms.length; i++) {
        var customForm = vm.record.custom_forms[i]
        result.push({
          name: customForm.name,
          key: customForm.form_key,
          formConfigs: customForm.form_configs
        })
      }
      return result
    }
  },
  mounted () {
    const vm = this
    vm.selectedFormType = vm.formTypes[0]
  }
}
</script>