<template>
  <div class="td-views line-height-1">
    <font-awesome-icon icon="eye"/>
    x <div class="badge badge-warning">{{ value }}</div>
  </div>
</template>

<script>
  export default {
    props: ['value', 'row', 'xprops']
  }
</script>
