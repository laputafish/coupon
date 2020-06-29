<script>
  import DatatableMixin from '@/mixins/DatatableMixin'
  import dtCommon from '@/views/comps/datatable'
  import dtComps from './dtComps'
  import dataRecord from './VoucherRecord'

  export default {
    mixins: [DatatableMixin],
    components: {
      ...dtCommon,
      ...dtComps,
      dataRecord
    },
    computed: {
      agents () {
        const vm = this
        return vm.$store.getters.agents
      }
    },
    data () {
      return {
        tableFilers: [],
        tableId: 'voucher-table',
        moduleNameTag: 'menu.vouchers',
        apiPath: '/vouchers',
        routeName: 'vouchers',
        columns: (() => {
          const cols = [
            {title: 'general.number', thComp: 'ThCommonHeader', tdComp: 'TdCommonIndex', field: 'id'},
            {title: 'general.description', thComp: 'ThCommonHeader', tdComp: 'TdDescription', field: 'description'},
            {title: 'agents.agent', thComp: 'ThCommonHeader', tdComp: 'TdAgent', field: 'agent'},
            {
              title: 'general.type',
              thComp: 'ThCommonHeader',
              thClass: 'text-center',
              tdComp: 'TdType',
              tdClass: 'text-center vertical-middle',
              field: 'voucher_type'
            },
            {title: 'general.qr_barcode', thComp: 'ThCommonHeader', thClass: 'text-center', tdComp: 'TdCodes', field: 'id'},
            {
              title: 'vouchers.activation_date',
              thComp: 'ThCommonHeader',
              tdComp: 'TdCommonDate',
              thClass: 'text-center',
              tdClass: 'text-center',
              field: 'activation_date'
            },
            {
              title: 'general.expiry_date',
              thComp: 'ThCommonHeader',
              tdComp: 'TdCommonDate',
              thClass: 'text-center',
              tdClass: 'text-center',
              field: 'expiry_date'
            },
            {
              title: 'general.created_at',
              thComp: 'ThCommonHeader',
              tdComp: 'TdCommonDate',
              thClass: 'text-center',
              tdClass: 'text-center',
              field: 'created_at'
            },
            {
              title: 'vouchers.participants',
              thComp: 'ThCommonHeader',
              thClass: 'text-center',
              tdClass: 'text-center',
              tdComp: 'TdParticipantCount',
              field: 'participant_count'
            },
            {
              title: 'vouchers.codes',
              thComp: 'ThCommonHeader',
              thClass: 'text-center',
              tdClass: 'text-center',
              tdComp: 'TdCommon',
              field: 'code_count'
            },
            // {title: 'vouchers.email_sent_total', thComp: 'ThCommonHeader', thClass: 'text-center', tdClass: 'text-center', tdComp: 'TdEmailSentTotal', field: 'id'},
            {title: 'general.status', thComp: 'ThCommonHeader', tdComp: 'TdCommonStatus', field: 'status'},
            {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
          ]
          return cols
        })(),
        breadcrumb: [
          {labelTag: 'general.home', routeName: 'dashboard'},
          {labelTag: 'menu.vouchers', routeName: ''}
        ]
      }
    },
    watch: {
      agents: function (newValue) {
        this.setTableFilters()
      },
      selectedFilter: function (newValue) {
        const vm = this
        if (newValue === 0) {
          vm.query.filter = ''
        } else {
          vm.query.filter = 'agent_id:' + newValue
        }
      }

    },
    methods: {
      setTableFilters () {
        const vm = this
        let filters = [
          {caption: 'All', value: 0}
        ]
        for (let i = 0; i < vm.agents.length; i++) {
          filters.push({
            caption: vm.agents[i].name,
            value: vm.agents[i].id
          })
        }
        vm.tableFilters = filters
      },
      onMounting () {
        const vm = this
        this.xprops.buttons = ['edit', 'delete']
        // this.xprops.buttons = ['edit', 'print', 'download', 'delete']
        vm.setTableFilters()
      },
      // onCreatingRecord (data) {
      //   const vm = this
      //   // data: {
      //   //    urlCommand: ...
      //   // }
      //   data['data'] = {
      //     'agent_id': vm.selectedFilter
      //   }
      //   return data
      // },
      onRecordCreated (responseData) {
        const vm = this
        const record = responseData.data
        // console.log('VoucherRecord :: onRecordCreated :: record: ', record)
        if (vm.selectedFilter !== 0) {
          record['agent_id'] = vm.selectedFilter
        }
        // console.log('VoucherRecord :: onRecordCreated :: record: ', record)
        vm.saveRecord(record, (record) => {
          // console.log('Voucher.vue :: onRecordCreated :: saveRecord record: ', record)
          vm.$router.push({name: vm.routeName, params: {id: record.id}})
        })
      },
      saveRecord (record, callback) {
        const vm = this
        // console.log('Voucher :: saveRecord: ', record)
        const data = {
          urlCommand: vm.apiPath + (record.id === 0 ? '' : '/' + record.id),
          data: record
        }
        vm.loading = true
        vm.$forceUpdate()
        const action = record.id === 0 ? 'AUTH_POST' : 'AUTH_PUT'
        vm.$store.dispatch(action, data).then(
          response => {
            vm.loading = false
            // console.log('after save: response: ', response)
            record.id = response.id
            if (typeof callback === 'function') {
              callback(record)
            }
          },
          error => {
            vm.$toaster.error(vm.$t('messages.' + error.messageTag))
          }
        )
      }
    }
  }
</script>

<style>
  #voucher-table div[name=Datatable] table tbody tr td {
    padding-top: 0.2rem;
    padding-bottom: 0.2rem;
  }
</style>
