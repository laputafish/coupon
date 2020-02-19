<template>
  <div class="verify-email card mt-5" style="min-height: 183px;">
    <div class="card-header">{{ $t(titleTag) }}</div>
    <div class="card-body">
      <auth-result-message
          v-if="message"
          :success="success"
          :message="message"></auth-result-message>
      <!-- Verifying -->
      <template v-if="verifying">
        <form @submit.prevent="gotoLoginPage()">
          <div class="row">
            <div class="col-sm-12 text-center">
              <div class="d-inline mr-3">{{ $t('auth.verifying') }}</div>
              <font-awesome-icon v-if="verifying" icon="spinner" class="fa-spin"/>
            </div>
          </div>
          <div class="row">
            <div class="col-12 text-center">
              <button type="submit" class="btn btn-primary">
                {{ $t('login.gotoLoginPage') }}
              </button>
            </div>
          </div>
        </form>
      </template>

      <!-- Fails -->
      <template v-if="!verifying && !success">
        <form @submit.prevent="sendVerificationCode()">
          <!-- Email -->
          <auth-input-row id="email_address"
                          labelTag="login.email_address"
                          v-model="resendData.email"
                          rules="required|email"></auth-input-row>
          <div class="row">
            <div class="col-12 text-center">
              <button type="submit" class="btn btn-primary">
                <font-awesome-icon v-if="loading" icon="spinner" class="fa-spin"/>
                {{ code ? $t('login.resendVerificationCode') : $t('login.sendVerificationCode')}}
              </button>
              <!--<button type="button" @click.prevent="sendVerificationCode()" class="btn btn-primary">-->
                <!--<font-awesome-icon v-if="loading" icon="spinner" class="fa-spin"/>-->
                <!--{{ code ? $t('login.resendVerificationCode') : $t('login.sendVerificationCode')}}-->
              <!--</button>-->
            </div>
          </div>
        </form>
      </template>

      <!-- success -->
      <template v-if="!verifying && success">
        <div v-if="hasCode" class="row">
          <div class="col-12 text-center form-control-plaintext">
            {{ $t('auth.verificationCompleted') }}
          </div>
        </div>
        <div class="row">
          <form @submit.prevent="gotoLoginPage()">
            <div class="col-12 text-center">
              <button type="submit" class="btn btn-primary">
                {{ $t('login.gotoLoginPage') }}
              </button>
            </div>
          </form>
        </div>
      </template>

    </div><!-- card body -->
  </div><!-- card -->
</template>

<script>
  import authInputRow from './comps/AuthInputRow'
  import authMixin from '@/mixins/AuthMixin'
  import authResultMessage from './comps/AuthResultMessage'

  export default {
    mixin: [authMixin],
    components: {
      authInputRow,
      authResultMessage
    },
    data () {
      return {
        loading: false,
        titleTag: 'login.accountVerification',

        message: '',
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
        vm.hasCode = true
        vm.verifyCode(vm.code)
      } else {
        vm.hasCode = false
        vm.success = false
        vm.verifying = false
      }
    },
    methods: {
      verifyCode (code) {
        const vm = this
        const postData = {
          urlCommand: '/auth/verify',
          data: {
            code: code
          }
        }
        vm.$store.dispatch('COMMON_POST', postData).then(
          response => {
            console.log('verify ok: response: ', response)
            vm.success = true
            vm.verifying = false
            vm.message = vm.$t('messages.' + response.messageTag)

            const url = vm.$route.path
            const newUrl = url.replace( '/' + vm.code, '')
            window.history.replaceState({}, document.title, newUrl)
            vm.hasCode = false
          },
          error => {
            console.log('verify fails: error: ', error)
            vm.success = false
            vm.verifying = false
            vm.message = vm.$t('messages.' + error.messageTag)

            const url = vm.$route.path
            const newUrl = url.replace( '/' + vm.code, '')
            window.history.replaceState({}, document.title, newUrl)
            vm.hasCode = false
          }
        )
      },
      gotoLoginPage () {
        this.$router.push({'name': 'Login'})
      },
      sendVerificationCode () {
        const vm = this
        console.log('sendVerificationCode')
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
            vm.success = true
            vm.message = vm.$t('messages.' + response.messageTag)
          },
          error => {
            vm.loading = false
            vm.success = false
            vm.message = vm.$t('messages.' + response.messageTag)
          }
        )
      }
    }
  }
</script>

<style>
.verify-email .card-body .row:first-child {
  min-height: 50px;
}
</style>
