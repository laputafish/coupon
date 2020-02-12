<template>
  <div class="container-fluid">
    <div class="row">
      <div v-if="record" class="col-12 border-bottom border-2 mb-3">
        <div class="d-flex flex-row justify-content-between">
          <div class="record-title flex-grow-1">
            <h2 v-if="record && record.description.length>0" class="d-inline mr-2">{{ record.description }}</h2>
            <h2 class="d-inline">[{{ recordId===0 ? $t('general.new') : $t('general.edit') }}]</h2>
          </div>
          <div class="btn-toolbar mb-1 flex-grow-0" role="toolbar" aria-label="Toolbar with buttons">
            <button type="button"
                    @click="$router.go(-1)"
                    class="btn btn-outline-secondary min-width-80">
              <i class="fas fa-reply"></i>&nbsp;{{ $t('buttons.back') }}
            </button>            <button type="button"
                                         @click="save()"
                                         class="btn btn-primary min-width-80">
              <i v-if="loading" class="fa fa-spinner fa-spin"></i>
              <i v-else class="fas fa-save"></i>
              {{ $t('buttons.save') }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="row" v-if="record">
      <div class="col-sm-6">
        <div class="form-group">
          <label for="description">{{ $t('general.description') }}</label>
          <input class="form-control" id="description" name="description" type="text" v-model="record.description"/>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="form-group">
          <label for="activation_date">{{ $t('vouchers.activation_date') }}</label>
          <!--<input class="form-control" id="activation_date" name="activation_date"-->
          <!--type="date"-->
          <!--v-model="record.activation_date"/>-->
          <date-picker v-model="record.activation_date" class="w-100" valueType="format"></date-picker>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="form-group">
          <label for="expiry_date">{{ $t('vouchers.expiry_date') }}</label>
          <!--<input class="form-control" id="expiry_date" name="expiry_date"-->
          <!--type="date"-->
          <!--v-model="record.expiry_date"/>-->
          <date-picker v-model="record.expiry_date" class="w-100" valueType="format"></date-picker>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="form-group">
          <label for="created_at">{{ $t('vouchers.creation_date') }}</label>
          <input readonly class="form-control" id="created_at" name="created_at"
                 type="text"
                 v-model="record.created_at"/>
          <!--<date-picker v-model="record.created_at" class="w-100" valueType="format"></date-picker>-->
        </div>
      </div>
      <div class="col-sm-4">
        <div class="form-group">
          <label for="agent_id">{{ $t('agents.agent') }}</label>
          <select class="form-control" id="agent_id" name="agent_id" v-model="record.agent_id">
            <option v-for="agent in agents"
                    :key="agent.id"
                    :value="agent.id">{{ agent.name }}</option>
          </select>
        </div>
      </div>
      <div class="col-sm-6">
        <div class="form-group">
          <label for="qr_code_composition">{{ $t('vouchers.qr_code_composition') }}</label>
          <input type="text" class="form-control" id="qr_code_composition" name="qr_code_composition"
                 v-model="record.qr_code_composition"/>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="form-group">
          <label for="status">{{ $t('general.status') }}</label>
          <input readonly class="form-control" id="status" name="status"
                 type="text"
                 :value="$t('status.' + record.status)"/>
        </div>
      </div>
    </div>
    <div v-if="record" class="p-2 bg-tab">
      <b-tabs content-class="py-0" class="bg-tab">
        <b-tab title="Agent Codes & Emails" class="bg-white py-2">
          <div class="container-fluid">
            <div class="row">
              <div class="col-7">
                <agent-code-table
                    ref="agentCodeTable"
                    @onCommand="onCommandHandler"
                    :codeInfos="record.code_infos"
                    :codeFieldsStr="record.code_fields"></agent-code-table>
              </div>
              <div class="col-5">
                <email-table
                    ref="emailTable"
                    @onCommand="onCommandHandler"
                    :emails="record.emails"></email-table>
              </div>
            </div>
          </div>
        </b-tab>
        <b-tab title="Leaflet Template" class="bg-white py-2">
          <div class="container-fluid">
            <div class="row">
              <div class="col-12">
              </div>
            </div>
            <div class="row" v-if="record">
              <div class="col-12 d-flex flex-row">
                 <editor
                     api-key="no-api-key"
                     :init="{
                     height: 500,
                     menubar: false,
                     plugins: [
                       'advlist autolink lists link image charmap print preview anchor',
                       'searchreplace visualblocks code fullscreen',
                       'insertdatetime media table paste code help wordcount'
                     ],
                     toolbar:
                       'undo redo | formatselect | bold italic backcolor | \
                       alignleft aligncenter alignright alignjustify | \
                       bullist numlist outdent indent | removeformat | help'
                   }"
                 />
                <!--<tinymce class="flex-grow-1 bg-muted" style="min-height:480px;" id="leaflet-template" v-model="record.template"></tinymce>-->

                <div class="flex-grow-0 p-2 bg-muted ml-2">
                  <h6>Token List</h6>
                  <div v-for="keyGroup in templateKeyGroups"
                       :key="keyGroup['name']">
                    {{ $t('vouchers.' + keyGroup['name']) }}
                    <ul class="token-list list-unstyled px-2">
                    <li v-for="templateKey in keyGroup.keys"
                        :key="templateKey">
                      <div class="badge badge-info">{{ '{'+templateKey+'}' }}</div>
                    </li>
                    </ul>

                  </div>
                </div>
              </div>
            </div>
          </div>
        </b-tab>
      </b-tabs>
    </div>
    <div v-else class="text-center">
      <h4 class="text-center">
        <i claas="fa fa-spinner fa-spin"></i>
      </h4>
    </div>
  </div>
</template>

<script>
import agentCodeTable from './comps/AgentCodeTable'
import emailTable from './comps/EmailTable'
// import tinymce from 'vue-tinymce-editor'
import datePicker from 'vue2-datepicker'
import 'vue2-datepicker/index.css'
import helpers from '@/helpers'
import editor from '@tinymce/tinymce-vue'

export default {
  components: {
    agentCodeTable,
    emailTable,
    datePicker,
    editor
  },
  data () {
    return {
      apiPath: '/vouchers',
      record: null,
      csrfToken: null,
      content: '<table class="border bg-gray"><tr><td>sdfdsfdsfs<br/>sdlfksdlfjds</td></tr></table>sdlkfjsdklfjds',
      defaultTemplateKeyGroups: [],
      agents: []
    }
  },
  props: {
    recordId: {
      type: Number,
      default: 0
    }
  },
  computed: {
    templateKeyGroups () {
      const vm = this
      const result = vm.defaultTemplateKeyGroups
      if (vm.codeFields.length > 0) {
        vm.defaultTemplateKeyGroups.push({
          name: 'code',
          keys: []
        })
      }
      for (let i = 0; i < vm.codeFields.length; i++) {
        let key = helpers.str2token('code_', vm.codeFields[i])
        vm.defaultTemplateKeyGroups[vm.defaultTemplateKeyGroups.length - 1]['keys'].push(key)
      }
      return result
    },
    codeFields () {
      const vm = this
      let result = []
      if (vm.record.code_fields !== null && vm.record.code_fields !== '') {
        console.log('codeFields :: codeFields = ' + vm.record.code_fields)
        const arKeyPairs = helpers.getKeyPairArray(vm.record.code_fields)
        console.log('codeFields :: arKeyPairs: ', arKeyPairs)
        result = arKeyPairs.map(keyPair => keyPair[0])
      }
      return result
    }
  },
  watch: {
    recordId: function (newValue) {
      const vm = this
      console.log('VoucherRecord :: watch(recordId) : newvalue = ' + newValue)
      vm.refreshDataRecord(newValue)
    }
  },
  mounted () {
    const vm = this
    vm.fetchAgents();
    vm.refreshDataRecord(vm.recordId)
    vm.fetchDefaultTemplateKeys()
  },
  methods: {
    fetchAgents () {
      const vm = this
      vm.$store.dispatch('COMMON_GET', '/agents').then(response => {
        vm.agents = response
      })
    },
    fetchDefaultTemplateKeys () {
      const vm = this
      vm.defaultTemplateKeyGroups = []
      vm.$store.dispatch('COMMON_GET', '/template_keys').then(response => {
        for (let i = 0; i < response.length; i++) {
          const responseItem = response[i]
          const category = responseItem.category
          const key = responseItem.key
          const keyGroup = vm.defaultTemplateKeyGroups.find(group => {
            return group.name === category
          })
          if (keyGroup) {
            console.log('keyGroup is true: ', keyGroup)
            keyGroup.keys.push(key)
          } else {
            console.log('keyGroup is false: ', keyGroup)
            vm.defaultTemplateKeyGroups.push({
              name: category,
              keys: [key]
            })
          }
        }
      })
    },
    onCommandHandler (payload) {
      const vm = this
      console.log('VoucherRecord :: onCommandHandler :: command = ' + payload.command)
      switch (payload.command) {
        // case 'saveTemp':
        //   vm.saveTemp()
        //   break
        case 'setCodeFields':
          vm.record.code_fields = vm.createCodeFieldStr(payload.value)
          break
        case 'setCodeData':
          vm.updateCodeInfos(payload.value)
          // vm.record.codeInfos = vm.createCodeInfos(payload.value)
          break
      }
    },
    updateCodeInfos (codeDataList) {
      // codeDataList = [
      //    ['value1', 'value2', 'value3', 'value4'],
      //    ['value1', 'value2', 'value3', 'value4'],
      //    ['value1', 'value2', 'value3', 'value4'],
      //    ['value1', 'value2', 'value3', 'value4']
      // ]
      console.log('updateCodeInfos :: codeDataList: ', codeDataList)
      let vm = this
      let existingCodes = []
      if (vm.record.code_infos) {
        existingCodes = vm.record.code_infos.map(codeInfo => codeInfo.code)
      } else {
        vm.record.code_infos = []
      }
      console.log('updateCodeInfos :: existingCodes: ', existingCodes)
      for (let i = 0; i < codeDataList.length; i++) {
        const fields = []
        const code = codeDataList[i][0]
        console.log('updateCodeInfos :: code = ' + code)
        for (let j = 1; j < codeDataList[i].length; j++) {
          const value = codeDataList[i][j]
          console.log('updateCodeInfos j=' + j + ': value=' + value)
          fields.push(value)
        }
        const extraFields = fields.join('|')
        const index = existingCodes.indexOf(code)
        // if exists
        if (index >= 0) {
          vm.record.code_infos[index].extra_fields = extraFields
        } else {
          vm.record.code_infos.push({
            id: 0,
            code: code,
            extra_fields: fields.join('|'),
            sent_on: '',
            status: 'pending'
          })
          existingCodes.push(code)
        }
      }
    },
    createCodeInfos (codeDataList) {
      // codeDataList = [
      //    ['value1', 'value2', 'value3', 'value4'],
      //    ['value1', 'value2', 'value3', 'value4'],
      //    ['value1', 'value2', 'value3', 'value4'],
      //    ['value1', 'value2', 'value3', 'value4']
      // ]
      const result = []
      for (let i = 0; i < codeDataList.length; i++) {
        const fields = []
        for (let j = 0; j < codeDataList[i].length; j++) {
          fields.push(codeDataList[i][j])
        }
        result.push({
          id: 0,
          code_details: fields.join('|'),
          sent_on: '',
          status: 'pending'
        })
      }
      return result
    },
    createCodeFieldStr (arCodeFields) {
      const result = []
      for (let i = 0; i < arCodeFields.length; i++) {
        result.push(arCodeFields[i]['title'] + ':' + arCodeFields[i]['type'])
      }
      return result.join('|')
    },

    // saveTemp () {
    //   const vm = this
    //   const agentCodeInfo = vm.$refs.agentCodeTable.getAgentCodeInfo()
    //   const reqData = JSON.parse(JSON.stringify(vm.record))
    //   reqData.status = 'preparing'
    //   reqData['fields'] = agentCodeInfo['fields']
    //   reqData['code_details'] = agentCodeInfo['codeDetails']
    //   const data = {
    //     urlCommand: vm.apiPath + (vm.record.id === 0 ? '' : '/' + vm.record.id),
    //     data: reqData
    //   }
    //   vm.loading = true
    //   const action = vm.record.id === 0 ? 'COMMON_POST' : 'COMMON_PUT'
    //   vm.$store.dispatch(action, data).then(response => {
    //     console.log('saveTemp: response: ', response)
    //     vm.loading = false
    //     vm.record.id = response.id
    //   })
    // },

    save () {
      const vm = this
      // const agentCodeInfo = vm.$refs.agentCodeTable.getAgentCodeInfo()
      // const reqData = JSON.parse(JSON.stringify(vm.record))
      // reqData['fields'] = agentCodeInfo['fields']
      // reqData['code_details'] = agentCodeInfo['codeDetails']
      const data = {
        urlCommand: vm.apiPath + (vm.record.id === 0 ? '' : '/' + vm.record.id),
        // options: {
        //   headers: {
        //     'X-CSRF-TOKEN': vm.csrfToken
        //   }
        // },
        data: vm.record
      }
      vm.loading = true
      const action = vm.record.id === 0 ? 'COMMON_POST' : 'COMMON_PUT'
      vm.$store.dispatch(action, data).then(response => {
        console.log('save: response: ', response)
        vm.loading = false
        vm.record.id = response.id
        vm.$router.go(-1);
      })
    },

    refreshDataRecord (id) {
      const vm = this
      console.log('refreshDataRecord :: id = ' + id)
      console.log('refreshDataRecord :: vm.selectedId = ' + vm.selectedId)
      if (vm.selectedId !== id) {
        vm.selectedId = id
      }
      const data = {
        urlCommand: vm.apiPath + '/' + id
      }
      vm.loading = true
      vm.$store.dispatch('COMMON_GET', data).then(function (response) {
        console.log('refreshDataRecord :: response: ', response)
        vm.record = response.data
        vm.csrfToken = response.csrfToken
        vm.loading = false
      })
    },


    // inputFile(newFile, oldFile, prevent) {

    // inputFile: function (newFile, oldFile) {
    //   if (newFile && oldFile && !newFile.active && oldFile.active) {
    //     // Get response data
    //     console.log('response', newFile.response)
    //     if (newFile.xhr) {
    //       //  Get the response status code
    //       console.log('status', newFile.xhr.status)
    //     }
    //   }
    // },
    /**
     * Pretreatment
     * @param  Object|undefined   newFile   Read and write
     * @param  Object|undefined   oldFile   Read only
     * @param  Function           prevent   Prevent changing
     * @return undefined
     */

  }
}
</script>

<style>
#email-table div[name=Datatable] table tbody tr td,
#code-table div[name=Datatable] table tbody tr td {
  padding-top: 0.1rem;
  padding-bottom: 0.1rem;
}

.nav-tabs .nav-item a.nav-link {
  background-color: #F7F7F7;
}

.nav-tabs .nav-item a.nav-link.active {
  background-color: white;
  color: white;
}

div[name=Datatable] .pagination {
  justify-content: flex-end !important;
}

.mce-tinymce {
  height: 100%;
}

.token-list div.badge {
  font-size: 0.9rem;
}


</style>
