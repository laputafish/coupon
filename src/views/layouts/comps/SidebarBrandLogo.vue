<template>
  <a href="index3.html" class="brand-link">
    <img :src="logoSrc" alt="AdminLTE Logo" class="brand-image img-circle elevation-3"
         style="opacity: .8">
    <span class="brand-text font-weight-light">Digital Voucher</span>
  </a>
</template>

<script>
  export default {
    props: {
      logoSrc: {
        type: String,
        default: '#'
      }
    }
  }
</script>