<template>
  <div class="d-flex flex-column">
    <div class="d-flex flex-row align-items-end line-height-1 mt-3 px-3">
      <div class="huge-font">{{ percentageValue }}%</div>
      <div class="ml-4 flex-grow-1">
        <div class="huge-font2 badge badge-warning">{{ completedCount }} / {{ totalCount }}</div>
      </div>
      <div class="align-items-stretch">
        <big-border-button v-if="!processing && !pausing"
                           variant="success"
                           @onCommand="onCommandHandler"
                           command="start"
                           caption="Start"></big-border-button>
        <big-border-button v-if="processing"
                           variant="danger"
                           @onCommand="onCommandHandler"
                           command="pause"
                           caption="Pause"></big-border-button>
        <big-border-button v-if="pausing"
                           variant="info"
                           @onCommand="onCommandHandler"
                           command="continue"
                           caption="Continue"></big-border-button>
      </div>

    </div>
    <div class="px-2 py-0">
      <yoov-progress-bar :value="completedCount"
                         class="px-2 py-3"
                         :max="totalCount"
                         :progress="0"
                         :completed="false"
                         :notes="notes"
                         :tempo="50"></yoov-progress-bar>
    </div>
  </div>
</template>

<script>
import yoovProgressBar from '@/views/comps/YoovProgressBar'
import bigBorderButton from './comps/BigBorderButton'

export default {
  components: {
    yoovProgressBar,
    bigBorderButton
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