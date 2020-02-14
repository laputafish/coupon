<template>
<div class="card mt-5">
  <div class="card-header">{{ $t(titleTag) }}</div>
  <div class="card-body">
    <form action="" method="">
      <!-- Email -->
      <div class="form-group row">
        <label for="email_address" class="col-md-4 col-form-label text-md-right">
          {{ $t('login.email_address') }}</label>
        <div class="col-md-6">
          <input type="text" id="email_address" class="form-control" name="email-address"
                 v-model="credentials.email"
                 required autofocus>
        </div>
      </div>
      <!-- Password -->
      <div class="form-group row">
        <label for="password" class="col-md-4 col-form-label text-md-right">
          {{ $t('login.password') }}</label>
        <div class="col-md-6">
          <input type="password" id="password" class="form-control" name="password"
                 v-model="credentials.password"
                 required>
        </div>
      </div>
      <!-- Remember -->
      <div class="form-group row">
        <div class="col-md-6 offset-md-4">
          <div class="checkbox">
            <label>
              <input type="checkbox" name="remember"> {{ $t('login.remember_me') }}
            </label>
          </div>
        </div>
      </div>
      <!-- Submit button -->
      <div class="col-md-6 offset-md-4">
        <button @click="submit()" class="btn btn-primary">
          {{ $t(titleTag) }}
        </button>
        <router-link :to="{name: 'Forget_Password'}" class="btn btn-link">
          {{ $t('login.forgot_your_password') }}
        </router-link>
      </div>
    </form>
  </div><!-- card body -->
</div><!-- card -->
</template>

<script>
  export default {
    data () {
      return {
        titleTag: 'login.login',
        credentials: {
          email: '',
          password: ''
        }
      }
    }
  }
</script>
