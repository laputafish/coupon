<template>
<b-tab class="bg-white py-2">
  <template v-slot:title>
    {{ title }}
    <div class="badge badge-info">{{ templates.length }}</div>
  </template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <template-editor
            @onCommand="onCommandHandler"
            :value="templates[selectedIndex].content"
            @input="value=>updateContent(value)">
          <template v-slot:leftPanel>
            <ul>
              <li v-for="template in templates"
                  :key="template.id">
                {{template.name}}
              </li>
            </ul>
          </template>
          <template v-slot:sidePanel>
            <h1>Side Panel</h1>
          </template>
        </template-editor>
      </div>
    </div>
  </div>
</b-tab>
</template>

<script>
import templateEditor from './TemplateEditor'

export default {
  components: {
    templateEditor
  },
  data () {
    return {
      selectedIndex: 0
    }
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    templates: {
      type: Array,
      default () {
        return []
      }
    }
  },
  methods: {
    onCommandHandler (payload) {
      this.$emit('onCommand', payload)
    },
    updateName (value) {
      const vm = this
      this.$emit('onCommand', {
        command: 'updateTemplate',
        templateIndex: vm.selectedIndex,
        name: value
      })
    },
    updateContent (content) {
      const vm = this
      this.$emit('onCommand', {
        command: 'updateTemplate',
        templateIndex: vm.selectedIndex,
        content: content
      })
    }
  }
}
</script>