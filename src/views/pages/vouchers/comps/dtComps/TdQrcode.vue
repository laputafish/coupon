<template>
  <div class="text-center" style="line-height:1.2;">
    <qrcode-vue
      :value="qrcodeLink"
      :size="120"
      level="M"></qrcode-vue>
    {{ value }}<br/>
    <div class="d-inline-block">
      <copy-link :link="qrcodeLink"></copy-link>
    </div>
  </div>
</template>

<script>
import qrcodeVue from 'qrcode.vue'
import copyLink from '@/views/comps/CopyLink.vue'

export default {
  components: {
    qrcodeVue,
    copyLink
  },
  props: ['row', 'value', 'xprops'],
  computed: {
    qrcodeLink() {
      const vm = this
      return vm.$store.getters.appHost + '/redeem/' + btoa(vm.value)
    }
  }
}
</script>

<style>

</style>