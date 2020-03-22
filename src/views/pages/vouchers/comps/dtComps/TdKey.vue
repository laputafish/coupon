<template>
  <div class="w-100 d-flex flex-row justify-content-between align-items-center" style="height:34px;">
    <div v-if="value===''" class="d-inline badge badge-secondary">
      {{ $t('vouchers.available_after_saving') }}
    </div>
    <template v-else>
      <div class="badge badge-primary flex-grow-1 mr-1 key-value"
        @click="copyLink()">
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
        vm.$copyText( vm.$store.getters.appHost + '/coupons/' + vm.value)
        vm.$toaster.info(vm.$t('messages.link_copied_to_clipboard'))
      }
    }
  }
</script>

<style>
.copy-link,
.key-value {
  cursor: pointer;
}

.copy-link {
  color: darkgray;
}

.copy-link:hover {
  color: rgb(10,10,10);
}
</style>