<template>
  <div class="user-panel mt-3 pb-3 mb-3 d-flex">
    <div class="image">
      <img :src="avatarUrl" class="img-circle elevation-2" alt="User Image">
    </div>
    <div class="info">
      <a href="#" class="d-block">{{ name }}</a>
    </div>
  </div>
</template>

<script>
  export default {
    props: {
      avatarUrl: {
        type: String,
        default: ''
      },
      name: {
        type: String,
        default: 'Guest'
      }
    }
  }
</script>