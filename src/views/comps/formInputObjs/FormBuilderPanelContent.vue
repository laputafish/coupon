<template>
<div class="row">
  <div class="col-md-12">
    <div slot="header"
         class="list-group-item mb-1 p-2 d-flex flex-row justify-content-between">
      <input-obj-button-list
          :includeInputObjs="isQuestionForm"
          @onCommand="onCommandHandler"></input-obj-button-list>
      <div class="d-flex flex-row justify-content-end mb-1">
        <button class="btn btn-danger min-width-100 ml-1 align-self-start no-wrap"
                style="white-space: nowrap;"
                @click="clearForm">
          <i class="fas fa-fw fa-times"></i>
          Clear Form
        </button>
        <button class="btn btn-outline-primary min-width-100 ml-1 align-self-start no-wrap"
                style="white-space: nowrap;"
                @click="exportForm">
          <i class="fas fa-fw fa-download"></i>
          Export
        </button>
        <xls-file-upload
            inputId="uploadQuestions"
            uploadUrl="/form_questions/upload"
            class="align-self-start ml-1"
            @onUploading="onUploadingHandler"
            @onUploaded="onUploadedHandler"></xls-file-upload>
        <button class="btn btn-outline-primary min-width-100 ml-1 align-self-start no-wrap"
                style="white-space: nowrap;"
                @click="previewForm">
          <i class="fas fa-fw fa-mask"></i>
          Preview
        </button>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-7" style="max-height: 640px; overflow-y: scroll;">
        <button class="btn w-100 mb-1 page-attributes-button"
                :class="{'btn-primary':selectedInputObj===pageInputObj,'btn-light':selectedInputObj!==pageInputObj}"
                @click="selectedInputObj=pageInputObj">
          Page Attributes
        </button>
        <draggable class="input-object-list list-group" tag="ul"
                   :value="inputObjs"
                   @input="value=>updateInputObjOrder(value)"
                   v-bind="dragOptions"
                   :move="onMove"
                   @start="isDragging=true"
                   @end="isDragging=false">

          <pane-list-item
              v-for="(inputObj, index) in inputObjs"
              :key="index"
              @onCommand="onCommandHandler"
              :selected="selectedInputObj==inputObj"
              :inputObj="inputObj"></pane-list-item>
        </draggable>
      </div>
      <div class="col-sm-5">
        <pane-details
            v-if="selectedInputObj"
            :inputObj="selectedInputObj"
            @onCommand="onCommandHandler"></pane-details>
      </div>
    </div>
  </div>
  <vue-loading
      :active.sync="uploading"
      :can-cancel="true"></vue-loading>
</div>
</template>

<script>
  import draggable from "vuedraggable"
  import paneListItem from '@/views/comps/formInputObjs/PaneListItem'
  import paneDetails from '@/views/comps/formInputObjs/PaneDetails'
  import inputObjButtonList from '@/views/comps/formInputObjs/InputObjButtonList'
  import dialogMixin from '@/mixins/DialogMixin'

  import xlsFileUpload from '@/views/comps/XlsFileUpload'

  const message = [
    "vue.draggable",
    "draggable",
    "component",
    "for",
    "vue.js 2.0",
    "based",
    "on",
    "Sortablejs"
  ]

  export default {
    mixins: [dialogMixin],
    name: "FormBuilderPanel",
    props: {
      formType: {
        type: Object,
        default: null
      },
      // formConfigs: {
      //   type: Object,
      //   default: null
      // },
      // key: {
      //   type: String,
      //   default: ''
      // }
      // record: {
      //   type: Object,
      //   default () {
      //     return null
      //   }
      // }
    },
    computed: {
      formConfigs () {
        const vm = this
        return vm.formType.formConfigs
      },
      isQuestionForm () {
        const vm = this
        return vm.formType.key === 'question'
      },
      pageInputObj () {
        const vm = this
        var result = {}
        if (vm.formConfigs) {
          result = vm.formConfigs.inputObjs.find(item => item.inputType === 'system-page')
        }
        return result
      },
      inputObjs () {
        const vm = this
        var result = []
        if (vm.formConfigs) {
          result = vm.formConfigs.inputObjs.filter(item => item.inputType !== 'system-page')
        }
        return result
      },
      // pageConfig () {
      //   const vm = this
      //   var result = {}
      //   if (vm.record && vm.record.form_configs && vm.record.form_configs.pageConfig) {
      //     result = vm.record.form_configs.pageConfig
      //   }
      //   return result
      //, }

      dragOptions () {
        return {
          animation: 0,
          group: "description",
          disabled: !this.editable,
          ghostClass: "ghost"
        };
      }
      ,
      listString () {
        return JSON.stringify(this.list, null, 2);
      }
      ,
      list2String () {
        return JSON.stringify(this.list2, null, 2);
      }
      ,
      inputObjTypes () {
        return this.$store.getters.inputObjTypes
      }
    },
    components: {
      draggable,
      paneListItem,
      paneDetails,
      inputObjButtonList,
      xlsFileUpload
    },
    data () {
      return {
        uploadRoute: '/form_input_objs/upload',
        uploading: false,
        selectedInputObj: null,
        list: message.map((name, index) => {
          return {name, order: index + 1, fixed: false};
        }),
        list2: [],
        editable: true,
        isDragging: false,
        delayedDragging: false
      };
    },
    mounted () {
      const vm = this
      vm.selectedInputObj = vm.pageInputObj
    },
    methods: {
      updateInputObjOrder (reorderedInputObjs) {
        const vm = this
        console.log('updateInputObjOrder  :: reorderedInputObjs: ', reorderedInputObjs)
        vm.$emit('onCommand', {
          command: 'replaceInputObjs',
          value: reorderedInputObjs
        })
      },
      // selectFormType (value) {
      //   const vm = this
      //   vm.selectedFormType = value
      // },
      // showPageProperty () {
      //   const vm = this
      //   vm.selectedInputObj = null;
      //
      // },
      updatePageConfigField (fieldName, fieldValue) {
        // console.log('FormBuilderPanel :: updatePageConfigField')
        this.$emit('onCommand', {
          command: 'updatePageConfigField',
          fieldName: fieldName,
          fieldValue: fieldValue
        })
      },
      clearForm () {
        const vm = this
        vm.confirmDelete(() => {
          this.$emit('onCommand', {
            command: 'clearForm'
          })
          this.selectedInputObj = this.pageInputObj
        })
      },
      exportForm () {
        this.$emit('onCommand', {
          command: 'exportFormConfigs'
        })
      },
      previewForm () {
        this.$emit('onCommand', {
          command: 'previewQuestionForm'
        })
      },
      onCommandHandler (payload) {
        console.log('FormBuilderPanelContent :: onCommandHandler : payload: ', payload)
        const vm = this
        const command = payload.command
        switch (command) {
          case 'selectInputObj':
            vm.selectedInputObj = payload.value
            break
          default:
            var objIndex = vm.getSelectedInputObjIndex()
            var newPayload = payload
            switch (command) {
              case 'newInputObj':
                newPayload['objIndex'] = objIndex
                break
              case 'deleteInputObj':
                objIndex = vm.getInputObjIndex(payload.inputObj)
                newPayload['objIndex'] = objIndex
                break
              case 'updateField':
                // console.log('FormBuilderPanel :: onCommandHandler :: updateFIeld: newPayload: ', newPayload)
                newPayload['command'] = newPayload['scope'] === 'pageConfig' ?
                  'updatePageConfigField' :
                  'updateInputObjField'
                newPayload['objIndex'] = objIndex
                break
              case 'appendBlankOption':
                newPayload['command'] = 'appendInputObjOption'
                newPayload['objIndex'] = objIndex
                break
              case 'updateOptions':
                newPayload['command'] = 'updateInputObjOptions'
                newPayload['objIndex'] = objIndex
                break
              case 'updateOptionByIndex':
                newPayload['command'] = 'updateInputObjOptionByIndex'
                newPayload['objIndex'] = objIndex
                break
              case 'removeOptionByIndex':
                newPayload['command'] = 'removeInputObjOptionByIndex'
                newPayload['objIndex'] = objIndex
                break
            }
            vm.$emit('onCommand', newPayload)
        }
      },

      getInputObjIndex (inputObj) {
        const vm = this
        var result = -1
        if (inputObj) {
          for (var i = 0; i < vm.formConfigs.inputObjs.length; i++) {
            if (vm.formConfigs.inputObjs[i] === inputObj) {
              result = i
              break
            }
          }
        }
        return result
      },

      getSelectedInputObjIndex () {
        const vm = this
        return vm.getInputObjIndex(vm.selectedInputObj)
      },

      selectInputObj (inputObj) {
        const vm = this
        // console.log('selectInputObj :: inputObj: ', inputObj)
        vm.selectedInputObj = inputObj
      },
      onMove ({relatedContext, draggedContext}) {
        const relatedElement = relatedContext.element;
        const draggedElement = draggedContext.element;
        return (
          (!relatedElement || !relatedElement.fixed) && !draggedElement.fixed
        );
      },

      onUploadingHandler () {
        // console.log('FormBuilderPanel :: onUploadingHandler')
        this.uploading = true
      },

      onUploadedHandler (result) {
        const vm = this
        vm.$emit('onCommand', {
          command: 'update'
        })
        vm.selectedInputObj = null
        // console.log('onUploadedHandler :: result: ', result)
        vm.uploading = false
        vm.$emit('onCommand', {
          command: 'replaceInputObjs',
          value: result
        })
      }
    }
    ,
    watch: {
      'formType.key': function () {
        const vm = this
        var found = false
        for (var i = 0; i < vm.formConfigs.inputObjs.length; i++) {
          if (vm.formConfigs.inputObjs[i] === vm.selectedInputObj) {
            found = true
            break
          }
        }
        if (!found) {
          vm.selectedInputObj = vm.pageInputObj
        }
      },
      pageInputObj (newValue) {
        const vm = this
        if (vm.selectedInputObj === null) {
          vm.selectedInputObj = newValue
        }
      },
      isDragging (newValue) {
        if (newValue) {
          this.delayedDragging = true;
          return;
        }
        this.$nextTick(() => {
          this.delayedDragging = false;
        });
      }
    }
  }
  ;
</script>

<style>
  .flip-list-move {
    transition: transform 0.5s;
  }

  .no-move {
    transition: transform 0s;
  }

  .ghost {
    opacity: 0.5;
    background: #c8ebfb;
  }

  .list-group {
    min-height: 20px;
  }

  .list-group-item {
    cursor: move;
  }

  .list-group-item i {
    cursor: pointer;
  }

  .object-type-list button small {
    line-height: 1;
  }

  .object-type-list button {
    width: 80px;
    padding: 2px;
  }

  .input-object-list .list-group-item {
    padding: 0.25rem 0.5rem;
  }

  .page-property {
    border: 1px solid rgba(0, 0, 0, 0.125);
    padding: 0.25rem 0.5rem;
    border-radius: 0.25rem;
    cursor: pointer;
    margin-bottom: 2px;
  }
  .page-attributes-button.btn-light {
    background-color: rgba(0, 123, 255, .4);
  }
</style>