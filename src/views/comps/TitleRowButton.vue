<template>
            <button
                :key="buttonInfo.command"
                class="btn min-width-100"
                type="button"
                @click="onButtonClicked"
                :class="'btn-'+buttonInfo.variant">
            <font-awesome-icon

                :icon="currentIcon"
                :class="currentIconClass"></font-awesome-icon>
              <!--<i v-else :class="buttonInfo.iconClass"></i>-->

              <!--<font-awesome-icon-->
              <!--v-if="loading"-->
              <!--icon="spinner"></font-awesome-icon>-->
              <!--<i v-else :class="buttonInfo.iconClass"></i>-->
              <span class="ml-2">{{ $t(buttonInfo.captionTag) }}</span>
          </button>

  </template>

  <script>
  export default {
    props: {
      buttonInfo: {
        type: Object,
        default: null
      },
      loading: {
        type: Boolean,
        default: false
      }
    },
    computed: {
      currentIcon () {
        const vm = this
        let result = vm.buttonInfo.iconClass // = vm.buttonInfo.iconClass
        if (vm.buttonInfo.toggleSpinner) {
          if (vm.loading) {
            result = 'spinner'
          }
        }
        return result
      },
      currentIconClass () {
        const vm = this
        let result = ''
        if (vm.buttonInfo.toggleSpinner) {
          if (vm.loading) {
            result = 'fa-spin'
          }
        }
        return result
      }
    },
    methods: {
      onButtonClicked () {
        const vm = this
        console.log('onButtonClicked :: command = ' + vm.buttonInfo.command)
        vm.$emit('onCommand', {
          command: vm.buttonInfo.command
        })
      }
    }
  }
</script>