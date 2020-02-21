<template>
  <div class="th-field">
    <div class="text-center">
      {{ title }}<br/>
      <div class="badge badge-info">{{ '{' + token + '}' }}</div>
    </div>
  </div>
</template>

<script>
import helpers from '@/helpers'
export default {
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
