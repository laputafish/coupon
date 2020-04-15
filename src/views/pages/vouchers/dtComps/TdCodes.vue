<template>
  <div class="text-center">
    <i class="fa fa-fw fa-qrcode"
      :class="{'text-light':!row['qrcode_comp'], 'text-success':row['qrcode_comp']}"></i>
    &nbsp;
    <i class="fa fa-fw fa-barcode"
       :class="{'text-light':!row['qrcode_comp'], 'text-success':row['qrcode_comp']}"></i>
  </div>
</template>

<script>
export default {
  props: ['row', 'value', 'xprops', 'field']
}
</script>
