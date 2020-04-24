<template>
  <div class="text-center">
    <div v-if="value==='voucher'"
      class="badge badge-primary">Voucher
    </div>
    <div v-else
         class="badge badge-success">
      Form <i class="fas fa-caret-right"></i>
      Voucher
    </div>
  </div>
</template>


<script>
export default {
  props: ['row','value','field','xprops']
}
</script>
