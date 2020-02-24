<template>
<div class="base-layout" style="padding-top:56px;">
  <!-- Navigation -->
  <base-navbar></base-navbar>
  <router-view></router-view>
</div>
</template>

<script>
import baseNavbar from '@/views/layouts/comps/BaseNavbar'

export default {
  components: {
    baseNavbar
  }
}
</script>
