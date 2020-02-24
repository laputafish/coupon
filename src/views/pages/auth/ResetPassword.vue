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
        <div class="row">
          <div class="col-sm-12 text-center">
            <div class="d-inline mr-3">{{ $t('auth.verifying') }}</div>
            <font-awesome-icon v-if="verifying" icon="spinner" class="fa-spin"/>
          </div>
        </div>
        <div class="row">
          <div class="col-12 text-center">
            <button type="button" @click.prevent="gotoLoginPage()" class="btn btn-primary">
              {{ $t('login.gotoLoginPage') }}
            </button>
          </div>
        </div>
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
        <form @submit.prevent="confirmPassword()">
          <div v-if="hasCode" class="row">
            <div class="col-12 text-center form-control-plaintext">
              {{ $t('auth.verificationCompleted') }}
            </div>
          </div>
          <!-- New password -->
          <div class="form-group row">
            <label for="password1" class="col-md-4 col-form-label text-md-right">
              {{ $t('login.password') }}</label>
            <div class="col-md-6">
              <validation-provider v-slot="{errors}" rules="required" vid="p1">
                <input type="password"
                       id="password1"
                       name="password1"
                       class="form-control"
                       v-model="password">
                <span>{{ errors[0] }}</span>
              </validation-provider>
            </div>
          </div>
          <!-- New Password (confirmation) -->
          <div class="form-group row">
            <label for="password2" class="col-md-4 col-form-label text-md-right">
              {{ $t('login.passwordConfirmation') }}</label>
            <div class="col-md-6">
              <validation-provider v-slot="{errors}" rules="required|confirmed:p1">
                <input type="password"
                       id="password2"
                       name="password2"
                       class="form-control"
                       v-model="passwordConfirmation">
                <span>{{ errors[0] }}</span>
              </validation-provider>
            </div>
          </div>

          <div class="row">
            <div class="col-12 text-center">
              <button type="submit"  class="min-width-80 btn btn-primary">
                {{ $t('buttons.ok') }}
              </button>
            </div>
          </div>
        </form>
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
        titleTag: 'auth.resetPassword',

        message: '',
        success: true,

        password: '',
        passwordConfirmation: '',
        messageTag: '',
        verifying: true,
        code: '',
        resendData: {
          email: ''
        },
        userId: 0
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
            vm.userId = response.userId
            let url = vm.$route.path
            let newUrl = url.replace('/' + vm.code, '')
            window.history.replaceState({}, document.title, newUrl)
            vm.hasCode = false
          },
          error => {
            console.log('verify fails: error: ', error)
            vm.success = false
            vm.verifying = false
            vm.message = vm.$t('messages.' + error.messageTag)

            let url = vm.$route.path
            let newUrl = url.replace('/' + vm.code, '')
            window.history.replaceState({}, document.title, newUrl)
            vm.hasCode = false
          }
        )
      },
      confirmPassword () {
        const vm = this
        console.log('confirmPassord')
        const postData = {
          urlCommand: '/auth/change_password',
          data: {
            password: vm.password,
            userId: vm.userId
          }
        }
        vm.loading = true
        vm.$store.dispatch('COMMON_POST', postData).then(
          response => {
            vm.loading = false
            vm.$router.push({'name': 'AuthMessage', params: {messageTag: response.messageTag}})
          },
          error => {
            vm.loading = false
            console.log('error: ', error)
            vm.message = vm.$t('messages.' + error.messageTag)
          }
        )
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
