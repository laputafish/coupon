<template>
<b-tab class="bg-white py-2">
  <template v-slot:title>
    {{ title }}
    <div class="badge badge-info">{{ templates.length }}</div>
  </template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12 d-flex flex-row align-items-stretch">
        <!--<div class="flex-grow-0">-->
          <!--<ul>-->
            <!--<li v-for="template in templates"-->
              <!--:key="template.id">-->
              <!--{{template.name}}-->
            <!--</li>-->
          <!--</ul>-->
        <!--</div>-->
        <template-editor
            id="customTemplateEditor"
            @onCommand="onCommandHandler"
            :customTemplate="templates[selectedIndex]"
            @input="value=>updateContent(value)">
          <template v-slot:leftPanel>
            <div class="text-right mb-1">
              <button type="button"
                      @click="addTemplate"
                      class="btn btn-sm btn-circle btn-primary">
                <i class="fas fa-plus"></i>
              </button>
            </div>
            <ul class="list-group template-list">
              <li v-for="template in templates"
                  class="list-group-item d-flex flex-row align-items-center pr-1"
                  :class="{'selected':template===templates[selectedIndex], 'system-template':template.system}"
                  :key="template.id">
                <div class="w-100 flex-grow-1 overflow-hidden-ellipsis">{{template.name}}</div>
                <button class="ml-1 btn btn-delete btn-circle btn-sm btn-danger" type="button"
                        @click="deleteTemplate(template)">
                  <i class="fas fa-times"></i>
                </button>
              </li>
            </ul>
          </template>
          <template v-slot:sidePanel>
            <h1>Side Panel</h1>
          </template>
        </template-editor>
        <!--<div class="flex-grow-0">-->
          <!--<h1>Side Panel</h1>-->
        <!--</div>-->
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
    addTemplate () {

    },
    deleteTemplate (template) {

    },
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

<style>
  .template-list li.selected:hover {
    background-color: #0069d9;
  }
  .template-list li.selected {
    background-color:#007bff;
    color: white;
  }
  .template-list li:hover {
    background-color: #e5e5e5;
  }
  .template-list li {
    background-color: white;
    padding: 0.25rem 0.5rem;
    cursor: pointer;
  }
  .template-list li.list-group-item {
    max-width: 160px;
  }
  .template-list li.list-group-item .overflow-hidden-ellipsis {
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow-x: hidden;
  }
  .template-list li.system-template .btn-delete {
    display: none;
  }
</style>