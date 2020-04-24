<template>
<div class="d-flex flex-row w-100">
  <div class="flex-grow-0 pr-1">
    <slot name="leftPanel"></slot>
  </div>
  <div class="flex-grow-1 d-flex flex-column bg-muted p-1">
    <div>
      <div class="d-flex flex-row align-items-center">
        <div class="pr-2">Name</div>
        <div class="flex-grow-1">
          <input class="form-control"
                 :value="customTemplate.name"
                 @input="$event=>updateTemplateName($event.target.value)"/>
        </div>
      </div>
    </div>
    <html-editor
        :id="id"
      :content="customTemplate.content"
        @input="value=>updateTemplateContent(value)">
    </html-editor>
  </div>
  <div class="flex-grow-0 p-2">
    <slot name="sidePanel"></slot>
  </div>
</div>
</template>

<script>
import htmlEditor from './HtmlEditor'

export default {
  components: {htmlEditor},
  props: {
    id: {
      type: String,
      default: 'customTemplate'
    },
    customTemplate: {
      type: Object,
      default () {
        return {
          id: 0,
          name: '',
          content: '',
          system: false
        }
      }
    }
  },
  methods: {
    updateTemplateName (value) {
      const vm = this
      vm.$emit('onCommand', {
        'command': 'updateTemplateName',
        'id': vm.customTemplate.id,
        'value': value
      })
    },
    updateTemplateContent (value) {
      const vm = this
      vm.$emit('onCommand', {
        'command': 'updateTemplateContent',
        'id': vm.customTemplate.id,
        'value': value
      })
    }
  }
}
</script>