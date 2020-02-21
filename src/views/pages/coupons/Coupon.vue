<template>
  <div class="coupon">
    <div v-if="message" class="info-message d-flex justify-content-center align-items-center" style="position:fixed;left:0;top:0;width:100%;height:100%;">
      <div class="card">
        <div class="card-body bg-danger card-shadow">
          <h3 class="m-0 p-0 d-inline-block">{{ message }}</h3>
        </div>
      </div>
    </div>
    <div v-else v-html="html"></div>
  </div>
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

<style>
  .coupon p {
    margin: 16px 0;
  }

  .coupon .info-message {
    font-family: cursive;
  }
  .card-shadow {
    -webkit-box-shadow: 10px 10px 9px -2px rgba(0, 0, 0, 0.75);
    -moz-box-shadow: 10px 10px 9px -2px rgba(0, 0, 0, 0.75);
    box-shadow: 10px 10px 9px -2px rgba(0, 0, 0, 0.75);
  }
</style>