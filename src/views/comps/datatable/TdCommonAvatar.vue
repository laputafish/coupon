<template>
  <div class="avatar">
    <img v-if="value" class="avatar-img" :src="photoUrl"/>
    <span v-else>
      <i class="fa fa-stop"></i>
    </span>
  </div>
</template>

<script>
export default {
  props: ['row', 'value', 'props', 'field'],
  computed: {
    photoUrl () {
      const vm = this
      let result = ''
      if (vm.row.avatar) {
        result = vm.row.avatarUrl
      } else {
        result = 'https://oa.yoov.com/' + vm.row.avatarUrl
      }
      return result
    }
  }
}
</script>

<style>
  .avatar-img {
    width: 32px;
    height: 32px;
    object-fit: contain;
    border-radius: 50rem;
    border: 1px solid #ddd;
  }
</style>
