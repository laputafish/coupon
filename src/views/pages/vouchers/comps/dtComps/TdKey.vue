<template>
  <div>
    <span v-if="value===''"
          class="badge badge-secondary">
      {{ $t('vouchers.available_after_saving') }}</span>
    <span class="badge badge-primary">{{ value }}</span>
  </div>
</template>

<script>
  export default {
    props: ['row', 'value', 'xprops']
  }
</script>