<template>
<div ref="container" class="d-flex flex-row align-items-center icon-link"
  :class="cssClass">
  <div @click="gotoLink(link)" class="d-inline-block link-icon">
    <font-awesome-icon icon="location-arrow"/>
  </div>
  <!--<a :href="link" class="d-inline-block copy-link-icon" target="_blank">-->
    <!--<font-awesome-icon icon="location-arrow"/>-->
  <!--</a>-->

  <div class="badge flex-grow-1 mx-1 key-value link-label"
       :class="'badge-'+variant"
       @click.stop.prevent="copyLink()">
    {{ linkLabel }}
  </div>

  <div class="d-inline-block link-icon"
       @click.stop.prevent="copyLink()">
    <font-awesome-icon icon="copy"/>
  </div>
  <div v-if="downloadLink" class="ml-2 d-inline-block link-icon"
       @click.stop.prevent="copyDownloadLink()">
    <font-awesome-icon icon="download"/>
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
    cssClass: {
      type: String,
      default: ''
    },
    label: {
      type: String,
      default: ''
    },
    link: {
      type: String,
      default: ''
    },
    downloadLink: {
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
      const container = vm.$refs.container
      vm.$copyText( vm.link, container)
      console.log('CopyLink :: link = ' + vm.link)
      vm.$toaster.info(vm.$t('messages.link_copied_to_clipboard'))
    },
    copyDownloadLink () {
      const vm = this
      const container = vm.$refs.container
      vm.$copyText( vm.downloadLink, container)
      console.log('CopyLink :: download link = ' + vm.downloadLink)
      vm.$toaster.info(vm.$t('messages.download_link_copied_to_clipboard'))
    },
    gotoLink (link) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'onLinkClicked',
        link: link
      })
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

.link-icon {
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