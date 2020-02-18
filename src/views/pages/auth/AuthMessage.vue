<template>
  <div class="card mt-5">
    <div class="card-header">{{ $t(titleTag) }}</div>
    <div class="card-body">
      <div v-if="message" class="text-center alert alert-info">
        {{ $t('messages.' + message) }}
      </div>
      <div class="form-group row"></div>

      <div class="col-12 text-center">
        <button type="button" @click.prevent="gotoLoginPage()" class="btn btn-primary">
          {{ $t('login.gotoLoginPage') }}
        </button>
      </div>
    </div><!-- card body -->
  </div><!-- card -->
</template>

<script>
  import authMixin from '@/mixins/AuthMixin'

  export default {
    mixins: [authMixin],
    data () {
      return {
        titleTag: 'general.information'
      }
    },
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
