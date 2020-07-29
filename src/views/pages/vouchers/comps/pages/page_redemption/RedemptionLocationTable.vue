<template>
  <div class="py-2 px-0 redemption-location-table">
    <div v-if="!loading" id="code-table"
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
    <div v-if="loading" class="text-center loading-mask d-flex flex-column justify-content-center align-items-center">
      <h3 class="d-inline-block">
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

    <!--<common-dialog-->
        <!--id="codeExportDialog"-->
        <!--ref="codeExportDialog"-->
        <!--title="Download"-->
        <!--v-model="showingCodeExportDialog"-->
        <!--:buttons="[{caption:'Only Codes',command:'exportCodesOnly',variant:'info'},{caption:'Codes with Participants',command:'exportCodesWithParticipants',variant:'primary'}]"-->
        <!--@onCommand="onCommandHandler"></common-dialog>-->

    <redemption-location-dialog
      ref="redemptionLocationDialog"
      :params="redemptionLocationDialogParams"
      @onCommand="onCommandHandler"
      v-model="showingRedemptionLocationDialog"></redemption-location-dialog>
  </div>
</template>

<script>
  import Vue from 'vue'
  import redemptionLocationDialog from './dialogs/RedemptionLocationDialog'

  // import uploadButton from '@/views/comps/UploadButton'
  import dataRadioToggle from '@/views/comps/forms/DataRadioToggle'
  import dtCommon from '@/views/comps/datatable'
  import dtComps from '../../dtComps/index'

  // import searchField from '../../comps/SearchField'
  // import deleteAllCodesDialog from '../../../dialogs/DeleteAllCodesDialog'
  // import codeImportDialog from '@/views/comps/dialogs/CodeImportDialog'
  // import commonDialog from '@/views/comps/dialogs/CommonDialog'
  // import qrCodeDialog from './dialogs/QrCodeDialog'

  import dtTableMixin from '@/mixins/DtTableMixin'

  // import Echo from 'laravel-echo'

  export default {
    mixins: [
      dtTableMixin
    ],
    components: {
      redemptionLocationDialog,

      ...dtCommon,
      ...dtComps,
      dataRadioToggle

      // xlsFileUpload,
      // searchField,
      //
      // codeImportDialog,
      // deleteAllCodesDialog,
      // commonDialog,
      // qrCodeDialog,
      //
      // uploadButton,
      // ,
      // helpers
    },
    data () {
      return {
        showingRedemptionLocationDialog: false,
        redemptionLocationDialogParams: null,
        channel: null,

        appLoading: false,
        uploading: false,
        loading: false,

        columns: [],

        COLUMNS_NO_PASSWORD: [
          {title: 'general.number', thComp: 'ThCommonHeader', tdComp: 'TdCommonIndex', field: 'id'},
          {title: 'general.name', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'name'},
          {title: 'general.location_code', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'location_code'},
          {title: 'general.qrcode', thComp: 'ThCommonHeader', thClass: 'text-center', tdComp: 'TdQrcode', field: 'qrcode'},
          {title: 'general.redemption_count', thComp: 'ThCommonHeader', thClass: 'text-center', tdComp: 'TdCommon', tdClass: 'text-center', field: 'redemption_count'},
          {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
        ],

        COLUMNS_WITH_PASSWORD: [
          {title: 'general.number', thComp: 'ThCommonHeader', tdComp: 'TdCommonIndex', field: 'id'},
          {title: 'general.name', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'name'},
          {title: 'general.location_code', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'location_code'},
          {title: 'general.qrcode', thComp: 'ThCommonHeader', thClass: 'text-center', tdComp: 'TdQrcode', field: 'qrcode'},
          {title: 'general.password', thComp: 'ThCommonHeader', thClass: 'text-center', tdComp: 'TdPassword', tdClass: 'text-center', field: 'password'},
          {title: 'general.redemption_count', thComp: 'ThCommonHeader', thClass: 'text-center', tdComp: 'TdCommon', tdClass: 'text-center', field: 'redemption_count'},
          {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
        ],
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
          buttons: ['edit', 'delete'],
          // buttons: ['view', 'delete', 'update', 'email'],
          // buttons: ['edit','view','delete'],
          eventbus: new Vue(),
          actionButtonSize: 'xs',
          statuses: []
        },
        HeaderSettings: false,
        selectedRow: null,
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
      },
      redemptionMethod: {
        type: String,
        default: 'qrcode'
      }
    },
    watch: {
      redemptionMethod: function (newValue) {
        const vm = this
        vm.setColumns(newValue)
      },
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
      vm.setColumns(vm.redemptionMethod)

      vm.query.page = 1
      vm.xprops.record = vm.record
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
      setColumns (redemptionMethod) {
        const vm = this
        switch (redemptionMethod) {
          case 'qrcode':
            vm.columns = vm.COLUMNS_NO_PASSWORD
            break
          case 'qrcode_password':
            vm.columns = vm.COLUMNS_WITH_PASSWORD
            break
        }
      },
      newRecord () {
        const vm = this
        vm.redemptionLocationDialogParams = {
          redemptionLocation: {
            id: 0,
            name: '',
            location_code: '',
            qrcode: '',
            password: ''
          }
        }
        // vm.$refs.redemptionLocationDialog.reset()
        vm.$bvModal.show('redemptionLocationDialog')
      },
      delete (id) {
        const vm = this
        const deleteData = {
          urlCommand: '/vouchers/' + record.id + '/redemption_locations' + id
        }
        vm.$store.dispatch('AUTH_DELETE', deleteData).then(
          response => {
            vm.reloadAll()
          }
        )
      },
      update (data) {
        const vm = this
        const putData = {
          urlCommand: '/vouchers/' + vm.record.id + '/redemption_locations/' + data.id,
          data: data
        }
        vm.$store.dispatch('AUTH_PUT', putData).then(
          response => {
            vm.reloadAll()
          }
        )
      },
      updateOneCodeMode (fieldName, fieldValue) {
        const vm = this
        switch (fieldName) {
          case 'has_one_code':
            const hasOneCode = fieldValue === 1
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

      onVoucherCodeRedeemed (data) {
        const vm = this
        console.log('onVoucherCodeRedeemed: data: ', data)
        const voucherCode = data.voucherCode
        for (var i = 0; i < vm.data.length; i++) {
          if (vm.data[i].id === voucherCode.id) {
            vm.data[i].redeemed_on = voucherCode.redeemed_on
            break
          }
        }
        vm.$emit('onCommand', {
          command: 'updateField',
          fieldName: 'total_redeemed',
          fieldValue: data.totalRedeemed
        })
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

          vm.pusherChannel.bind('VoucherCodeRedeemed', function (data) {
            vm.onVoucherCodeRedeemed(data)
          })
        }
      },

      unbindEvents () {
        const vm = this
        if (vm.pusherChannel) {
          // vm.pusherChannel.unbind('VoucherCodeStatusUpdated')
          vm.pusherChannel.unbind('VoucherCodeViewsUpdated')
          vm.pusherChannel.unbind('VoucherCodeRedeemed')
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
            break
          case 'redemptionLocationDialogConfirm':
            console.log('onCommandHandler :: redemptionLocationDialogConfirm')
            vm.update(payload.redemptionLocation)
            break
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
        vm.reloadRedemptionLocations(query)
      },

      refresh () {
        const vm = this
        // console.log('refresh')
        vm.reloadRedemptionLocations()
      },

      reloadAll () {
        const vm = this

        vm.reloadRedemptionLocations()
      },

      reloadRedemptionLocations (query) {
        const vm = this
        vm.loading = true
        if (typeof query === 'undefined') {
          query = vm.query
        }
        if (vm.voucherId === 0) {
          alert('vm.voucherId = 0')
          return
        }
        const data = {
          urlCommand: '/vouchers/' + vm.voucherId + '/redemption_locations',
          query: query
        }
        vm.$store.dispatch('AUTH_GET', data).then(response => {
          vm.total = response.total
          vm.data = response.data
          vm.loading = false
        })
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
        console.log('RedemptionLocationTable :: onRowCommandHandler :: payload: ', payload)
        switch (payload.command) {
          // case 'onLinkClicked':
          //   vm.updateCodeViewCount(payload.row)
          //   break
          case 'edit':
            console.log('onRowCommandHandler :: payload.command = edit')
            vm.redemptionLocationDialogParams = {
              redemptionLocation: JSON.parse(JSON.stringify(payload.row))
            }
            vm.$bvModal.show('redemptionLocationDialog')
            break
          // case 'view':
          //   vm.$emit('onCommand', {
          //     command: 'view_leaflet',
          //     row: payload.row
          //   })
          //   break
          case 'delete':
            vm.$dialog.confirm(vm.$t('messages.areYouSure'))
              .then(() => {
                vm.delete(vm.data[payload.index].id)
              })
            break
        }
      },
    }

  }
</script>

<style>
  .agent-code-table #code-table .mx-input[name=date] {
    background-color: #e5f8ff;
    width: 120px;
  }

  .loading-mask {
    background-color: rgba(128, 128, 128, .5);
    position: absolute;
    left: 0;
    top: 5px;
    width: 100%;
    height: 100%;
    min-height: 320px;
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
