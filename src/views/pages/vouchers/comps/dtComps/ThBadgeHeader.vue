<template>
  <div class="th-field">
    <div class="text-center">
      {{ title }}<br/>
      <copy-token
        :token="token"></copy-token>
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
  computed: {
    token () {
      const vm = this
      // console.log('helpers::ThBadgeHeader :: title: ', vm.title)
      return helpers.str2token('code_', vm.title)
    }
  },
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
  line-height: 1;
}
</style>
