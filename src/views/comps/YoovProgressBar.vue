<template>
  <div class="container-fluid" id="progressbar">
    <div class="progress m-0 p-0">
      <div class="progress-bar progress-bar-striped" role="progressbar" :aria-valuenow="progress" aria-valuemin="0"
           aria-valuemax="100" :style="{'width': `${progress}%`}">
        {{ progress }}%
      </div>
    </div>
    <div class="position-absolute mt-1 m-0 p-0" v-html="notes"></div>
  </div>
</template>

<script>
export default {
  props: {
    progress: {
      type: Number,
      default: 0
    },
    completed: {
      type: Boolean,
      default: false
    },
    tempo: {
      type: Number,
      default: 0
    },
    notes: {
      type: String,
      default: ''
    }
  }
  // ,
  // created: function() {
  //   this.timer(this.tempo)
  // },
  // methods: {
  //   timer: function(tempo) {
  //     let vm = this;
  //     let setIntervalRef = setInterval(function() {
  //       vm.progress++;
  //       if (vm.progress == 100) {
  //         clearInterval(setIntervalRef);
  //         vm.completed = true;
  //       }
  //     }, tempo);
  //   }
  // }
}
</script>