import Vue from 'vue'
import appMixin from '@/mixins/AppMixin'

const mixin = Vue.util.mergeOptions(appMixin, {
  methods: {
    refresh (id) {
      const vm = this
      console.log('DataRecordMixin :: refresh')
      const data = {
        urlCommand: vm.apiPath + '/' + id
      }
      vm.loading = true
      vm.$store.dispatch('AUTH_GET', data).then(function (response) {
        // console.log('refresh :: response: ', response)
        vm.record = response.data
        vm.loading = false
        vm.$forceUpdate()
      })
    }
  }
})

export default mixin
