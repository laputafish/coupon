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

   <div class="col-sm-12 mt-4 px-5 d-flex flex-column">
     <h6>Reference</h6>
     <ul>
       <li>
         <a href="https://developers.facebook.com/tools/debug" target="_blank"
            class="useful-link">Facebook Sharing Debugger (Link Validator)</a>
       </li>
     </ul>
   </div>
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

<style>
  .useful-link:hover {
    color: red;
  }
</style>
