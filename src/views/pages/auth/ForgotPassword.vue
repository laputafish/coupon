<template>
<div class="card mt-5">
  <div class="card-header">{{ $t(titleTag) }}</div>
  <div class="card-body">
    <auth-result-message
        v-if="message"
        :success="success"
        :message="message"></auth-result-message>
    <!--<div v-if="message" class="text-center alert alert-danger">-->
      <!--{{ message }}-->
    <!--</div>-->
    <form action="" method="">
      <!-- Email -->
      <div class="form-group row">
        <label for="email_address" class="col-md-4 col-form-label text-md-right">
          {{ $t('login.email_address') }}</label>
        <div class="col-md-6">
          <input type="text" id="email_address" class="form-control" name="email-address"
                 v-model="email"
                 required autofocus>
        </div>
      </div>
      <div class="col-md-6 offset-md-4">
        <button type="button" @click="submit()" class="btn btn-primary">
          <font-awesome-icon v-if="loading" icon="spinner" class="fa-spin" />
          {{ $t('auth.resendEmail') }}
        </button>
      </div>
    </form>
  </div><!-- card body -->
</div><!-- card -->
</template>

<script>
  import authMixin from '@/mixins/AuthMixin'
  import authResultMessage from './comps/AuthResultMessage'

  export default {
    components: {
      authResultMessage
    },
    mixins: [authMixin],
    data () {
      return {
        titleTag: 'auth.forgot_password',
        email: '',
        success: false,
        message: ''

      }
    },
    mounted () {
      const vm = this
      vm.email = 'yoovcoupon@gmail.com'
    },
    methods: {
      submit () {
        const vm = this
        vm.sendResetEmail(vm.email)
      }
    }
  }
</script>
