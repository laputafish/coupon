<template>
  <div class="th-field badge badge-info">
    {{ $t(title) }}
  </div>
</template>

<script>
export default {
  props: [
    'title',
    'field'
  ]
}
</script>

<style>
.th-field {
  white-space: nowrap;
  font-weight: normal;
}
</style>
