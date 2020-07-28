<template>
  <div class="text-center">
    <qrcode-vue
      :value="qrcode"
      :size="120"
      level="M"></qrcode-vue>
  </div>
</template>

<script>
import qrcodeVue from 'qrcode.vue'

export default {
  components: {
    qrcodeVue
  },
  props: ['row', 'value', 'xprops'],
  computed: {
    qrcode () {
      const vm = this
      return vm.value
    }
  }
}
</script>

<style>

</style>