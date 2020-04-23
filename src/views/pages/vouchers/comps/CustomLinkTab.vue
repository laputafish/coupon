<template>
<b-tab class="bg-white py-2">
  <template v-slot:title>
    {{ title }}
    <div v-if="customLinkName==='none'" class="d-inline-block">(None)</div>
    <div v-else class="badge badge-info">{{ customLinkName }}</div>
  </template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <div class="mb-1 d-flex flex-row align-items-center">

          <table>
            <tr>
              <td class="pr-2">Link:</td>
              <td>
                <div v-if="record.custom_template_id===0">
                  Custom link is not used.
                </div>
                <div v-else-if="!record.custom_link_key || !record.custom_template" class="badge badge-muted">
                  Link is available after saving.
                </div>
                <div v-else class="badge badge-success mr-2 questionnaire-link d-flex flex-row align-items-center"
                     @click="copyCustomLink()">
                  {{ customLink }}
                  <font-awesome-icon class="ml-1" icon="copy"/>
                </div>
              </td>
            </tr>
            <tr>
              <td class="pr-2">Entrance Page:</td>
              <td>
                <data-radio-toggle
                  :value="record.entrance_page_type"
                  @input="value=>updateEntrancePageType(value)"
                  :options="pageOptions"></data-radio-toggle>
                <div v-if="entrancePageKey==='custom'">
                  <data-radio-toggle
                    :value="record.entrance_page_id"
                    @input="value=>updateEntrancePageId(value)"
                    :options="customTemplateOptions"></data-radio-toggle>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </div>
    </div>
  </div>
</b-tab>
</template>

<script>
import dataRadioToggle from '@/views/comps/forms/DataRadioToggle'

export default {
  components: {
    dataRadioToggle
  },
  data () {
    return {
      entrancePageKey: 'questionnaire',
      // ['questionnaire', 'custom23', 'custom34']
      quotaType: 'fixed', // fixed | codes
      quotaCount: 0,

      entrancePageKeyAfterQuota: 'questionnaire',
      // ['questionnaire', 'custom23', 'custom34']

      pageOptions: [
        {name: 'Questionnaire', value: 'questionnaire'},
        {name: 'Custom', value: 'custom'},
        {name: 'None', value: 'none'}
      ]

    }
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    record: {
      type: Object,
      default: null
    }
  },
  computed: {
    customTemplateOptions () {
      const vm = this
      var result = []
      for (var i = 0; i < vm.record.custom_templates.length; i++) {
        var customTemplate = vm.record.custom_templates[i]
        result.push({
          name: customTemplate.name,
          value: customTemplate.id
        })
      }
      return result
    },
    // selectedEntrancePage () {
    //   const vm = this
    //   return vm.entrancePageKey === 'questionnaire' ? 'questionnaire' : 'custom'
    // },
    // selectedEntrancePageAfterQuota () {
    //   const vm = this
    //   return vm.entrancePageKeyAfterQuota === 'questionnaire' ? 'questionnaire' : 'custom'
    // },
    customLink () {
      const vm = this
      return vm.$store.getters.apiUrl + '/q/' + vm.record.questionnaire_key
    },
    customLinkName () {
      const vm = this
      var result = 'none';
      if (vm.record.custom_template_id !== 0) {
        for (var i = 0; i < vm.record.custom_templates.length; i++) {
          if (vm.record.custom_templates[i].id === vm.record.custom_template_id) {
            result = vm.record.custom_templates[i].name
            break
          }
        }
      }
      return result
    }
  },
  method: {
    updateField (fieldName, fieldValue) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateField',
        fieldName: fieldName,
        fieldValue: fieldValue
      })
    },
    updateEntrancePageId (value) {
      this.updateField('entrance_page_id', value)
    },
    updateEntrancePageType (value) {

      this.updateField('entrance_page_type', value)
    },
    updateEntrancePageIdAfterQuota (value) {
      this.updateField('entrance_page_id_after_quota', value)
    },
    updateEntrancePageIdAfterQuota (value) {
      this.updateField('entrance_page_type_after_quota', value)
    },

    // selectEntrancePage (value) {
    //   // value = questionnaire | custom
    //   //
    //   const vm = this
    //   if (value === 'questionnaire') {
    //     vm.$emit('onCommand', {
    //       command: 'updateField',
    //       fieldName: 'entrance_page_type',
    //       fieldValue: 0
    //     })
    //   } else {
    //
    //   }
    //
    // },
    // updateSelectedPage (value) {
    //   console.log('customLinkTab :: updateSelectedPage: ', value)
    // },
    onCommandHandler (payload) {
      const vm = this
      vm.$emit('onCommand', payload)
    },
    copyCustomLink () {
      const vm = this
      vm.$copyText( vm.questionnaireLink )
      vm.$toaster.info(vm.$t('messages.link_copied_to_clipboard'))
    }
  }
}
</script>