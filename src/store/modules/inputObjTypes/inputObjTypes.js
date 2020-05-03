import Vue from 'vue'

const state = {
  inputObjTypes: [
    {icon: 'fas fa-home', newIcon: 'home', text: '', label: 'Page', type: 'system-page', isInput: true, fixed: true},
    {icon: 'fas fa-i-cursor', newIcon: 'i-cursor', text: '', label: '1-line Text', type: 'simple-text', isInput: true},
    {icon: '', newIcon: '', text: '123', label: 'Number', type: 'number', isInput: true},
    {icon: 'fas fa-envelope', newIcon: 'envelope', text: '', label: 'Email', type: 'email', isInput: true},
    {icon: 'fas fa-align-justify', newIcon: 'align-justify', text: '', label: 'n-line Text', type: 'text', isInput: true},
    {icon: 'fas fa-user', newIcon: 'user', text: '', label: 'Name', type: 'name', isInput: true},
    {icon: 'fas fa-phone', newIcon: 'phone', text: '', label: 'Phone', type: 'phone', isInput: true},
    {icon: 'fas fa-check-square', newIcon: 'check-square', text: '', label: 'Choice', type: 'single-choice', isInput: true},
    {icon: 'fas fa-tasks', newIcon: 'tasks', text: '', label: 'Multi-Choice', type: 'multiple-choice', isInput: true},
    {icon: 'fas fa-image', newIcon: 'image', text: '', label: 'Image', type: 'output-image', isInput: false},
    {icon: '', newIcon: '', text: 'ABC', label: 'Remark', type: 'output-remark', isInput: false},
    {icon: 'fas fa-bolt', newIcon: 'bolt', text: '', label: 'Submit Btn', type: 'output-submit', isInput: false}
  ],
  attributeInfos: {
    width: {caption:'Width', styleName:'width', optionGroup:'option1'},
    bgColor: {caption: 'Background Color', styleName:'background-color', optionGroup: 'option1'},
    maxWidth: {caption:'Max. Width', styleName:'max-width', optionGroup:'option1'},
    height: {caption: 'Height', styleName:'height', optionGroup: 'option1'},
    alignment: {caption: 'Alignment', styleName: 'text-align', optionGroup: 'option2'},
    fontSize: {caption: 'Font Size', styleName: 'font-size', optionGroup: 'option2'},
    textColor: {caption: 'Text Color', styleName: 'color', optionGroup: 'option1'},
    paddingTop: {caption: 'Padding (Top)', styleName: 'padding-top', optionGroup: 'option1'},
    paddingBottom: {caption: 'Padding (Bottom)', styleName: 'padding-bottom', optionGroup: 'option1'},
    paddingLeft: {caption: 'Padding (Left)', styleName: 'padding-left', optionGroup: 'option1'},
    paddingRight: {caption: 'Padding (Right)', styleName: 'padding-right', optionGroup: 'option1'},
    color: {caption: 'Color', styleName: 'background-color', optionGroup: 'option1'},
    selectedChoiceColor: {caption: 'Selected Choice Color', styleName: 'selected-choice-color', optionGroup: 'option1'},
    selectedChoiceTextColor: {caption: 'Selected Choice Text Color', styleName: 'selected-choice-text-color', optionGroup: 'option1'},

    containerPaddingTop: {caption: 'Padding (Top)', styleName: 'padding-top', optionGroup: 'option2'},
    containerPaddingBottom: {caption: 'Padding (Bottom)', styleName: 'padding-bottom', optionGroup: 'option2'},
    containerPaddingLeft: {caption: 'Padding (Left)', styleName: 'padding-left', optionGroup: 'option2'},
    containerPaddingRight: {caption: 'Padding (Right)', styleName: 'padding-right', optionGroup: 'option2'},
    containerBackgroundColor: {caption: 'Background Color', styleName: 'background-color', optionGroup: 'option2'}
  },
  userAttributes: {
    'system-page': [
      {
        caption: '',
        attributeKeys: [
          'maxWidth',
          'bgColor',
          'fontSize',
          'textColor',
          'paddingTop',
          'selectedChoiceColor',
          'selectedChoiceTextColor'
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
  }
}

const getters = {
  DEFAULT_FORM_CONFIGS: () => {
    return {
      'inputObjs': [
        {
          'name': '',
          'inputType': 'system-page',
          'question': '',
          'required': true,
          'options': [
            'background-color:white;' +
            'color:black;' +
            'font-size:14px;' +
            'max-width:640px;' +
            'padding-top:60px;'
          ]
        }
      ]
    }
  },
  inputObjTypes: (state) => {
    return state.inputObjTypes
  },
  attributeInfos: (state) => {
    return state.attributeInfos
  },
  userAttributes: (state) => {
    return state.userAttributes
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
  }
}

const mutations = {
}

const actions = {

}


export default {
state,
getters,
mutations,
actions
}
