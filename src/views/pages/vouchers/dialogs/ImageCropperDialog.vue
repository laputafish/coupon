<template>
  <base-dialog
      id="imageCropperDialog"
      :title="title"
      modalType="confirmation"
      size="xl"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div class="left-pane">
        Image
        <div class="left-pane-scroll d-flex flex-column justify-content-center align-items-center">
          <div class="cut flex-grow-1" style="width:100%;height:100%;">
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
          <div v-if="previews" class="show-preview" :style="{'width': previews.w + 'px', 'height': previews.h + 'px',  'overflow': 'hidden', 'margin': '5px'}">
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

  export default {
    mixins: [appMixin],
    components: {
      baseDialog
    },
    props: {
      voucherId: {
        type: Number,
        default: 0
      },
      imageSrc: {
        type: String,
        default: ''
      },
      title: {
        type: String,
        default: ''
      },
      value: {
        type: Boolean,
        default: false
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
          fixedNumber: [1,1],
          canMove: true,
          canMoveBox: true,
          fixedBox: false,
          autoCrop: true,
          autoCropWidth: 256,
          autoCropHeight: 256,
          maxImgSize: 256,
          original: false,
          mode: 'cover',
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
      startCrop () {
        const vm = this
        console.log('ImageCropperDialog::startCrop() $refs: ', vm.$refs)
        if (vm.$refs.cropper) {
          console.log('ImageCropperDialog::startCrop() $refs.cropper is defined.')
          vm.$refs.cropper.startCrop()
        } else {
          console.log('ImageCropperDialog::startCrop() $refs.cropper not defined.')
        }
      },
      reset () {
        const vm = this
        vm.$refs.cropper.clearCrop()
        vm.$refs.cropper.changeScale(1)
      },
      realTime(data) {
        this.previews = data
        console.log('realTime() :: data: ', data)
      },
      imgLoad () {
        // const vm = this
        console.log('imgLoad()')
      },

      onCommandHandler (payload) {
        // const vm = this
        console.log('imageCropperDialog :; onCommandHandler :: payload: ', payload)
        const command = payload.command
        switch (command) {
          case 'ok':
            break
        }
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
    }
  }
</script>

<style>
  #imageCropperDialog .left-pane {
    display: block;
    padding-right: 10px;
    flex-grow:1;
    overflow-y: hidden;
  }

  #imageCropperDialog .left-pane-scroll {
    overflow-x: hidden;
    height: 0;
    min-height: 100%;
  }

  #imageCropperDialog .right-pane {
    display: block;
    flex-grow:0;
  }

  #imageCropperDialog .right-pane-scroll {
    overflow: hidden;
    height: 0;
    min-height: 100%;
    width:266px;
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
    color: rgba(0,0,0,.6);
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
    color: rgba(0,0,0,.3);
  }

  #imageCropperDialog .list-group-item .voucher-note .note-value {
    color: black
  }

  #imageCropperDialog .list-group-item.active .voucher-note {
    color: rgba(255,255,255,.5);
  }

  #imageCropperDialog .list-group-item.active .voucher-note .note-value {
    color: white;
  }

  #imageCropperDialog .modal-dialog [role=document] {
    max-height: 520px;
  }
</style>