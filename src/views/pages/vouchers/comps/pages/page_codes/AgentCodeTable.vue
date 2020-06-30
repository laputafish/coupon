<template>
  <div class="py-2 px-3 agent-code-table">
    <div class="toolbar d-flex justify-content-between mb-1">
      <!-- Search Panel -->
      <search-field
          :searchValue="searchValue"
          :appLoading="appLoading"
          @onCommand="onCommandHandler"></search-field>

      <!-- Status summary table -->
      <table class="summary-table">
        <tr>
          <td class="summary-label">
            <div class="badge badge-warning min-width-80">Views</div>
          </td>
          <td class="summary-value">{{record.total_views}}</td>
          <td class="summary-label">
            <div class="badge badge-info min-width-80">Pending</div>
          </td>
          <td class="summary-value">{{statusSummary.pending}}</td>
          <td class="summary-label">
            <div class="badge badge-success min-width-80">Completed</div>
          </td>
          <td class="summary-value">{{ statusSummary.completed}}</td>
        </tr>
        <tr>
          <td></td>
          <td></td>
          <td class="summary-label">
            <div class="badge badge-muted min-width-80">On Hold</div>
          </td>
          <td class="summary-value">{{statusSummary.hold}}</td>
          <td class="summary-label">
            <div class="badge badge-danger min-width-80">Fails</div>
          </td>
          <td class="summary-value">{{ statusSummary.fails}}</td>
        </tr>
      </table>

      <data-radio-toggle
        label="Voucher Type"
        btnClass="min-width-100"
        :value="record.has_one_code"
        @input="value=>updateOneCodeMode('has_one_code', value)"
        :options="voucherTypeOptions"></data-radio-toggle>
      <!--<div class="d-flex flex-row">-->
      <!--<div class="d-flex flex-column">-->
      <!--<div class="badge badge-info mr-1 mb-1">Pending: 22</div>-->
      <!--<div class="badge badge-primary mr-1 mb-">Ready to Send: 22</div>-->
      <!--</div>-->
      <!--<div class="d-flex flex-column">-->
      <!--<div class="badge badge-success mr-1 mb-1">Completed: 22</div>-->
      <!--<div class="badge badge-danger mr-1 mb-">Fails: 22</div>-->
      <!--</div>-->
      <!--</div>-->
      <div>
        <button type="button"
                class="btn btn-outline-primary min-width-100 mr-1"
                @click="reloadAll()">
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
          <span class="ml-2">{{ $t('buttons.download') }}</span>
        </button>
        <!--<button type="button"-->
        <!--:disabled="data.length===0"-->
        <!--class="btn btn-warning min-width-100 mr-1"-->
        <!--@click="exportExcel()">-->
        <!--<i class="fas fa-download"></i>-->
        <!--<span class="ml-2">{{ $t('buttons.download') }}</span>-->
        <!--</button>-->
        <!--<xls-file-upload-->
            <!--inputId="uploadCodes"-->
            <!--uploadUrl="/agent_codes/upload"-->
            <!--:postData="{id: voucherId}"-->
            <!--@onUploading="onUploadingHandler"-->
            <!--@onUploaded="onUploadedHandler"></xls-file-upload>-->
        <!--<upload-button-->
          <!--:record="record"-->
          <!--size="lg"></upload-button>-->

      </div>
    </div>
    <div v-if="data.length>0" id="code-table"
         class="freezable-table freeze-last-column freeze-left-three-columns">
      <datatable v-cloak v-bind="$data"
                 :columns="columns"></datatable>
    </div>
    <!--<b-modal id="codeInfoDialog"-->
    <!--v-model="selectedRow"-->
    <!--:title="$t('general.coupon')+': '+selectedRow.code">-->
    <!--<div class="container-fluid">-->
    <!--<div class="row">-->
    <!--<div class="col-12">-->
    <!--<div class="form-group">-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--</b-modal>-->
    <vue-loading
        :active.sync="uploading"
        :can-cancel="true"></vue-loading>
    <div v-if="loading" id="loadingMask" class="text-center">
      <h3 class="d-inline-block mr-auto">
        <font-awesome-icon icon="spinner" class="fa-spin fa-3x"/>
      </h3>
    </div>

    <!--<code-import-dialog-->
        <!--ref="codeImportDialog"-->
        <!--v-model="showingCodeImportDialog"-->
        <!--:codeFieldsStr="codeFieldNamesStr"-->
        <!--:participantFieldsStr="participantFieldNamesStr"-->
        <!--callbackCommand="confirmCodeImport"-->
        <!--@onCommand="onCommandHandler"></code-import-dialog>-->

    <common-dialog
        id="codeExportDialog"
        ref="codeExportDialog"
        title="Download"
        v-model="showingCodeExportDialog"
        :buttons="[{caption:'Only Codes',command:'exportCodesOnly',variant:'info'},{caption:'Codes with Participants',command:'exportCodesWithParticipants',variant:'primary'}]"
        @onCommand="onCommandHandler"></common-dialog>

    <delete-all-codes-dialog
        ref="deleteAllCodesDialog"
        v-model="showingDeleteAllCodesDialog"
        @onCommand="onCommandHandler"></delete-all-codes-dialog>

  </div>
</template>

<script>
  import Vue from 'vue'

  import uploadButton from '@/views/comps/UploadButton'
  import dataRadioToggle from '@/views/comps/forms/DataRadioToggle'
  import dtCommon from '@/views/comps/datatable'
  import dtComps from '../../dtComps/index'
  import xlsFileUpload from '@/views/comps/XlsFileUpload'
  import searchField from '../../comps/SearchField'
  import deleteAllCodesDialog from '../../../dialogs/DeleteAllCodesDialog'

  import codeImportDialog from '@/views/comps/dialogs/CodeImportDialog'
  import commonDialog from '@/views/comps/dialogs/CommonDialog'

  import dtTableMixin from '@/mixins/DtTableMixin'

  // import Echo from 'laravel-echo'

  export default {
    mixins: [
      dtTableMixin
    ],
    components: {
      ...dtCommon,
      ...dtComps,
      xlsFileUpload,
      searchField,
      codeImportDialog,
      deleteAllCodesDialog,
      commonDialog,
      uploadButton,
      dataRadioToggle,
      // ,
      // helpers
    },
    data () {
      return {
        voucherTypeOptions: [
          {name: 'Multiple', value: 0},
          {name: 'Single', value: 1}
        ],
        // echo: null,
        statusSummary: {
          pending: 0,
          hold: 0,
          completed: 0,
          fails: 0
        },
        channel: null,
        showingDeleteAllCodesDialog: false,
        showingCodeImportDialog: false,
        showingCodeExportDialog: false,

        importedFileKey: '',
        importedFieldInfos: [],
        uploadRoute: '/agent_codes/upload',
        appLoading: false,
        uploading: false,
        loading: false,

        columns: [],
        allData: [],
        data: [],
        total: 0,
        query: {
          filter: '',
          limit: 10,
          offset: 0,
          sort: '',
          order: '',
          page: 0
        },
        xprops: {
          buttons: ['delete', 'email'],
          // buttons: ['view', 'delete', 'update', 'email'],
          // buttons: ['edit','view','delete'],
          eventbus: new Vue(),
          actionButtonSize: 'xs',
          statuses: []
        },
        HeaderSettings: false,
        selectedRow: null,
        defaultColumns1: [
          {
            title: 'general.views',
            thComp: 'ThCommonHeader',
            thClass: 'text-center',
            tdClass: 'align-middle text-center',
            tdComp: 'TdViews',
            field: 'views',
            sortable: false
          },
          {
            title: 'general.key',
            thComp: 'ThKeyBadgeHeader',
            thClass: 'text-center',
            tdClass: 'align-middle',
            tdComp: 'TdKey',
            field: 'key',
            sortable: true
          },
        ],
        defaultColumns2: [
          {
            title: 'general.remark',
            thComp: 'ThCommonHeader',
            tdClass: 'align-middle',
            tdComp: 'TdCommonInputWithButton',
            field: 'remark'
          },
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
        ],
        searchValue: '',
        searchInputTimer: 3000,
        filterFields: '*'
        // ,      codeInfos: {
        //   type: Array,
        //   default () {
        //     return []
        //   }
        // }
      }
    },
    computed: {
      pusher () {
        return this.$store.getters.pusher
      },
      voucherId () {
        const vm = this
        var result = 0
        if (vm.record) {
          result = vm.record.id
        }
        return result
      },
      codeFieldsStr () {
        const vm = this
        return vm.record.code_fields
      },
      codeFieldNamesStr () {
        const vm = this
        var result = ''
        var fieldInfos = []
        if (vm.codeFieldsStr && vm.codeFieldsStr !== '') {
          fieldInfos = vm.codeFieldsStr.split('|')
          var fieldNames = []
          for (var i = 0; i < fieldInfos.length; i++) {
            const segs = fieldInfos[i].split(':')
            const tag = i === 0 ? 'code' : 'code-other'
            fieldNames.push(segs[0] + ':' + tag)
          }
          result = fieldNames.join('|')
        }
        return result
      },
      participantFieldNamesStr () {
        const vm = this
        var result = []
        if (vm.record.participant_configs && vm.record.participant_configs['inputObjs']) {
          const inputObjs = vm.record.participant_configs['inputObjs']
          for (var i = 0; i < inputObjs.length; i++) {
            result.push(inputObjs[i].name);
          }
        }
        return result.join('|')
      }

    },
    props: {
      // voucherId: {
      //   type: Number,
      //   default: 0
      // },
      // codeFieldsStr: {
      //   type: String,
      //   default: ''
      // },
      record: {
        type: Object,
        default: null
      }
    },
    watch: {
      pusher: function (newValue) {
        const vm = this
        if (newValue) {
          vm.initPusherChannel()
        }
      },
      files: {
        handler: function () {
          const vm = this
          if (vm.voucherId === 0) {
            alert('voucherId === 0')
            vm.$emit('onCommand', {
              command: 'save',
              callback: response => {
                vm.voucherId = response.id
              }
            })
          }
        },
        deep: true
      },
      // codeInfos: {
      //   handler: function (newValue) {
      //     // console.log('AgentCodeTable :: watch(codeInfos) :: newValue: ', newValue)
      //     const vm = this
      //     vm.setTableData(newValue)
      //     vm.refreshList()
      //   },
      //   deep: true
      // },
      codeFieldsStr: function (newValue) {
        // codeFields is string in format:
        //
        // Code:string|Serial No:string|activate_date:date
        //
        // console.log('watch(codeFieldsStr) : newValue: ' + newValue)
        const vm = this
        // console.log('watch(codeFieldsStr) :: newValue: ', newValue)
        vm.setColumns(newValue)
      },
      voucherId: {
        handler: function (newValue) {
          const vm = this
          if (vm.voucherId !== 0) {
            // console.log('watch(voucherId) :: voucherId = ' + newValue)
            vm.onQueryChangedHandler(newValue)
          }
        }
      },
      query: {
        handler: function (newValue) {
          const vm = this
          // console.log('watch(query): filter = ' + newValue.filter)
          // console.log('watch(query): limit = ' + newValue.limit)
          // console.log('watch(query): offset = ' + newValue.offset)
          // console.log('watch(query): order = ' + newValue.order)
          // console.log('watch(query): page = ' + newValue.page)
          // console.log('watch(query): sort = ' + newValue.sort)

          if (vm.voucherId !== 0) {
            // console.log('watch(query) && voucherId !== 0: ', vm.voucherId)
            vm.onQueryChangedHandler(newValue)
          }
          // console.log('AGentCodeTable :: watch(query): ', newValue)
          // vm.refreshList()
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

      // vm.listen()
      vm.initPusherChannel()

      vm.setColumns(vm.codeFieldsStr)
      // vm.setTableData(vm.codeInfos)
      vm.query.page = 1
      vm.xprops.record = vm.record
      vm.showingCodeImportDialog = false
      vm.showingCodeExportDialog = false
      vm.showingDeleteAllCodesDialog = false
      vm.reloadCodeSummary()
    },
    created () {
      const vm = this
      vm.xprops.eventbus.$on('onRowCommand', vm.onRowCommandHandler)
      // vm.channelVoucherCode = vm.pusher.subscribe('voucher.code.channel')
      // vm.channelVoucherCode.bind('VoucherCodeStatusUpdated', function (data) {
      //   console.log('VoucherCodeStatusUpdated: data: ', data)
      // })

    },
    beforeDestroy () {
      const vm = this
      vm.xprops.eventbus.$off('onRowCommand')
      vm.unbindEvents()
    },
    destroyed () {
      const vm = this
      vm.xprops.eventbus.$off('onRowCommand')
    },
    methods: {
      updateOneCodeMode (fieldName, fieldValue) {
        const vm = this
        switch (fieldName) {
          case 'has_one_code':
            const hasOneCode = fieldValue===1
            // console.log('updateOneCodeMode :: hasOneCode = ' + hasOneCode)
            // console.log('updateOneCodeMode :: record.code_count = ' + vm.record.code_count)

            if (hasOneCode) {
              if (vm.record.code_count > 1) {
                vm.$dialog.confirm('Only first code will remain. Are you sure?', {
                  customClass: 'confirm-keep-one-code'
                }).then(
                  () => {
                    console.log('confirm removal of others except first one')
                    vm.$emit('onCommand', {
                      command: 'keepOnlyOneCode',
                      callback: () => {
                        vm.$emit('onCommand', {
                          command: 'updateField',
                          fieldName: fieldName,
                          fieldValue: fieldValue
                        })
                        console.log('AgentCodeTable :: updateOneCodeMode => refresh')
                        vm.$emit('onCommand', {
                          command: 'updateField',
                          fieldName: 'code_count',
                          fieldValue: 1
                        })
                        console.log('AgentCodeTable :: updateOneCodeMode :: callback')
                        vm.refresh()
                      }
                    })
                  }
                )
              } else {
                vm.$emit('onCommand', {
                  command: 'keepOnlyOneCode',
                  callback: () => {
                    vm.$emit('onCommand', {
                      command: 'updateField',
                      fieldName: fieldName,
                      fieldValue: fieldValue
                    })
                    // console.log('AgentCodeTable :: updateOneCodeMode => refresh')
                    vm.$emit('onCommand', {
                      command: 'updateField',
                      fieldName: 'code_count',
                      fieldValue: 1
                    })
                    // console.log('AgentCodeTable :: updateOneCodeMode :: code_count==1 :: callback => refresh')
                    vm.refresh()
                  }
                })
                // console.log('AgentCodeTable :: updateOneCodeMode :: code_count==1 :: refresh')
                vm.refresh()
              } // if vm.record.rode_count > 1
            } else {
              vm.$emit('onCommand', {
                command: 'useMultipleCodes',
                callback: () => {
                  vm.$emit('onCommand', {
                    command: 'updateField',
                    fieldName: fieldName,
                    fieldValue: fieldValue
                  })
                  // console.log('not has one code => refresh')
                  vm.refresh()
                }
              })
            }
            break
        }
      },
      listen () {
        const vm = this
        // console.log('methods :: listen :: $echo: ', window.Echo)
        // alert('listen')
        // vm.$echo = new Echo({
        //   broadcaster: 'pusher',
        //   key: '1fe6acadae70811a093e',
        //   cluster: 'ap1',
        //   encrypted: true
        // });
        // console.log('method :: listen :: channel = ' + ('voucher' + vm.voucherId + '.channel'))
        // this.echo.channel('voucher' + vm.voucherId + '.channel')
        //   .listen('VoucherCodeViewsUpdated', (data) => {
        //     alert('VoucherCodeViewsUpdated event echo')
        //   })

        const channelName = 'voucher' + vm.record.id + '.channel'
        window.Echo.channel(channelName)
          .listen('.App.Events.VoucherCodeViewsUpdated', (data) => {
            console.log('*** event: VoucherCodeViewsUpdated: data: ', data)
          })
        // vm.$echo.channel(channelName)
        //   .listen('VoucherCodeViewsUpdated', (data) => {
        //     console.log('*** event: VoucherCodeViewsUpdated: data: ', data)
        //   })
      },
      download () {
        const vm = this
        vm.showingCodeExportDialog = true
      },
      updateCodeViewCount (row) {
        const vm = this
        const postData = {
          urlCommand: '/agent_codes/' + row.id + '/update_views'
        }
        vm.$store.dispatch('AUTH_POST', postData).then(
          () => {
          }
        )
      },
      sendEmail (row) {
        const vm = this
        const participant = row['participant']
        if (participant) {
          const postData = {
            urlCommand: '/participants/' + participant.id + '/send_email'
          }
          var commandStatus = 'email:' + row.id
          vm.addXpropsStatus(commandStatus)
          vm.$store.dispatch('AUTH_POST', postData).then(
            response => {
              // console.log('AgentCodeTable :: sendEmail :: response: ', response)
              vm.removeXpropsStatus(commandStatus)
            },
            error => {
              row['error_message'] = error['message']
              row['sent_at'] = error['sent_at']
              row['status'] = error['status']
              vm.$toaster.warning(error['message'])
              vm.removeXpropsStatus(commandStatus)
            }
          )
        } else {
          vm.$toaster.error('Participant not specified!')
        }
      },
      sendVoucherCodeEmail (row) {
        const vm = this
        const postData = {
          urlCommand: '/vouchers/' + vm.record.id + '/codes/' + row.id + '/send_email'
        }
        var commandStatus = 'email:' + row.id
        vm.addXpropsStatus(commandStatus)
        vm.$store.dispatch('AUTH_POST', postData).then(
          response => {
            // console.log('sendVoucherCodeEmail :: response: ', response)
            vm.removeXpropsStatus(commandStatus)
          }
        )
      },

      onVoucherCodeViewsUpdated (data) {
        const vm = this
        const voucherCode = data.voucherCode
        for (var i = 0; i < vm.data.length; i++) {
          if (vm.data[i].id === voucherCode.id) {
            vm.data[i].views = voucherCode.views
            break
          }
        }
        vm.$emit('onCommand', {
          command: 'updateField',
          fieldName: 'total_views',
          fieldValue: data.totalViews
        })
      },

      updateStatus (data) {
        const vm = this
        // console.log('AgentCodeTable :; updateStatus :: data: ', data)
        const statusInfo = data.statusInfo
        for (var i = 0; i < vm.data.length; i++) {
          if (vm.data[i].id === statusInfo.code_id) {
            vm.updateStatusByIndex(i, statusInfo)
            // vm.data[i].status = statusInfo.status
            // switch (statusInfo.status) {
            //   case 'hold':
            //   case 'pending':
            //   case 'processing':
            //     vm.data[i].sent_at = ''
            //     vm.data[i].error_message = ''
            //     break
            //   case 'completed':
            //   case 'fails':
            //     vm.data[i].sent_at = statusInfo.sent_at
            //     vm.data[i].error_message = statusInfo.error_message
            //     break
            // }
            // vm.configRowButtonsByIndex(i)
            break
          }
        }
      },

      onVoucherCodeStatusUpdated (data) {
        const vm = this
        const voucherCode = data.voucherCode
        for (var i = 0; i < vm.data.length; i++) {
          if (vm.data[i].id === voucherCode.id) {
            vm.data[i].status = voucherCode.status
            switch (voucherCode.status) {
              case 'processing':
                vm.data[i].error_message = ''
                vm.data[i].sent_on = ''
                break
              case 'completed':
              case 'fails':
                vm.data[i].error_message = voucherCode.error_message
                vm.data[i].sent_on = voucherCode.sent_on
            }
            break
          }
        }
      },

      initPusherChannel () {
        const vm = this
        if (vm.pusher && vm.record) {
          vm.unbindEvents()
          vm.pusherChannel = vm.pusher.subscribe('voucher' + vm.record.id + '.channel')

          // vm.pusherChannel.bind('VoucherCodeStatusUpdated', function (data) {
          //   vm.onVoucherCodeStatusUpdated(data)
          // })

          vm.pusherChannel.bind('VoucherCodeViewsUpdated', function (data) {
            vm.onVoucherCodeViewsUpdated(data)
          })
        }
      },

      unbindEvents () {
        const vm = this
        if (vm.pusherChannel) {
          // vm.pusherChannel.unbind('VoucherCodeStatusUpdated')
          vm.pusherChannel.unbind('VoucherCodeViewsUpdated')
        }
      },

      onCommandHandler (payload) {
        const vm = this
        // console.log('AgentCodeTable :: onCommandHandler :: payload: ', payload)
        const command = payload.command
        switch (command) {
          case 'search':
            vm.searchValue = payload.searchValue
            break
          case 'confirmCodeImport':
            vm.onParsingCodes(payload)
            break
          case 'deleteAllCodes':
            vm.doDeleteAll()
            if (typeof payload.callback === 'function') {
              payload.callback()
            }
            break
          case 'exportCodesOnly':
            vm.$emit('onCommand', {
              command: command
            })
            vm.$refs.codeExportDialog.close()
            break
          case 'exportCodesWithParticipants':
            vm.$emit('onCommand', {
              command: command
            })
            vm.$refs.codeExportDialog.close()
            break
          case 'deleteAllCodesAndParticipants':
            vm.doDeleteAll()
            vm.doDeleteAllParticipants()

            if (typeof payload.callback === 'function') {
              payload.callback()
            }
        }
      },
      saveCodeInfo (row) {
        // console.log('saveCodeInfo : row: ', row)
        const vm = this
        const codeInfo = vm.row2CodeInfo(row)
        const data = {
          urlCommand: '/vouchers/' + vm.voucherId + '/codes/' + row.id,
          data: codeInfo
        }
        vm.$store.dispatch('AUTH_PUT', data).then(
          () => {
            vm.$toaster.success(vm.$t('messages.saved_successfully'))
          }
        ).catch(
          () => {
            vm.$toaster.danger(vm.$t('messages.saved_failed'))
          }
        )
      },

      exportExcel () {
        const vm = this
        vm.$emit('onCommand', {
          command: 'exportCodesWithParticipants'
        })
      },

      deleteAll () {
        const vm = this
        if (vm.record.participant_count > 0) {
          vm.$bvModal.show('deleteAllCodesDialog')
          // vm.showingDeleteAllCodesDialog = true
        } else {
          vm.$dialog.confirm(vm.$t('messages.areYouSure')).then(
            () => {
              vm.doDeleteAll()
              vm.$emit('onCommand', {
                command: 'setRecordField',
                fieldName: 'code_count',
                fieldValue: 0
              })
            }
          )
        }
      },

      doDeleteAllParticipants () {
        const vm = this
        const data = {
          urlCommand: '/vouchers/' + vm.voucherId + '/participants'
        }
        vm.$store.dispatch('AUTH_DELETE', data).then(() => {
          vm.$toaster.success(vm.$t('messages.all_participants_are_removed'))
          vm.onQueryChangedHandler(vm.query)
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
          urlCommand: '/vouchers/' + vm.voucherId + '/codes'
        }
        vm.$store.dispatch('AUTH_DELETE', data).then(() => {
          vm.$toaster.success(vm.$t('messages.all_codes_are_removed'))
          vm.$emit('onCommand', {
            command: 'setQrCodeAndBarcodeComposition',
            data: ''
          })
          vm.$emit('onCommand', {
            command: 'setCodeFields',
            value: ''
          })
          vm.$emit('onCommand', {
            command: 'setRecordField',
            fieldName: 'code_count',
            fieldValue: 0
          })
          vm.reloadAll()
          // vm.onQueryChangedHandler(vm.query)
          // vm.codeSummary.pending = 0
          // vm.codeSummary.completed = 0
          // vm.codeSummary.fails = 0
          // vm.codeSummary.hold = 0
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
        // console.log('clearSearch')
        vm.query.filter = vm.filterFields + ':'
        vm.onQueryChangedHandler(vm.query)
      },

      getFilterValue (filter) {
        // const vm = this
        const filterItems = filter.split(';')
        let result = ''
        for (let i = 0; i < filterItems.length; i++) {
          const keyValue = filterItems[i].split(':')
          if (keyValue[0] === '*') {
            result = keyValue[1]
            break
          }
        }
        return result
      },

      onQueryChangedHandler (query) {
        const vm = this
        // console.log('onQueryChangedHandler')
        vm.reloadCodeList(query)
      },

      refresh () {
        const vm = this
        // console.log('refresh')
        vm.reloadCodeSummary()
        vm.reloadCodeList()
      },

      reloadAll () {
        const vm = this

        vm.reloadCodeSummary()
        vm.reloadCodeList()
      },

      reloadCodeSummary () {
        // const vm = this
        // vm.loading = true
        // if (vm.voucherId === 0) {
        //   alert('vm.voucherId = 0')
        //   return
        // }
        // const data = {
        //   urlCommand: '/vouchers/' + vm.voucherId + '/code_summary'
        // }
        // vm.$store.dispatch('AUTH_GET', data).then(response => {
        //   vm.statusSummary = response.code_summary
        //   vm.loading = false
        // })
      },

      reloadCodeList (query) {
        const vm = this
        // console.log('AgentCodeTable :: reloadCodeList')
        vm.loading = true
        if (typeof query === 'undefined') {
          query = vm.query
        }
        if (vm.voucherId === 0) {
          alert('vm.voucherId = 0')
          return
        }
        const data = {
          urlCommand: '/vouchers/' + vm.voucherId + '/codes',
          query: query
        }
        vm.$store.dispatch('AUTH_GET', data).then(response => {
          // console.log('AUTH_GET :: response: ', response)
          vm.total = response.total
          vm.data = vm.parseCodeInfoData(response.data)
          // console.log('reloadCodeList => configRowButtons: vm.data.length = ' + vm.data.length)

          // console.log('reloadCodeList => configRowButtons: buttons.length = ' + vm.data[0].buttons)
          vm.configRowButtons(vm.data)
          // console.log('reloadCodeList => forceUpdate')
          vm.$forceUpdate()
          // console.log('reloadCodeList => loading = false')
          vm.loading = false
          // console.log('reloadCodeList ends')
        })
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

      configRowButtonsByIndex (index) {
        const vm = this
        const row = vm.data[index]
        var disabled = []
        if (row.locked) {
          disabled.push('delete')
        }
        if (row.participant) {
          disabled.push('delete')
          if (vm.record.has_one_code || row.participant_email.trim() === '' || row.status === 'fails' || row.status === 'completed') {
            disabled.push('email')
          }
        } else {
          disabled.push('email')
        }
        vm.data[index].buttons = vm.xprops.buttons.filter(item => disabled.indexOf(item) === -1)
      },

      row2CodeInfo (row) {
        const vm = this
        const codeFields = vm.getCodeFieldsFromStr(vm.codeFieldsStr);
        const codeFieldCount = codeFields.length
        const code = row['field0']
        const extraFieldsArray = []
        for (let i = 1; i < codeFieldCount; i++) {
          const fieldName = 'field' + i
          extraFieldsArray.push(row[fieldName])
        }

        return {
          id: row.id,
          order: row.order,
          code: code,
          'extra_fields': extraFieldsArray.join('|'),
          key: row.key,
          remark: row.remark,
          'sent_on': row.sent_on,
          status: row.status
        }
      },
      onRowCommandHandler (payload) {
        const vm = this
        // console.log('AgentCodeTable :: onRowCommandHandler :: payload: ', payload)
        switch (payload.command) {
          // case 'onLinkClicked':
          //   vm.updateCodeViewCount(payload.row)
          //   break
          case 'edit':
            alert('onRowCommandHandler :; edit')
            break
          case 'view':
            vm.$emit('onCommand', {
              command: 'view_leaflet',
              row: payload.row
            })
            break
          case 'delete':
            vm.$dialog.confirm(vm.$t('messages.areYouSure'))
              .then(() => {
                vm.$emit('onCommand', {
                  command: 'delete_code_info',
                  index: payload.index
                })
              })
            break
          case 'update': // = save
            vm.saveCodeInfo(payload.row);
            break
          case 'changeStatus':
            vm.changeStatus(payload)
            break
          case 'email':
            if (payload.row.participant) {
              vm.sendEmail(payload.row)
            }
            // vm.sendVoucherCodeEmail(payload.row)
            break
          case 'saveField':
            vm.saveCodeInfoField(
              payload.row,
              payload.fieldName,
              payload.fieldValue
            )
            break
          case 'updateField':
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
          case 'gotoLink':
            vm.$emit('onCommand', payload)
            break
        }
      },
      setVoucherCodeStatus (row, status) {
        const vm = this
        const postData = {
          urlCommand: '/vouchers/' + vm.record.id + '/codes/' + row.id + '/set_status',
          data: {
            status: status
          }

        }
        vm.$store.dispatch('AUTH_POST', postData).then(
          response => {
            // console.log('sendEmail : response: ', response)
            if (response.message) {
              vm.$toaster.info(response.message)
            }
            const voucherCode = response.voucherCode
            // console.log('setVoucherCodeStatus :: data: ', vm.data)
            // console.log('response.voucherCode = ', voucherCode)
            var dataVoucherCode = vm.data.find(item => item.id === voucherCode.id)
            if (dataVoucherCode) {
              dataVoucherCode.status = voucherCode.status
              dataVoucherCode.error_message = voucherCode.error_message
              dataVoucherCode.sent_on = voucherCode.sent_on
            }
            // vm.reloadCodeList()
          },
          error => {
            vm.$toaster.error(error.message)
          }
        )
      },

      saveCodeInfoField (row, fieldName, fieldValue) {
        const vm = this
        const postData = {
          urlCommand: '/agent_codes/' + row.id + '/update_field',
          data: {
            fieldName: fieldName,
            fieldValue: fieldValue
          }
        }
        vm.$store.dispatch('AUTH_POST', postData).then(
          () => {
            vm.$toaster.info('Successfully updated!')
          }
        )
      },

      setCodeFieldValue (row, fieldName, fieldValue) {
        const vm = this
        for (let i = 0; i < vm.data.length; i++) {
          if (vm.data[i] == row) {
            // console.log('vm.data[' + i + '] == row')
            vm.data[i][fieldName] = fieldValue
            break
          } else {
            // console.log('vm.data[' + i + '] not equals to row')
          }
        }
      },
      setCodeFieldValue2 (row, fieldName, fieldValue) {
        const vm = this
        for (let i = 0; i < vm.data.length; i++) {
          const codeInfo = vm.data[i]
          if (codeInfo['code'] === row['code'] && codeInfo['extra_fields'] === row['extra_fields']) {
            vm.data[i][fieldName] = fieldValue
            break
          }
        }
      },

      changeStatus (payload) {
        const vm = this
        const participant = payload.row.participant
        if (participant) {
          const postData = {
            // urlCommand: '/agent_codes/' + payload.row.id + '/change_status/' + payload.status
            urlCommand: '/participants/' + participant.id + '/change_status/' + payload.status
          }
          vm.$store.dispatch('AUTH_POST', postData).then(
            () => {
              const statusInfo = {
                status: payload.status,
                sent_at: '',
                error_message: ''
              }

              for (var i = 0; i < vm.data.length; i++) {
                if (vm.data[i].id === payload.row.id) {
                  vm.updateStatusByIndex(i, statusInfo)
                  break
                }
              }
              // vm.reloadAll()
            }
          )
        }
      },

      // statusInfo = {
      //    status: '',
      //    sent_at: '',
      //    error_message: ''
      // }
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

      getCodeFieldsFromStr (fieldStr) {
        const result = []
        // console.log('getCodeFieldsFromStr: fieldStr = ' + fieldStr)
        if (fieldStr !== null && fieldStr !== '') {
          const arTitleType = fieldStr.split('|')
          for (let i = 0; i < arTitleType.length; i++) {
            const titleTypePair = arTitleType[i]
            const segs = titleTypePair.split(':')
            result.push({
              title: segs[0],
              type: segs[1]
            })
          }
        }
        // console.log('getCodeFieldsFromStr: result: ', result)
        return result
      },

      setColumns (fieldsStr) {
        // Input : fieldsStr
        //
        // Code:string|Serial No:string|activate_date:date
        //
        const vm = this
        // console.log('setColumns: fieldsStr = ' + fieldsStr)
        const codeFields = vm.getCodeFieldsFromStr(fieldsStr);
        // codeFields = [
        //    {
        //      title: 'title 1',
        //      type: 'number'
        //    },
        //    {
        //      title: 'title 2',
        //      type: 'string'
        //    },
        //
        //
        vm.columns = [{
          title: vm.$t('general.number'),
          tdClass: 'text-center',
          thClass: 'text-center',
          tdComp: 'TdCommonIndex',
          field: 'id'
        }];

        var tdClass = 'text-left align-middle'
        var thClass = 'text-left'
        var field = null

        // code field
        if (codeFields.length > 0) {
          field = codeFields[0]
          vm.columns.push({
            title: field['title'],
            thComp: 'ThCodeBadgeHeader',
            tdClass: tdClass,
            thClass: thClass,
            field: 'field0'
          })
        }

        // default columns set #1
        for (let j = 0; j < vm.defaultColumns1.length; j++) {
          vm.columns.push(vm.defaultColumns1[j])
        }

        // code fields except "code"
        for (let i = 1; i < codeFields.length; i++) {
          tdClass = 'text-left align-middle'
          thClass = 'text-left'
          const field = codeFields[i]
          switch (field['type']) {
            case 'date':
            case 'integer':
              tdClass = 'text-center align-middle'
              thClass = 'text-center align-middle'
              break;
          }
          vm.columns.push({
            title: field['title'],
            thComp: 'ThCodeBadgeHeader',
            tdClass: tdClass,
            thClass: thClass,
            field: 'field' + i
          })
        }

        // default columns set #2
        for (let j = 0; j < vm.defaultColumns2.length; j++) {
          vm.columns.push(vm.defaultColumns2[j])
        }

      },

      parseCodeInfoData (infoData) {
        const vm = this
        let result = []
        if (vm.columns) {
          for (let i = 0; i < infoData.length; i++) {
            const codeRecord = infoData[i]
            const fieldsStr = codeRecord['code'] + '|' + codeRecord['extra_fields']
            const arFieldValues = fieldsStr.split('|')

            const obj = {
              id: codeRecord['id'],
              order: codeRecord['order']
            }
            for (let j = 0; j < arFieldValues.length; j++) {
              obj['field' + j] = arFieldValues[j]
            }
            obj['status'] = codeRecord['status']
            obj['key'] = codeRecord['key']
            obj['remark'] = codeRecord['remark']
            obj['error_message'] = codeRecord['error_message']
            obj['participant'] = codeRecord['participant']
            obj['participant_name'] = codeRecord['participant'] ? codeRecord['participant']['name'] : null
            obj['participant_email'] = codeRecord['participant'] ? codeRecord['participant']['email'] : null
            obj['participant_phone'] = codeRecord['participant'] ? codeRecord['participant']['phone'] : null
            obj['sent_at'] = codeRecord['sent_at']
            obj['views'] = codeRecord['views']
            obj['buttons'] = []
            result.push(obj)
          }
        } else {
          result = infoData
        }
        return result
      },

      // setTableData (tableData) {
      //   const vm = this
      //   vm.allData = vm.parseCodeInfoData(tableData)
      //   vm.total = vm.allData.length
      // },

      onUploadingHandler () {
        const vm = this
        vm.uploading = true
        vm.$bvModal.hide('codeImportDialog')
        // vm.showingCodeImportDialog = false
      },

      onUploadedHandler (result) {
        const vm = this
        // console.log('onUploaded');
        // result = {
        //    codeFields: "barcode:string|serialno:string|actdate:date|exdate:date"
        //    new: 9
        //    updated: 0
        // }
        //
        vm.uploading = false
        // vm.showingCodeImportDialog = true
        vm.$refs.codeImportDialog.preInit(result.fields, result.key)
        vm.$bvModal.show('codeImportDialog')
        // vm.$refs.codeImportDialog.toggle()
      },

      onParsingCodes (payload) {
        const vm = this
        console.log('onParsingCodes :: payload: ', payload)
        const postData = {
          urlCommand: '/agent_codes/parse/' + payload.key,
          data: {
            fieldInfos: payload.fieldInfos,
            includeCode: payload.includeCode,
            includeParticipant: payload.includeParticipant,
            singleCodeMode: vm.record.has_one_code
          }
        }

        console.log('AgentCodeTable :: onParsingCodes :: postData: ', postData)
        vm.uploading = true
        vm.$store.dispatch('AUTH_POST', postData).then(
          result => {
            vm.uploading = false

            var msgs = []
            if (result.codeFields) {
              vm.updateCodeFields(result)
              if (result.existing > 0) {
                msgs.push(result.existing + ' code(s) are duplicated')
              } else {
                msgs.push('No code(s) is duplicated')
              }
              if (result.new > 0) {
                msgs.push(result.new + ' code(s) are added')
              } else {
                msgs.push('no code(s) are added')
              }
            }

            if (result.participantConfigs) {
              vm.updateParticipantFields(result)
              msgs.push(result.participantIds.length + ' participant(s) are added')
            }
            vm.$dialog.alert(msgs.join('<br/>'), {html: true})
            // vm.$toaster.success(msgs.join(' and ') + '.')
            vm.reloadAll()
              // const newParticipantConfigs = result.participantConfigs
              // console.log('parse: vm.record.participant_configs: ', vm.record.participant_configs)
              // console.log('parse: newParticipantConfigs: ', newParticipantConfigs)
              // console.log('parse: result.participantCount: ', result.participantCount)
              //
              // if (JSON.stringify(vm.record.participant_configs) === JSON.stringify(newParticipantConfigs)) {
              //   console.log('participant configs no changed')
              // } else {
              //
              //   vm.$emit('onCommand', {
              //     command: 'updateField',
              //     fieldName: 'participant_configs',
              //     fieldValue: newParticipantConfigs
              //   })
              //   vm.$emit('onCommand', {
              //     command: 'updateField',
              //     fieldName: 'participant_count',
              //     fieldValue: result.participantCount
              //   })
              // }
              //
              // console.log('after')
              // console.log('parse: vm.record.participant_configs: ', vm.record.participant_configs)

            //   let msgs = []
            //   if (result.existing > 0) {
            //     msgs.push(result.existing + ' code(s) are duplicated')
            //   } else {
            //     msgs.push('No code(s) is duplicated')
            //   }
            //   if (result.new > 0) {
            //     msgs.push(result.new + ' code(s) are added')
            //   } else {
            //     msgs.push('no code(s) are added')
            //   }
            //   vm.$toaster.success(msgs.join(' and ') + '.')
            //   vm.reloadAll()
            //   // vm.onQueryChangedHandler(vm.query)
            // } else {
            //   vm.$dialog.alert(vm.$t('messages.error_occurred_maybe_invalid_format'))
            // }
          },
          error => {
            vm.uploading = false
            console.log('error: ', error)
          }
        )
      },
      // onUploaded2 (result) {
      //   const vm = this
      //   // result = {
      //   //    fields: [
      //   //      {title: 'PCC', type: 'string'},
      //   //      {title: 'PCC', type: 'string'},
      //   //      {title: 'PCC', type: 'string'},
      //   //      {title: 'PCC', type: 'string'}
      //   //    ],
      //   //    values: [ ... ]
      //   // }
      //   //
      //   const newCodeFieldsStr = vm.getCodeFieldsStrFromArray(result.fields)
      //   console.log('onUploaded :: newCodeFieldsStr: ', newCodeFieldsStr)
      //   // let goAhead = true
      //   // console.log('codeFieldsStr = [' + vm.codeFieldsStr + ']')
      //   // console.log('newCodeFieldsStr = [' + newCodeFieldsStr + ']')
      //   if (vm.codeFieldsStr !== '' && vm.codeFieldsStr !== null) {
      //     if (newCodeFieldsStr !== vm.codeFieldsStr) {
      //       // goAhead = false
      //       const options = {
      //         okText: vm.$t('buttons.continue'),
      //         cancelText: vm.$t('buttons.cancel')
      //       }
      //       vm.$dialog.confirm(vm.$t('messages.fields_not_matched_please_delete_all_first'), options).then(
      //         () => {
      //           vm.$emit('onCommand', {
      //             command: 'clear_all_code_info',
      //             callback: () => {
      //               vm.importCodes(result)
      //             }
      //           })
      //         }
      //       )
      //     } else {
      //       vm.importCodes(result)
      //     }
      //   } else {
      //     vm.importCodes(result)
      //   }
      // },
      //
      // importCodes (result) {
      //   console.log('importCodes :: result: ', result)
      //   const vm = this
      //   // const newCodeFieldsStr = vm.getCodeFieldsStrFromArray(result.fields)
      //
      //   // console.log('codeFieldsStr: ' + vm.codeFieldsStr)
      //   // console.log('newCodeFieldsStr = ' + newCodeFieldsStr)
      //
      //   // console.log('equal: ' + (vm.codeFieldsStr === newCodeFieldsStr ? 'yes' : 'no'))
      //   vm.$emit('onCommand', {
      //     command: 'setCodeFields',
      //     value: result.fields
      //   })
      //   vm.$emit('onCommand', {
      //     command: 'setCodeDataRows',
      //     value: result.data
      //   })
      //
      //   vm.$emit('onCommand', {
      //     command: 'setQrCodeComposition',
      //     data: helpers.str2token('code_', result.fields[0].title)
      //   })
      // },
      getCodeFieldsStrFromArray (fields) {
        const result = []
        for (let i = 0; i < fields.length; i++) {
          result.push(fields[i].title + ':' + fields[i].type)
        }
        return result.join('|')
      },
      // onSuccess () {
      //   alert('AgentCodeTable')
      //   // alert('success')
      // },

      updateCodeFields (result) {
        const vm = this
        const newCodeFieldsStr = result.codeFields
        if (vm.codeFieldsStr == newCodeFieldsStr) {} else {
          vm.$emit('onCommand', {command: 'setCodeFields', value: newCodeFieldsStr})
          vm.$emit('onCommand', {command: 'setRecordField', fieldName: 'code_count', fieldValue: result.codeCount })
          if (result.code_composition) {
            vm.$emit('onCommand', {command: 'setQrCodeAndBarcodeComposition', data: result.code_composition })
          }
        }
      },

      updateParticipantFields (result) {
        // result = {
        //    participantConfigs
        //    participantIds
        // }
        const vm = this
        const newParticipantConfigs = result.participantConfigs
        const newParticipantCount = result.participantIds.length
        if (JSON.stringify(vm.record.participant_configs) === JSON.stringify(newParticipantConfigs)) {} else {
          vm.$emit('onCommand', {command: 'updateField', fieldName: 'participant_configs', fieldValue: newParticipantConfigs})
          vm.$emit('onCommand', {command: 'updateField', fieldName: 'participant_count', fieldValue: newParticipantCount })
        }
      },

      search () {
      }

      // editSave() {
      //   console.log('editSave')
      //   this.edit = false
      //   // let file = this.files[0]
      //   // let oldFile = this.files[0]
      //   // let binStr = atob(this.cropper.getCroppedCanvas().toDataURL(oldFile.type).split(',')[1])
      //   // let arr = new Uint8Array(binStr.length)
      //   // for (let i = 0; i < binStr.length; i++) {
      //   //   arr[i] = binStr.charCodeAt(i)
      //   // }
      //   // let file = new File([arr], oldFile.name, { type: oldFile.type })
      //   this.$refs.upload.update(file.id, {
      //     file,
      //     type: file.type,
      //     size: file.size,
      //     active: true,
      //   })
      // },
    }
  }
</script>

<style>
  .agent-code-table #code-table .mx-input[name=date] {
    background-color: #e5f8ff;
    width: 120px;
  }

  #loadingMask {
    background-color: rgba(128, 128, 128, .5);
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    min-height: 480px;
    padding-top: 150px;
    font-size: 48px;
  }

  .agent-code-table #code-table table th {
    padding-top: 0.3rem;
    padding-bottom: 0.3rem;
  }

  .agent-code-table .summary-table {
    font-size: 90%;
    margin: 0;
  }

  .agent-code-table .summary-table td div {
    width: 100%;
  }

  .agent-code-table .summary-table td.summary-value {
    padding: 0 15px 0 3px;
    font-size: 80%;
  }

  .agent-code-table .summary-table td {
    line-height: 1;
    padding: 0 0 1px 0;
  }

  .confirm-keep-one-code .dg-main-content {
    background-color: #dc3545;
    color: white;
  }

  #code-table.freezable-table [name=Datatable] [name=SimpleTable] table thead th:nth-child(2) {
    left: 42px;
  }
  #code-table.freezable-table [name=Datatable] [name=SimpleTable] table thead th:nth-child(3) {
    left: 158px;
  }

  #code-table.freezable-table [name=Datatable] [name=SimpleTable] table tbody tr td:nth-child(2) {
    left: 42px;
  }
  #code-table.freezable-table [name=Datatable] [name=SimpleTable] table tbody tr td:nth-child(3) {
    left: 158px;
  }
  #code-table [name=Datatable] [name=SimpleTable] table thead th:last-child,
  #code-table [name=Datatable] [name=SimpleTable] table tr td:last-child {
    width: 60px;
  }

</style>
