<template>
  <div class="line-height-1">
    {{ value }}<br/>
    <copy-link v-if="codeKey"
               :label="codeKey"
               variant="success"
               :link="link"></copy-link>
  </div>
</template>

<script>
import copyLink from '@/views/comps/CopyLink.vue'

export default {
  components: {
    copyLink
  },
  props: ['value', 'row', 'xprops', 'field'],
  computed: {
    // codeKey () {
    //   return this.row['codeKey']
    // },
    codeKey () {
      const vm = this
      var result = ''
      if (vm.field === vm.xprops.firstField) {
        return vm.row['code_key']
      }
      return result
    },
    link () {
      const vm = this
      var result = ''
      if (vm.field === vm.xprops.firstField) {
        return vm.$store.getters.appHost + '/coupons/' + vm.codeKey
      }
      return result
    }
  }

}
</script>
