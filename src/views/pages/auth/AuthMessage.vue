<template>
  <div class="card mt-5">
    <div class="card-header">{{ $t(titleTag) }}</div>
    <div class="card-body">
      <div v-if="message" class="text-center alert alert-info">
        {{ $t('messages.' + message) }}
      </div>
      <div class="form-group row"></div>

      <div class="col-md-6 offset-md-4">
        <button type="button" @click.prevent="gotoLoginPage()" class="btn btn-primary">
          {{ $t('login.gotoLoginPage') }}
        </button>
      </div>
    </div><!-- card body -->
  </div><!-- card -->
</template>

<script>
  export default {
    computed: {
      message () {
        return this.$route.params.messageTag
      }
    },
    methods: {
      gotoLoginPage () {
        this.$router.push({'name': 'Login'})
      }
    }
  }
</script>
