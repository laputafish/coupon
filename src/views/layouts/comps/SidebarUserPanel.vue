<template>
  <div class="user-panel mt-3 pb-3 mb-3 d-flex flex-row align-items-center line-height-1">
    <img :src="avatarUrl" class="img-circle elevation-2" alt="User Image">
    <div v-if="user" class="info">
      <a href="#" class="d-block">{{ user.name }}</a>
      <div class="badge badge-primary">{{ user.email }}</div>
    </div>
  </div>
</template>

<script>
  export default {
    computed: {
      user () {
        const vm = this
        return vm.$store.getters.user
      },
      avatarUrl () {
        return '/img/user.png'
      }
    }
  }
</script>