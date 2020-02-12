<template>
  <div class="td-agent">
    {{ row['code_sent'] }} / {{ row['code_count'] }}
  </div>
</template>

<script>
export default {
  props: ['row', 'value', 'xprops']
}
</script>