<template>
  <div
      class="py-1 px-2 w-100 d-flex flex-row justify-content-start align-items-center rounded"
      style="background-color:lightskyblue; line-height:1.4;">
    <div class="mr-2 bg-white d-flex flex-column justify-content-center align-items-center p-1"
         style="border-radius:24px;width:48px;height:48px;">
      <font-awesome-icon icon="user" class="fa-fw fa-2x"></font-awesome-icon>
    </div>
    <div class="d-flex flex-column flex-grow-1 align-items-start">
      {{ user.name }}
      <div class="badge badge-primary d-inline-block">
        {{ user.email }}
      </div>
    </div>
    <button type="button"
            @click="deleteUser"
            class="ml-2 btn-circle btn btn-danger">
      <font-awesome-icon icon="times"></font-awesome-icon>
    </button>
  </div>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: null
    }
  },
  methods: {
    deleteUser () {
      const vm = this
      vm.$dialog.confirm('Are you sure?')
        .then(dialog => {
          vm.doDelete()
        })
        .catch(() => {

        })
    },
    doDelete () {
      const vm = this
      console.log('doDelete')
      this.$emit('onCommand', {
        command: 'deleteUser',
        row: vm.user
      })
    }
  }
}
</script>