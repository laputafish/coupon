<template>
  <div class="fluid-container p-2">
    <div class="d-flex flex-row justify-content-end pb-1">
      <div class="btn-toolbar"></div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <div slot="header"
             class="list-group-item mb-1 p-2 d-flex flex-row justify-content-between">
          <input-obj-button-list
              @onCommand="onCommandHandler"></input-obj-button-list>
          <div class="d-flex flex-row justify-content-end mb-1">
            <!--<div class="d-flex flex-column d-inline-block mx-1">-->
                <!--<div class="text-center px-2 pb-2"-->
                     <!--style="width:120px;border-radius:0.5rem;"-->
                     <!--:style="{backgroundColor:record.form_configs.pageConfig.bgColor}">-->
                  <!--<label style="filter:invert(100%);">Background</label>-->
                  <!--<input :value="record.form_configs.pageConfig.bgColor"-->
                         <!--style="width:100%;" class="text-center"-->
                         <!--@input="$event=>updatePageConfigField('bgColor',$event.target.value)"/>-->
                <!--</div>-->
            <!--</div>-->
            <button class="btn btn-outline-primary min-width-100 ml-1 align-self-start no-wrap"
                    style="white-space: nowrap;"
                    @click="exportForm">
              <i class="fas fa-fw fa-download"></i>
              Export
            </button>


            <xls-file-upload
                inputId="uploadQuestions"
                uploadUrl="/form_questions/upload"
                :postData="{id: record.id}"
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
          <!--<div style="border-left:lightgray solid 1px; width:80px;"-->
          <!--class="flex-grow-1 ml-2 pl-2 justify-content-start">-->
          <!--</div>-->
          <!--<div class="d-flex flex-column">-->
          <!--&lt;!&ndash;<div class="d-flex flex-row justify-content-end">&ndash;&gt;-->
          <!--&lt;!&ndash;<label class="p-0 m-0">Bg Color</label>&ndash;&gt;-->
          <!--&lt;!&ndash;<input :value="record.form_configs.pageConfig.bgColor"&ndash;&gt;-->
          <!--&lt;!&ndash;style="width:50px;"&ndash;&gt;-->
          <!--&lt;!&ndash;@input="$event=>updatePageConfigField('color',$event.target.value)"/>&ndash;&gt;-->
          <!--&lt;!&ndash;</div>&ndash;&gt;-->
          <!--</div>-->

        </div>
        <div class="row">
          <div class="col-sm-7" style="max-height: 640px; overflow-y: scroll;">
            <button class="btn w-100 mb-1"
                    :class="{'btn-primary':!selectedInputObj,'btn-light':selectedInputObj}"
                    @click="showPageProperty">
              Page Attributes
            </button>
            <draggable class="input-object-list list-group" tag="ul"
                       v-model="inputObjs"
                       v-bind="dragOptions"
                       :move="onMove"
                       @start="isDragging=true"
                       @end="isDragging=false">

              <form-input-obj
                  v-for="(inputObj, index) in inputObjs"
                  :key="index"
                  @onCommand="onCommandHandler"
                  :selected="selectedInputObj==inputObj"
                  :inputObj="inputObj"></form-input-obj>
            </draggable>
          </div>
          <div class="col-sm-5">
            <form-input-details
                v-if="selectedInputObj"
                :inputObj="selectedInputObj"
                @onCommand="onCommandHandler"></form-input-details>
            <div v-else>
              <div class="d-flex flex-column border">
                <div class="p-2 border bg-primary text-center">
                  Page Attributes
                </div>
                <div class="p-2">
                    <table class="table table-hover details-field-table">
                      <!-- bgColor -->
                      <fields-table-row label="Background Color" :value="pageConfig.bgColor"
                                        notes="(e.g. #FFEEDD)"
                                        fieldName="bgColor"
                                        scope="pageConfig"
                                        @onCommand="onCommandHandler"></fields-table-row>

                      <!-- color -->
                      <fields-table-row label="Text Color" :value="pageConfig.color"
                                        notes="(e.g. white)"
                                        fieldName="color"
                                        scope="pageConfig"
                                        @onCommand="onCommandHandler"></fields-table-row>

                      <!-- maxWidth -->
                      <fields-table-row label="Max. Width" :value="pageConfig.maxWidth"
                                        notes="(e.g. 640px)"
                                        fieldName="maxWidth"
                                        scope="pageConfig"
                                        @onCommand="onCommandHandler"></fields-table-row>

                      <!-- paddingTop -->
                      <fields-table-row label="Padding (Top)" :value="pageConfig.paddingTop"
                                        notes="(e.g. 60px)"
                                        fieldName="paddingTop"
                                        scope="pageConfig"
                                        @onCommand="onCommandHandler"></fields-table-row>

                      <!-- fontSize -->
                      <fields-table-row label="Font Size" :value="pageConfig.fontSize"
                                        notes="(e.g. 14px)"
                                        fieldName="fontSize"
                                        scope="pageConfig"
                                        @onCommand="onCommandHandler"></fields-table-row>

                      <!-- selectedChoiceColor -->
                      <fields-table-row label="Choice color if selected" :value="pageConfig.selectedChoiceColor"
                                        notes="(e.g. yellow)"
                                        fieldName="selectedChoiceColor"
                                        scope="pageConfig"
                                        @onCommand="onCommandHandler"></fields-table-row>

                      <!-- selectedChoiceTextColor -->
                      <fields-table-row label="Choice text Color if selected" :value="pageConfig.selectedChoiceTextColor"
                                        notes="(e.g. black)"
                                        fieldName="selectedChoiceTextColor"
                                        scope="pageConfig"
                                        @onCommand="onCommandHandler"></fields-table-row>

                      <!-- style -->
                      <fields-table-row label="Other styles" :value="pageConfig.style"
                                        notes=""
                                        fieldName="style"
                                        scope="pageConfig"
                                        @onCommand="onCommandHandler"></fields-table-row>

                    </table>
                </div>
              </div>
            </div>
          </div>
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
  import formInputObj from '@/views/comps/formInputObjs/FormInputObj'
  import formInputDetails from '@/views/comps/formInputObjs/FormInputDetails'
  import inputObjButtonList from '@/views/comps/formInputObjs/InputObjButtonList'

  import xlsFileUpload from '@/views/comps/XlsFileUpload'
  import fieldsTableRow from '@/views/comps/formInputObjs/FieldsTableRow'

  const message = [
    "vue.draggable",
    "draggable",
    "component",
    "for",
    "vue.js 2.0",
    "based",
    "on",
    "Sortablejs"
  ];
  export default {
    name: "FormBuilderPanel",
    model: {
      prop: 'inputObjs',
      event: 'input'
    },

    props: {
      record: {
        type: Object,
        default () {
          return null
        }
      }
    },
    components: {
      draggable,
      formInputObj,
      formInputDetails,
      inputObjButtonList,
      xlsFileUpload,
      fieldsTableRow
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
    methods: {
      showPageProperty () {
        const vm = this
        vm.selectedInputObj = null;

      },
      updatePageConfigField (fieldName, fieldValue) {
        console.log('FormBuilderPanel :: updatePageConfigField')
        this.$emit('onCommand', {
          command: 'updatePageConfigField',
          fieldName: fieldName,
          fieldValue: fieldValue
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
                console.log('FormBuilderPanel :: onCommandHandler :: updateFIeld: newPayload: ', newPayload)
                newPayload['command'] = newPayload['scope'] === 'pageConfig' ?
                  'updatePageConfigField' :
                  'updateInputObjField'
                newPayload['objIndex'] = objIndex
                break
              case 'appendBlankOption':
                newPayload['command'] = 'appendInputObjOption'
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
          for (var i = 0; i < vm.inputObjs.length; i++) {
            if (vm.inputObjs[i] === inputObj) {
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
        console.log('selectInputObj :: inputObj: ', inputObj)
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
        console.log('FormBuilderPanel :: onUploadingHandler')
        this.uploading = true
      },

      onUploadedHandler (result) {
        const vm = this
        vm.$emit('onCommand', {
          command: 'update'
        })
        console.log('onUploadedHandler :: result: ', result)
        vm.uploading = false
        vm.$emit('onCommand', {
          command: 'replaceInputObjs',
          value: result
        })
      }
    }
    ,
    computed: {
      inputObjs () {
        const vm = this
        var result = []
        if (vm.record && vm.record.form_configs) {
          result = vm.record.form_configs.inputObjs
        }
        return result
      }
      ,
      pageConfig () {
        const vm = this
        var result = {}
        if (vm.record && vm.record.form_configs && vm.record.form_configs.pageConfig) {
          result = vm.record.form_configs.pageConfig
        }
        return result
      }
      ,
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
    }
    ,
    watch: {
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
</style>