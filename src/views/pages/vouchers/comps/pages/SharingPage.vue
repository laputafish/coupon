<template>
 <div class="row">
    <sharing-context-box
        class="col-sm-6"
        title="Voucher Sharing Link"
        :record="record"
        sharingType="coupons"
        sharingTitleField="sharing_title"
        sharingDescriptionField="sharing_description"
        sharingImageIdField="sharing_image_id"
        @onCommand="onCommandHandler">
    </sharing-context-box>
    <sharing-context-box
        class="col-sm-6"
        title="Form Sharing Link"
        :record="record"
        sharingType="forms"
        sharingTitleField="form_sharing_title"
        sharingDescriptionField="form_sharing_description"
        sharingImageIdField="form_sharing_image_id"
        @onCommand="onCommandHandler">
    </sharing-context-box>
  </div>
</template>

<script>
import sharingContextBox from './comps/SharingContextBox'

export default {
  components: {
    sharingContextBox
  },
  props: {
    record: {
      type: Object,
      default: null
    }
  },
  methods: {
    onCommandHandler (payload) {
      const vm = this
      vm.$emit('onCommand', payload)
    }
  }
}
</script>