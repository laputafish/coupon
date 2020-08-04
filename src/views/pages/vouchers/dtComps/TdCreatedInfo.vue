<template>
  <div class="text-center td-created-info">
    <div class="d-inline-block">{{ trimDate }}</div>
    <div v-if="!isOwner" class="text-center">
      <div class="badge badge-warning">By {{ row.creator.name }}</div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['value', 'row'],
  computed: {
    user () {
      const vm = this
      return vm.$store.getters.user
    },
    isOwner () {
      const vm = this
      return vm.row.user_id === vm.user.id
    },
    trimDate () {
      const vm = this
      let result = '-'
      if (vm.value) {
        if (vm.value === '') {
          result = '-'
        } else {
          result = vm.value.substr(0, 10)
        }
      }
      return result
    }
  }
}
</script>

<style>
.td-created-info {
  line-height: 1.2;
}
</style>
