<template>
  <div class="td-views line-height-1">
    <span v-if="value===0">0</span>
    <div v-else class="badge badge-warning">{{ value }}</div>
  </div>
</template>

<script>
  export default {
    props: ['value', 'row', 'xprops']
  }
</script>
