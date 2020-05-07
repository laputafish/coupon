<template>
<div class="fluid-container p-2">
  <form-type-selection
      :options="formTypes"
      :value="selectedFormType"
      @onCommand="onCommandHandler"
      @input="value=>selectFormType(value)"></form-type-selection>
  <form-builder-panel-content v-if="selectedFormType"
                              :formType="selectedFormType"
                              :participantCount="record.participant_count"
                              @onCommand="onCommandHandler"></form-builder-panel-content>
</div>
</template>

<script>
import formBuilderPanelContent from './FormBuilderPanelContent'
import formTypeSelection from './comps/FormTypeSelection'

export default {
  components: {
    formBuilderPanelContent,
    formTypeSelection
  },
  data () {
    return {
      selectedFormType: null,
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
          // console.log('onCommandHandler :: payload: ', payload)
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
  },
  props: {
    record: {
      type: Object,
      default () {
        return null
      }
    }
  }
}
</script>