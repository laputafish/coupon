<template>
  <div v-html="html"></div>
</template>

<script>
  export default {
    data () {
      return {
        html: ''
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
        }
      )
    }
  }
</script>