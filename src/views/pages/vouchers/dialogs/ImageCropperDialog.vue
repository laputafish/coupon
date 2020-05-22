<template>
  <base-dialog
      id="imageCropperDialog"
      :title="title"
      modalType="confirmation"
      size="xl"
      :okButtonState="true"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div class="left-pane">
        Image
        <div class="left-pane-scroll d-flex flex-column">
          <div class="cut" style="width:800px;height:400px;">
            <vue-cropper ref="cropper"
                         :img="imageSrc"
                         :output-size="option.outputSize"
                         :output-type="option.outputType"
                         :info="option.info"
                         :full="option.full"
                         :fixed="option.fixed"
                         :fixed-number="option.fixedNumber"
                         :canMoveBox="true"
                         :canMove="true"
                         :auto-crop="option.autoCrop"
                         :auto-crop-width="option.autoCropWidth"
                         :auto-crop-height="option.autoCropHeight"
                         :fixed-box="option.fixedBox"
                         :original="option.original"
                         :mode="option.mode"
                         :center-box="option.centerBox"
                         @real-time="realTime"
                         @img-load="imgLoad"></vue-cropper>
          </div>
        </div><!-- left-pane-scroll -->
      </div><!-- left-pane -->
      <div class="right-pane">
        Preview
        <div class="right-pane-scroll">
          <!--<div class="rectangle-stencil" :style="style">-->
          <!--<preview-result-->
          <!--classname="circle-stencil__preview"-->
          <!--:img="img"-->
          <!--:width="stencilCoordinates.width"-->
          <!--:height="stencilCoordinates.height"-->
          <!--:coordinates="resultCoordinates"-->
          <!--/>-->
          <!--</div>-->
          <div v-if="previews" class="show-preview"
               :style="{'width': previews.w + 'px', 'height': previews.h + 'px',  'overflow': 'hidden', 'margin': '5px'}">
            <div>
            <!--<div :style="previews.div">-->
              <img :src="previews.url" :style="previews.img">
            </div>
          </div>
        </div><!-- right-pane-scroll -->
      </div><!-- right-pane -->

    </template>
  </base-dialog>
</template>

<script>
  import baseDialog from '@/views/comps/BaseDialog'
  import appMixin from '@/mixins/AppMixin'
  import {VueCropper} from 'vue-cropper'

  export default {
    mixins: [appMixin],
    components: {
      baseDialog,
      vueCropper: VueCropper
    },
    props: {
      voucherId: {
        type: Number,
        default: 0
      },
      mediaId: {
        type: Number,
        default: 0
      },
      title: {
        type: String,
        default: ''
      },
      value: {
        type: Boolean,
        default: false
      },
      mediaIdField: {
        type: String,
        default: ''
      }
    },
    // watch: {
    //   '$refs.cropper': function (newValue) {
    //     const vm = this
    //     alert('watch(refs.croper)')
    //     if (newValue !== null) {
    //       if (newValue) {
    //         vm.$refs.cropper.startCrop()
    //       }
    //     }
    //   }
    // },
    model: {
      prop: 'value',
      event: 'input'
    },
    data () {
      return {
        loading: false,
        option: {
          outputSize: 1,
          outputType: 'jpg',
          info: true,
          full: false,
          fixed: true,
          fixedNumber: [1, 1],
          canMove: true,
          canMoveBox: true,
          fixedBox: false,
          autoCrop: true,
          autoCropWidth: 256,
          autoCropHeight: 256,
          maxImgSize: 256,
          original: false,
          mode: 'contain', // cover',
          centerBox: true,
          high: true
        },
        previews: {}
      }
    },
    mounted () {
      // const vm = this
      // vm.$refs.cropper.startCrop()
    },
    methods: {
      change ({coordinates, canvas}) {
        // console.log(coordinates, canvas)
      },
      startCrop () {
        const vm = this
        // console.log('ImageCropperDialog::startCrop() $refs: ', vm.$refs)
        if (vm.$refs.cropper) {
          // console.log('ImageCropperDialog::startCrop() $refs.cropper is defined.')
          vm.$refs.cropper.startCrop()
        } else {
          // console.log('ImageCropperDialog::startCrop() $refs.cropper not defined.')
        }
      },
      reset () {
        const vm = this
        vm.$refs.cropper.clearCrop()
        vm.$refs.cropper.changeScale(1)
      },
      realTime (data) {
        this.previews = data
        // console.log('realTime() :: data: ', data)
      },
      imgLoad () {
        // const vm = this
        // console.log('imgLoad()')
      },

      onCommandHandler (payload) {
        const vm = this
        // console.log('imageCropperDialog :; onCommandHandler :: payload: ', payload)
        const command = payload.command
        switch (command) {
          case 'onClosing':
            vm.deleteMedia(vm.mediaId)
            break
          case 'ok':
            this.$refs.cropper.getCropBlob( blob => {
              let formData = new FormData()
              // console.log('ImageCropperDialog :: onCommandHandler ::  blob: ', blob)
              const filename = 'image-name-' + (new Date()).getTime() + '.jpg'
              formData.append('name', filename)
              formData.append('file', blob, filename)
              formData.append('width', 256)

              // console.log('ImageCropperDialog :: onCommandHandler ::  formData: ', formData)
              // const data = {
              //   urlCommand: '/media/upload',
              //   data: formData
              // }

              vm.$http.post(vm.$store.getters.apiUrl + '/media/upload',
                formData, {
                  contentType: false,
                  processData: false,
                  headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Authorization': 'bearer ' + vm.$store.getters.accessToken
                  }
                }
              ).then(
                response => {
                  // console.log('post :: response: ', response)
                  vm.$emit('onCommand', {
                    command: 'setRecordField',
                    fieldName: vm.mediaIdField,
                    fieldValue: response.data.result.imageId
                  })
                  vm.deleteMedia(vm.mediaId)
                  vm.$bvModal.hide('imageCropperDialog')
                }
              )

              // vm.$store.dispatch('AUTH_POST', data).then(
              //   response => {
              //     vm.$emit('onCommand', {
              //       command: 'setRecordField',
              //       fieldName: 'sharing_media_id',
              //       fieldValue: response.imageId
              //     })
              //     vm.deleteMedia(vm.mediaId)
              //   },
              //   error => {
              //     console.log('upload image error: ', error)
              //   }
              // )
          })
          break
        }
      },

      deleteMedia (mediaId) {
        const vm = this
        const data = {
          urlCommand: '/medias/' + mediaId
        }
        vm.$store.dispatch('AUTH_DELETE', data).then(
          response => {
            console.log('ImageCropperDialog :: AUTH_DELETE :: response: ', response)
          }
        )
      }
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
      // }
    },
    computed: {
      imageSrc () {
        const vm = this
        return vm.$store.getters.appHost + '/media/image/' + vm.mediaId
      }
    }

    // ,
    // computed: {
    //   style() {
    //     const { height, width, left, top } = this.stencilCoordinates;
    //     return {
    //       width: `${width}px`,
    //       height: `${height}px`,
    //       left: `${left}px`,
    //       top: `${top}px`
    //     };
    //   }
    // }
  }
</script>

<style>
  #imageCropperDialog .left-pane {
    display: block;
    padding-right: 10px;
    flex-grow: 1;
    overflow-y: hidden;
  }

  #imageCropperDialog .left-pane-scroll {
    /*overflow-x: hidden;*/
    height: 0;
    min-height: 100%;
  }

  #imageCropperDialog .right-pane {
    display: block;
    flex-grow: 0;
  }

  #imageCropperDialog .right-pane-scroll {
    overflow: hidden;
    height: 0;
    min-height: 100%;
    width: 266px;
  }

  #imageCropperDialog .right-pane-scroll .voucher-item-description {
    line-height: 1.1;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }

  #imageCropperDialog .right-pane-scroll .voucher-item-notes {
    line-height: 1;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }

  #imageCropperDialog .right-pane-scroll .voucher-item-notes {
    color: rgba(0, 0, 0, .6);
  }

  #imageCropperDialog .right-pane-scroll .show-preview img {
    width: 256px;
    height: auto;
    object-fit: contain;
  }

  #imageCropperDialog .right-pane-scroll .voucher-item-title-block {
    height: 32px;
  }

  #imageCropperDialog {
    display: flex !important;
    flex-direction: column;
  }

  #imageCropperDialog .modal-dialog {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    width: 100%;
  }

  #imageCropperDialog .modal-dialog [role=document] {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
  }

  #imageCropperDialog .modal-dialog [role=document] .modal-body {
    flex-grow: 1;
    display: flex;
    flex-direction: row;
  }

  #imageCropperDialog .list-group-item.active {
    background-color: #0080ff;
  }

  #imageCropperDialog .list-group-item.active:hover {
    background-color: #3299ff;
  }

  #imageCropperDialog .list-group-item:hover {
    background-color: #f6f6f6;
  }

  #imageCropperDialog .list-group-item {
    cursor: pointer;
  }

  #imageCropperDialog .list-group-item.voucher-item {
    padding: 0.35rem 0.7rem;
  }

  #imageCropperDialog .list-group-item .voucher-note {
    color: rgba(0, 0, 0, .3);
  }

  #imageCropperDialog .list-group-item .voucher-note .note-value {
    color: black
  }

  #imageCropperDialog .list-group-item.active .voucher-note {
    color: rgba(255, 255, 255, .5);
  }

  #imageCropperDialog .list-group-item.active .voucher-note .note-value {
    color: white;
  }

  #imageCropperDialog .modal-dialog [role=document] {
    max-height: 520px;
  }

  .circle-stencil {
    border-radius: 50%;
    cursor: move;
    position: absolute;
    border: dashed 2px white;
    box-sizing: border-box;

  &
  __handler {
    position: absolute;
    right: 15%;
    top: 14%;
    z-index: 1;
    cursor: ne-resize;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    transform: translate(50%, -50%);
  }

  &
  __preview {
    border-radius: 50%;
    overflow: hidden;
  }

  }

</style>