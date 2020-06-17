import * as types from './inputObjTypes_types'

const state = {
  inputObjsInfo: null,

  DEFAULT_PAGE_CONFIGS: {
    'name': '',
    'inputType': 'system-page',
    'question': '',
    'required': true,
    'note1': '',
    'note2': '',
    'options': [
      'background-color:white;' +
      'color:black;' +
      'font-size:14px;' +
      'max-width:640px;' +
      'padding-top:60px;'
    ]
  },
  inputObjTypes: [
    {icon: 'fas fa-home', newIcon: 'home', text: '', label: 'Page', type: 'system-page', isInput: true, fixed: true},
    {icon: 'fas fa-image', newIcon: 'image', text: '', label: 'Image', type: 'output-image', isInput: false},
    {icon: '', newIcon: '', text: 'ABC', label: 'Remark', type: 'output-remark', isInput: false},
    {icon: 'fas fa-bolt', newIcon: 'bolt', text: '', label: 'Submit Btn', type: 'output-submit', isInput: false},

    {icon: 'fas fa-i-cursor', newIcon: 'i-cursor', text: '', label: '1-line Text',
      type: 'simple-text', isInput: true, default: {caption: '備註', question: '備註'}},

    {icon: '', newIcon: '', text: '123', label: 'Number', type: 'number', isInput: true},

    {icon: 'fas fa-envelope', newIcon: 'envelope', text: '', label: 'Email',
      type: 'email', isInput: true, default: {caption: '電郵', question: '電郵地址'}},

    {icon: 'fas fa-align-justify', newIcon: 'align-justify', text: '', label: 'n-line Text', type: 'text',
      isInput: true, default: {caption: '備註多行', question: '備註 (多行)'}},

    {icon: 'fas fa-user', newIcon: 'user', text: '', label: 'Name',
      type: 'name', isInput: true, default: {caption: '名字,姓氏', question: '姓名', note1: '名字', note2: '姓氏'}},

    {icon: 'fas fa-venus-mars', newIcon: 'venus-mars', text: '', label: 'Gender', type: 'gender',
      isInput: true, default: {caption: '性別', question: '性別', options: ['男', '女']}},

    {icon: 'fas fa-phone', newIcon: 'phone', text: '', label: 'Phone', type: 'phone',
      isInput: true, default: {caption: '手機號碼', question: '手機號碼'}},


    {icon: 'fas fa-check-square', newIcon: 'check-square', text: '', label: 'Choice', type: 'single-choice',
      isInput: true, default: {caption: '選擇項目', question: '選擇項目'}},

    {icon: 'fas fa-tasks', newIcon: 'tasks', text: '', label: 'Multi-Choice', type: 'multiple-choice',
      isInput: true, default: {caption: '多選項目', question: '多選項目'}}
  ],
  attributeInfos: {
    width: {caption:'Width', styleName:'width', optionGroup:'elementGroup'},
    bgColor: {caption: 'Background Color', styleName:'background-color', optionGroup: 'elementGroup'},
    maxWidth: {caption:'Max. Width', styleName:'max-width', optionGroup:'elementGroup'},
    height: {caption: 'Height', styleName:'height', optionGroup: 'elementGroup'},
    alignment: {caption: 'Alignment', styleName: 'text-align', optionGroup: 'containerGroup'},
    pageFontSize: {caption: 'Font Size', styleName: 'font-size', optionGroup: 'elementGroup'},
    fontSize: {caption: 'Font Size', styleName: 'font-size', optionGroup: 'containerGroup'},
    textColor: {caption: 'Text Color', styleName: 'color', optionGroup: 'elementGroup'},
    paddingTop: {caption: 'Padding (Top)', styleName: 'padding-top', optionGroup: 'elementGroup'},
    paddingBottom: {caption: 'Padding (Bottom)', styleName: 'padding-bottom', optionGroup: 'elementGroup'},
    paddingLeft: {caption: 'Padding (Left)', styleName: 'padding-left', optionGroup: 'elementGroup'},
    paddingRight: {caption: 'Padding (Right)', styleName: 'padding-right', optionGroup: 'elementGroup'},
    color: {caption: 'Color', styleName: 'background-color', optionGroup: 'elementGroup'},
    selectedChoiceColor: {caption: 'Selected Choice Color', styleName: 'selected-choice-color', optionGroup: 'elementGroup'},
    selectedChoiceTextColor: {caption: 'Selected Choice Text Color', styleName: 'selected-choice-text-color', optionGroup: 'elementGroup'},
    inputRegionMaxWidth: {caption: 'Input Region Max Width', styleName: 'input-region-max-width', optionGroup: 'elementGroup'},

    containerPaddingTop: {caption: 'Padding (Top)', styleName: 'padding-top', optionGroup: 'containerGroup'},
    containerPaddingBottom: {caption: 'Padding (Bottom)', styleName: 'padding-bottom', optionGroup: 'containerGroup'},
    containerPaddingLeft: {caption: 'Padding (Left)', styleName: 'padding-left', optionGroup: 'containerGroup'},
    containerPaddingRight: {caption: 'Padding (Right)', styleName: 'padding-right', optionGroup: 'containerGroup'},
    containerBackgroundColor: {caption: 'Background Color', styleName: 'background-color', optionGroup: 'containerGroup'}
  },
  objAttributeGroups: {
    'system-page': [
      {
        caption: '',
        attributeKeys: [
          'maxWidth',
          'bgColor',
          'pageFontSize',
          'textColor',
          'paddingTop',
          'selectedChoiceColor',
          'selectedChoiceTextColor',
          'inputRegionMaxWidth'
        ]
      }
    ],
    'output-image': [
      {
        caption: 'Attributes',
        attributeKeys: [
          'width',
          'height',
          'alignment'
        ]
      },
      {
        caption: 'Container Attributes',
        attributeKeys: [
          'containerPaddingTop',
          'containerPaddingBottom',
          'containerPaddingLeft',
          'containerPaddingRight',
          'containerBackgroundColor'
        ]
      }
    ],
    'output-remark': [
      {
        caption: 'Attributes',
        attributeKeys: [
          'width',
          'height',
          'alignment',
          'fontSize',
          'textColor'
        ]
      },
      {
        caption: 'Container Attributes',
        attributeKeys: [
          'containerPaddingTop',
          'containerPaddingBottom',
          'containerPaddingLeft',
          'containerPaddingRight',
          'containerBackgroundColor'
        ]
      }
    ],
    'output-submit': [
      {
        caption: 'Attributes',
        attributeKeys: [
          'width',
          'height',
          'alignment',
          'fontSize',
          'textColor',
          'paddingTop',
          'paddingBottom',
          'paddingLeft',
          'paddingRight',
          'color'
        ]
      },
      {
        caption: 'Container Attributes',
        attributeKeys: [
          'containerPaddingTop',
          'containerPaddingBottom',
          'containerPaddingLeft',
          'containerPaddingRight',
          'containerBackgroundColor'
        ]
      }
    ]
  },
  inputObjsInfoLoaded: false
}

const getters = {
  DEFAULT_PAGE_CONFIGS: (state) => {
    return state.inputObjsInfo ? state.inputObjsInfo.defaultPageConfigs : null
  },
  DEFAULT_FORM_CONFIGS: (state) => {
    if (state.inputObjsInfo) {
      return {
        'inputObjs': [
          state.inputObjsInfo.defaultPageConfigs
        ]
      }
    } else {
      return null
    }
  },
  inputObjTypes: (state) => {
    return state.inputObjsInfo ? state.inputObjsInfo.inputObjTypes : []
  },
  attributeInfos: (state) => {
    return state.inputObjsInfo ? state.inputObjsInfo.attributeInfos : []
  },
  objAttributeGroups: (state) => {
    return state.inputObjsInfo ? state.inputObjsInfo.objAttributeGroups : []
  },
  iconList: (state) => {
    return state.inputObjsInfo ? state.iconList : []
  },
  inputObjsInfoLoaded: (state) => {
    return state.inputObjsInfoLoaded
  }
}

const getters2 = {
  DEFAULT_PAGE_CONFIGS: (state) => state.DEFAULT_PAGE_CONFIGS,
  DEFAULT_FORM_CONFIGS: (state) => {
    return {
      'inputObjs': [
        state.DEFAULT_PAGE_CONFIGS
      ]
    }
  },
  inputObjTypes: (state) => {
    return state.inputObjTypes
  },
  attributeInfos: (state) => {
    return state.attributeInfos
  },
  objAttributeGroups: (state) => {
    return state.objAttributeGroups
  },
  iconList: (state) => {
    var result = []
    for (var i = 0; i < state.inputObjTypes.length; i++) {
      var buttonObj = state.inputObjTypes[i]
      result[buttonObj.type] = {
        icon: buttonObj.icon,
        text: buttonObj.text
      }
    }
    return result
  },
  inputObjsInfoLoaded: (state) => {
    return state.inputObjsInfoLoaded
  }
}
// console.log(getters2)

const mutations = {
  setInputObjsInfo (state, payload)  {
    state.inputObjsInfo = payload
    state.inputObjsInfoLoaded = true
  }
}

const actions = {
  [types.FETCH_INPUT_OBJS_INFO] ({commit, dispatch}) {
    return new Promise((resolve, reject) => {
      const data = {
        urlCommand: '/input_objs_info',
      }
      dispatch('AUTH_GET', data).then(
        response => {
          // console.log('FETCH_INPUT_OBJS_INFO :: response: ', response)
          commit('setInputObjsInfo', response)
          resolve(response)
        },
        error => {
          reject(error)
        }
      )
    })
  }
}

export default {
state,
getters,
getters2,
mutations,
actions
}
