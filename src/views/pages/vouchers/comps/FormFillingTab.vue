<template>
  <b-tab class="bg-white py-2">
    <template v-slot:title>
      {{ title }}
    </template>
    <div class="container-fluid p-4">
      <div class="row mb-3">
        <div class="col-sm-12">
          <div class="mb-1 d-flex flex-row align-items-center">
            <table>
              <tr>
                <td class="pr-2">Target Type</td>
                <td>
                  <data-radio-toggle
                      :value="record.goal_type"
                      @input="updateGoalType"
                      :options="goalOptions"></data-radio-toggle>
                </td>
              </tr>
              <tr v-if="record.goal_type==='fixed'">
                <td class="pr-2">Target Count</td>
                <td>
                  <input type="number"
                         class="form-control w-50"
                         :value="record.goal_count"
                         @input="updateGoalCount"/>
                </td>
              </tr>
              <tr v-if="record.goal_type==='codes'">
                <td class="pr-2">Target Count</td>
                <td>
                  <div type="number"
                       readonly
                       class="form-control w-50">
                    {{ record.code_count }}
                  </div>
                </td>
              </tr>
              <!--<tr v-if="record.goal_type!=='none' && false">-->
                <!--<td class="pr-2">When target archived,</td>-->
                <!--<td>-->
                  <!--<data-radio-toggle-->
                      <!--:value="record.action_type_after_goal"-->
                      <!--@input="updateActionTypeAfterGoal"-->
                      <!--:options="optionsAfterGoal"></data-radio-toggle>-->
                <!--</td>-->
              <!--</tr>-->
              <!--<tr v-if="record.action_type_after_goal==='custom'">-->
                <!--<td></td>-->
                <!--<td>-->
                  <!--<data-radio-toggle-->
                      <!--v-if="record.custom_forms.length > 0"-->
                      <!--:value="record.action_page_after_goal"-->
                      <!--@input="updateActionTypeAfterGoal"-->
                      <!--:options="customForms"></data-radio-toggle>-->
                  <!--<div v-else class="text-danger">-->
                    <!--No custom page defined. Please create one!-->
                  <!--</div>-->
                <!--</td>-->
              <!--</tr>-->
            </table>
          </div>
        </div>
      </div>
      <div class="row form-filling-workflow">
        <div class="mb-3 col-sm-12">
          <h5 class="mb-1">Workflow (before Target)</h5>
          <workflow-radio-button
              tag="actionTypeBeforeGoal"
            :selectedActionType="record.action_type_before_goal"
            :customForms="record.custom_forms"
            :options="['form_voucher','form_custom','custom']"
            @onCommand="onCommandHandler"></workflow-radio-button>
          <h5 class="mb-1">Workflow (after Target)</h5>
          <workflow-radio-button
              tag="actionTypeAfterGoal"
              :selectedActionType="record.action_type_after_goal"
              :customForms="record.custom_forms"
              :options="['form_custom', 'custom', 'none']"
              @onCommand="onCommandHandler"></workflow-radio-button>
        </div>
      </div>
    </div>
  </b-tab>
</template>

<script>
  import dataRadioToggle from '@/views/comps/forms/DataRadioToggle'
  import testComp from './TestComp'
  import workflowRadioButton from './comps/WorkflowRadioButton'

  export default {
    components: {
      dataRadioToggle,
      testComp,
      workflowRadioButton
    },
    data () {
      return {
        entrancePageKey: 'questionnaire',
        // ['questionnaire', 'custom23', 'custom34']
        quotaType: 'fixed', // fixed | codes
        quotaCount: 0,

        entrancePageKeyAfterQuota: 'questionnaire',
        // ['questionnaire', 'custom23', 'custom34']

        optionsAfterGoal: [
          {name: 'Continue Filling Form', value: 'questionnaire'},
          {name: 'Goto Page', value: 'custom'},
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
      // customTemplates () {
      //   const vm = this
      //   var result = []
      //   for (var i = 0; i < vm.record.custom_forms.length; i++) {
      //     var template = vm.record.custom_forms[i]
      //     result.push({
      //       name: template.name,
      //       value: 'custom_'.template.id
      //     })
      //   }
      // },
      goalOptions () {
        console.log('goalOptions')
        const vm = this
        var result = []
        result.push({name: 'Fixed', value: 'fixed'})
        result.push({
          name: 'No. of Coupon Codes',
          value: 'codes'
        })
        result.push({
          name: 'Unlimited',
          value: 'none'
        })
        return result
      },
      customFormOptions () {
        const vm = this
        var result = []
        for (var i = 0; i < vm.record.custom_forms.length; i++) {
          var customTemplate = vm.record.custom_forms[i]
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
        if (vm.record.custom_form_id !== 0) {
          for (var i = 0; i < vm.record.custom_forms.length; i++) {
            if (vm.record.custom_forms[i].id === vm.record.custom_form_id) {
              result = vm.record.custom_forms[i].name
              break
            }
          }
        }
        return result
      }
    },
    methods: {
      // updateTestValue (value) {
      //   console.log('updateTestValue: value: ', value)
      // },
      // onCommand (payload) {
      //   const vm = this
      //   console.log('FormFillingTab :: payload: ', payload)
      //   switch (payload.command) {
      //     case 'selectOption':
      //       vm.emit('onCommand', {
      //         'command': 'updateField',
      //         'fieldName': 'goal_type',
      //         'fieldValue': payload['value']
      //       })
      //       break
      //   }
      // },
      updateField (fieldName, fieldValue) {
        const vm = this
        vm.$emit('onCommand', {
          command: 'updateField',
          fieldName: fieldName,
          fieldValue: fieldValue
        })
      },
      updateActionTypeAfterGoal (value) {
        this.updateField('action_type_after_goal', value)
      },
      updateGoalCount (value) {
        this.updateField('goal_count', value)
      },
      updateGoalType (value) {
        this.updateField('goal_type', value)
      },
      // updateEntrancePageType (value) {
      //
      //   this.updateField('entrance_page_type', value)
      // },
      // updateEntrancePageIdAfterQuota (value) {
      //   this.updateField('entrance_page_id_after_quota', value)
      // },

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
        vm.$copyText(vm.questionnaireLink)
        vm.$toaster.info(vm.$t('messages.link_copied_to_clipboard'))
      }
    }
  }
</script>

<style>

  .form-filling-workflow .btn-light img.white-icon {
    display: none;
  }

  .form-filling-workflow .btn-light img:not(.white-icon) {
    display: inline-block;
  }

  .form-filling-workflow .btn-success img.white-icon,
  .form-filling-workflow .btn-primary img.white-icon {
    display: inline-block;
  }

  .form-filling-workflow .btn-success img:not(.white-icon),
  .form-filling-workflow .btn-primary img:not(.white-icon) {
    display: none;
  }
</style>