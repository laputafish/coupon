<template>
<b-tab class="bg-white py-2">
  <template v-slot:title>
    {{ title }}
  </template>
  <div class="container-fluid">
    <form-builder-panel :record="record"
                        @onCommand="onCommandHandler"></form-builder-panel>
  </div>
</b-tab>
</template>

<script>
import formBuilderPanel from '@/views/comps/formInputObjs/FormBuilderPanel'

export default {
  components: {
    formBuilderPanel
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    record: {
      type: Object,
      default: null
    }
  },
  methods: {
    onCommandHandler (payload) {
      this.$emit('onCommand', payload)
    }
  }
}
</script>