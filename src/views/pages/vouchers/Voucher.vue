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
  data () {
    return {
      moduleNameTag: 'menu.vouchers',
      apiPath: '/vouchers',
      routeName: 'vouchers',
      columns: (() => {
        const cols = [
          {title: 'general.number', thComp: 'ThCommonHeader', tdComp: 'TdCommonIndex', field: 'id'},
          {title: 'general.description', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'description'},
          {title: 'agents.agent', thComp: 'ThCommonHeader', tdComp: 'TdAgent', field: 'agent'},
          {title: 'vouchers.activation_date', thComp: 'ThCommonHeader', tdComp: 'TdCommonDate', field: 'activation_date'},
          {title: 'general.expiry_date', thComp: 'ThCommonHeader', tdComp: 'TdCommonDate', field: 'expiry_date'},
          {title: 'vouchers.email_sent_total', thComp: 'ThCommonHeader', thClass: 'text-center', tdClass: 'text-center', tdComp: 'TdEmailSentTotal', field: 'id'},
          {title: 'general.status', thComp: 'ThCommonHeader', tdComp: 'TdCommonStatus', field: 'status'},
          {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
        ]
        return cols
      })(),
      breadcrumb: [
        { labelTag: 'general.home', routeName: 'dashboard' },
        { labelTag: 'menu.vouchers', routeName:'' }
      ]
    }
  },
  methods: {
    onMounting () {
      this.xprops.buttons = ['edit', 'delete']
      // this.xprops.buttons = ['edit', 'print', 'download', 'delete']
    }
  }
}
</script>
