<template>
<div>
  <div class="mt-5 text-center" style="font-size:72px;">ERROR</div>
  <div class="mt-3">
    <div style="border:2px solid red;width:90%;max-width:480px;" class="mx-auto my-3 p-3 text-left text-center">
      Access Denied,<br/>
      Session Expired, or<br/>
      Logout Already.<br/>
    </div>
  </div>
  <div class="text-center">
    <router-link :to="{name: 'Login'}" class="btn btn-primary">
      Back to Login
    </router-link>
  </div>
</div>
</template>

<script>
export default {

}
</script>
