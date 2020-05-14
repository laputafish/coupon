<template>
  <div class="container-fluid">
    <title-row :record="record"
               :titleField="titleField"
               :loading="loading"
               :processingButtons="processingButtons"
               :buttons="['back', 'save']"
               @onCommand="onCommandHandler"></title-row>
    <div v-if="record" class="w-100 d-flex flex-row justify-content-between" style="margin-top:-20px;">
      <div style="color:rgba(0,0,0,.6);">{{ record ? '#' + record.id : '' }}</div>
      <div>
        <div class="p-0 m-0 d-inline mr-2" style="color:darkgray">{{ $t('general.created_at') }}</div>&nbsp;&nbsp;&nbsp;
        <div class="p-0 m-0 d-inline" style="color:rgba(0,0,0,.6);">{{ record ? record.created_at : '' }}</div>
      </div>
    </div>

    <div class="row mb-2" v-if="record">
      <!-- ********* -->
      <!-- Row #0 -->
      <!-- ********* -->
      <!--<data-input width="3" id="description" labelTag="vouchers.title"-->
      <!--v-model="record.description"></data-input>-->
      <!--<data-input width="3" id="notes" labelTag="vouchers.sub_title"-->
      <!--v-model="record.notes"></data-input>-->
      <div class="col-sm-6">
        <div class="form-group mb-1">
          <label for="description">{{ $t('vouchers.title') }}</label>
          <input class="form-control"
                 id="description"
                 name="description"
                 type="text"
                 v-model="record.description"/>
          <input class="form-control mt-1"
                 :placeholder="$t('vouchers.sub_title')"
                 id="notes"
                 name="notes"
                 type="text"
                 style="padding: 0.25rem 0.75rem;line-height: 1.2;height:1.4rem;"
                 v-model="record.notes"/>
        </div>
      </div>

      <!--<data-input width="4" id="description" labelTag="general.description" v-model="record.description"></data-input>-->
      <data-input-date width="2" id="activate_date" labelTag="vouchers.activation_date"
                       v-model="record.activation_date"></data-input-date>
      <data-input-date width="2" id="expiry_date" labelTag="vouchers.expiry_date"
                       v-model="record.expiry_date"></data-input-date>
      <data-input-readonly width="2" id="status" labelTag="general.status"
                           :value="$t('status.'+record.status)"></data-input-readonly>

      <!-- ********* -->
      <!-- Row #1 -->
      <!-- ********* -->
      <data-input-select width="2" id="agent_id" labelTag="agents.agent" v-model="record.agent_id"
                         :options="agents"
                         optionLabelField="name"></data-input-select>
      <!--<data-input-readonly width="2" id="created_at" labelTag="vouchers.creation_date"-->
      <!--v-model="record.created_at"></data-input-readonly>-->

      <div class="col-sm-2">
        <div class="d-flex flex-row justify-content-between">
          <label>QR Code
            <div class="badge badge-info">{qrcode}</div>
          </label>
          <!--<toggle-black-white-->
            <!--v-model="qrcodeConfig.code_color"></toggle-black-white>-->
        </div>
        <input class="form-control" v-model="qrcodeConfig.composition">
        <div class="d-flex flex-row align-items-center">
          <small class="line-height-1 d-inline mr-1">Size</small>
          <vue-range-slider :min="5" :max="20" ref="slider" style="width:100%;" v-model="qrcodeConfig.width">
            <div class="diy-tooltip" slot="tooltip" slot-scope="{ value }">
              {{ value }}
            </div>
          </vue-range-slider>
          <div class="line-height-1 text-nowrap">{{ qrcodeConfig.width }} px</div>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="d-flex flex-row justify-content-between">
          <label>Barcode
            <div class="badge badge-info">{barcode}</div>
          </label>
          <!--<toggle-black-white-->
            <!--v-model="barcodeConfig.code_color"></toggle-black-white>-->
          <!--<select v-model="record.barcodeType">-->
          <!--<option value="C39">Code 39</option>-->
          <!--<option value="C128">Code 128</option>-->
          <!--</select>-->
        </div>
        <input class="form-control" v-model="barcodeConfig.composition">
        <div class="d-flex flex-row align-items-center">
          <small class="text-nowrap line-height-1 d-inline mr-1">Width/bar</small>
          <vue-range-slider :min="1" :max="5" ref="slider" style="width:100%;" v-model="barcodeConfig.width">
            <div class="diy-tooltip" slot="tooltip" slot-scope="{ value }">
              {{ value }}
            </div>
          </vue-range-slider>
          <div class="line-height-1 text-nowrap">{{ barcodeConfig.width }}</div>
        </div>
        <div class="d-flex flex-row align-items-center">
          <small class="text-nowrap line-height-1 d-inline mr-1">Height</small>
          <vue-range-slider :min="30" :max="99" ref="slider" style="width:100%;" v-model="barcodeConfig.height">
            <div class="diy-tooltip" slot="tooltip" slot-scope="{ value }">
              {{ value }}
            </div>
          </vue-range-slider>
          <div class="line-height-1 text-nowrap">{{ barcodeConfig.height }}</div>
        </div>
      </div>

      <div class="col-sm-6">
        <div class="d-flex flex-row">
          <label>Voucher Type</label>
        </div>
        <div class="d-flex flex-row justify-content-between align-items-start voucher-type-selection">
          <div class="flex-grow-1">
            <!--:class="{'active':record.voucher_type=='voucher'}"-->
            <button type="button"
                    :class="{'btn-primary':record.voucher_type==='voucher','btn-light':record.voucher_type!=='voucher'}"
                    @click="record.voucher_type='voucher'"
                    class="btn w-100 mr-1">
              <img class="voucher-type-icon" data-toggle="tooltip" title="Voucher" src="/img/voucher.png"/>
              <img class="voucher-type-icon white-icon" data-toggle="tooltip" title="Voucher" src="/img/voucher-w.png"/>
            </button>
          </div>
          <div class="flex-grow-1 p-l-1">
            <!--:class="{'active':record.voucher_type==='form'}"-->
            <button type="button"
                    :class="{'btn-success':record.voucher_type==='form','btn-light':record.voucher_type!=='form'}"
                    @click="record.voucher_type='form'"
                    class="btn w-100 ml-1">
              <div class="d-flex flex-row justify-content-center align-items-center">
                <img class="voucher-type-icon flex-grow-1"
                     data-toggle="tooltip"
                     title="Form Filling"
                     src="/img/form.png"/>
                <img class="voucher-type-icon flex-grow-1 white-icon"
                     data-toggle="tooltip"
                     title="Form Filling"
                     src="/img/form-w.png"/>
                <i class="fa fa-play"></i>
                <img class="voucher-type-icon flex-grow-1"
                     data-toggle="tooltip"
                     title="Voucher"
                     src="/img/voucher.png"/>
                <img class="voucher-type-icon flex-grow-1 white-icon"
                     data-toggle="tooltip"
                     title="Voucher"
                     src="/img/voucher-w.png"/>
              </div>
            </button>
          </div>
        </div>
        <div v-if="record.voucher_type==='form'"
             class="position-absolute d-flex flex-row justify-content-center align-items-center"
             style="left:0;right:0;">
          <small class="mr-1">Form Link</small>
          <copy-link :link="customLink" variant="danger"></copy-link>
          <!--<div class="badge badge-success mr-2 custom-link d-flex flex-row align-items-center"-->
               <!--@click="copyCustomLink()">-->
            <!--{{ customLink }}-->
            <!--<font-awesome-icon class="ml-1" icon="copy"/>-->
          <!--</div>-->
        </div>
      </div>
    </div>

    <div v-if="record" class="p-2 bg-tab">
      <b-tabs content-class="py-0" class="bg-tab">
        <!--
         ******************
          Agent Code Table
         ******************
        -->
        <agent-code-tab
            ref="agentCodeTab""
          :title="$t('vouchers.codeTabLabel')"
          :record="record"
          @onCommand="onCommandHandler"></agent-code-tab>

        <!--
        *****************
         Email List
        *****************
        -->
        <b-tab v-if="false" title="Emails" class="bg-white py-2">
          <div class="container-fluid">
            <div class="row">
              <div class="col-12">
                <email-table
                    ref="emailTable"
                    @onCommand="onCommandHandler"
                    :emails="record.emails"></email-table>
              </div>
            </div>
          </div>
        </b-tab>

        <!--
        **************************
         Leaflet Template Editor
        **************************
        -->
        <b-tab title="Leaflet" class="bg-white py-2">
          <div class="container-fluid">
            <div class="row">
              <div class="col-12">
              </div>
            </div>
            <div class="row" v-if="record">
              <div class="col-12">
                <div class="d-flex flex-row">
                  <tinymce
                      ref="yoovEditor"
                      class="flex-grow-1 bg-muted"
                      @editorInit="onEditorInit()"
                      style="min-height:480px;"
                      id="yoovEditor"
                      :toolbar1="tinymceToolbar1"
                      :other_options="tinymceOtherOptions"
                      :options="tinymceOptions"
                      v-model="record.template"></tinymce>
                  <div class="flex-grow-0 p-2 bg-muted ml-2">
                    <b-button @click="showingCopyTemplateDialog=true"
                              class="btn btn-primary mb-3 w-100">
                      {{ $t('vouchers.copyTemplateFrom') }}
                    </b-button>
                    <h6>Token List</h6>
                    <div v-for="keyGroup in templateKeyGroups"
                         :key="keyGroup['name']">
                      {{ $t('vouchers.' + keyGroup['name']) }}
                      <ul class="token-list list-unstyled px-2 mb-1">
                        <li v-for="templateKey in keyGroup.keys"
                            :key="templateKey">
                          <div @click="insertKey(templateKey)"
                               class="badge badge-info">{{ '{'+templateKey+'}' }}
                          </div>
                        </li>
                      </ul>
                    </div>
                  </div>
                  <div class="fullscreen-token-list-panel d-flex flex-column"
                       v-if="tinyMCEInFullScreen">
                    <div class="flex-grow-1 p-2 bg-muted">
                      <!--<b-button @click="$bvModal.show('voucherSelectDialog')"-->
                      <!--class="btn btn-primary mb-3 w-100">-->
                      <!--{{ $t('vouchers.copyTemplateFrom') }}-->
                      <!--</b-button>-->
                      <b-button @click="showingCopyTemplateDialog=true"
                                class="btn btn-primary mb-3 w-100">
                        {{ $t('vouchers.copyTemplateFrom') }}
                      </b-button>
                      <h6>Token List</h6>
                      <div v-for="keyGroup in templateKeyGroups"
                           :key="keyGroup['name']">
                        {{ $t('vouchers.' + keyGroup['name']) }}
                        <ul class="token-list list-unstyled px-2 mb-1">
                          <li v-for="templateKey in keyGroup.keys"
                              :key="templateKey">
                            <div @click="insertKey(templateKey)"
                                 class="badge badge-info">{{ '{'+templateKey+'}' }}
                            </div>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </b-tab>

        <!--
        *****************
         Sharing
        *****************
        -->
        <b-tab id="sharingTab" title="Sharing Context" class="bg-white py-2">
          <div class="row">
            <sharing-context-box
              class="col-sm-6"
              title="Voucher Sharing Link"
              :record="record"
              sharingType="coupons"
              sharingTitleField="sharing_title"
              sharingDescriptionField="sharing_description"
              sharingImageIdField="sharing_image_id"
              @onCommand="onCommandHandler">
              </sharing-context-box>
            <sharing-context-box
              class="col-sm-6"
              title="Form Sharing Link"
              :record="record"
              sharingType="forms"
              sharingTitleField="form_sharing_title"
              sharingDescriptionField="form_sharing_description"
              sharingImageIdField="form_sharing_image_id"
              @onCommand="onCommandHandler">
              </sharing-context-box>
          </div>
        </b-tab>

        <!--
        *****************
         Custom Link
        *****************
        -->
        <!--<b-tab class="bg-white py-2">-->
        <!--<template v-slot:title>-->
        <!--{{ $t('vouchers.custom_link') }}-->
        <!--({{ customLink }})-->
        <!--</template>-->
        <!--<div class="container-fluid">-->
        <!--<div class="row">-->
        <!--<div class="col-12">-->
        <!--<div class="mb-1 d-flex flex-row align-items-center">-->
        <!--<div class="mr-1">LINK:</div>-->
        <!--<div v-if="!record.has_questionnaire">-->
        <!--Questionnaire is not used.-->
        <!--</div>-->
        <!--<div v-else-if="!record.questionnaire_key || !record.questionnaire" class="badge badge-muted">-->
        <!--Link is available after saving.-->
        <!--</div>-->
        <!--<div v-else class="badge badge-success mr-2 custom-link d-flex flex-row align-items-center"-->
        <!--@click="copyQuestionnaireLink()">-->
        <!--{{ questionnaireLink }}-->
        <!--<font-awesome-icon class="ml-1" icon="copy"/>-->
        <!--</div>-->
        <!--</div>-->
        <!--</div>-->
        <!--</div>-->
        <!--</div>-->
        <!--</b-tab>-->

        <form-filling-tab
            v-if="record.voucher_type==='form'"
            title="Form Filling"
            :record="record"
            @onCommand="onCommandHandler"></form-filling-tab>

        <custom-forms-tab
            ref="customFormsTab"
            v-if="record.voucher_type==='form'"
            title="Custom Forms"
            :record="record"
            @onCommand="onCommandHandler"></custom-forms-tab>

        <form-participants-tab
            v-if="record.voucher_type==='form'"
            title="Participants"
            :record="record"
            @onCommand="onCommandHandler"></form-participants-tab>

        <form-page-templates-tab
            v-if="record.voucher_type==='form' && false"
            title="Form Page Templates"
            :templates="allTemplates"
            @onCommand="onCommandHandler"></form-page-templates-tab>

      </b-tabs>
    </div>
    <div v-else class="text-center">
      <h4 class="text-center">
        <font-awesome-icon v-if="loading" icon="spinner" class="fa-spin"/>
      </h4>
    </div>
    <image-cropper-dialog
        id="imageCropperDialog"
        ref="imageCropperDialog"
        :mediaId="selectedTempMediaId"
        :mediaIdField="selectedTempMediaIdField"
        :voucherId="recordId"
        v-model="showingImageCropperDialog"
        @onCommand="onCommandHandler"></image-cropper-dialog>
    <voucher-select-dialog
        :title="$t('vouchers.copyTemplateFrom')"
        :initialAgentId="record ? record.agent_id : 0"
        v-model="showingCopyTemplateDialog"
        @onCommand="onCommandHandler"></voucher-select-dialog>
    <image-select-dialog
        :title="$t('vouchers.images')"
        :voucher="record"
        :imageScope="imageScope"
        v-model="showingImageSelectDialog"
        @onCommand="onCommandHandler"></image-select-dialog>

    <single-field-dialog ref="singleFieldDialog" @onCommand="onCommandHandler">
    </single-field-dialog>
  </div>
</template>

<script>
  import titleRow from '@/views/comps/TitleRow'
  import formInputs from '@/views/comps/forms'
  import fileUpload from 'vue-upload-component'
  import templateEditor from './comps/TemplateEditor'
  import toggleBlackWhite from './comps/ToggleBlackWhite'
  import appMixin from '@/mixins/AppMixin'
  import DataRecordMixin from '@/mixins/DataRecordMixin'
  import copyLink from '@/views/comps/CopyLink'

  // import agentCodeTable from './comps/AgentCodeTable'

  // import emailTable from './comps/EmailTable'
  import tinymce from 'vue-tinymce-editor'
  // import datePicker from 'vue2-datepicker'
  import 'vue2-datepicker/index.css'
  import helpers from '@/helpers'
  import vueRangeSlider from 'vue-range-slider'
  // import vueRangeSlider from 'vue-range-slider'

  import voucherSelectDialog from './dialogs/VoucherSelectDialog'
  import imageSelectDialog from './dialogs/ImageSelectDialog'
  import imageCropperDialog from './dialogs/ImageCropperDialog'
  import singleFieldDialog from './dialogs/SingleFieldDialog'

  import agentCodeTab from './comps/tabs/AgentCodeTab'
  import formFillingTab from './comps/tabs/FormFillingTab'
  import formPageTemplatesTab from './comps/tabs/FormPageTemplatesTab'
  import customFormsTab from './comps/tabs/CustomFormsTab'
  import formParticipantsTab from './comps/tabs/FormParticipantsTab'

  import formInputObjMixin from '@/mixins/FormInputObjMixin'

  import $ from 'jquery'

  import sharingContextBox from './comps/SharingContextBox'

  export default {
    mixins: [DataRecordMixin, appMixin, formInputObjMixin],
    components: {
      copyLink,
      toggleBlackWhite,
      templateEditor,
      imageCropperDialog,
      // agentCodeTable,
      agentCodeTab,
      fileUpload,
      // emailTable,
      // datePicker,
      tinymce,
      titleRow,
      ...formInputs,
      // ,
      vueRangeSlider,
      voucherSelectDialog,
      imageSelectDialog,
      singleFieldDialog,

      formPageTemplatesTab,
      formFillingTab,
      customFormsTab,
      formParticipantsTab,
      sharingContextBox
      // ,
      // yoovEditor
      // ,
      // editor

    },
    data () {
      return {
        apiPath: '/vouchers',
        titleField: 'description',
        record: null,

        // Upload Sharing Image
        // editingUploadFile: false,
        // files: [],

        loading: false,
        // content: '<table class="border bg-gray"><tr><td>sdfdsfdsfs<br/>sdlfksdlfjds</td></tr></table>sdlkfjsdklfjds',
        defaultTemplateKeyGroups: [],
        // agents: [],
        // showingCopyTemplateDialogx: false,
        allVouchers: [],

        // Template selection
        // selectedAgent: null,
        // selectedVoucher: null,
        agentVouchers: [],

        showingCopyTemplateDialog: false,
        showingImageSelectDialog: false,

        // sharing Image properties
        imageScope: '',
        selectedTempMediaId: 0,
        selectedTempMediaIdField: '',

        showingImageCropperDialog: false,

        processingButtons: [],

        tinymceOptions: {
          twoWay: true
        },
        tinymceOtherOptions: {
          'relative_urls': false,
          'remove_script_host': false,
          icons: 'small',
          setup: function (editor) {
            // *********************
            // Embed Image
            //**********************
            var inpEmbed = $('<input id="tinymce-embedder" type="file" name="pic" accept="image/*" style="display:none">')
            $(editor.getElement()).parent().append(inpEmbed)

            editor.addButton('embedImage', {
              tooltip: 'Embed Image',
              icon: 'image',
              onclick: function () {
                inpEmbed.trigger('click')
              }
            })

            inpEmbed.on("change", function () {
              var input = inpEmbed.get(0)
              var file = input.files[0]
              var fr = new FileReader()
              fr.onload = function () {
                var img = new Image()
                img.src = fr.result
                editor.insertContent('<img src="' + img.src + '"/>')
                inpEmbed.val('')
              }
              fr.readAsDataURL(file);
            })

            // *********************
            // Upload Image
            //**********************
            var inpUpload = $('<input id="tinymce-uploader" type="file" name="pic" accept="image/*" style="display:none">')
            $(editor.getElement()).parent().append(inpUpload)

            editor.addButton('uploadImage', {
              tooltip: 'Upload Image',
              icon: 'upload',
              onclick: function () {
                inpUpload.trigger('click')
              }
            })

            // *********************
            // Select Image
            //**********************
            editor.addButton('selectImage', {
              tooltip: 'Select Image',
              icon: 'browse',
              classes: 'select-image'
            })

            //
            // inpUpload.on("change",function(){
            //   this.uploadImage(inpUpload, editor)
            // })
            //

          }
        },
        tinymceToolbar1: 'undo redo | ' +
        'formatselect | ' +
        'bold italic strikethrough forecolor backcolor | ' +
        'link embedImage uploadImage selectImage | ' +
        'alignleft aligncenter alignright alignjustify | ' +
        'numlist bullist outdent indent | ' +
        'removeformat | ' +
        'fullscreen',

        tinyMCEInFullScreen: false,
        qrcodeConfig: {
          composition: '',
          width: 0,
          height: 0
        },
        barcodeConfig: {
          composition: '',
          width: 0,
          height: 0
        },
        testLink: '',
        inputObjs: [],
        selectedFormConfigs: null,
        selectedInputObjIndex: -1
      }
    },
    props: {
      recordId: {
        type: Number,
        default: 0
      }
    },

    computed: {
      customLink () {
        const vm = this
        return vm.$store.getters.appHost + '/q/' + vm.record.custom_link_key
      },
      allTemplates () {
        const vm = this
        var result = []
        result.push({
          id: 0,
          name: 'Questionnaire',
          content: vm.record.questionnaire,
          system: true
        })
        for (var i = 0; i < vm.record.custom_templates.length; i++) {
          var customTemplate = vm.record.custom_templates[i]
          result.push({
            id: customTemplate.id,
            name: customTemplate.name,
            content: customTemplate.content,
            system: false
          })
        }
        return result
      },

      // testLink () {
      //   const vm = this
      //   return window.location.origin + '/coupons/test/' + vm.record.id + '/' + new Date().getTime()
      // },
      // sharingTitleCharCount () {
      //   const vm = this
      //   let result = 0
      //   if (vm.record) {
      //     result = vm.record.sharing_title.length
      //   }
      //   return result
      // },
      // sharingDescriptionCharCount () {
      //   const vm = this
      //   let result = 0
      //   if (vm.record) {
      //     result = vm.record.sharing_description.length
      //   }
      //   return result
      // },
      // sharingImageSrc () {
      //   const vm = this
      //   let result = ''
      //   if (vm.record) {
      //     result = vm.$store.getters.appHost + '/media/image/' + vm.record.sharing_media_id
      //   }
      //   return result
      // },
      // authHeaders () {
      //   const vm = this
      //   return {
      //     Authorization: 'bearer ' + vm.$store.getters.accessToken
      //   }
      // },
      // sharingImagePostAction () {
      //   const vm = this
      //   return vm.$store.getters.apiUrl + '/media/upload'
      // },
      agents () {
        return this.$store.getters.agents
      },
      otherVouchers () {
        const vm = this
        let result = []
        if (vm.record) {
          result = vm.allVouchers.filter(voucher => {
            return voucher.id !== vm.record.id
          })
        }
        d
        return result
      },
      templateKeyGroups () {
        const vm = this
        const result = JSON.parse(JSON.stringify(vm.defaultTemplateKeyGroups))
        if (vm.codeFields.length > 0) {
          result.push({
            name: 'code',
            keys: []
          })
        }
        const lastIndex = result.length - 1
        for (let i = 0; i < vm.codeFields.length; i++) {
          const key = helpers.str2token('code_', vm.codeFields[i])
          result[lastIndex]['keys'].push(key)
        }
        return result
      },
      codeFields () {
        const vm = this
        let result = []
        if (vm.record.code_fields !== null && vm.record.code_fields !== '') {
          // console.log('codeFields :: codeFields = ' + vm.record.code_fields)
          const arKeyPairs = helpers.getKeyPairArray(vm.record.code_fields)
          // console.log('codeFields :: arKeyPairs: ', arKeyPairs)
          result = arKeyPairs.map(keyPair => keyPair[0])
        }
        return result
      }
    },
    watch: {
      recordId: function (newValue) {
        const vm = this
        // console.log('VoucherRecord :: watch(recordId) : newvalue = ' + newValue)
        vm.refresh(newValue)
      }
    },
    mounted () {
      const vm = this

      vm.showingCopyTemplateDialog = false
      vm.showingImageSelectDialog = false
      vm.showingImageCropperDialog = false

      vm.$store.dispatch('FETCH_AGENTS')
      // vm.fetchAgents();
      vm.fetchVouchers();
      vm.fetchDefaultTemplateKeys()

      vm.refresh(vm.recordId)

      vm.testLink = window.location.origin + '/coupons/' + vm.recordId + '/' + new Date().getTime()
    },
    methods: {
      copyCustomLink () {
        const vm = this
        vm.$copyText(vm.customLink)
        vm.$toaster.info(vm.$t('messages.link_copied_to_clipboard'))
      },
      // removeSharingImage () {
      //   const vm = this
      //   const data = {
      //     urlCommand: '/medias/' + vm.record.sharing_media_id,
      //     data: {
      //       type: 'temp'
      //     }
      //   }
      //   vm.$store.dispatch('AUTH_PUT', data).then(
      //     () => {
      //       vm.$toaster.success(vm.$t('messages.deleteSuccessfully'))
      //       vm.record.sharing_media_id = 0
      //     }
      //   )
      // },
      // inputFilter (newFile, oldFile, prevent) {
      //   const vm = this
      //   if (newFile && !oldFile) {
      //     // Filter non-image file
      //     if (!/\.(jpg|jpeg|png|gif)$/i.test(newFile.name)) {
      //       vm.$toaster.warning('Invalid Image File Format!')
      //       return prevent()
      //     }
      //   }
      // },
      //
      // inputImageFile (newFile, oldFile) {
      //   const vm = this
      //   console.log('inputImageFile')
      //   if (newFile && !oldFile) {
      //     this.$nextTick(function () {
      //       this.editingUploadFile = true
      //       this.uploading = true
      //       this.$refs.uploadSharingImage.active = true
      //     })
      //   }
      //   if (!newFile && oldFile) {
      //     this.edit = false
      //   }
      //   if (newFile && newFile.success) {
      //     vm.onUploaded(newFile.response.result)
      //   }
      // },
      //
      onUploaded (result) {
        const vm = this
        console.log('onUploaded :: result: ', result)
        vm.selectedTempMediaId = result.imageId
        // sharingImageSrc = vm.$store.getters.appHost + '/media/image/' + result.imageId
        vm.$bvModal.show('imageCropperDialog')
        // vm.showingImageCropperDialog = true
        vm.$nextTick(() => {
          vm.$refs.imageCropperDialog.startCrop()
        })
      },
      onRefreshed () {
        const vm = this

        // init voucher sharing title/description
        if (!vm.record.sharing_title) {
          vm.record.sharing_title = ''
        }
        if (!vm.record.sharing_description) {
          vm.record.sharing_description = ''
        }

        // init question form sharing title/description
        if (!vm.record.form_sharing_title) {
          vm.record.form_sharing_title = ''
        }
        if (!vm.record.form_sharing_description) {
          vm.record.form_sharing_description = ''
        }

        // init form configs
        if (vm.record.form_configs === null || vm.record.form_configs.length===0) {
          vm.record.form_configs = JSON.parse(JSON.stringify(vm.DEFAULT_FORM_CONFIGS))
        }

        if (vm.record.custom_forms.length === 0) {
          vm.record.custom_forms.push({
            id: 0,
            form_key: vm.newFormKey(),
            name: 'Thank you',
            type: 'general',
            form_configs: JSON.parse(JSON.stringify(vm.DEFAULT_FORM_CONFIGS))
          })
          vm.record.custom_forms.push({
            id: 0,
            form_key: vm.newFormKey(),
            name: 'Sorry',
            type: 'general',
            form_configs: JSON.parse(JSON.stringify(vm.DEFAULT_FORM_CONFIGS))
          })
        }
        if (vm.record.thankyou_configs === null) {
          vm.record.thankyou_configs = JSON.parse(JSON.stringify(vm.DEFAULT_FORM_CONFIGS))
        }
        if (vm.record.sorry_configs === null) {
          vm.record.sorry_configs = JSON.parse(JSON.stringify(vm.DEFAULT_FORM_CONFIGS))
        }

        // *****************
        // qrcode
        // *****************
        vm.qrcodeConfig = vm.getCodeConfig('qrcode', {
          id: 0,
          composition: '',
          'code_group': 'qrcode',
          'code_type': 'QRCODE',
          width: 160,
          height: 160
        })

        vm.barcodeConfig = vm.getCodeConfig('barcode', {
          id: 0,
          composition: '',
          'code_group': 'barcode',
          'code_type': 'C128',
          width: 3,
          height: 12
        })

        // vm.qrcodeConfig = {
        //   id: 0,
        //   composition: '',
        //   'code_group': 'qrcode',
        //   'code_type': 'QRCODE',
        //   width: 160,
        //   height: 160
        // }
        // const qrcodes = vm.record.code_configs.filter(config => {
        //   return config.code_group === 'qrcode'
        // })
        // if (qrcodes && qrcodes.length > 0) {
        //   vm.qrcodeConfig = qrcodes[0]
        // }
        //
        // // *****************
        // // barcode
        // // *****************
        // vm.barcodeConfig = {
        //   id: 0,
        //   composition: '',
        //   'code_group': 'barcode',
        //   'code_type': 'C128',
        //   width: 3,
        //   height: 12
        // }
        // const barcodes = vm.record.code_configs.filter(config => {
        //   return config.code_group === 'barcode'
        // })
        //
        // if (barcodes && barcodes.length > 0) {
        //   vm.barcodeConfig = barcodes[0]
        // }
      },

      getCodeConfig (codeGroup, defaultConfig) {
        const vm = this
        var result = defaultConfig
        const codes = vm.record.code_configs.filter(config => {
          return config.code_group === codeGroup
        })
        if (codes && codes.length > 0) {
          result = codes[0]
        }
        return result
      },
      // onFullscreenStateChanged (full) {
      //   alert('onFull')
      // },
      copyTemplate (selectedVoucher) {
        const vm = this
        // console.log('VoucherRecord :: copyTemplate :: selectedVoucher: ', selectedVoucher)
        vm.showingCopyTemplateDialog = false
        if (vm.record.template && vm.record.template.trim() !== '') {
          vm.$dialog.confirm(vm.$t('messages.overwrite_existing_content') + '?').then(
            () => {
              vm.record.template = vm.getVoucherTemplate(selectedVoucher.id)
              vm.$toaster.success(vm.$t('messages.template_copied'))
            }
          )
        } else {
          vm.record.template = vm.getVoucherTemplate(selectedVoucher.id)
          vm.$toaster.success(vm.$t('messages.template_copied_successfully'))
        }
      },
      getVoucherTemplate (voucherId) {
        const vm = this
        const data = {
          urlCommand: '/vouchers/' + voucherId,
          options: {
            params: {
              select: 'template'
            }
          }
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            vm.record.template = response.data.template
          }
        )
      },
      insertKey (key) {
        tinyMCE.get('yoovEditor').execCommand('mceInsertContent', false, '{' + key + '}');
      },
      onEditorInit () {
        const vm = this
        tinyMCE.get('yoovEditor').setContent(vm.record.template ? vm.record.template : '')
        tinyMCE.get('yoovEditor').save()
        tinyMCE.get('yoovEditor').on('fullscreenStateChanged', function (e) {
          vm.tinyMCEInFullScreen = e.state
        })
        const editor = tinyMCE.get('yoovEditor')
        editor.on('blur', function(e) {
          editor.selection.collapse(false);
          // console.log('yooveditor.on(blur) e: ', e)
        })
        // tinymce.get('yoovEditor').setContent('<p>hello world</p>')
        // console.log('tinymce: ', tinymce)
        // vm.$refs.yoovEditor.setContent('<p>hello world</p>')
        // console.log('template: ', vm.record.template)

        vm.addTinyMCEButtonEvents(tinyMCE.get('yoovEditor'))
      },
      addTinyMCEButtonEvents (editor) {
        const vm = this

        //*****************
        // Upload Image
        //*****************
        var editorObj = $('#yoovEditor')
        var inpUpload = $(editorObj).parent().find('input#tinymce-uploader')
        $(inpUpload).off('change').on('change', function () {
          vm.uploadImage(inpUpload, editor)
        })
        const objTinymce = $('#yoovEditor').prev('.mce-tinymce')
        const btnSelectImage = $(objTinymce).find('.mce-select-image button')

        //*****************
        // Select Image
        //*****************
        $(btnSelectImage).off('click').on('click', function () {
          vm.imageScope = 'tinymce'
          vm.showingImageSelectDialog = true
        })


        // Select Image

        //   '' +
        //   ' inpUpload = $(\'<input id="tinymce-uploader' +
        //   '' +
        //   '')
        // vm.addTinyMCEButtonEmbedImage(editor, 'embedImage')
        // vm.addTinyMCEButtonUploadImage(editor, 'uploadImage')
        // vm.tinymceToolbar1 = 'undo redo | formatselect | bold italic strikethrough forecolor backcolor | link embedImage uploadImage | alignleft aligncenter alignright alignjustify | numlist bullist outdent indent | removeformat | fullscreen'
      },
      uploadImage (inpUpload, editor) {
        const vm = this
        var input = inpUpload.get(0);
        var data = new FormData();
        data.append('file', input.files[0]);
        data.append('scope', 'tinymce');
        // data.append('image[file]', input.files[0]);

        const url = vm.$store.getters.apiUrl + '/media/upload_image'
        const bearerToken = 'bearer ' + vm.$store.getters.accessToken
        console.log('uploadImage')
        $.ajax({
          headers: {'Authorization': bearerToken},
          url: url,
          type: 'POST',
          data: data,
          processData: false, // Don't process the files
          contentType: false, // Set content type to false as jQuery will tell the server its a query string request
          success: function (response, textStatus, jqXHR) {
            console.log('VoucherRecord :: uploadImage :: response :: data: ', response)
            const data = response.result
            editor.insertContent('<img class="content-img" src="' + data.imageUrl + '"/>');
          },
          error: function (jqXHR, textStatus, errorThrown) {
            console.log('VoucherRecord :: uploadImage :: error')
            if (jqXHR.responseText) {
              const errors = JSON.parse(jqXHR.responseText).errors
              alert('Error uploading image: ' + errors.join(", ") + '. Make sure the file is an image and has extension jpg/jpeg/png.');
            }
          }
        });
      },
      addTinyMCEButtonEmbedImage (editor, buttonName) {
        const vm = this
        // alert('addTinyMCEButtonEmbedImage')
        // var inpEmbed = $('<input id="tinymce-embedder" type="file" name="pic" accept="image/*" style="display:none">')
        // $(editor.getElement()).parent().append(inpEmbed)
        //
        // inpEmbed.on("change", function () {
        //   var input = inpEmbed.get(0)
        //   var file = input.files[0]
        //   var fr = new FileReader()
        //   fr.onload = function () {
        //     var img = new Image()
        //     img.src = fr.result
        //     editor.insertContent('<img src="' + img.src + '"/>')
        //     inpEmbed.val('')
        //   }
        //   fr.readAsDataURL(file);
        // })
        //
        // editor.addButton(buttonName, {
        //   tooltip: 'Embed Image',
        //   icon: 'upload',
        //   onclick: function () {
        //     inpEmbed.trigger('click')
        //   }
        // })
      },
      // addTinyMCEButtonUploadImage (editor, buttonName) {
      //   const vm = this
      //   alert('addTinyMCEButtonUploadImage')
      //   var inpUpload = $('<input id="tinymce-uploader" type="file" name="pic" accept="image/*" style="display:none">')
      //   $(editor.getElement()).parent().append(inpUpload)
      //
      //   inpUpload.on("change",function(){
      //     this.uploadImage(inpUpload, editor)
      //   })
      //
      //   editor.addButton( buttonName, {
      //     tooltip: 'Upload Image',
      //     icon: 'image',
      //     onclick: function() {
      //       inpUpload.trigger('click')
      //     }
      //   })
      //
      // },
      // fetchAgents () {
      //   const vm = this
      //   vm.$store.dispatch('AUTH_GET', '/agents').then(
      //     response => {
      //       // console.log('fetchAgents: redsponse: ', response)
      //       vm.agents = response
      //     },
      //     error => {
      //       vm.$dialog.alert('Agents: ' + vm.$t('messages.error_during_loading'))
      //     }
      //   )
      // },
      fetchVouchers () {
        const vm = this
        let data = {
          urlCommand: '/vouchers',
          options: {
            params: {
              select: 'description,id,agent.name,agent_id,template'
            }
          }
        }
        vm.$store.dispatch('AUTH_GET', data).then(
          response => {
            // console.log('fetchVouchers :: response: ', response)
            vm.allVouchers = response
          },
          () => {
            vm.showSessionExpired('vouchers')
            // vm.$dialog.alert('Voucher Selection: ' + vm.$t('messages.error_during_loading'))
          }
        )
      },

      fetchDefaultTemplateKeys () {
        const vm = this
        vm.defaultTemplateKeyGroups = []
        vm.$store.dispatch('AUTH_GET', '/template_keys').then(
          response => {
            for (let i = 0; i < response.length; i++) {
              const responseItem = response[i]
              const category = responseItem.category
              const key = responseItem.key
              const keyGroup = vm.defaultTemplateKeyGroups.find(group => {
                return group.name === category
              })
              if (keyGroup) {
                // console.log('keyGroup is true: ', keyGroup)
                keyGroup.keys.push(key)
              } else {
                // console.log('keyGroup is false: ', keyGroup)
                vm.defaultTemplateKeyGroups.push({
                  name: category,
                  keys: [key]
                })
              }
            }
          },
          () => {
            vm.showSessionExpired('template keys')
            // vm.$dialog.alert('Template Keys: ' + vm.$t('messages.error_during_loading'))
          }
        )
      },
      getCodeInfoFromRow (row) {
        // id: 0
        // field0: "0019999900100008000000g0rDtKv136"
        // field1: "00092979"
        // field2: "2019-11-14"
        // field3: "2020-05-23"
        // status: "pending"
        // key: ""
        // sent_on: null

        const vm = this
        const codeFields = vm.record.code_fields
        const fieldCount = codeFields.split('|').length
        const fieldValues = []
        for (let i = 1; i < fieldCount; i++) {
          fieldValues.push(row['field' + i])
        }

        return {
          id: row['id'],
          code: row['field0'],
          extra_fields: fieldValues.join('|'),
          key: row['key']
        }
      },
      createTempLeaflet (codeRecord) {
        const vm = this
        // console.log('createTempLeaflet :: codeRecord: ', codeRecord)
        const tempRecord = JSON.parse(JSON.stringify(vm.record))
        delete tempRecord['code_infos']
        const codeConfigs = [
          vm.qrcodeConfig,
          vm.barcodeConfig
        ]
        tempRecord.code_configs = codeConfigs
        const data = {
          urlCommand: '/templates/create_temp',
          data: {
            record: tempRecord,
            codeInfo: vm.getCodeInfoFromRow(codeRecord)
          }
        }
        // console.log('view_temp_leaflet: data: ', data)
        vm.$store.dispatch('AUTH_POST', data).then(response => {
          const key = response
          const url = window.location.origin + '/coupons/temp/' + key
          // const url = vm.$store.getters.constants.apiUrl + '/templates/view/' + key
          window.open(url, '_blank');
        })
      },
      showLeaflet (key) {
        const vm = this
        const url = vm.$store.getters.appHost + '/coupons/' + key
        window.open(url, '_blank');
      },
      getCustomFormByKey (key) {
        const vm = this
        var result = null
        for (var i = 0 ; i < vm.record.custom_forms.length; i++) {
          var customForm = vm.record.custom_forms[i]
          if (customForm.form_key === key) {
            result = customForm
            break
          }
        }
        return result
      },
      onCommandHandler (payload) {
        const vm = this
        var customForm = null
        console.log('VoucherRecord :: onCommandHandler :; payload: ', payload)
        // console.log('VoucherRecord :: onCommandHandler :: payload: ', payload)
        switch (payload.command) {
          case 'cropImage':
            vm.selectedTempMediaId = payload.imageId
            vm.selectedTempMediaIdField = payload.imageIdField /* sharing_image_id or form_sharing_image_id */
            // sharingImageSrc = vm.$store.getters.appHost + '/media/image/' + result.imageId
            vm.$bvModal.show('imageCropperDialog')
            // vm.showingImageCropperDialog = true
            vm.$nextTick(() => {
              vm.$refs.imageCropperDialog.startCrop()
            })

            break
          case 'selectCustomForm':
            switch (payload.tag) {
              case 'actionTypeBeforeGoal':
                console.log('voucherRecord > onCommandHandler > selectCustomForm > actionTypeBeforeGoal formKey = ' + payload.formKey)
                vm.record.custom_form_key_before_goal = payload.formKey
                break
              case 'actionTypeAfterGoal':
                console.log('voucherRecord > onCommandHandler > selectCustomForm > actionTypeAfterGoal formKey = ' + payload.formKey)
                vm.record.custom_form_key_after_goal = payload.formKey
                break
            }
            break
          case 'selectActionType':
            switch (payload.tag) {
              case 'actionTypeBeforeGoal':
                vm.record.action_type_before_goal = payload.actionType
                break
              case 'actionTypeAfterGoal':
                vm.record.action_type_after_goal = payload.actionType
                break
            }
            break
          case 'removeFormType':
            for (var i = 0; i < vm.record.custom_forms.length; i++) {
              customForm = vm.record.custom_forms[i]
              if (customForm.form_key === payload.formKey) {
                vm.record.custom_forms.splice(i, 1)
              }
            }
            break
          case 'newFormType':
            customForm = vm.getCustomFormByKey(payload.formKey)
            vm.$refs.singleFieldDialog.init(
              'New',
              'onNewFormType',
              {formKey: 'ADD'},
              '')
            break
          case 'onNewFormType':
            if (payload.fieldValue === '') {
              vm.$toaster.warn('No name specified!')
            } else {
              vm.record.custom_forms.push({
                'form_key': vm.newFormKey(),
                'form_configs': JSON.parse(JSON.stringify(vm.DEFAULT_FORM_CONFIGS)),
                id: 0,
                name: payload.fieldValue,
                type: 'general',
                voucher_id: vm.record.id
              })
            }
            break
          case 'renameFormType':
            customForm = vm.getCustomFormByKey(payload.formKey)
            vm.$refs.singleFieldDialog.init(
              'Rename',
              'onRenameFormName',
              {formKey: payload.formKey},
              customForm.name)
            break
          // case 'onNewFormType':
          //   break
          case 'onRenameFormName':
            var formKey = payload.idParams['formKey']
            customForm = vm.getCustomFormByKey(formKey)
            customForm.name = payload.fieldValue
            break
          case 'onImageSelected':
            switch (payload.imageScope) {
              case 'tinymce':
                const editor = tinyMCE.get('yoovEditor')
                console.log('onImageSelected :: tinymce :: vm.$store.getters.appHost = ' + vm.$store.getters.appHost)
                const url = vm.$store.getters.appHost + '/media/image/' + payload.imageId
                console.log('onImageSelected :: url = ' + url)
                editor.insertContent('<img class="content-img" src="' + url + '"/>');
                vm.$toaster.success('Image Added')
                break
              case 'inputObj':
                if (vm.selectedFormConfigs && vm.selectedInputObjIndex >= 0) {
                  vm.selectedFormConfigs.inputObjs[vm.selectedInputObjIndex]['question'] =
                    vm.$store.getters.appHost + '/media/image/' + payload.imageId
                }
                vm.showingImageSelectDialog = false
                break
            }
            break
          case 'copyTemplate':
            vm.copyTemplate(payload.voucher)
            break
          case 'exportParticipants':
            vm.exportParticipants()
            break
          case 'export':
            vm.exportCodes()
            break
          case 'refreshCouponCodes':
            vm.$refs.agentCodeTab.refresh()
            break
          case 'select_voucher':
            alert('voucher selected')
            break
          // case 'update_code_info_field':
          //   // console.log('update_code_info_field :: payload: ', payload)
          //   vm.setCodeFieldValue(payload.row, payload.fieldName, payload.fieldValue)
          //   // let codeInfo = vm.getCodeInfo(payload.row)
          //   // codeInfo[payload.fieldName] = payload.fieldValue
          //   break

          // case 'clear_all_code_info':
          //   // vm.record.code_infos = []
          //   vm.record.code_fields = ''
          //   vm.record.code_infos = [];
          //   // vm.record.qr_code_composition = ''
          //
          //   vm.qrcodeConfig.composition = ''
          //   vm.barcodeConfig.composition = ''
          //
          //   if (typeof payload.callback === 'function') {
          //     payload.callback()
          //   }
          //   break
          // case 'delete_participant':
          //
          //   break
          case 'delete_code_info':
            vm.record.code_infos.splice(payload.index, 1)
            break
          case 'view_leaflet':
            if (vm.record.template && vm.record.template.trim() !== '') {
              if (payload.row.key === '') {
                vm.createTempLeaflet(payload.row)
              } else {
                vm.save(() => {
                  vm.showLeaflet(payload.row.key)
                })
              }
            } else {
              vm.$dialog.alert(vm.$t('messages.template_missing'))
            }
            break
          case 'save':
            vm.save(payload.callback)
            break
          case 'save_and_back':
            vm.save(() => {
              vm.$router.go(-1);
            })
            break
          // case 'saveTemp':
          //   vm.saveTemp()
          //   break
          case 'setRecordField':
            console.log('onCommandHandler :; setRecordField :: fieldName = ' + payload.fieldName)
            console.log('onCommandHandler :; setRecordField :: fieldValue = ' + payload.fieldValue)
            vm.record[payload.fieldName] = payload.fieldValue
            break
          case 'setCodeFields':
            vm.record.code_fields = payload.value // vm.createCodeFieldStr(payload.value)
            // console.log('VoucherRecord :: setCodeFields = ' + vm.record.code_fields)
            break
          case 'setCodeDataRows':
            // console.log('onCommandHandler :: setCodeData :: payload.value: ', payload.value)
            vm.updateCodeInfos(payload.value)
            // vm.record.codeInfos = vm.createCodeInfos(payload.value)
            break
          case 'updateField':
            var fieldName = payload.fieldName
            var fieldValue = payload.fieldValue
            // console.log('onCommandHandler :: updateField :; fieldName = ' + fieldName)
            // console.log('onCommandHandler :: updateField :; fieldValue = ' + fieldValue)
            vm.record[fieldName] = fieldValue
            break
          case 'setQrCodeComposition':
            // console.log('setQrCodeComposition :: payload.data: ', payload.data)
            if (vm.qrcodeConfig.composition === '' || payload.data === '') {
              // console.log('setQrCodeComposition: vm.qrcodeConfig.composition === "" || payload.data === ""')
              vm.qrcodeConfig.composition = payload.data
            }
            if (vm.barcodeConfig.composition === '' || payload.data === '') {
              // console.log('setQrCodeComposition: vm.barcodeConfig.composition === "" || payload.data === ""')
              vm.barcodeConfig.composition = payload.data
            }
            break
          default:
            vm.onInputObjCommandHandler(payload)

        }
        console.log('VoucherRecord :: onCommandHandler :: ends')
      },
      exportParticipants () {
        const vm = this
        const data = {
          urlCommand: '/vouchers/' + vm.record.id + '/participants/export',
          options: {
            data: {
              description: vm.record.description
            }
          }
        }
        vm.$store.dispatch('AUTH_POST', data).then(
          response => {
            window.open(vm.$store.getters.apiUrl + '/files/' + response.key)
          },
          () => {
            vm.$toaster.warning(vm.$t('message.some_errors_occurred_during_export'))
          }
        )
      },
      exportCodes () {
        const vm = this
        const data = {
          urlCommand: '/vouchers/' + vm.record.id + '/codes/export',
          options: {
            data: {
              description: vm.record.description
            }
          }
        }
        vm.$store.dispatch('AUTH_POST', data).then(
          response => {
            window.open(vm.$store.getters.apiUrl + '/files/' + response.key)
          },
          () => {
            vm.$toaster.warning(vm.$t('message.some_errors_occurred_during_export'))
          }
        )
      },
      // setCodeFieldValue (row, fieldName, fieldValue) {
      //   const vm = this
      //   // const result = null
      //   for (let i = 0; i < vm.record.code_infos.length; i++) {
      //     const codeInfo = vm.record.code_infos[i]
      //     // console.log('record.codeInfo[code] = ' + codeInfo['code'])
      //     // console.log('record.codeInfo[extra_fields] = ' + codeInfo['extra_fields'])
      //     //
      //     // console.log('row.codeInfo[code] = ' + row['code'])
      //     // console.log('row.codeInfo[extra_fields] = ' + row['extra_fields'])
      //
      //     if (codeInfo['code'] === row['code'] && codeInfo['extra_fields'] === row['extra_fields']) {
      //       // console.log('VoucherRecord :: setCodeFieldValue :: found => assign field: ' + fieldName + ' to ' + fieldValue)
      //       vm.record.code_infos[i][fieldName] = fieldValue
      //       // result = codeInfo
      //       break
      //     }
      //   }
      // },
      getCodeInfo (row) {
        const vm = this
        let result = null
        for (let i = 0; i < vm.record.code_infos.length; i++) {
          const codeInfo = vm.record.code_infos[i]
          // console.log('record.codeInfo[code] = ' + codeInfo['code'])
          // console.log('record.codeInfo[extra_fields] = ' + codeInfo['extra_fields'])
          //
          // console.log('row.codeInfo[code] = ' + row['code'])
          // console.log('row.codeInfo[extra_fields] = ' + row['extra_fields'])

          if (codeInfo['code'] === row['code'] && codeInfo['extra_fields'] === row['extra_fields']) {
            result = codeInfo
            break
          }
        }
        return result
      },
      updateCodeInfos (newCodeDataList) {
        // codeDataList = [
        //    ['value1', 'value2', 'value3', 'value4'],
        //    ['value1', 'value2', 'value3', 'value4'],
        //    ['value1', 'value2',setCodeFields 'value3', 'value4'],
        //    ['value1', 'value2', 'value3', 'value4']
        // ]setCodeFields
        // console.log('updateCodeInfos :: newCodeDataList: ', newCodeDataList)
        const vm = this
        let existingCodes = []
        if (vm.record.code_infos) {
          existingCodes = vm.record.code_infos.map(codeInfo => codeInfo.code)
        } else {
          vm.record.code_infos = []
        }
        // console.log('updateCodeInfos :: existingCodes: ', existingCodes)
        for (let i = 0; i < newCodeDataList.length; i++) {

          const fields = []
          const code = newCodeDataList[i][0]
          // console.log('updateCodeInfos :: code = ' + code)
          for (let j = 1; j < newCodeDataList[i].length; j++) {
            const value = newCodeDataList[i][j]
            // console.log('updateCodeInfos j=' + j + ': value=' + value)
            fields.push(value)
          }

          const index = existingCodes.indexOf(code)
          // if exists
          if (index >= 0) {
            vm.record.code_infos[index].extra_fields = fields.join('|')
          } else {
            vm.record.code_infos.push({
              id: 0,
              code: code,
              extra_fields: fields.join('|'),
              sent_on: '',
              remark: '',
              order: 0,
              key: '',
              status: 'pending'
            })
            existingCodes.push(code)
          }
        }
        for (let i = 0; i < vm.record.code_infos.length; i++) {
          vm.record.code_infos[i].order = i + 1
        }
      },
      createCodeInfos (codeDataList) {
        // codeDataList = [
        //    ['value1', 'value2', 'value3', 'value4'],
        //    ['value1', 'value2', 'value3', 'value4'],
        //    ['value1', 'value2', 'value3', 'value4'],
        //    ['value1', 'value2', 'value3', 'value4']
        // ]
        const result = []
        for (let i = 0; i < codeDataList.length; i++) {
          const fields = []
          for (let j = 0; j < codeDataList[i].length; j++) {
            fields.push(codeDataList[i][j])
          }
          result.push({
            id: 0,
            code_details: fields.join('|'),
            sent_on: '',
            remark: '',
            status: 'pending'
          })
        }
        return result
      },
      createCodeFieldStr (arCodeFields) {
        const result = []
        for (let i = 0; i < arCodeFields.length; i++) {
          result.push(arCodeFields[i]['title'] + ':' + arCodeFields[i]['type'])
        }
        return result.join('|')
      },

      // saveTemp () {
      //   const vm = this
      //   const agentCodeInfo = vm.$refs.agentCodeTable.getAgentCodeInfo()
      //   const reqData = JSON.parse(JSON.stringify(vm.record))
      //   reqData.status = 'preparing'
      //   reqData['fields'] = agentCodeInfo['fields']
      //   reqData['code_details'] = agentCodeInfo['codeDetails']
      //   const data = {
      //     urlCommand: vm.apiPath + (vm.record.id === 0 ? '' : '/' + vm.record.id),
      //     data: reqData
      //   }
      //   vm.loading = true
      //   const action = vm.record.id === 0 ? 'COMMON_POST' : 'COMMON_PUT'
      //   vm.$store.dispatch(action, data).then(response => {
      //     console.log('saveTemp: response: ', response)
      //     vm.loading = false
      //     vm.record.id = response.id
      //   })
      // },

      certifyFormConfigs () {
        const vm = this
        var formConfigs = vm.record.form_configs;
        if (formConfigs['inputObjs']) {
          var inputObjs = formConfigs['inputObjs']
          for (var i = 0; i < inputObjs.length; i++) {
            var inputObj = inputObjs[i]
            switch (inputObj['inputType']) {
              case 'single-choice':
              case 'multiple-choice':
                const options = JSON.parse(JSON.stringify(inputObj['options']))
                var result = []
                for (var j = 0; j < options.length; j++) {
                  if (options[j].trim() !== '') {
                    result.push(options[j]);
                  }
                }
                formConfigs['inputObjs'][i]['options'] = result
                break
            }
          }
        }
      },

      save (callback) {
        const vm = this
        console.log('VoucherRecord :: save')
        const codeConfigs = [
          vm.qrcodeConfig,
          vm.barcodeConfig
        ]
        vm.record.code_configs = codeConfigs

        // Check form configs validity
        vm.certifyFormConfigs()

        const data = {
          urlCommand: vm.apiPath + (vm.record.id === 0 ? '' : '/' + vm.record.id),
          // options: {
          //   headers: {
          //     'X-CSRF-TOKEN': vm.csrfToken
          //   }
          // },
          data: vm.record
        }
        vm.loading = true
        vm.$forceUpdate()
        const action = vm.record.id === 0 ? 'AUTH_POST' : 'AUTH_PUT'
        // console.log('action = ' + action)
        vm.$store.dispatch(action, data).then(
          response => {
            const successMessage = vm.$t('messages.saved_successfully')
            vm.$toaster.success(successMessage)
            // console.log('save: response: ', response)
            vm.loading = false
            console.log('after save: response: ', response)
            vm.record.id = response.id
            vm.refresh(vm.record.id)
            if (typeof callback === 'function') {
              callback()
            }
          },
          error => {
            vm.$toaster.error(vm.$t('messages.' + error.messageTag))
          }
        )
      }


      // inputFile(newFile, oldFile, prevent) {

      // inputFile: function (newFile, oldFile) {
      //   if (newFile && oldFile && !newFile.active && oldFile.active) {
      //     // Get response data
      //     console.log('response', newFile.response)
      //     if (newFile.xhr) {
      //       //  Get the response status code
      //       console.log('status', newFile.xhr.status)
      //     }
      //   }
      // },
      /**
       * Pretreatment
       * @param  Object|undefined   newFile   Read and write
       * @param  Object|undefined   oldFile   Read only
       * @param  Function           prevent   Prevent changing
       * @return undefined
       */

    }
  }
</script>

<style lang="scss">
  @import 'vue-range-slider/dist/vue-range-slider.scss';
</style>

<style>
  #participant-table div[name=Datatable] table {
    border: 1px solid #dee2e6;
  }

  #email-table div[name=Datatable] table tbody tr td,
  #code-table div[name=Datatable] table tbody tr td,
  #participant-table div[name=Datatable] table tbody tr td {
    padding-top: 0.1rem;
    padding-bottom: 0.1rem;
  }

  #code-table div[name=Datatable] table tbody tr td .input-group .form-control {
    padding: 0.1rem 0.3rem;
    height: calc(2rem + 2px);
  }

  .nav-tabs .nav-item a.nav-link {
    background-color: #F7F7F7;
  }

  .nav-tabs .nav-item a.nav-link.active {
    background-color: white;
    color: white;
  }

  div[name=Datatable] .pagination {
    justify-content: flex-end !important;
  }

  .mce-tinymce {
    height: 100%;
  }

  .token-list div.badge {
    font-size: 0.9rem;
  }

  .mce-edit-area iframe {
    min-height: 360px;
  }

  #copyTemplateDialog .modal-body {
    /*overflow-y: scroll;*/
    /*max-height: 480px;*/
  }

  #copyTemplateDialog .list-group-item.active:hover {
    background-color: #0062cc;

  }

  #copyTemplateDialog .list-group-item:hover {
    background-color: #f8f9fa;
  }

  #copyTemplateDialog .list-group-item {
    cursor: pointer;
    line-height: 1;
  }

  #copyTemplateDialog___BV_modal_outer_ {
    z-index: 2000 !important;
  }

  #imageSelectDialog___BV_modal_outer_ {
    z-index: 2000 !important;
  }

  .token-list li > div.badge {
    cursor: pointer;
  }

  .mce-fullscreen .mce-resizehandle {
    display: block;
  }

  .mce-fullscreen .mce-edit-area.mce-container {
    padding-right: 240px;
  }

  .mce-fullscreen .mce-edit-area.mce-container {
    height: 100%;
  }

  .mce-fullscreen .mce-container-body.mce-stack-layout {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .fullscreen-token-list-panel {
    z-index: 2000;
    position: fixed;
    top: 80px;
    right: 10px;
    width: 220px;
    height: 100%;
    padding-bottom: 120px;
  }

  /*.fullscreen-token-list-panel > div {*/
  /*background-color: lightgray;*/
  /*}*/

  /*.left-pane {*/
  /*padding-right: 10px;*/
  /*flex-grow: 1;*/
  /*}*/

  /*.right-pane {*/
  /*flex-grow: 1;*/
  /*}*/

  /*.left-pane-scroll {*/
  /*overflow-y: scroll;*/
  /*height: 0;*/
  /*min-height: 100%;*/
  /*}*/

  /*.right-pane-scroll {*/
  /*overflow-y: scroll;*/
  /*height: 0;*/
  /*min-height: 100%;*/
  /*}*/

  /*#copyTemplateDialog {*/
  /*display: flex !important;*/
  /*flex-direction: column;*/
  /*}*/

  /*#copyTemplateDialog .modal-dialog {*/
  /*flex-grow: 1;*/
  /*display: flex;*/
  /*flex-direction: column;*/
  /*width: 100%;*/
  /*}*/
  /*#copyTemplateDialog .modal-dialog [role=document] {*/
  /*flex-grow: 1;*/
  /*display: flex;*/
  /*flex-direction: column;*/
  /*}*/
  /*#copyTemplateDialog .modal-dialog [role=document] .modal-body {*/
  /*flex-grow: 1;*/
  /*display: flex;*/
  /*flex-direction: row;*/
  /*}*/



  .custom-link {
    background-color: #a60930;
    /*background-color: #28a745;*/
    cursor: pointer;
  }

  .custom-link:hover {
    background-color: #d00c3d;
  }

  .voucher-type-icon {
    height: 48px;
    width: auto;
    object-fit: contain;
  }

  .btn-voucher-type {
    color: #555;
    background-color: lightgray;
    border-color: #ccc;
    box-shadow: none;
  }

  .btn-voucher-type.active {
    color: #ffffff;
    background-color: #007bff;
    border-color: #007bff;
    box-shadow: none;
  }

  .btn-voucher-type.active:hover {
    color: #ffffff;
    background-color: #0069d9;
    border-color: #0062cc;
  }

  .btn-voucher-type img.white-icon {
    display: none;
  }

  .btn-voucher-type.active img.white-icon {
    display: inline-block;
  }

  .btn-voucher-type.active img {
    display: none;
  }

  .voucher-type-selection .btn-light img.white-icon {
    display: none;
  }

  .voucher-type-selection .btn-light img:not(.white-icon) {
    display: inline-block;
  }

  .voucher-type-selection .btn-success img.white-icon,
  .voucher-type-selection .btn-primary img.white-icon {
    display: inline-block;
  }

  .voucher-type-selection .btn-success img:not(.white-icon),
  .voucher-type-selection .btn-primary img:not(.white-icon) {
    display: none;
  }
</style>
