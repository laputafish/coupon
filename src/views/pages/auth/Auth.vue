<template>
<div>
  <auth-navbar></auth-navbar>
  <main class="login-form">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-8">
          <router-view></router-view>
        </div><!-- col -->
      </div><!-- row -->
    </div><!-- container -->
  </main>
</div>
</template>

<script>
import authNavbar from './comps/AuthNavbar'

export default {
  components: {
    authNavbar
  }
}
</script>
