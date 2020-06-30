<script>
  import DatatableMixin from '@/mixins/DatatableMixin'
  import dtCommon from '@/views/comps/datatable'
  import dtComps from './dtComps'
  import dataRecord from './AgentRecord'

  export default {
    mixins: [DatatableMixin],
    components: {
      ...dtCommon,
      ...dtComps,
      dataRecord
    },
    data () {
      return {
        tableId: 'agent-table',
        moduleNameTag: 'menu.agents',
        apiPath: '/agents',
        routeName: 'agents',
        columns: (() => {
          const cols = [
            {title: 'general.number', thComp: 'ThCommonHeader', tdComp: 'TdCommonIndex', field: 'id'},
            {title: 'general.name', thComp: 'ThCommonHeader', tdComp: 'TdCommonClick', field: 'name'},
            {title: 'general.alias', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'alias'},
            {title: 'general.tel_no', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'tel_no'},
            {title: 'general.fax_no', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'fax_no'},
            {title: 'general.web_url', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'web_url'},
            {title: 'general.email', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'email'},
            {
              title: 'agents.smtp_servers',
              thComp: 'ThCommonHeader',
              tdComp: 'TdCommon',
              tdClass: 'text-center',
              thClass: 'text-center',
              field: 'smtp_server_count'
            },
            {
              title: 'agents.voucher_count',
              thComp: 'ThCommonHeader',
              tdComp: 'TdCommon',
              tdClass: 'text-center',
              thClass: 'text-center',
              field: 'voucher_count'
            },
            {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
          ]
          return cols
        })(),
        breadcrumb: [
          {labelTag: 'general.home', routeName: 'dashboard'},
          {labelTag: 'menu.agents', routeName: ''}
        ]
      }
    },
    methods: {
      deletionAllowed (row) {
        const vm = this
        let result = ''
        console.log('Agent :: deletionAllowed :: voucher_count = ' + row.voucher_count)
        if (row.voucher_count > 0) {
          result = vm.$t('messages.this_agent_has_related_vouchers')
        }
        return result
      },
      onMounting () {
        this.xprops.buttons = ['edit', 'delete']
      },
      confirmDialog (row, callback) {
        const vm = this
        let handled = false
        const message = vm.deletionAllowed(row)
        if (message !== '') {
          vm.selectedRow = row
          vm.forceDeleteMessage = message
          vm.$bvModal.show('forceDeleteDialog')
          handled = true
        }
        if (!handled) {
          vm.confirmDelete(callback)
          // vm.$dialog.prompt({
          //   title: vm.$t('general.confirmation'),
          //   body: vm.$t('messages.areYouSure')
          // }).then(
          //   () => {
          //     alert('delete')
          //     vm.doDeleteRow(row)
          //   }
          // )
        }
      }
    }
  }
</script>

<style>
  #agent-table div[name=Datatable] table tbody tr td {
    padding-top: 0.2rem;
    padding-bottom: 0.2rem;
  }
</style>
