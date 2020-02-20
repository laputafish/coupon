<template>
  <div class="container-fluid">
    <title-row :record="record"
               :titleField="titleField"
               :loading="loading"
               :processingButtons="processingButtons"
               :buttons="['back', 'save']"
               @onCommand="onCommandHandler"></title-row>
    <div class="row" v-if="record">
      <!-- Row #0 -->
      <data-input width="6" id="description" labelTag="general.description" v-model="record.description"></data-input>
      <data-input-date width="2" id="activate_date" labelTag="vouchers.activation_date"
                       v-model="record.activation_date"></data-input-date>
      <data-input-date width="2" id="expiry_date" labelTag="vouchers.expiry_date"
                       v-model="record.expiry_date"></data-input-date>
      <data-input-readonly width="2" id="created_at" labelTag="vouchers.creation_date"
                           v-model="record.created_at"></data-input-readonly>

      <!-- Row #1 -->
      <data-input-select width="4" id="agent_id" labelTag="agents.agent" v-model="record.agent_id"
                         :options="agents"
                         optionLabelField="name"></data-input-select>
      <data-input width="3"
                  id="qr_code_composition"
                  labelTag="vouchers.qr_code_composition"
                  v-model="record.qr_code_composition"></data-input>

      <!--<data-input-slider width="3" id="qr_code_size" labelTag="vouchers.qr_code_size" v-model="record.qr_code_size"-->
                        <!--:min="100" :max="300"></data-input-slider>-->

      <div class="col-sm-3">
        <div class="form-group">
          <label>{{ $t('vouchers.qr_code_size') }}</label>
          <div class="form-control d-flex flex-row">
             <vue-range-slider :min="100" :max="300" ref="slider" style="width:100%;" v-model="record.qr_code_size">
              <div class="diy-tooltip" slot="tooltip" slot-scope="{ value }">
                {{ value }}
              </div>
             </vue-range-slider>
              <div class="line-height-1 text-nowrap">{{ record.qr_code_size }} px</div>
          </div>
        </div>
      </div>
      <data-input-readonly width="2" id="status" labelTag="general.status" :value="$t('status.'+record.status)"></data-input-readonly>
      <!--<div class="col-sm-2">-->
        <!--<div class="form-group">-->
          <!--<label for="status">{{ $t('general.status') }}</label>-->
          <!--<input readonly class="form-control" id="status" name="status"-->
                 <!--type="text"-->
                 <!--:value="$t('status.' + record.status)"/>-->
        <!--</div>-->
      <!--</div>-->
    </div>
    <div v-if="record" class="p-2 bg-tab">
      <b-tabs content-class="py-0" class="bg-tab">
        <b-tab class="bg-white py-2">
          <template v-slot:title>
            Agent Codes
            <div v-if="record && record.code_infos && record.code_infos.length>0"
              class="badge badge-warning">
              {{ record.code_infos.length }}
            </div>
          </template>
          <div class="container-fluid">
            <div class="row">
              <div class="col-12">
                <agent-code-table
                    ref="agentCodeTable"
                    @onCommand="onCommandHandler"
                    :codeInfos="record.code_infos"
                    :codeFieldsStr="record.code_fields"></agent-code-table>
              </div>
            </div>
          </div>
        </b-tab>
        <b-tab title="Emails" class="bg-white py-2">
          <div class="container-fluid">
            <div class="row">
              <div class="col-12">
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
                <tinymce
                    ref="yoovEditor"
                    class="flex-grow-1 bg-muted"
                    @editorInit="onEditorInit()"
                    @onFullscreenStateChanged="onFullscreenStateChanged"
                    style="min-height:480px;"
                    id="yoovEditor"
                    :toolbar1="tinymceToolbar1"
                    :options="tinymceOptions"
                    v-model="record.template"></tinymce>
                <div class="flex-grow-0 p-2 bg-muted ml-2">
                  <b-button @click="showCopyTemplateDialog=true"
                          class="btn btn-primary mb-3 w-100">
                    {{ $t('vouchers.copy_template_from') }}
                  </b-button>
                  <h6>Token List</h6>
                  <div v-for="keyGroup in templateKeyGroups"
                       :key="keyGroup['name']">
                    {{ $t('vouchers.' + keyGroup['name']) }}
                    <ul class="token-list list-unstyled px-2 mb-1">
                      <li v-for="templateKey in keyGroup.keys"
                          :key="templateKey">
                        <div @click="insertKey(templateKey)"
                             class="badge badge-info">{{ '{'+templateKey+'}' }}</div>
                      </li>
                    </ul>
                  </div>
                </div>
                <div class="fullscreen-token-list-panel d-flex flex-column"
                  v-if="tinyMCEInFullScreen">
                  <div class="flex-grow-1 p-2">
                    <b-button @click="showCopyTemplateDialog=true"
                              class="btn btn-primary mb-3 w-100">
                      {{ $t('vouchers.copy_template_from') }}
                    </b-button>
                    <h6>Token List</h6>
                    <div v-for="keyGroup in templateKeyGroups"
                         :key="keyGroup['name']">
                      {{ $t('vouchers.' + keyGroup['name']) }}
                      <ul class="token-list list-unstyled px-2 mb-1">
                        <li v-for="templateKey in keyGroup.keys"
                            :key="templateKey">
                          <div @click="insertKey(templateKey)"
                               class="badge badge-info">{{ '{'+templateKey+'}' }}</div>
                        </li>
                      </ul>
                    </div>
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
        <font-awesome-icon v-if="loading" icon="spinner" class="fa-spin"/>
      </h4>
    </div>
    <b-modal id="copyTemplateDialog"
             v-model="showCopyTemplateDialog"
             :title="$t('vouchers.copy_template_from')">
      <b-list-group>
        <b-list-group-item v-for="voucher in otherVouchers"
                           @click="selectedVoucher=voucher"
                           :class="{'active': selectedVoucher==voucher}"
            :key="voucher.id">
          {{ voucher.description }}
        </b-list-group-item>
      </b-list-group>
      <template v-slot:modal-footer>
        <div class="w-100 text-right">
          <div class="btn-toolbar justify-content-end">
              <b-button
                  :disabled="selectedVoucher===null"
                variant="primary"
                size="sm"
                class="min-width-80"
                @click="copyTemplate(selectedVoucher)">
              {{ $t('buttons.ok') }}
            </b-button>
              <b-button
                  variant="secondary"
                  size="sm"
                  class="min-width-80"
                  @click="showCopyTemplateDialog=false">
              {{ $t('buttons.cancel') }}
            </b-button>
          </div>
        </div>
      </template>
    </b-modal>
  </div>
</template>

<script>
  import titleRow from '@/views/comps/TitleRow'
  import formInputs from '@/views/comps/forms'

  import DataRecordMixin from '@/mixins/DataRecordMixin'
  import agentCodeTable from './comps/AgentCodeTable'
  import emailTable from './comps/EmailTable'
  import tinymce from 'vue-tinymce-editor'
  // import datePicker from 'vue2-datepicker'
  import 'vue2-datepicker/index.css'
  import helpers from '@/helpers'
  import vueRangeSlider from 'vue-range-slider'
  // import vueRangeSlider from 'vue-range-slider'

  export default {
    mixins: [DataRecordMixin],
    components: {
      agentCodeTable,
      emailTable,
      // datePicker,
      tinymce,
      titleRow,
      ...formInputs,
      // ,
      vueRangeSlider
      // ,
      // yoovEditor
      // ,
      // editor

    },
    data () {
      return {
        apiPath: '/vouchers',
        titleField: 'description',
        record: null,
        loading: false,
        // content: '<table class="border bg-gray"><tr><td>sdfdsfdsfs<br/>sdlfksdlfjds</td></tr></table>sdlkfjsdklfjds',
        defaultTemplateKeyGroups: [],
        agents: [],
        showCopyTemplateDialog: false,
        allVouchers: [],
        selectedVoucher: null,
        showCopyTemplateDialog: false,
        processingButtons: [],
        tinymceOptions: {
          twoWay:true
        },
        tinymceToolbar1: 'formatselect | bold italic strikethrough forecolor backcolor | link | alignleft aligncenter alignright alignjustify | numlist bullist outdent indent | removeformat | fullscreen',
        tinyMCEInFullScreen: false
      }
    },
    props: {
      recordId: {
        type: Number,
        default: 0
      }
    },
    computed: {
      otherVouchers () {
        const vm = this
        let result = []
        if (vm.record) {
          result = vm.allVouchers.filter(voucher => {
            return voucher.id !== vm.record.id
          })
        }
        return result
      },
      templateKeyGroups () {
        const vm = this
        const result = JSON.parse(JSON.stringify(vm.defaultTemplateKeyGroups))
        if (vm.codeFields.length > 0) {
          result.push({
            name: 'code',
            keys: []
          })
        }
        const lastIndex = result.length - 1
        for (let i = 0; i < vm.codeFields.length; i++) {
          const key = helpers.str2token('code_', vm.codeFields[i])
          result[lastIndex]['keys'].push(key)
        }
        return result
      },
      codeFields () {
        const vm = this
        let result = []
        if (vm.record.code_fields !== null && vm.record.code_fields !== '') {
          // console.log('codeFields :: codeFields = ' + vm.record.code_fields)
          const arKeyPairs = helpers.getKeyPairArray(vm.record.code_fields)
          // console.log('codeFields :: arKeyPairs: ', arKeyPairs)
          result = arKeyPairs.map(keyPair => keyPair[0])
        }
        return result
      }
    },
    watch: {
      recordId: function (newValue) {
        const vm = this
        // console.log('VoucherRecord :: watch(recordId) : newvalue = ' + newValue)
        vm.refresh(newValue)
      }
    },
    mounted () {
      const vm = this

      vm.fetchAgents();
      vm.fetchVouchers();
      vm.fetchDefaultTemplateKeys()

      vm.refresh(vm.recordId)
    },
    methods: {
      onFullscreenStateChanged (full) {
        alert('onFull')
      },
      copyTemplate () {
        const vm = this
        vm.showCopyTemplateDialog = false
        if (vm.record.template && vm.record.template.trim() !== '') {
          vm.$dialog.confirm(vm.$t('messages.overwrite_existing_content') + '?').then(response => {
            vm.record.template = vm.selectedVoucher.template
          })
        } else {
          vm.record.template = vm.selectedVoucher.template
        }
      },
      insertKey (key) {
        tinyMCE.get('yoovEditor').execCommand('mceInsertContent', false, '{' + key + '}');
      },
      onEditorInit () {
        const vm = this
        // console.log('onEditorInit :: tinyMCE: ', tinyMCE)
        tinyMCE.get('yoovEditor').setContent(vm.record.template ? vm.record.template : '')
        tinyMCE.get('yoovEditor').on('fullscreenStateChanged', function(e) {
          vm.tinyMCEInFullScreen = e.state
        })
        // tinymce.get('yoovEditor').setContent('<p>hello world</p>')
        // console.log('tinymce: ', tinymce)
        // vm.$refs.yoovEditor.setContent('<p>hello world</p>')
        // console.log('template: ', vm.record.template)
      },
      fetchAgents () {
        const vm = this
        vm.$store.dispatch('AUTH_GET', '/agents').then(
          response => {
            // console.log('fetchAgents: redsponse: ', response)
            vm.agents = response
          },
          error => {
            vm.$dialog.alert('Agents: ' + vm.$t('messages.error_during_loading'))
          }
        )
      },
      fetchVouchers () {
        const vm = this
        let data = {
          urlCommand: '/vouchers',
          options: {
            params: {
              select: 'description,id,agent.name,agent_id,template'
            }
          }
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            // console.log('fetchVouchers :: response: ', response)
            vm.allVouchers = response
          },
          error => {
            vm.$dialog.alert('Voucher Selection: ' + vm.$t('messages.error_during_loading'))
          }
        )
      },

      fetchDefaultTemplateKeys () {
        const vm = this
        vm.defaultTemplateKeyGroups = []
        vm.$store.dispatch('AUTH_GET', '/template_keys').then(
          response => {
            for (let i = 0; i < response.length; i++) {
              const responseItem = response[i]
              const category = responseItem.category
              const key = responseItem.key
              const keyGroup = vm.defaultTemplateKeyGroups.find(group => {
                return group.name === category
              })
              if (keyGroup) {
                // console.log('keyGroup is true: ', keyGroup)
                keyGroup.keys.push(key)
              } else {
                // console.log('keyGroup is false: ', keyGroup)
                vm.defaultTemplateKeyGroups.push({
                  name: category,
                  keys: [key]
                })
              }
            }
          },
          error => {
            vm.$dialog.alert('Template Keys: ' + vm.$t('messages.error_during_loading'))
          }
        )
      },
      getCodeInfoFromRow (row) {
        // id: 0
        // field0: "0019999900100008000000g0rDtKv136"
        // field1: "00092979"
        // field2: "2019-11-14"
        // field3: "2020-05-23"
        // status: "pending"
        // key: ""
        // sent_on: null

        const vm = this
        const codeFields = vm.record.code_fields
        const fieldCount = codeFields.split('|').length
        const fieldValues = []
        for (let i = 1; i < fieldCount; i++) {
          fieldValues.push(row['field' + i])
        }

        return {
          id: row['id'],
          code: row['field0'],
          extra_fields: fieldValues.join('|'),
          key: row['key']
        }
      },
      createTempLeaflet (codeRecord) {
        const vm = this
        // console.log('createTempLeaflet :: codeRecord: ', codeRecord)
        const tempRecord = JSON.parse(JSON.stringify(vm.record))
        delete tempRecord['code_infos']
        const data = {
          urlCommand: '/templates/create_temp',
          data: {
            record: tempRecord,
            codeInfo: vm.getCodeInfoFromRow(codeRecord)
          }
        }
        // console.log('view_temp_leaflet: data: ', data)
        vm.$store.dispatch('AUTH_POST', data).then(response => {
          const key = response
          const url = window.location.origin + '/coupons/temp/' + key
          // const url = vm.$store.getters.constants.apiUrl + '/templates/view/' + key
          window.open(url, '_blank');
        })
      },
      showLeaflet (key) {
        const vm = this
        // console.log('showLeaflet ::  key= ' + key)
        const url = window.location.origin + '/coupons/' + key
        // const url = vm.$store.getters.constants.apiUrl + '/templates/view/' + key
        window.open(url, '_blank');
      },
      onCommandHandler (payload) {
        const vm = this
        // console.log('VoucherRecord :: onCommandHandler :: payload: ', payload)
        switch (payload.command) {
          case 'update_code_info_field':
            // console.log('update_code_info_field :: payload: ', payload)
            vm.setCodeFieldValue( payload.row, payload.fieldName, payload.fieldValue)
            // let codeInfo = vm.getCodeInfo(payload.row)
            // codeInfo[payload.fieldName] = payload.fieldValue
            break
          case 'clear_all_code_info':
            vm.record.code_infos = []
            vm.record.code_fields = ''

            if (typeof payload.callback) {
              payload.callback()
            }
            break
          case 'delete_code_info':
            vm.record.code_infos.splice(payload.index, 1)
            break
          case 'view_leaflet':
            if (payload.row.key === '') {
              vm.createTempLeaflet(payload.row)
            } else {
              vm.showLeaflet(payload.row.key)
            }
            break
          case 'save':
            vm.save()
            break
          case 'save_and_back':
            vm.save(() => {
              vm.$router.go(-1);
            })
            break
          // case 'saveTemp':
          //   vm.saveTemp()
          //   break
          case 'setCodeFields':
            vm.record.code_fields = vm.createCodeFieldStr(payload.value)
            break
          case 'setCodeDataRows':
            // console.log('onCommandHandler :: setCodeData :: payload.value: ', payload.value)
            vm.updateCodeInfos(payload.value)
            // vm.record.codeInfos = vm.createCodeInfos(payload.value)
            break
          case 'setQrCodeComposition':
            vm.record.qr_code_composition = payload.data
        }
      },
      setCodeFieldValue (row, fieldName, fieldValue) {
        const vm = this
        let result = null
        for (let i = 0; i < vm.record.code_infos.length; i++) {
          const codeInfo = vm.record.code_infos[i]
          // console.log('record.codeInfo[code] = ' + codeInfo['code'])
          // console.log('record.codeInfo[extra_fields] = ' + codeInfo['extra_fields'])
          //
          // console.log('row.codeInfo[code] = ' + row['code'])
          // console.log('row.codeInfo[extra_fields] = ' + row['extra_fields'])

          if (codeInfo['code'] === row['code'] && codeInfo['extra_fields'] === row['extra_fields']) {
            // console.log('VoucherRecord :: setCodeFieldValue :: found => assign field: ' + fieldName + ' to ' + fieldValue)
            vm.record.code_infos[i][fieldName] = fieldValue
            // result = codeInfo
            break
          }
        }
      },
      getCodeInfo (row) {
        const vm = this
        let result = null
        for (let i = 0; i < vm.record.code_infos.length; i++) {
          const codeInfo = vm.record.code_infos[i]
          // console.log('record.codeInfo[code] = ' + codeInfo['code'])
          // console.log('record.codeInfo[extra_fields] = ' + codeInfo['extra_fields'])
          //
          // console.log('row.codeInfo[code] = ' + row['code'])
          // console.log('row.codeInfo[extra_fields] = ' + row['extra_fields'])

          if (codeInfo['code'] === row['code'] && codeInfo['extra_fields'] === row['extra_fields']) {
            result = codeInfo
            break
          }
        }
        return result
      },
      updateCodeInfos (newCodeDataList) {
        // codeDataList = [
        //    ['value1', 'value2', 'value3', 'value4'],
        //    ['value1', 'value2', 'value3', 'value4'],
        //    ['value1', 'value2', 'value3', 'value4'],
        //    ['value1', 'value2', 'value3', 'value4']
        // ]
        // console.log('updateCodeInfos :: codeDataList: ', newCodeDataList)
        const vm = this
        let existingCodes = []
        if (vm.record.code_infos) {
          existingCodes = vm.record.code_infos.map(codeInfo => codeInfo.code)
        } else {
          vm.record.code_infos = []
        }
        // console.log('updateCodeInfos :: existingCodes: ', existingCodes)
        for (let i = 0; i < newCodeDataList.length; i++) {

          const fields = []
          const code = newCodeDataList[i][0]
          // console.log('updateCodeInfos :: code = ' + code)
          for (let j = 1; j < newCodeDataList[i].length; j++) {
            const value = newCodeDataList[i][j]
            // console.log('updateCodeInfos j=' + j + ': value=' + value)
            fields.push(value)
          }

          const index = existingCodes.indexOf(code)
          // if exists
          if (index >= 0) {
            vm.record.code_infos[index].extra_fields = fields.join('|')
          } else {
            vm.record.code_infos.push({
              id: 0,
              code: code,
              extra_fields: fields.join('|'),
              sent_on: '',
              remark: '',
              order: 0,
              key: '',
              status: 'pending'
            })
            existingCodes.push(code)
          }
        }
        for (let i = 0; i < vm.record.code_infos.length; i++) {
          vm.record.code_infos[i].order = i + 1
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
            remark: '',
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

      save (callback) {
        const vm = this
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
        vm.$forceUpdate()
        const action = vm.record.id === 0 ? 'AUTH_POST' : 'AUTH_PUT'
        vm.$store.dispatch(action, data).then(
          response => {
            vm.$toaster.success(vm.$t('messages.saved_successfully'))
            // console.log('save: response: ', response)
            vm.loading = false
            vm.record.id = response.id
            if (typeof callback === 'function') {
              callback()
            }
          },
          error => {
            vm.$toast.danger(vm.$t('messages.' + error.messageTag))
          }
        )
      }


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

<style lang="scss">
@import 'vue-range-slider/dist/vue-range-slider.scss';
</style>

<style>
  #email-table div[name=Datatable] table tbody tr td,
  #code-table div[name=Datatable] table tbody tr td {
    padding-top: 0.1rem;
    padding-bottom: 0.1rem;
  }

  #code-table div[name=Datatable] table tbody tr td .input-group .form-control {
    padding: 0.1rem 0.3rem;
    height: calc(2rem + 2px);
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

  .mce-edit-area iframe {
    min-height: 360px;
  }

  #copyTemplateDialog .modal-body {
    overflow-y: scroll;
    max-height: 480px;
  }

  #copyTemplateDialog .list-group-item {
    cursor: pointer;
  }

  .token-list li > div.badge {
    cursor: pointer;
  }

  .mce-fullscreen .mce-resizehandle {
    display: block;
  }

  .mce-fullscreen .mce-edit-area.mce-container {
    padding-right: 240px;
  }
  .mce-fullscreen .mce-edit-area.mce-container {
    height: 100%;
  }

  .mce-fullscreen .mce-container-body.mce-stack-layout {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .fullscreen-token-list-panel {
    z-index: 2000;
    position: fixed;
    top: 80px;
    right: 10px;
    width: 220px;
    height: 100%;
    padding-bottom: 120px;
  }

  .fullscreen-token-list-panel > div {
    background-color: lightgray;
  }


  /*.mce-container.mce-panel.mce-floatpanel[role=dialog] {*/
    /*width: 800px;*/
    /*height: 80%;*/
    /*overflow-y: hidden;*/
    /*max-width: 90%;*/
  /*}*/

  /*.mce-container.mce-panel.mce-floatpanel[role=dialog]*/
  /*.mce-container-body {*/
  /*width: 100% !important;*/
  /*height: 100% !important;*/
  /*padding-bottom: 90px;*/
  /*position: absolute;*/
  /*}*/

  /*.mce-container.mce-panel.mce-floatpanel[role=dialog]*/
  /*.mce-reset*/
  /*.mce-container.mce-foot[role=group] {*/
    /*width: 100% !important;*/
  /*}*/

  /*.mce-container.mce-panel.mce-floatpanel[role=dialog]*/
  /*.mce-reset*/
  /*.mce-container.mce-foot[role=group] >*/
  /*.mce-container-body {*/
    /*width: 100%;*/
  /*}*/

  /*.mce-container.mce-panel.mce-floatpanel[role=dialog]*/
  /*.mce-reset*/
  /*.mce-container.mce-foot*/
  /*.mce-container-body*/
  /*.mce-widget.mce-btn {*/
    /*top: 10px !important;*/
    /*width: 80px !important;*/
    /*height: 38px !important;*/
    /*right: 56px !important;*/
    /*left: auto !important;*/
  /*}*/

  /*.mce-container.mce-panel.mce-floatpanel[role=dialog]*/
  /*.mce-reset*/
  /*.mce-container.mce-foot*/
  /*.mce-container-body*/
  /*.mce-widget.mce-btn*/
  /*button[role=presentation] {*/
    /*height: 100%;*/
    /*width: 100%;*/
    /*text-align: center;*/
    /*line-height: 28px;*/

  /*}*/
</style>
