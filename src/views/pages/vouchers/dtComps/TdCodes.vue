<template>
  <div class="text-center">
    <font-awesome-icon icon="qrcode"
                       class="fa-fw"
                       :class="qrcodeClass"></font-awesome-icon>
    <font-awesome-icon icon="barcode"
                       class="fa-fw"
                       :class="barcodeClass"></font-awesome-icon>
  </div>
</template>

<script>
export default {
  // data () {
  //   return {
  //     qrcodeComp: '',
  //     barcodeComp: ''
  //   }
  // },
  computed: {
    qrcodeClass () {
      const vm = this
      var result = 'text-disabled'
      console.log('computed(qrcodeClass) : vm.row[qrcode_comp]: ' + vm.row['qrcode_comp'])
      if (vm.row['qrcode_comp'] !== '') {
        result = 'text-success'
      }
      return result
    },
    barcodeClass () {
      const vm = this
      var result = 'text-disabled'
      console.log('computed(barcodeClass) : vm.row[barcode_comp]: ' + vm.row['barcode_comp'])
      if (vm.row['barcode_comp'] !== '') {
        result = 'text-success'
      }
      return result
    }
  },
  mounted() {
    const vm = this
    // vm.qrcodeComp = vm.row['qrcode_comp']
    // vm.barcodeComp = vm.row['barcode_comp']
  },
  props: ['row', 'value', 'xprops', 'field']
  // ,
  // watch: {
  //   'row.qrcode_comp': function(newVal) {
  //     alert('qrcode_comp = ' + newVal)
  //     vm.qrcodeComp = newVal
  //     vm.$forceUpdate()
  //   },
  //   'row.barcode_comp': function(newVal) {
  //     alert('barcode_comp = ' + newVal)
  //     vm.barcodeComp = newVal
  //     vm.$forceUpdate()
  //   }
  // }
}
</script>

<style>
  .text-disabled {
    color: #C8D8D9;
  }
</style>
