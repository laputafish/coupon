<template>
  <div class="th-field">
    <div class="text-center">
      Key<br/>
      <copy-token token="code_ticket_link"></copy-token>
    </div>
  </div>
</template>

<script>
import helpers from '@/helpers'
import copyToken from '@/views/comps/CopyToken'

export default {
  components: {
    copyToken
  },
  props: [
    'title',
    'field'
  ]
}
</script>

<style>
.th-field {
  display: inline-block;
  white-space: nowrap;
  font-weight: normal;
  line-height: 1;
}
</style>
