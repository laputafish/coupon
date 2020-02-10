<template>
<div>
  {{ $t('general.' + value)}}
</div>
</template>

<script>
export default {
  props: ['row', 'value', 'field', 'xprops']
}
</script>
