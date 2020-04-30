<template>
  <li class="list-group-item d-flex flex-row align-items-center"
      @click="selectInputObj"
    :class="{'bg-primary':selected,'bg-muted':!selected}">

    <pane-list-item-info
        :inputObj="inputObj" @onCommand="onCommandHandler"></pane-list-item-info>

    <!-- Delete Button -->
    <div class="pl-3">
      <button class="btn btn-sm btn-danger btn-circle"
              @click="deleteObj(inputObj)">
        <i class="fas fa-times"></i>
      </button>
    </div>
  </li>
</template>

<script>
import paneListItemInfo from './PaneListItemInfo'

export default {
  components: {
    paneListItemInfo
  },
  props: {
    index: {
      type: Number,
      default: 0
    },
    inputObj: {
      type: Object,
      default: null
    },
    selected: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    // inputObjTypes () {
    //   return this.$store.getters.inputObjTypes
    // }
  },
  methods: {
    deleteObj () {
      const vm = this
      vm.$dialog.confirm(vm.$t('messages.areYouSure')).then(
        () => {
          vm.$emit('onCommand', {
            command: 'deleteInputObj',
            inputObj: vm.inputObj
          })
        }
      )
    },
    selectInputObj () {
      const vm = this
      console.log('FormInputObj :: selectInputObj')
      vm.$emit('onCommand', {
        command: 'selectInputObj',
        value: vm.inputObj
      })
    },
    onCommandHandler (payload) {
      alert('FormInputObj :: onCommandHandler :: unhandled')
    }
    // ,
    // inputObjTypeName (inputType) {
    //   const vm = this
    //   var result = '(Unknown)'
    //   for (var i = 0; i < vm.inputObjTypes.length; i++) {
    //     var obj = vm.inputObjTypes[i]
    //     if (obj.type === inputType) {
    //       result = obj.label
    //       break
    //     }
    //   }
    //   return result
    // }
  }
}
</script>
