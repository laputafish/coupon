<template>
<div class="d-flex flex-row">
  <tinymce
      ref="templateEditor"
      class="flex-grow-1 bg-muted"
      @editorInit="onEditorInit()"
      style="min-height:480px;"
      id="templateEditor"
      :toolbar1="tinymceToolbar1"
      :other_options="tinymceOtherOptions"
      :options="tinymceOptions"
      :value="content"
      @input="value=>updateContent(value)"></tinymce>
  <div class="flex-grow-0 p-2 bg-muted ml-2">
    <slot name="sidePanel"></slot>
  </div>
</div>
</template>

<script>
import tinymce from 'vue-tinymce-editor'

export default {
  data () {
    return {
      tinymceToolbar1: [],
      tinymceOtherOptions: [],
      tinymceOptions: []
    }
  },
  props: {
    content: {
      type: String,
      default: ''
    }
  },
  methods: {
    onEditorInit () {

    },
    updateContent (value) {
      const vm = this
      vm.$emit('input', value)
    }
  }
}
</script>