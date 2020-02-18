const AuthMixin = {
  data () {
    return {
      loading: false
    }
  },
  computed: {
    mode () {
      return process.env.NODE_ENV
    }
  },
  methods: {
    sendResetEmail (email) {
      const vm = this
      const postData = {
        urlCommand: '/auth/reset_password',
        data: {
          email: email,
          url: window.location.origin + '/reset'
        }
      }
      vm.loading = true
      console.log('submit :: COMMON_POST => ' + postData.urlCommand)
      vm.$store.dispatch('COMMON_POST', postData).then(
        response => {
          vm.loading = false
          console.log('sendResetEmail :: response: ', response)
          vm.success = true,
          vm.message = vm.$t('messages.' + response.messageTag)
        },
        error => {
          vm.loading = false
          console.log('sendResetEmail :: error: ', error)
          vm.success = false
          vm.message = vm.$t('messages.' + error.messageTag)
        }
      )

      //   .then(
      //   (response) => {
      //     vm.loading = false
      //     vm.$router.push({'name': 'AuthMessage', params: {messageTag: response.messageTag}})
      //   },
      //   (error) => {
      //     vm.loading = false
      //     console.log('error: ', error)
      //     vm.message = vm.$t('messages.' + error.messageTag)
      //   }
      // )
    }
  }
}

export default AuthMixin
