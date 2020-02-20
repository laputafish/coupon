<template>
  <div v-if="message" class="d-flex justify-content-center align-items-center" style="position:fixed;left:0;top:0;width:100%;height:100%;">
    <h2 class="m-0 p-0 d-inline-block">{{ message }}</h2>
  </div>
  <div v-else v-html="html"></div>
</template>

<script>
  export default {
    data () {
      return {
        html: '',
        message: ''
      }
    },
    computed: {
      isTemp () {
        const vm = this
        return vm.$route.name === 'TempCoupon'
      }
    },
    mounted () {
      const vm = this
      const key = vm.$route.params.key

      const data = {
        urlCommand: '/templates',
        data: {
          isTemp: vm.isTemp,
          key: key
        }
      }
      vm.$store.dispatch('COMMON_POST', data).then(
        response => {
          vm.html = response
        },
        error => {
          vm.message = vm.$t('messages.' + error.messageTag)
        }
      )
    }
  }
</script>