<template>
  <div class="d-flex flex-column">
    <div class="d-flex flex-row line-height-1 mt-3 px-3">
      <div class="d-flex flex-column flex-grow-1">
        <div class="d-flex flex-row align-items-end">
          <div class="huge-font">{{ percentCompleted }}%</div>
          <div class="ml-4 flex-grow-1">
            <div class="huge-font2 badge badge-warning">{{ processedCount }} / {{ totalCount }}</div>
          </div>
          <div class="align-self-stretch px-2">
            <button class="btn btn-outline-primary min-width-100"
                    @click="refreshSummary">
              <i class="fas fa-sync"></i>
              <!--<font-awesome-icon icon="refresh"></font-awesome-icon>-->
            </button>
          </div>
        </div>
        <yoov-progress-bar :value="processedCount"
                           class="px-1 py-3"
                           :max="totalCount"
                           :progress="0"
                           :completed="false"
                           :notes="notes"
                           :tempo="50"></yoov-progress-bar>
      </div>
      <icon-item
          v-if="smtpServer"
          iconKey="smtp-server"
          :description="smtpServer.description"></icon-item>
      <icon-item
          v-else
          iconKey="smtp-server"
          :disabled="true"
          :hasFault="true"
          description="No Smtp Server Specified!"></icon-item>
      <div class="">
        <big-border-button v-if="!processing && !pausing"
                           :disabled="!ready"
                           variant="success"
                           @onCommand="onCommandHandler"
                           command="start"
                           caption="Start"></big-border-button>
        <big-border-button v-if="processing"
                           :disabled="!ready"
                           variant="danger"
                           @onCommand="onCommandHandler"
                           command="pause"
                           caption="Pause"></big-border-button>
        <big-border-button v-if="pausing"
                           :disabled="!ready"
                           variant="info"
                           @onCommand="onCommandHandler"
                           command="continue"
                           caption="Continue"></big-border-button>
      </div>
    </div>
    <div class="mx-3 mt-2 mb-0 d-flex flex-row">
      <h4 class="mb-2 text-success">Success:</h4><h4 class="ml-3 text-black-50">{{ successCount }}</h4>
    </div>
    <div class="mx-3 mt-2 mb-1 d-flex flex-row">
      <h4 class="mb-3 text-danger">Failed:</h4><h4 class="ml-3 text-black-50">{{ failCount }}</h4>
    </div>
    <div class="mx-3">
      <div id="failMailingTable">
        <datatable v-cloak v-bind="$data"
                   :columns="columns"></datatable>
        <!--<table class="table table-hover striped">-->
        <!--<thead>-->
        <!--<tr>-->
        <!--<th class="text-center">#</th>-->
        <!--<th>Email</th>-->
        <!--<th>Date/Time</th>-->
        <!--<th>Error</th>-->
        <!--</tr>-->
        <!--</thead>-->
        <!--<tbody>-->
        <!--<tr>-->
        <!--<td class="text-center">1</td>-->
        <!--<td>abc@gmail.com</td>-->
        <!--<td>2020-05-31 02:05:05</td>-->
        <!--<td>xxxx</td>-->
        <!--</tr>-->
        <!--<tr>-->
        <!--<td class="text-center">1</td>-->
        <!--<td>abc@gmail.com</td>-->
        <!--<td>2020-05-31 02:05:05</td>-->
        <!--<td>xxxx</td>-->
        <!--</tr>-->
        <!--<tr>-->
        <!--<td class="text-center">1</td>-->
        <!--<td>abc@gmail.com</td>-->
        <!--<td>2020-05-31 02:05:05</td>-->
        <!--<td>xxxx</td>-->
        <!--</tr>-->
        <!--<tr>-->
        <!--<td class="text-center">1</td>-->
        <!--<td>abc@gmail.com</td>-->
        <!--<td>2020-05-31 02:05:05</td>-->
        <!--<td>xxxx</td>-->
        <!--</tr>-->
        <!--</tbody>-->
        <!--</table>-->
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import yoovProgressBar from '@/views/comps/YoovProgressBar'
import bigBorderButton from './comps/BigBorderButton'
import iconItem from '@/views/comps/IconItem'

export default {
  components: {
    yoovProgressBar,
    bigBorderButton,
    iconItem
  },
  computed: {
    pausing () {
      return !this.processing &&
        this.processedCount > 0 &&
        (this.processedCount < this.totalCount)
    },
    processing () {
      const vm = this
      var result = false
      if (vm.voucher) {
        result = vm.voucher.status === 'sending'
      }
      return result
    },
    notes () {
      const vm = this
      var result = ''
      if (vm.mailingSummary && vm.mailingSummary.sendingTo) {
        var values = []
        if (vm.mailingSummary.sendingTo.email && vm.mailingSummary.sendingTo.email !== '') {
          values.push(vm.mailingSummary.sendingTo.email)
        }
        if (vm.mailingSummary.sendingTo.name && vm.mailingSummary.sendingTo.name !== '') {
          values.push('(' + vm.mailingSummary.sendingTo.name + ')')
        }
        result = 'Sending ... <div class="badge badge-info">' + values.join(' ') + '</div>'
      }
      return result
    },
    percentCompleted () {
      const vm = this
      var result = 0
      if (vm.totalCount !== 0) {
        result = vm.processedCount*100 / vm.totalCount
        result = Math.round(result);
      }
      return result
    },
    successCount () {
      const vm = this
      return vm.getMailingSummaryByFilter('completed')
    },
    failCount () {
      const vm = this
      return vm.getMailingSummaryByFilter('fails')
    },
    processedCount () {
      return this.successCount + this.failCount
    },
    totalCount () {
      return this.mailingSummary.statusList.length
    },
    ready () {
      const vm = this
      return vm.smtpServer ? true : false
    },
    systemConfigs () {
      return this.$store.getters.systemConfigs
    },
    systemSmtpServer () {
      const vm = this
      var result = null
      if (vm.systemConfigs && vm.systemConfigs.smtp_server) {
        result = vm.systemConfigs.smtp_server
      }
      return result
    }
  },
  props: {
    voucher: {
      type: Object,
      default: null
    },
    smtpServer: {
      type: Object,
      default: null
    }
  },
  // watch: {
  //   'voucher.id': function (newVal) {
  //     alert('id changed')
  //   }
  // },
  mounted () {
    const vm = this
    vm.loadMailingSummary()
    if (vm.voucher.status === 'sending') {
      this.fetchMailingStatus()
      this.timer = setInterval(this.fetchMailingStatus, 1000)
    }
  },
  beforeDestroy () {
    if (this.timer) {
      clearInterval(this.timer)
    }
  },
  methods: {
    fetchMailingStatus () {
      const vm = this
      if (!vm.fetching) {
        vm.fetching = true
        const data = {
          urlCommand: '/vouchers/' + vm.voucher.id + '/mailing_summary'
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            vm.mailingSummary = response.summary
          }
        )
      }
      vm.fetching = false
    },
    getMailingSummaryByFilter (filter) {
      return this.mailingSummary.statusList.filter(item => item === filter).length
    },
    refreshSummary () {
      const vm = this
      vm.loadMailingSummary()
    },
    loadMailingSummary () {
      const vm = this
      if (vm.voucher) {
        const data = {
          urlCommand: '/vouchers/' + vm.voucher.id + '/mailing_summary'
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            console.log('FETCH_MAILING_SUMMARY :: response: ', response)
            vm.$set(vm.mailingSummary, 'sendingTo', response.summary.sending_to)
            vm.$set(vm.mailingSummary, 'statusList', response.summary.status_list)

            // vm.mailingSummary.sendingTo = response.summary.sending_to
            // vm.mailingSummary.statusList = response.summary.status_list
            // vm.$set(vm.mailingSummary, response.summary.status_list)
          },

          error => console.log(error)
        )
      }
    },
    pauseOperation () {

    },
    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      switch (command) {
        case 'start':
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'status',
            fieldValue: 'sending'
          })
          break
        case 'pause':
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'status',
            fieldValue: 'pending'
          })
          break
        case 'continue':
          console.log('onCommand :: updatefield :: status => sending')
          vm.$emit('onCommand', {
            command: 'updateField',
            fieldName: 'status',
            fieldValue: 'sending'
          })
          break
      }
    }
  },
  data () {
    return {
      fetching: false,
      timer: null,

      mailingSummary: {
        statusList: [],
        sendingTo: null
      },

      // datatable
      columns: (() => {
        const cols = [
          {title: 'general.number', thComp: 'ThCommonHeader', tdComp: 'TdCommonIndex', field: 'id'},
          {title: 'general.name', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'name'},
          {title: 'general.email', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'email'},
          {title: 'general.tel_no', thComp: 'ThCommonHeader', tdComp: 'TdCommon', field: 'tel_no'},
          {title: 'general.action', thComp: 'ThCommonHeader', tdComp: 'TdCommonOpt', field: 'id'}
        ]
        return cols
      })(),
      data: [],
      total: 0,
      query: {
        filter: '',
        sort: '',
        order: '',
        page: 0
      },
      xprops: {
        buttons: ['delete'],
        eventbus: new Vue(),
        actionButtonSize: 'xs'
      },
      HeaderSettings: false,
      // end of datatable

      progressBarOptions: {
        text: {
          color: '#FFFFFF',
          shadowEnable: true,
          shadowColor: '#000000',
          fontSize: 14,
          fontFamily: 'Helvetica',
          dynamicPosition: false,
          hideText: false
        },
        progress: {
          color: '#2dbd2d',
          backgroundColor: '#333333'
        },
        layout: {
          height: 25,
          width: '100%',
          verticalTextAlign: 70,
          horizontalTextAlign: 43,
          zeroOffset: 0,
          strokeWidth: 50,
          progressPadding: 0,
          type: 'line'
        }
      }
    }
  }
}
</script>

<style>
.huge-font {
  font-size: 72px;
}

.huge-font2 {
  font-size: 36px;
}

.vue-progress-path path {
  stroke-width: 12;
}

.vue-progress-path .progress {
  stroke: red;
}

.vue-progress-path .background {
  stroke: #edd;
}

.btn-xlg {
  font-size: 32px;
}

#failMailingTable th {
  padding-top: 0.3rem;
  padding-bottom: 0.3rem;
}
</style>