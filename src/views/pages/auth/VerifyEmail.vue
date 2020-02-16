<template>
  <div class="card mt-5">
    <div class="card-header">{{ $t(titleTag) }}</div>
    <div class="card-body">
      <div v-if="messageTag" class="text-center alert"
           :class="'alert-'+variant">
        {{ $t('messages.' + messageTag) }}
      </div>

      <!-- Fails -->
      <template v-if="!verifying && !success">
        <!-- Email -->
        <auth-input-row id="email_address"
                        labelTag="login.email_address"
                        v-model="resendData.email"
                        rules="required|email"></auth-input-row>
        <div class="col-md-6 offset-md-4">
          <button type="button" @click.prevent="sendVerificationCode()" class="btn btn-primary">
            <font-awesome-icon v-if="loading" icon="spinner" class="fa-spin" />
            {{ code ? $t('login.resendVerificationCode') : $t('login.sendVerificationCode')}}
          </button>
        </div>
      </template>

      <!-- success -->
      <template v-if="!verifying && success">
        <div class="col-md-6 offset-md-4">
          <button type="button" @click.prevent="gotoLoginPage()" class="btn btn-primary">
            {{ $t('login.gotoLoginPage') }}
          </button>
        </div>
      </template>

    </div><!-- card body -->
  </div><!-- card -->
</template>

<script>
  import authInputRow from './comps/AuthInputRow'

  export default {
    components: {
      authInputRow
    },
    data () {
      return {
        loading: false,
        variant: 'info',
        titleTag: 'login.accountVerification',
        success: true,
        messageTag: '',
        verifying: true,
        code: '',
        resendData: {
          email: ''
        }
      }
    },
    mounted () {
      const vm = this
      vm.code = vm.$route.params.code

      if (vm.code) {
        const postData = {
          urlCommand: '/auth/verify',
          data: {
            code: vm.code
          }
        }
        vm.$store.dispatch('COMMON_POST', postData).then(
          response => {
            console.log('verify ok')
            vm.success = true
            vm.verifying = false

            vm.variant = 'info'
            vm.messageTag = response.messageTag

          },
          error => {
            console.log('verify fails')
            vm.success = false
            vm.verifying = false

            vm.variant = 'danger'
            vm.messageTag = error.messageTag
          }
        )
      } else {
        vm.success = false
        vm.variant = 'danger'
        vm.verifying = false
      }
    },
    methods: {
      gotoLoginPage () {
        this.$router.push({'name': 'Login'})
      },
      sendVerificationCode () {
        const vm = this
        const postData = {
          urlCommand: '/auth/verify',
          data: {
            email: vm.resendData.email,
            url: window.location.origin + '/verify'
          }
        }
        vm.loading = true
        vm.$store.dispatch('COMMON_POST', postData).then(
          response => {
            vm.loading = false

            vm.variant = 'info'
            vm.messageTag = response.messageTag
          },
          error => {
            vm.loading = false

            vm.variant = 'danger'
            vm.messageTag = error.messageTag
          }
        )
      }
    }
  }
</script>
