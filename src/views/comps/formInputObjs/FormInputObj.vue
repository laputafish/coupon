<template>
  <li class="list-group-item d-flex flex-row align-items-center"
      @click="selectInputObj"
    :class="{'bg-primary':selected,'bg-muted':!selected}">

    <input-obj-list-item-info
        :inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>

    <!--&lt;!&ndash; simple-text &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='simple-text'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; number &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='number'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; email &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='email'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; text &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='text'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; name &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='name'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; phone &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='phone'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; single-choice &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='single-choice'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; multiple-choice &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='multiple-choice'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; image &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='image'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

    <!--&lt;!&ndash; label &ndash;&gt;-->
    <!--<input-obj-list-item-info v-if="inputObj.inputType==='label'"-->
                   <!--:inputObj="inputObj" @onCommand="onCommandHandler"></input-obj-list-item-info>-->

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
import inputObjListItemInfo from './InputObjListItemInfo'

export default {
  components: {
    inputObjListItemInfo
  },
  props: {
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
    selectInputObj () {
      const vm = this
      console.log('FormInputObj :: selectInputObj')
      vm.$emit('onCommand', {
        command: 'selectInputObj',
        value: vm.inputObj
      })
    },
    onCommandHandler (payload) {

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
