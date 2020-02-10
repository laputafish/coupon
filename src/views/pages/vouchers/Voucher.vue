<template>
<div>
  <section-header :title="$t('menu.vouchers')"
    :breadcrumb="breadcrumb"></section-header>

  <!-- Main content -->
  <section class="content">
    <div v-if="mode==='list'" class="container-fluid">
      <div class="row">
        <div class="col-12">
          <div class="btn-toolbar mb-1 justify-content-end" role="toolbar" aria-label="Toolbar with buttons">
            <button type="button"
                    @click="newVoucher()"
                    class="btn btn-primary">
              <i class="fas fa-plus"></i>
            </button>
          </div>
        </div>
        <div class="col-12">
          <datatable v-cloak v-bind="$data"></datatable>
        </div>
        <!-- /.col -->
      </div>
    </div>
    <voucher-record v-else :record="record"></voucher-record>
    <!-- /.row -->
  </section>
</div>
</template>

<script>
import DatatableMixin from '@/mixins/DatatableMixin'
import sectionHeader from '@/views/layouts/comps/SectionHeader'
import dtCommon from '@/views/comps/datatable'
import dtComps from './dtComps'
import voucherRecord from './VoucherRecord'

export default {
  mixins: [DatatableMixin],
  components: {
    sectionHeader,
    ...dtCommon,
    ...dtComps,
    voucherRecord
  },
  data () {
    return {
      apiPath: '/vouchers',
      columns: (() => {
        const cols = [
          {title: 'general.number', thComp: 'ThCommonHeader', tdComp: 'TdCommonIndex', field: 'id'},
          {title: 'general.description', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'description'},
          {title: 'agents.agent', thComp: 'ThCommonHeader', tdComp: 'tdAgent', field: 'agent'},
          {title: 'general.expiry_date', thComp: 'ThCommonHeader', tdComp: 'TdCommonDate', field: 'expiry_date'},
          {title: 'vouchers.email_sent_total', thComp: 'ThCommonHeader', tdComp: 'TdEmailSentTotal', field: 'id'},
          {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
        ]
        return cols
      })(),
      breadcrumb: [
        { labelTag: 'general.home', routeName: 'dashboard' },
        { labelTag: 'menu.vouchers', routeName:'' }
      ],
      record: null
      // <ol class="breadcrumb float-sm-right">
      //   <li class="breadcrumb-item"><a href="#">Home</a></li>
      // <li class="breadcrumb-item active">DataTables</li>
      // </ol>
    }
  },
  methods: {
    onMounting () {
      this.xprops.buttons = ['edit', 'print', 'download', 'delete']
    },
    newVoucher () {
      this.$router.push({name: 'vouchers', params: {id: 0}})
    }
  }
}
</script>
