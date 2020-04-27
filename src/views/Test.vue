<template>
  <div class="fluid-container p-2">
    <div class="d-flex flex-row justify-content-end pb-1">
      <div class="btn-toolbar">
        <button class="btn btn-outline-primary">Import</button>
        <button class="btn btn-outline-primary">Preview</button>
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <div slot="header"
             class="list-group-item mb-1 p-2">
          <input-obj-button-list
            @onCommand="onCommandHandler"></input-obj-button-list>
        </div>
        <div class="row">
          <div class="col-sm-7">
            <draggable class="input-object-list list-group" tag="ul"
                       v-model="inputObjs"
                       v-bind="dragOptions"
                       :move="onMove"
                       @start="isDragging=true"
                       @end="isDragging=false">

              <form-input-obj
                  v-for="inputObj in inputObjs"
                  :key="inputObj.id"
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
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import draggable from "vuedraggable"
  import formInputObj from '@/views/comps/formInputObjs/FormInputObj'
  import formInputDetails from '@/views/comps/formInputObjs/FormInputDetails'
  import inputObjButtonList from '@/views/comps/formInputObjs/InputObjButtonList'

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
    name: "hello",
    components: {
      draggable,
      formInputObj,
      formInputDetails,
      inputObjButtonList
    },
    data() {
      return {
        selectedInputObj: null,
        list: message.map((name, index) => {
          return { name, order: index + 1, fixed: false };
        }),
        list2: [],
        editable: true,
        isDragging: false,
        delayedDragging: false,
        inputObjs: []
      };
    },
    mounted () {
      const vm = this
      vm.inputObjs = [
        {
          id: 1,
          name: 'Simple Text',
          order: 1,
          fixed: false,
          inputType: 'simple-text',
          question: '簡單輸入',
          required: true,
          options: [],
          notes: 'simple text'
        },
        {
          id: 2,
          name: 'Name',
          order: 2,
          fixed: false,
          inputType: 'name',
          question: '名字',
          required: true,
          options: [],
          notes: 'simple text'
        },
        {
          id: 3,
          name: 'Phone',
          order: 3,
          fixed: false,
          inputType: 'phone',
          question: '電話號碼',
          required: true,
          options: [],
          notes: 'simple text'
        },
        {
          id: 4,
          name: 'Email',
          order: 4,
          fixed: false,
          inputType: 'email',
          question: 'Email',
          required: true,
          options: [],
          notes: 'simple text'
        },
        {
          id: 5,
          name: 'Address',
          order: 5,
          fixed: false,
          inputType: 'text',
          question: '地址 (我哋會安排以郵寄方式將3天試用裝寄比你)',
          required: true,
          options: [],
          notes: 'simple text'
        },
        {
          id: 6,
          name: 'Remark',
          order: 6,
          fixed: false,
          inputType: 'label',
          question: '* 試用裝將會於登記後一星期內以郵遞寄出',
          required: true,
          options: [],
          notes: 'simple text'
        },
        {
          id: 7,
          name: 'Do you know it?',
          order: 7,
          fixed: false,
          inputType: 'single-choice',
          question: '你認唔認識UL·OS呢個品牌？ *',
          required: true,
          options: ['認識','不認識'],
          notes: 'simple text'
        },
        {
          id: 8,
          name: 'Ever buy or use it?',
          order: 8,
          fixed: false,
          inputType: 'single-choice',
          question: '你有無曾經用過或買過UL·OS嘅產品？',
          required: true,
          options: ['曾經使用', '曾經購買', '未曾使用', '未曾購買'],
          notes: 'simple text'
        },
        {
          id: 9,
          name: 'Seen in shops?',
          order: 9,
          fixed: false,
          inputType: 'multiple-choice',
          question: '你有無喺以下店舖見過UL·OS嘅產品？（可多選） *',
          required: true,
          options: [
            '屈臣氏',
            '百佳',
            '惠康',
            '7-11',
            'Donki',
            'YATA',
            'AEON',
            'APITA',
            'HKTVmall',
            '完全無見過認識',
            '不認識'
          ]
        },
        {
          id: 10,
          name: 'Remark',
          order: 10,
          fixed: false,
          inputType: 'label',
          question: '* 每人只限登記乙次及換領乙份，換完即止。\n' +
          '\n' +
          '* 換領日期為2020年5月5日至5月11日，逾期無效。',
          required: true,
          options: [],
          notes: 'simple text'
        },
      ]
    },
    methods: {
      getSelectedObjIndex () {
        const vm = this
        var result = -1
        for (var i =0; i < vm.inputObjs.length; i++) {
          if (vm.inputObjs[i] === vm.selectedInputObj) {
            result = i
            break
          }
        }
        return result
      },
      getInputObjType (type) {
        const vm = this
        var result = null
        for (var i = 0; i < vm.inputObjTypes.length; i++) {
          var inputObjType = vm.inputObjTypes[i]
          if (inputObjType.inputType === type) {
            result = inputObjType
            break
          }
        }
        return result
      },
      getNewInputObj (type) {
        const vm = this
        var inputObjType = vm.getInputObjType(type)
        var result = {
          id: 0,
          name: inputObjType.label,
          fixed: false,
          inputType: type,
          question: '',
          required: true,
          options: [],
          notes: ''
        }
        return result
      },
      resetOptionIds () {
        const vm = this
      },
      onCommandHandler (payload) {
        const vm = this
        const command = payload.command

        switch (command) {
          case 'selectInputObj':
            vm.selectedInputObj = payload.value
            break
          case 'newInputObj':
            var inputObjType = payload.value
            var newObj = vm.getNewInputObj(inputObjType)
            var currentIndex = vm.getSelectedObjIndex()
            if (currentIndex === -1) {
              vm.inputObjs.push(newObj)
            } else {
              vm.inputObjs.splice(currentIndex, newObj, 0)
            }
            vm.resetOptionIds()
            break
          case 'updateField':
            vm.selectedInputObj[payload.fieldName] = payload.fieldValue
            break
          case 'removeOptionByIndex':
            var index = payload.index
            if (index !== -1 && index <= vm.selectedInputObj.options.length) {
              vm.selectedInputObj.options.splice(index, 1)
            }
            break
          case 'appendBlankOption':
            vm.selectedInputObj.options.push('')
            break
          case 'updateOptionByIndex':
            var index = payload.index
            var newOptionList = JSON.parse(JSON.stringify(vm.selectedInputObj.options))
            if (index !== -1 && index <= newOptionList.length) {
              newOptionList[index] = payload.fieldValue
            }
            vm.selectedInputObj.options = newOptionList
        }
        console.log('Test :: onCommandHandler :: payload: ', payload)
      },
      selectInputObj (inputObj) {
        const vm = this
        console.log('selectInputObj :: inputObj: ', inputObj)
        vm.selectedInputObj = inputObj
      },
      onMove({ relatedContext, draggedContext }) {
        const relatedElement = relatedContext.element;
        const draggedElement = draggedContext.element;
        return (
          (!relatedElement || !relatedElement.fixed) && !draggedElement.fixed
        );
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
      listString() {
        return JSON.stringify(this.list, null, 2);
      },
      list2String() {
        return JSON.stringify(this.list2, null, 2);
      },
      inputObjTypes () {
        return this.$store.getters.inputObjTypes
      }
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
    }
  };
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
</style>