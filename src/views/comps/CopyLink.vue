<template>
<div class="d-flex flex-row align-items-center">
  <a :href="link" class="d-inline-block copy-link" target="_blank">
    <font-awesome-icon icon="location-arrow"/>
  </a>

  <div class="badge flex-grow-1 mx-1 key-value"
       :class="'badge-'+variant"
       @click="copyLink()">
    {{ linkLabel }}
  </div>

  <div class="d-inline-block copy-link"
       @click="copyLink()">
    <font-awesome-icon icon="copy"/>
  </div>
</div>

</template>

<script>
export default {
  computed: {
    linkLabel () {
      const vm = this
      var result = vm.link
      if (vm.label !== '') {
        result = vm.label
      }
      return result
    }
  },
  props: {
    label: {
      type: String,
      default: ''
    },
    link: {
      type: String,
      default: ''
    },
    variant: {
      type: String,
      default: 'primary'
    }
  },
  methods: {
    copyLink () {
      const vm = this
      vm.$copyText( vm.link)
      vm.$toaster.info(vm.$t('messages.link_copied_to_clipboard'))
    }
  }
}
</script>