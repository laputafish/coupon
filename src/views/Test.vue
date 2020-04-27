<template>
  <form-builder-panel
    v-model="inputObjs"
    @onCommand="onCommandHandler"></form-builder-panel>
</template>

<script>
  import formBuilderPanel from '@/views/comps/formInputObjs/FormBuilderPanel'
  import formInputObjMixin from '@/mixins/FormInputObjMixin'

  export default {
    mixins: [formInputObjMixin],
    components: {
      formBuilderPanel
    },
    data () {
      return {
        record: {
          inputObjs: []
        }
      };
    },
    mounted () {
      const vm = this
      vm.record.inputObjs = [
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
          options: ['認識', '不認識'],
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
      onCommandHandler (payload) {

      }
    }
  }
</script>