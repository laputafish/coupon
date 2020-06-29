<template>
  <div class="py-2 px-3 form-participants-table">
    <div class="toolbar d-flex flex-row justify-content-between mb-1 align-items-end">
      <search-field
          :searchValue="searchValue"
          :appLoading="appLoading"></search-field>
      <div class="text-center btn-group mx-3">
        <button type="button"
                class="btn btn-sm btn-outline-success min-width-100"
                @click="assignCode()">
          <font-awesome-icon icon="paperclip"></font-awesome-icon>
          <span class="ml-2">Assign Code</span>
        </button>
        <button type="button"
                class="btn btn-sm btn-outline-danger min-width-100"
                @click="clearCodeAssignment()">
          <font-awesome-icon icon="paperclip"></font-awesome-icon>
          <span class="ml-2">Clear Assignment</span>
        </button>
      </div>
      <div>
        <button type="button"
                class="btn btn-outline-primary min-width-100 mr-1"
                @click="reloadData()">
          <i class="fas fa-recycle"></i>
          <span class="ml-2">Refresh</span>
        </button>
        <button type="button"
                :disabled="data.length===0"
                class="btn btn-danger min-width-100 mr-1"
                @click="deleteAll()">
          <i class="fas fa-times"></i>
          <span class="ml-2">{{ $t('buttons.deleteAll') }}</span>
        </button>
        <button type="button"
                :disabled="data.length===0"
                class="btn btn-warning min-width-100 mr-1"
                @click="exportExcel()">
          <i class="fas fa-download"></i>
          <span class="ml-2">Download</span>
        </button>
      </div>
    </div>
    <div id="participant-table" 
         class="freezable-table freeze-last-column freeze-left-three-columns">
      <datatable v-cloak v-bind="$data"
                 :columns="columns"></datatable>
    </div>
    <!--<div v-if="data.length>0" id="participant-table">-->
    <!--<datatable v-cloak v-bind="$data"-->
    <!--:columns="columns"></datatable>-->
    <!--</div>-->
    <div v-if="loading" id="loadingMask" class="text-center">
      <h3 class="d-inline-block mr-auto">
        <font-awesome-icon icon="spinner" class="fa-spin"/>
      </h3>
    </div>
    <common-dialog
        id="codeAssignmentConfirmationDialog"
        ref="codeAssignmentConfirmationDialog"
        title="Code Assignment Confirmation"
        :buttons="codeAssignmentConfirmationButtons"
        @onCommand="onCommandHandler"></common-dialog>


  </div>
</template>

<script>
  import Vue from 'vue'
  import dtCommon from '@/views/comps/datatable'
  import dtComps from '../../dtComps/index'
  import searchField from '../../comps/SearchField'
  import commonDialog from '@/views/comps/dialogs/CommonDialog'

  import appMixin from '@/mixins/AppMixin'
  import dtTableMixin from '@/mixins/DtTableMixin'

  export default {
    mixins: [
      appMixin,
      dtTableMixin
    ],
    components: {
      ...dtCommon,
      ...dtComps,
      searchField,
      commonDialog
    },
    data () {
      return {
        codeAssignmentConfirmationButtons: [
          {caption: 'Go Ahead', command: 'confirmAssignCode', variant: 'primary'}
        ],
        loading: false,
        appLoading: false,
        columns: [],
        allData: [],
        data: [],
        total: 0,
        query: {
          filter: '',
          sort: '',
          order: '',
          page: 0
        },
        xprops: {
          buttons: ['delete', 'email'],
          eventbus: new Vue(),
          actionButtonSize: 'xs',
          optionalChoices: [],
          firstField: '',
          statuses: []
        },
        HeaderSettings: false,
        selectedRow: null,
        searchValue: '',
        searchInputTimer: 3000,
        filterFields: '*',
        defaultColumns2: [
          {
            title: 'general.status',
            thComp: 'ThCommonHeader',
            thClass: 'text-center',
            tdClass: 'align-middle text-center',
            tdComp: 'TdCodeStatus',
            field: 'status',
            sortable: true
          },
          {
            title: 'general.action',
            thComp: 'ThCommonHeader',
            tdClass: 'align-middle',
            tdComp: 'TdCommonOpt',
            field: 'id'
          }
        ]
      }
    },
    computed: {
      userInputObjs () {
        const vm = this
        var result = []
        for (var i = 0; i < vm.inputObjs.length; i++) {
          var inputObj = vm.inputObjs[i]
          var inputType = inputObj['inputType']
          switch (inputType) {
            case 'output-image':
            case 'output-remark':
            case 'output-submit':
            case 'system-page':
              continue;
            default:
              result.push(inputObj)
          }
        }
        return result
      }
    },
    props: {
      voucherId: {
        type: Number,
        default: 0
      },
      inputObjs: {
        type: Array,
        default () {
          return []
        }
      },
      record: {
        type: Object,
        default: null
      }

    },
    watch: {
      userInputObjs: {
        handler: function (newVal) {
          const vm = this
          vm.setColumns(newVal)
          vm.query.page = 1
        },
        deep: true
      },
      voucherId: {
        handler: function (newValue) {
          const vm = this
          if (vm.voucherId !== 0) {
            console.log('watch(voucherId) :: voucherId = ' + newValue)
            vm.onQueryChangedHandler(newValue)
          }
        }
      },
      query: {
        handler: function (newValue) {
          const vm = this
          if (vm.voucherId !== 0) {
            vm.onQueryChangedHandler(newValue)
          }
        },
        deep: true
      },
      searchValue: function () {
        const vm = this
        // console.log('AgentCodeTable :: searchValue = ' + newValue)
        if (vm.filterFields && vm.filterFields !== null) {
          if (vm.searchInputTimer !== 0) {
            clearTimeout(vm.searchInputTimer)
          }
          vm.searchInputTimer = setTimeout(vm.setSearchValue, 2000)
          // console.log('AgentCodeTable :: searchInputTimer: ', vm.searchInputTimer)
        } else {
          vm.alert('No filter fields defined!')
        }
      }
    },
    mounted () {
      const vm = this
      vm.setColumns(vm.userInputObjs)
      vm.query.page = 1
    },
    created () {
      const vm = this
      vm.xprops.eventbus.$on('onRowCommand', vm.onRowCommandHandler)
    },
    destroyed () {
      const vm = this
      vm.xprops.eventbus.$off('onRowCommand')
    },
    methods: {
      updateStatus (data) {
        const vm = this
        console.log('FormParticipantsTable :: updateStatus :: data: ', data)
        const statusInfo = data.statusInfo
        for (var i = 0; i < vm.data.length; i++) {
          if (vm.data[i].id === statusInfo.participant_id) {
            vm.updateStatusByIndex(i, statusInfo)
            // vm.data[i].status = statusInfo.status
            // switch (statusInfo.status) {
            //   case 'processing':
            //     vm.data[i].error_message = ''
            //     vm.data[i].sent_at = ''
            //     break
            //   case 'completed':
            //   case 'fails':
            //     vm.data[i].error_message = statusInfo.error_message
            //     vm.data[i].sent_at = statusInfo.sent_at
            // }
            break
          }
        }
      },

      updateStatusByIndex (index, statusInfo) {
        const vm = this
        const status = statusInfo.status
        vm.data[index].status = status
        switch (status) {
          case 'fails':
          case 'completed':
            vm.data[index].sent_at = statusInfo.sent_at
            vm.data[index].error_message = statusInfo.error_message
            break
          case 'hold':
          case 'pending':
          case 'processing':
            vm.data[index].sent_at = ''
            vm.data[index].error_message = ''
            break
        }
        vm.configRowButtonsByIndex(index)
        // console.log('updateStatusByIndex: index =' + index + ': ', vm.data[index])
      },

      clearCodeAssignment () {
        const vm = this
        vm.$dialog.confirm({
          title: vm.$t('general.confirmation'),
          body: 'All assigned codes will be revoked from all the participants. Are you sure?'
        }).then(function () {
          const postData = {
            urlCommand: '/vouchers/' + vm.voucherId + '/clear_code_assignments'
          }
          vm.$store.dispatch('AUTH_POST', postData).then(
            response => {
              vm.showToaster(response)
              vm.reloadData()
            },
            error => {
              vm.showToaster(error)
            }
          )
        })
      },

      assignCode (force) {
        const vm = this
        if (typeof force === 'undefined') {
          force = false
        }
        const postData = {
          urlCommand: '/vouchers/' + vm.voucherId + '/assign_codes',
          data: {
            force: force
          }
        }
        vm.$store.dispatch('AUTH_POST', postData).then(
          response => {
            console.log('assignCode.then response: ', response)
            vm.showToaster(response)
            vm.reloadData()
          },
          error => {
            console.log('assignCode.then error: ', error)
            if (error.needConfirm) {
              vm.$refs.codeAssignmentConfirmationDialog.setMessage(error.message)
              vm.$bvModal.show('codeAssignmentConfirmationDialog')
            } else {
              vm.showToaster(error)
            }
          }
        )
      },
      deleteParticipant (participantId) {
        const vm = this
        const data = {
          urlCommand: '/vouchers/' + vm.voucherId + '/participants/' + participantId
        }
        vm.$store.dispatch('AUTH_DELETE', data).then(
          response => {
            console.log('deleteParticipant :: AUTH_DELETE.then : response: ', response)
            vm.reloadData(vm.query)
            vm.$emit('onCommand', {
              command: 'refreshCouponCodes'
            })
            vm.$emit('onCommand', {
              command: 'updateField',
              fieldName: 'participant_count',
              fieldValue: response.participant_count
            })
          },
          error => {
            console.log('deleteParticipant :: AUTH_DELETE.then : error: ', error)
          }
        )
      },
      onCommandHandler (payload) {
        const vm = this
        const command = payload.command
        switch (command) {
          case 'search':
            vm.searchValue = payload.searchValue
            break
          case 'confirmAssignCode':
            vm.$bvModal.hide('codeAssignmentConfirmationDialog')
            vm.assignCode(true);
            break
        }
      },
      refresh () {
        console.log('FormParticipantsTable :: refresh()')
        this.reloadData()
      },
      exportExcel () {
        const vm = this
        vm.$emit('onCommand', {
          command: 'exportParticipants'
        })
      },
      deleteAll () {
        const vm = this
        vm.$dialog.confirm(vm.$t('messages.areYouSure')).then(
          () => {
            vm.doDeleteAll()
            vm.$emit('onCommand', {
              command: 'setRecordField',
              fieldName: 'participant_count',
              fieldValue: 0
            })
          })
      },
      doDeleteAll () {
        const vm = this
        const data = {
          urlCommand: '/vouchers/' + vm.voucherId + '/participants'
        }
        vm.$store.dispatch('AUTH_DELETE', data).then(() => {
          vm.$toaster.success(vm.$t('messages.all_codes_are_removed'))
          vm.onQueryChangedHandler(vm.query)
        })
      },
      setSearchValue (search) {
        const vm = this

        // console.log('setSearchValue : search: ', search)
        if (typeof search === 'undefined') {
          search = vm.searchValue
        } else {
          vm.searchValue = search
        }
        if (search) {
          vm.query.filter = vm.filterFields + ':' + search
        } else {
          vm.query.filter = ''
        }
        vm.searchInputTimer = 0
      },
      clearSearch () {
        const vm = this
        vm.query.filter = vm.filterFields + ':'
        vm.onQueryChangedHandler(vm.query)
      },
      onQueryChangedHandler (query) {
        this.reloadData(query)
      },
      reloadData (query) {
        const vm = this
        vm.loading = true
        if (typeof query === 'undefined') {
          query = vm.query
        }
        if (vm.voucherId === 0) {
          return
        }
        const data = {
          urlCommand: '/vouchers/' + vm.voucherId + '/participants',
          query: query
        }
        vm.$store.dispatch('AUTH_GET', data).then(response => {
          vm.total = response.total
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'participant_count',
            fieldValue: vm.total
          })
          vm.data = vm.parseCodeInfoData(response.data)
          vm.configRowButtons(vm.data)
          vm.$forceUpdate()
          vm.loading = false
        })
      },

      parseCodeInfoData (data) {
        const vm = this
        var result = []
        for (var i = 0; i < data.length; i++) {
          var obj = data[i]
          obj['buttons'] = []
          result.push(obj)
        }
        return result
      },
      onRowCommandHandler (payload) {
        const vm = this
        // console.log('FormParticipantsTable :: onRowCommandHandler :: payload: ', payload)
        switch (payload.command) {
          case 'delete':
            vm.$dialog.confirm(vm.$t('messages.areYouSure'))
              .then(() => {
                var participantId = payload.row.id
                vm.deleteParticipant(participantId)
              })
            break
          case 'changeStatus':
            vm.changeStatus(payload)
            break
          case 'email':
            vm.sendEmail(payload.row)
            break
          case 'update': // = save
            vm.saveCodeInfo(payload.row);
            break
          case 'updateField':
            // console.log('AgentCodeTable :: onRowCommandHandler :: updateField: payload: ', payload)
            // vm.$emit('onCommand', {
            vm.setCodeFieldValue(
              payload.row,
              // vm.row2CodeInfo(payload.row),
              payload.fieldName,
              payload.fieldValue
            )
            // )
            //   command: 'update_code_info_field',
            //   row: vm.row2CodeInfo(payload.row),
            //   fieldName: payload.fieldName,
            //   fieldValue: payload.fieldValue
            // })
            break
        }
      },

      sendEmail (row) {
        const vm = this
        const postData = {
          urlCommand: '/participants/' + row.id + '/send_email'
        }
        var commandStatus = 'email:' + row.id
        vm.addXpropsStatus(commandStatus)
        vm.$store.dispatch('AUTH_POST', postData).then(
          response => {
            console.log('FormParticipantsTable :: sendEmail :: response: ', response)
            vm.removeXpropsStatus(commandStatus)
          },
          error => {
            row['error_message'] = error['message']
            row['sent_at'] = error['sent_at']
            row['status'] = error['status']
            vm.$toaster.warning(error['message'])
            vm.removeXpropsStatus(commandStatus)
            vm.configRowButtons()
          }
        )
      },
      changeStatus (payload) {
        const vm = this
        console.log('FormParticipantsTable :: changeStatus :: payload: ', payload)
        const postData = {
          urlCommand: '/participants/' + payload.row.id + '/change_status/' + payload.status
        }
        vm.$store.dispatch('AUTH_POST', postData).then(
          () => {
            const statusInfo = {
              status: payload.status,
              sent_at: '',
              error_message: ''
            }
            // vm.refresh()
            for (var i = 0; i < vm.data.length; i++) {
              if (vm.data[i].id === payload.row.id) {
                vm.updateStatusByIndex(i, statusInfo)
                break
              }
            }
            // for (var i = 0; i < vm.data.length; i++) {
            //   if (vm.data[i].id === payload.row.id) {
            //     vm.data[i].status = payload.status
            //     if (payload.status !== 'hold' && payload.status !== 'pending') {
            //       vm.$toaster.success(vm.$t('messages.participant_status_has_been_updated'))
            //     } else {
            //       vm.data[i].sent_on = ''
            //       vm.data[i].error_message = ''
            //     }
            //     vm.configRowButtonsByIndex(i)
            //     break
            //   }
            // }
          }
        )
      },

      getInputObjOption (inputObj, optionKey) {
        const vm = this
        var result = false
        if (inputObj.options.length > 0) {
          const keyValues = vm.strToKeyValues(inputObj.options[0])
          if (Object.keys(keyValues).indexOf('twoFields') >= 0) {
            result = keyValues['twoFields']
          }
        }
        return result
      },

      configRowButtonsByIndex (index) {
        const vm = this
        const row = vm.data[index]
        var disabled = []
        if (row.locked) {
          disabled.push('delete')
        }
        if (row) {
          if (row.email.trim() === '' || row.status === 'fails' || row.status === 'completed') {
            disabled.push('email')
          }
        } else {
          disabled.push('email')
        }
        vm.data[index].buttons = vm.xprops.buttons.filter(item => disabled.indexOf(item) === -1)
      },

      configRowButtons (data) {
        const vm = this
        if (typeof data === 'undefined') {
          data = vm.data
        }
        for (var i = 0; i < data.length; i++) {
          vm.configRowButtonsByIndex(i)
        }
      },

      setColumns (userInputObjs) {
        const vm = this
        vm.xprops['optionalChoices'] = {}
        // console.log('setColumns :: userInputObjs: ', userInputObjs)
        vm.columns = [{
          title: vm.$t('general.number'),
          thComp: 'ThSimpleHeader',
          tdComp: 'TdCommonIndex',
          tdClass: 'text-center align-middle',
          thClass: 'text-center',
          field: 'id'
        }];

        for (var i = 0; i < userInputObjs.length; i++) {
          var userInputObj = userInputObjs[i]
          var inputType = userInputObj['inputType'];
          var fieldName = 'field' + i;

          if (i === 0) {
            if (inputType === 'name') {
              const hasTwoFields = vm.getInputObjOption(userInputObj, 'twoFields')
              // if (inputType === 'phone' || inputType === 'name') {
              vm.xprops.firstField = hasTwoFields ? fieldName + '_0' : fieldName
            } else {
              vm.xprops.firstField = fieldName
            }
          }

          // console.log('i = ' + i + ': userInputObj: ', userInputObj)

          switch (inputType) {
            case 'simple-text':
              vm.columns.push({
                title: userInputObj.name,
                tdClass: 'text-left align-middle',
                thClass: 'text-left',
                thComp: 'ThParticipantBadgeHeader',
                tdComp: 'TdParticipantField',
                field: fieldName
              });
              break
            case 'number':
              vm.columns.push({
                title: userInputObj.name,
                tdClass: 'text-center align-middle',
                thClass: 'text-center',
                thComp: 'ThParticipantBadgeHeader',
                tdComp: 'TdParticipantField',
                field: fieldName
              })
              break
            case 'email':
              vm.columns.push({
                title: userInputObj.name,
                tdClass: 'text-left align-middle',
                thClass: 'text-left',
                thComp: 'ThParticipantBadgeHeader',
                tdComp: 'TdParticipantField',
                field: fieldName
              });
              break
            case 'text':
              vm.columns.push({
                title: userInputObj.name,
                tdClass: 'text-left align-middle',
                thClass: 'text-left',
                thComp: 'ThParticipantBadgeHeader',
                tdComp: 'TdParticipantField',
                field: fieldName
              });
              break
            case 'name':
              const options = userInputObj.options
              const hasTwoFields = vm.getInputObjOption(userInputObj, 'twoFields')
              if (hasTwoFields) {
                var defaultName = 'Name';
                var name0 = '';
                var name1 = '';
                if (userInputObj.name.trim() !== '') {
                  const nameSegs = userInputObj.name.split(',');
                  if (nameSegs.length > 0) name0 = nameSegs[0]
                  if (nameSegs.length > 1) {
                    name1 = nameSegs[1]
                  } else {
                    name1 = name0 + ' [2]';
                    name0 = name0 + ' [1]';
                  }
                }
                vm.columns.push({
                  title: name0,
                  tdClass: 'text-left align-middle',
                  thClass: 'text-left',
                  thComp: 'ThParticipantBadgeHeader',
                  tdComp: 'TdParticipantField',
                  field: fieldName + '_0'
                })
                vm.columns.push({
                  title: name1,
                  tdClass: 'text-left align-middle',
                  thClass: 'text-left',
                  thComp: 'ThParticipantBadgeHeader',
                  tdComp: 'TdParticipantField',
                  field: fieldName + '_1'
                })
              } else {
                vm.columns.push({
                  title: userInputObj.name,
                  tdClass: 'text-left align-middle',
                  thClass: 'text-left',
                  thComp: 'ThParticipantBadgeHeader',
                  tdComp: 'TdParticipantField',
                  field: fieldName
                });
              }
              break
            case 'phone':
              vm.columns.push({
                title: userInputObj.name,
                tdClass: 'text-left align-middle',
                thClass: 'text-left',
                thComp: 'ThParticipantBadgeHeader',
                tdComp: 'TdParticipantField',
                field: fieldName
                // + '_0'
              })
              // vm.columns.push({
              //   title: 'Phone No.',
              //   tdClass: 'text-left',
              //   thClass: 'text-left',
              //   thComp: 'ThSimpleHeader',
              //   tdComp: 'TdParticipantField',
              //   field: fieldName + '_1'
              // });
              break
            case 'gender':
              vm.columns.push({
                title: userInputObj.name,
                tdClass: 'text-center align-middle',
                thClass: 'text-center',
                thComp: 'ThParticipantBadgeHeader',
                tdComp: 'TdSingleChoice',
                field: fieldName
              });
              vm.xprops['optionalChoices'][fieldName] = userInputObj.options
              break
            case 'single-choice':
              vm.columns.push({
                title: userInputObj.name,
                tdClass: 'text-left align-middle',
                thClass: 'text-left',
                thComp: 'ThParticipantBadgeHeader',
                tdComp: 'TdSingleChoice',
                field: fieldName
              });
              vm.xprops['optionalChoices'][fieldName] = userInputObj.options
              break
            case 'multiple-choice':
              vm.columns.push({
                title: userInputObj.name,
                tdClass: 'text-left align-middle',
                thClass: 'text-left',
                thComp: 'ThParticipantBadgeHeader',
                tdComp: 'TdMultipleChoice',
                field: fieldName
              });
              // vm.xprops['optionalChoices'][fieldName] = userInputObj.options
              break
          }
        }
        // default columns set #2
        for (let j = 0; j < vm.defaultColumns2.length; j++) {
          vm.columns.push(vm.defaultColumns2[j])
        }
        // vm.columns.push({
        //   title: 'general.action',
        //   thComp: 'ThCommonHeader',
        //   tdClass: 'align-middle',
        //   tdComp: 'TdCommonOpt'
        // })
      }
    }
  }
</script>

<style>
  #loadingMask {
    background-color: rgba(128, 128, 128, .5);
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    min-height: 320px;
    padding-top: 150px;
    font-size: 24px;
  }

  #participant-table table th {
    padding-top: 0.3rem;
    padding-bottom: 0.3rem;
  }

  #participant-table.freezable-table [name=Datatable] [name=SimpleTable] table thead th:nth-child(2) {
    left: 42px;
  }
  #participant-table.freezable-table [name=Datatable] [name=SimpleTable] table thead th:nth-child(3) {
    left: 158px;
  }

  #participant-table.freezable-table [name=Datatable] [name=SimpleTable] table tbody tr td:nth-child(2) {
    left: 42px;
  }
  #participant-table.freezable-table [name=Datatable] [name=SimpleTable] table tbody tr td:nth-child(3) {
    left: 158px;
  }

  #participant-table [name=Datatable] [name=SimpleTable] table thead th:last-child,
  #participant-table [name=Datatable] [name=SimpleTable] table tr td:last-child {
    width: 60px;
  }
</style>