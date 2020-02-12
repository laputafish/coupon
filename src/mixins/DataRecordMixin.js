import Vue from 'vue'
import dialogMixin from '@/mixins/DialogMixin'
import dtCommon from '@/views/comps/datatable'
import sectionHeader from '@/views/layouts/comps/SectionHeader'

const mixin = {
  methods: {
    refresh (id) {
      const vm = this
      const data = {
        urlCommand: vm.apiPath + '/' + id
      }
      vm.loading = true
      vm.$store.dispatch('COMMON_GET', data).then(function (response) {
        console.log('refresh :: response: ', response)
        vm.record = response.data
        vm.csrfToken = response.csrfToken
        vm.loading = false
        vm.$forceUpdate()
      })
    }
  }
}

export default mixin
