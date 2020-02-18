<template>
<div class="text-center alert"
     :class="'alert-'+variant">
  {{ message }}
</div>
</template>

<script>
  export default {
    computed: {
      variant () {
        const vm = this
        return vm.success ? 'info' : 'danger'
      }
    },
    props: {
      success: {
        type: Boolean,
        default: false
      },
      message: {
        type: String,
        default: ''
      }
    }
  }
</script>