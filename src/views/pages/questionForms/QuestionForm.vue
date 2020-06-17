<template>
  <div>
  <h1>Question Form</h1>
    {{ formConfigs }}
  </div>
</template>

<script>
export default {
  data () {
    return {
      formConfigs: null
    }
  },
  mounted () {
    const vm = this
    const key = vm.$route.params.key
    const getData = {
      urlCommand: '/form_questions/' + key
    }
    vm.$store.dispatch('USER_GET', getData).then(
      response => {
        vm.formConfigs = response.formConfigs
      }
    )
  }
}
</script>
