<template>
  <div class="w-100 d-flex flex-row justify-content-between align-items-center" style="height:34px;">
    <div v-if="value===''" class="d-inline badge badge-secondary">
      {{ $t('vouchers.available_after_saving') }}
    </div>
    <template v-else>
      <div class="badge badge-primary flex-grow-1 mr-1">
        {{ value }}
      </div>
      <div class="d-inline-block copy-link"
          @click="copyLink()">
        <font-awesome-icon icon="copy"/>
      </div>
    </template>
  </div>
</template>

<script>
  export default {
    props: ['row', 'value', 'xprops'],
    methods: {
      copyLink () {
        const vm = this
        vm.$copyText( window.location.origin + '/coupons/' + vm.value)
      }
    }
  }
</script>

<style>
.copy-link {
  cursor: pointer;
}
</style>