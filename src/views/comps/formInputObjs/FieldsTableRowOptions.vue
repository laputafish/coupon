<template>
  <tr>
    <td class="align-top line-height-1 pt-3 label-cell">
      <div>{{ label }}</div>
      <small class="field-notes" v-if="notes !== ''">{{ notes }}</small>
    </td>
    <td class="value-cell">
      <draggable class="input-option-list list-group" tag="ul"
                 :value="optionItems"
                 @input="newOptionItems=>updateItemOrder(newOptionItems)"
                 v-bind="dragOptions"
                 :move="onMove"
                 @start="isDragging=true"
                 @end="isDragging=false">
      <!--<draggable class="input-option-list list-group" tag="ul"-->
                 <!--v-model="optionItems"-->
                 <!--:value="optionItems"-->
                 <!--@input="value=>updateField(value)"-->
                 <!--v-bind="dragOptions"-->
                 <!--:move="onMove"-->
                 <!--@start="isDragging=true"-->
                 <!--@end="isDragging=false">-->
        <li v-for="optionItem in optionItems"
            :key="optionItem.id"
          class="input-option-item list-group-item px-2 py-1">
          <div class="d-flex flex-row align-items-center">
            <div class="ml-1 mr-3">
              <i class="fas fa-align-justify"></i>
            </div>
            <div class="flex-grow-1 pr-2">
              <input @mouseenter="editable=false"
                     @mouseleave="editable=true"
                     :value="optionItem.value"
                     class="w-100"
                @input="$event=>updateField(optionItem.id, $event.target.value)"></input>
            </div>
            <button type="button"
              @click="deleteOption(optionItem.id)">
              <i class="fas fa-times"></i>
            </button>
          </div>
        </li>
      </draggable>
      <!--<input :type="type"-->
             <!--:value="value"-->
             <!--class="form-control"-->
             <!--@input="$event=>{updateField(fieldName, $event.target.value)}"/>-->
      <div class="p-1">
        <button type="button"
                class="btn btn-primary btn-circle"
                @click="addOption">
          <i class="fas fa-plus"></i>
        </button>
      </div>
    </td>
  </tr>
</template>

<script>
import draggable from "vuedraggable"

export default {
  data () {
    return {
      editable: true,
      isDragging: false,
      delayedDragging: false
      // optionItems: [
      //   {
      //     id:1,
      //     name: 'item 1'
      //   },
      //   {
      //     id: 2,
      //     name: 'item 2'
      //   }
      // ]
    }
  },
  components: {
    draggable
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  watch: {
    isDragging(newValue) {
      if (newValue) {
        this.delayedDragging = true;
        return;
      }
      this.$nextTick(() => {
        this.delayedDragging = false;
      });
    }
  },
  computed: {
    dragOptions() {
      return {
        animation: 0,
        group: "description",
        disabled: !this.editable,
        ghostClass: "ghost"
      };
    },
    optionItems () {
      const vm = this
      var result = []
      for (var i = 0; i < vm.value.length; i++) {
        result.push({
          id: i + 1,
          value: vm.value[i]
        })
      }
      return result
    }
  },
  props: {
    label: {
      type: String,
      value: ''
    },
    notes: {
      type: String,
      value: ''
    },
    value: {
      type: Array,
      value () {
        return []
      }
    },
    type: {
      type: String,
      value: 'text'
    },
    fieldName: {
      type: String,
      value: ''
    }
  },
  methods: {
    addOption () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'appendBlankOption'
      })
    },
    updateField (itemId, fieldValue) {
      const vm = this
      var index = vm.getOptionIndex(itemId)
      this.$emit('onCommand', {
        command: 'updateOptionByIndex',
        index: index,
        fieldValue: fieldValue
      })
    },
    deleteOption (itemId) {
      const vm = this
      var index = vm.getOptionIndex(itemId)
      vm.$emit('onCommand', {
        command: 'removeOptionByIndex',
        index: index
      })
    },
    getOptionIndex (itemId) {
      const vm = this
      var index = -1
      for (var i = 0; i < vm.optionItems.length; i++) {
        if (vm.optionItems[i].id === itemId) {
          index = i
          break
        }
      }
      return index
    },
    onMove({ relatedContext, draggedContext }) {
      const relatedElement = relatedContext.element;
      const draggedElement = draggedContext.element;
      return (
        (!relatedElement || !relatedElement.fixed) && !draggedElement.fixed
      );
    },
    updateItemOrder (newOptionItems) {
      const vm = this
      var result = []
      for (var i = 0; i < newOptionItems.length; i++) {
        result.push(newOptionItems[i].value)
      }
      vm.$emit('onCommand', {
        command: 'updateField',
        fieldName: vm.fieldName,
        fieldValue: result
      })
    }
  }
}
</script>

<style>
  .field-notes {
    color: rgb(160,160,160);
  }
  .input-option-item {
    cursor: pointer;

  }
</style>