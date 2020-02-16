<template>
<div class="card mt-5">
  <div class="card-header">{{ $t(titleTag) }}</div>
  <div class="card-body">
    <div v-if="message" class="text-center alert alert-danger">
      {{ message }}
    </div>
    <form action="" method="">
      <!-- Name -->
      <auth-input-row id="name"
                      labelTag="general.name"
                      v-model="registerData.name"
                      rules="required"
                      :fieldName="$t('general.email')"></auth-input-row>
      <!-- Email -->
      <auth-input-row id="email_address"
                      labelTag="login.email_address"
                      v-model="registerData.email"
                      rules="required|email"></auth-input-row>
      <!-- Password -->
      <div class="form-group row">
        <label for="password1" class="col-md-4 col-form-label text-md-right">
          {{ $t('login.password') }}</label>
        <div class="col-md-6">
          <validation-provider v-slot="{errors}" rules="required" vid="p1">
            <input type="password"
                   id="password1"
                   name="password1"
                   class="form-control"
                   v-model="registerData.password">
            <span>{{ errors[0] }}</span>
          </validation-provider>
        </div>
      </div>
      <!-- Password (confirmation) -->
      <div class="form-group row">
        <label for="password2" class="col-md-4 col-form-label text-md-right">
          {{ $t('login.passwordConfirmation') }}</label>
        <div class="col-md-6">
          <validation-provider v-slot="{errors}" rules="required|confirmed:p1">
            <input type="password"
                   id="password2"
                   name="password2"
                   class="form-control"
                   v-model="registerData.passwordConfirmation">
            <span>{{ errors[0] }}</span>
          </validation-provider>
        </div>
      </div>

      <!-- Submit button -->
      <div class="col-md-6 offset-md-4">
        <button type="button" @click.prevent="onSubmitRegistration()" class="btn btn-primary">
          <font-awesome-icon v-if="loading" icon="spinner" class="fa-spin" />
          {{ $t(titleTag) }}
        </button>
      </div>
    </form>
  </div><!-- card body -->
</div><!-- card -->
</template>

<script>
  import authInputRow from './comps/AuthInputRow'
  import authInputRowPassword from './comps/AuthInputRowPassword'

  export default {
    components: {
      authInputRow,
      authInputRowPassword
    },
    data () {
      return {
        password1: 'aaa',
        password2: 'aaa',
        loading: false,
        message: '',
        titleTag: 'login.register',
        registerData: {
          name: 'Dominic Lee',
          email: 'dominic@yoov.com',
          password: 'yoovyoov',
          passwordConfirmation: 'yoovyoov'
        }
      }
    },
    methods: {
      onSubmitRegistration () {
        const vm = this
        const postData = {
          urlCommand: '/auth/register',
          data: {
            ...vm.registerData,
            url: window.location.origin + '/verify'
          }
        }
        vm.loading = true
        console.log('submit :: COMMON_POST => ' + postData.urlCommand)
        vm.$store.dispatch('COMMON_POST', postData).then(
          (response) => {
            vm.loading = false
            vm.$router.push({'name': 'AuthMessage', params: {messageTag: response.messageTag}})
          },
          (error) => {
            vm.loading = false
            console.log('error: ', error)
            vm.message = vm.$t('messages.' + error.messageTag)
          }
        )

      }
    }
  }
</script>
