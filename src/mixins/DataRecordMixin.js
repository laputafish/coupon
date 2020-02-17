const mixin = {
  methods: {
    refresh (id) {
      const vm = this
      const data = {
        urlCommand: vm.apiPath + '/' + id
      }
      vm.loading = true
      vm.$store.dispatch('AUTH_GET', data).then(function (response) {
        console.log('refresh :: response: ', response)
        vm.record = response.data
        vm.loading = false
        vm.$forceUpdate()
      })
    }
  }
}

export default mixin
