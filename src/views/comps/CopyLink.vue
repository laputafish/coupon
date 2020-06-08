<template>
<div class="d-flex flex-row align-items-center icon-link">
  <a :href="link" class="d-inline-block copy-link-icon" target="_blank">
    <font-awesome-icon icon="location-arrow"/>
  </a>
  <!--<a :href="link" @click="onLinkClicked" class="d-inline-block copy-link-icon" target="_blank">-->
    <!--<font-awesome-icon icon="location-arrow"/>-->
  <!--</a>-->

  <div class="badge flex-grow-1 mx-1 key-value"
       :class="'badge-'+variant"
       @click="copyLink()">
    {{ linkLabel }}
  </div>

  <div class="d-inline-block copy-link-icon"
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
    // ,
    // onLinkClicked () {
    //   this.$emit('onCommand', {
    //     command: 'onLinkClicked'
    //   })
    // }
  }
}
</script>

<style>

.copy-link-icon {
  color: darkgray;
  cursor: pointer
}

.icon-link .badge {
  max-width: 240px;
}
.copy-link .badge {
  cursor: pointer;
}
</style>