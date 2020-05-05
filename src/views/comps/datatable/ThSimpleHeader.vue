<template>
  <div class="th-field">
    {{ title }}
  </div>
</template>

<script>
export default {
  props: ['title', 'field']
}
</script>

<style>
.th-field {
  white-space: nowrap;
  font-weight: normal;
}
</style>
