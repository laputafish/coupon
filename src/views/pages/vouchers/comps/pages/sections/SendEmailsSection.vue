<template>
  <div class="d-flex flex-column">
    <div class="d-flex flex-row line-height-1 mt-3 px-3">
      <div class="d-flex flex-column flex-grow-1">
        <div class="d-flex flex-row align-items-end">
          <div class="huge-font">{{ percentageValue }}%</div>
          <div class="ml-4 flex-grow-1">
            <div class="huge-font2 badge badge-warning">{{ completedCount }} / {{ totalCount }}</div>
          </div>
        </div>
        <yoov-progress-bar :value="completedCount"
                           class="px-2 py-3"
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
    <div class="mx-3 mt-3 mb-0">
      <h4 class="mb-2 text-success">Success:</h4>
    </div>
    <div class="mx-3 mt-3 mb-1">
      <h4 class="mb-3 text-danger">Failed:</h4>
      <table class="table striped">
        <thead>
          <tr>
            <th class="text-center">#</th>
            <th>Email</th>
            <th>Date/Time</th>
            <th>Error</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="text-center">1</td>
            <td>abc@gmail.com</td>
            <td>2020-05-31 02:05:05</td>
            <td>xxxx</td>
          </tr>
          <tr>
            <td class="text-center">1</td>
            <td>abc@gmail.com</td>
            <td>2020-05-31 02:05:05</td>
            <td>xxxx</td>
          </tr>
          <tr>
            <td class="text-center">1</td>
            <td>abc@gmail.com</td>
            <td>2020-05-31 02:05:05</td>
            <td>xxxx</td>
          </tr>
          <tr>
            <td class="text-center">1</td>
            <td>abc@gmail.com</td>
            <td>2020-05-31 02:05:05</td>
            <td>xxxx</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
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
    ready () {
      const vm = this
      return vm.smtpServer
    },
    smtpServers () {
      return this.$store.getters.smtpServers
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
    },
    smtpServer () {
      const vm = this
      var result = null
      if (vm.voucher) {
        if (vm.voucher.smtp_server_id === 0) {
          result = vm.systemSmtpServer
        } else {
          result = vm.smtpServers.find(server => server.id === vm.voucher.smtp_server_id)
        }
      }
      return null
    }
  },
  props: {
    voucher: {
      type: Object,
      default: null
    }
  },
  methods: {
    pauseOperation () {

    },
    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      switch (command) {
        case 'start':
          vm.processing = true
          break
        case 'pause':
          vm.processing = false
          vm.pausing = true
          break
        case 'continue':
          vm.processing = true
          vm.pausing = false
          break
      }
    }
  },
  data () {
    return {
      processing: false,
      pausing: false,

      percentageValue: 20,
      completedCount: 40,
      totalCount: 200,

      notes: 'Sending ... <div class="badge badge-info">#2 peter@gmail.com (Peter Chan)</div>',

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

</style>