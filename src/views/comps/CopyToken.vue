<template>
  <div @click="copyToken"
       class="copy-token badge badge-info">{{ '{' + token + '}' }}&nbsp;<i class="fas fa-copy"></i></div>
</template>

<script>
export default {
  props: {
    token: {
      type: String,
      default: ''
    }
  },
  methods: {
    copyToken () {
      const vm = this
      vm.$copyText('{' + vm.token + '}')
      vm.$toaster.info(vm.$t('messages.token_copied_to_clipboard'))
    }
  }
}
</script>

<style>
.copy-token {
  cursor: pointer;
}
</style>