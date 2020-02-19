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
            {title: 'general.fax_no', thComp: 'ThCommonHeader',  tdComp: 'TdCommon', field: 'fax_no'},
            {title: 'general.web_url', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'web_url'},
            {title: 'general.email', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'email'},
            {title: 'agents.voucher_count', thComp: 'ThCommonHeader', tdComp: 'TdCommon', tdClass: 'text-center', thClass: 'text-center', field:  'voucher_count'},
            {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
          ]
          return cols
        })(),
        breadcrumb: [
          { labelTag: 'general.home', routeName: 'dashboard' },
          { labelTag: 'menu.agents', routeName:'' }
        ]
      }
    },
    methods: {
      onMounting () {
        this.xprops.buttons = ['edit', 'delete']
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
