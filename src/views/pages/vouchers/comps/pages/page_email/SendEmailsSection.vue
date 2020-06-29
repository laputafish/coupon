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
            <!--<button class="btn btn-outline-primary min-width-100"-->
                    <!--@click="refreshSummary">-->
              <!--<i class="fas fa-sync"></i>-->
              <!--&lt;!&ndash;<font-awesome-icon icon="refresh"></font-awesome-icon>&ndash;&gt;-->
            <!--</button>-->
          </div>
        </div>
        <yoov-progress-bar class="px-1 py-3"
                           :progress="percentCompleted"
                           :completed="false"
                           :notes="notes"
                           :tempo="50"></yoov-progress-bar>
        <!--<yoov-progress-bar class="px-1 py-3"-->
                           <!--:value="processedCount"-->
                           <!--:max="totalCount"-->
                           <!--:progress="percentCompleted"-->
                           <!--:completed="false"-->
                           <!--:notes="notes"-->
                           <!--:tempo="50"></yoov-progress-bar>-->
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
        <big-border-button v-if="(voucher.status!=='sending'&&processedCount===0&&totalCount>0)||(totalCount==0)"
                           class="mb-1"
                           :disabled="!smtpServerReady || totalCount===0"
                           variant="success"
                           @onCommand="onCommandHandler"
                           command="start"
                           caption="Start"></big-border-button>
        <big-border-button v-if="voucher.status==='sending'"
                           class="mb-1"
                           :disabled="!smtpServerReady"
                           variant="danger"
                           @onCommand="onCommandHandler"
                           command="pause"
                           caption="Pause"></big-border-button>
        <big-border-button v-if="voucher.status!=='sending'&&processedCount>0&&processedCount<totalCount"
                           class="mb-1"
                           :disabled="!smtpServerReady"
                           variant="info"
                           @onCommand="onCommandHandler"
                           command="continue"
                           caption="Continue"></big-border-button>
        <big-border-button v-if="processedCount===totalCount && totalCount!==0"
                           class="mb-1"
                           :disabled="true"
                           variant="muted"
                           caption="Finished"></big-border-button>
        <button class="btn btn-danger btn-sm"
                :disabled="(voucher.status!=='completed'&&voucher.status!=='pending'&&processedCount===0) || totalCount===0 || voucher.status==='sending'"
          @click="resetAll">
          Reset All
        </button>
      </div>
    </div>
    <div class="mx-4 my-0 d-flex flex-row">
      <h4 class="mb-2 text-info">Sent:</h4>
      <h4 class="mx-3 text-black-50">{{ processedCount }}</h4>

      <h4 class="text-black-50">(</h4>
        <h4 class="mb-2 text-success">Success:</h4>
        <h4 class="mx-3 text-black-50">{{ mailingSummary.completed }}</h4>
        <div class="mb-3 ml-0 ">
          <div class="d-flex flex-row">
            <h4 class="text-danger">Failed:</h4>
            <h4 class="ml-3 text-black-50">{{ mailingSummary.fails }}</h4>
          </div>
          <button class="btn btn-sm btn-outline-danger"
                  @click="doResetFails"
            :disabled="mailingSummary.fails===0">
            <font-awesome-icon class="mr-1" icon="redo"></font-awesome-icon>
            Resend
          </button>
        </div>


      <h4 class="text-black-50">)</h4>
    </div>
    <!--<div class="mx-3 mt-0 mb-1 d-flex flex-row">-->
      <!--<h4 class="mb-2 text-info">Ready to Send:</h4><h4 class="mx-3 text-black-50">{{ totalCount - processedCount }}</h4>-->
    <!--</div>-->
    <div v-if="false" class="mx-3">
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
    <serious-confirm-dialog
        id="resetAllDialog"
        ref="seriousConfirmDialog"
        v-model="showingConfirmResetAllDialog"
        @onCommand="onCommandHandler"></serious-confirm-dialog>
  </div>
</template>

<script>
import Vue from 'vue'
import yoovProgressBar from '@/views/comps/YoovProgressBar'
import bigBorderButton from './BigBorderButton'
import iconItem from '@/views/comps/IconItem'
import seriousConfirmDialog from '@/views/comps/dialogs/SeriousConfirmDialog'

export default {
  components: {
    yoovProgressBar,
    bigBorderButton,
    iconItem,
    seriousConfirmDialog
  },
  computed: {
    pusher () {
      return this.$store.getters.pusher
    },
    // pausing () {
    //   return this.voucher.status !== 'sending' &&
    //     this.processedCount > 0 &&
    //     (this.processedCount < this.totalCount)
    // },
    // processing () {
    //   return this.voucher.status === 'sending'
    // },
    notes () {
      const vm = this
      var result = ''

      var values = []
      if (vm.sendingToEmail !== '') {
        values.push(vm.sendingToEmail)
      }
      if (vm.sendingToName !== '') {
        values.push('(' + vm.sendingToName + ')')
      }
      if (values.length > 0) {
        result = 'Sending ... <div class="badge badge-info">' + values.join(' ') + '</div>'
      }
      return result
    },

    // Mailing Summary
    //
    // total = (smtpServerReady + completed + fails)
    //

    percentCompleted () {
      const vm = this
      var result = 0
      if (vm.totalCount !== 0) {
        result = vm.processedCount*100 / vm.totalCount
        result = Math.round(result);
      }
      return result
    },
    // successCount () {
    //   const vm = this
    //   return vm.mailingSummary.completed
    // },
    // failCount () {
    //   const vm = this
    //   return vm.mailingSummary.fails
    // },
    processedCount () {
      const vm = this
      // vm.outputMailingSummary()
      const result =
        vm.mailingSummary.completed +
        vm.mailingSummary.fails
      // console.log('processedCount :: result = ' + result)
      return result

    },
    totalCount () {
      const vm = this
      // vm.outputMailingSummary()
      const result =
        vm.mailingSummary.completed +
        vm.mailingSummary.fails +
        vm.mailingSummary.pending +
        vm.mailingSummary.processing
      return result
    },
    smtpServerReady () {
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
    },
    pusherChannel: {
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
    }
  },
  // watch: {
  //   'voucher.id': function (newVal) {
  //     alert('id changed')
  //   }
  // },
  mounted () {
    const vm = this
    vm.initPusherChannel()
    vm.refreshSummary()
    vm.showingConfirmResetAllDialog = false
    // vm.loadMailingSummary()
    // if (vm.voucher.status === 'sending') {
    //   this.fetchMailingStatus()
    //   this.timer = setInterval(this.fetchMailingStatus, 1000)
    // }

  },
  beforeDestroy () {
    const vm = this
    if (this.timer) {
      clearInterval(this.timer)
    }
    vm.unbindEvents()
  },
  methods: {
    resetAll () {
      const vm = this
      this.$refs.seriousConfirmDialog.init({
        title: 'Reset All Mailing Status',
        message: 'All mailing status (completed or fails) will be lost. Are you sure?',
        confirmWord: 'reset',
        command: 'resetAll',
        inputValue: ''
      })
      this.showingConfirmResetAllDialog = true
    },
    setVoucherStatus (status) {
      const vm = this
      const postData = {
        urlCommand: '/vouchers/' + vm.voucher.id + '/status/' + status
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        response => {
          vm.$toaster.success('Signal has been sent to server.')
        }
      )
    },
    // outputMailingSummary () {
    //   const vm = this
    //   // console.log('mailingSummary :: sending_to: ', vm.mailingSummary.sending_to)
    //   // console.log('mailingSummary :: pending: ', vm.mailingSummary.pending)
    //   // console.log('mailingSummary :: processing: ', vm.mailingSummary.processing)
    //   // console.log('mailingSummary :: completed: ', vm.mailingSummary.completed)
    //   // console.log('mailingSummary :: fails: ', vm.mailingSummary.fails)
    // },
    initPusherChannel () {
      const vm = this
      if (vm.pusher && vm.voucher) {
        vm.unbindEvents()
        vm.pusherChannel = vm.pusher.subscribe('voucher' + vm.voucher.id + '.channel')
        vm.pusherChannel.bind('VoucherMailingStatusUpdated', function (data) {
          vm.onVoucherMailingStatusUpdated(data)
        })

        vm.pusherChannel.bind('VoucherCodeStatusUpdated', function (data) {
          vm.onVoucherCodeStatusUpdated(data)
        })

      }
    },

    unbindEvents () {
      const vm = this
      if (vm.pusherChannel) {
        vm.pusherChannel.unbind('VoucherMailingStatusUpdated')
        vm.pusherChannel.unbind('VoucherCodeStatusUpdated')
      }
    },

    onVoucherMailingStatusUpdated (data) {
      this.setMailingSummary(data.mailingSummary.summary)
    },

    onVoucherCodeStatusUpdated (data) {
      const vm = this
      const voucherCode = data.voucherCode
      if (voucherCode.status === 'processing') {
        vm.sendingToName = voucherCode.participant_name
        vm.sendingToEmail = voucherCode.participant_email
      }
    },

    setMailingSummary (summary) {
      const vm = this
      vm.mailingSummary.pending = summary.pending
      vm.mailingSummary.processing = summary.processing
      vm.mailingSummary.completed = summary.completed
      vm.mailingSummary.fails = summary.fails
      if (vm.mailingSummary.processing === 0) {
        vm.sendingToName = ''
        vm.sendingToEmail = ''
      }
    },
    
    refreshSummary () {
      const vm = this
      if (vm.voucher) {
        const data = {
          urlCommand: '/vouchers/' + vm.voucher.id + '/mailing_summary'
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          // response => {
          //  sendintTo:
          //  fails:
          //  completed:
          //  processing:
          //  pending:
          // }
          //
          response => {
            vm.setMailingSummary(response.summary)

            //   .sendingTo = response.summary.sending_to
            // vm.mailingSummary.pending = response.summary.pending
            // vm.mailingSummary.processing = response.summary.processing
            // vm.mailingSummary.fails = response.summary.fails
            // vm.mailingSummary.completed = response.summary.completed

            // vm.updateMailingSummary(response.summary)
            // vm.$set(vm.mailingSummary, 'sendingTo', response.summary.sending_to)
            // vm.$set(vm.mailingSummary, 'pending'', response.summary.status_list)

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
    doResetFails () {
      const vm = this
      const postData = {
        urlCommand: '/vouchers/' + vm.voucher.id + '/reset_failed_codes'
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        response => {
          vm.setMailingSummary(response.summary)
          vm.$toaster.info('All failed entries have been reset.')
          vm.setVoucherStatus('sending')
        }
      )
    },
    doResetAll (callback) {
      const vm = this
      const postData = {
        urlCommand: '/vouchers/' + vm.voucher.id + '/reset_all_codes_mailing_status'
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        response => {
          vm.setMailingSummary(response.summary)
          vm.$toaster.info('All mailing status have been reset.')
          if (typeof callback === 'function') {
            callback()
          }
        }
      )
    },
    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      switch (command) {
        case 'resetAll':
          vm.doResetAll(() => {
            if (typeof payload.callback === 'function') {
              payload.callback()
            }
          })
          break
        case 'start':
          vm.setVoucherStatus('sending')
          // vm.$emit('onCommand', {
          //   command: 'updateField',
          //   fieldName: 'status',
          //   fieldValue: 'sending'
          // })
          // vm.startSendingEmails()
          break
        case 'pause':
          vm.setVoucherStatus('pending')
          // vm.$emit('onCommand', {
          //   command: 'updateField',
          //   fieldName: 'status',
          //   fieldValue: 'pending'
          // })
          break
        case 'continue':
          vm.setVoucherStatus('sending')
          // vm.$emit('onCommand', {
          //   command: 'updateField',
          //   fieldName: 'status',
          //   fieldValue: 'sending'
          // })
          break
      }
    }
  },
  data () {
    return {
      showingConfirmResetAllDialog: false,
      fetching: false,
      timer: null,

      mailingSummary: {
        pending: 0,
        completed: 0,
        fails: 0,
        processing: 0
      },
      sendingToName: '',
      sendingToEmail: '',

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
  stroke-width: 12px;
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