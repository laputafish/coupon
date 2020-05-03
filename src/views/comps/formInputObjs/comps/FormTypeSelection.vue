<template>
  <div class="form-type-selection btn-group mb-2">
    <button type="button"
            class="btn py-1 px-2 no-wrap form-type-button"
            v-for="option in optionsWithAddButton"
            :key="option.name"
            @mouseleave="showMenu=''"
            @click="selectOption(option)"
            :class="{'btn-primary':option===value, 'btn-light':option!==value, 'min-width-100':option.name!=='+'}">
        <div class="d-inline-block">{{ option.name }}</div>
        <div v-if="option.key!=='question' && option.name!=='+'"
             @click="showMenu=option.key"
             class="other-actions d-inline-block ml-2 px-1 border-1">
            ...
            <div v-if="showMenu===option.key"
                 style="position:absolute;top:100%;left:0;display:block;"
                 class="dropdown-menu" aria-labelledby="dropdownMenuButton">
              <a class="dropdown-item" href="#" @click="renameOption(option)">Rename</a>
              <a class="dropdown-item" href="#" @click="deleteOption(option)">Remove</a>
          </div>
      </div>
    </button>
  </div>
</template>

<script>
import dialogMixin from '@/mixins/DialogMixin'

export default {
  mixins: [dialogMixin],
  data () {
    return {
      showMenu: ''
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  computed: {
    optionsWithAddButton () {
      const vm = this
      var result = []
      for (var i = 0; i < vm.options.length; i++) {
        result.push(vm.options[i])
      }
      result.push({
        name: '+',
        key: 'ADD',
        formConfigs: null
      })
      return result
    }
  },
  props: {
    value: {
      type: Object,
      default: null
    },
    options: {
      type: Array,
      default () {
        return []
      }
    }
  },
  methods: {
    renameOption (option) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'renameFormType',
        formKey: option.key
      })
    },
    deleteOption (option) {
      const vm = this
      vm.confirm(() => {
        vm.$emit('onCommand', {
          command: 'removeFormType',
          formKey: option.key
        })
      })
    },
    selectOption (value) {
      const vm = this
      vm.$emit('input', value)
    }
  }
}
</script>

<style>
  .form-type-selection button {
    /*color: darkgray;*/
    min-width: 50px;
    /*width: 50px;*/
  }
  .form-type-selection button.selected {
    background-color: white;
    color: black;
  }
  .form-type-button .other-actions:hover {
    border-color: darkgray;
  }
  .form-type-button .other-actions {
    border: 1px solid transparent;
  }
</style>
