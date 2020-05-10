<template>
  <base-dialog
      id="imageSelectDialog"
      :title="title"
      modalType="confirmation"
      :okButtonState="selectedImage!==null"
      size="xl"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div v-show="$refs.upload && $refs.upload.dropActive" class="drop-active">
        <h3>Drop files to upload</h3>
      </div>
      <div class="w-100 d-flex flex-column">
        <div class="mb-2">
          <data-radio-toggle
              btnClass="min-width-100"
              :options="scopeOptions"
              v-model="activeScope"></data-radio-toggle>
          <div class="footer-status float-right">
            Drop: {{$refs.upload ? $refs.upload.drop : false}},
            Active: {{$refs.upload ? $refs.upload.active : false}},
            Uploaded: {{$refs.upload ? $refs.upload.uploaded : true}},
            Drop active: {{$refs.upload ? $refs.upload.dropActive : false}}
          </div>
        </div>
        <h3 v-if="loading" class="mt-5 text-center">
          <i class="fas fa-spinner fa-spin"></i>
        </h3>
        <div class="flex-grow-1 d-flex flex-row">
          <div v-if="hasGroups" class="left-pane">
            <ul class="list-group group-list">
              <li class="list-group-item"
                  @click="selectedGroup=group"
                  :class="{'bg-primary selected':selectedGroup===group,'bg-light':selectedGroup!==group}"
                  v-for="group in groups"
                  :key="group.id">
                {{ group.name }}
              </li>
            </ul>
          </div>
          <div class="right-pane">

            <!--<div class="btn-group">-->
            <!--<button class="min-width-100 btn btn-light">Local</button>-->
            <!--<button class="min-width-100 btn btn-primary">Vouchers</button>-->
            <!--<button class="min-width-100 btn btn-light">Agents</button>-->
            <!--<button class="btn btn-light">All</button>-->
            <!--</div>-->

            <div class="right-pane-scroll">
              <div v-if="hasGroups && selectedGroup">
                <image-item
                    v-for="image in selectedGroup.images"
                    :key="image.id"
                    :imageItem="image"
                    @onCommand="onCommandHandler"
                    :activeImage="selectedImage">
                </image-item>
              </div>
              <div v-else>
                <image-item
                    v-for="image in images"
                    :key="image.id"
                    :imageItem="image"
                    @onCommand="onCommandHandler"
                    :activeImage="selectedImage">
                </image-item>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    <template v-slot:buttonBar>
      <file-upload
          class="btn btn-primary min-width-80"
          :post-action="postAction"
          :put-action="putAction"
          :extensions="extensions"
          :accept="accept"
          :multiple="multiple"
          :directory="directory"
          :size="size || 0"
          :thread="thread < 1 ? 1 : (thread > 5 ? 5 : thread)"
          :headers="headers"
          :data="data"
          :drop="drop"
          :drop-directory="dropDirectory"
          :add-index="addIndex"
          v-model="files"
          @input-filter="inputFilter"
          @input-file="inputFile"
          ref="upload">
        <i class="fad fa-upload"></i>
        Upload
      </file-upload>
      <button class="min-width-80 btn btn-primary">OK</button>
      <button class="min-width-80 btn btn-secondary"
              @click="closeDialog">Cancel</button>
    </template>
  </base-dialog>
</template>

<script>
  import baseDialog from '@/views/comps/BaseDialog'
  import appMixin from '@/mixins/AppMixin'
  import imageItem from './comps/ImageItem'
  import dataRadioToggle from '@/views/comps/forms/DataRadioToggle'
  import fileUpload from 'vue-upload-component'
  import ImageCompressor from 'image-compressor'

  export default {
    mixins: [appMixin],
    components: {
      baseDialog,
      imageItem,
      dataRadioToggle,
      fileUpload
    },
    props: {
      id: {
        type: String,
        default: ''
      },
      title: {
        type: String,
        default: ''
      },
      voucher: {
        type: Object,
        default: null
      },
      value: {
        type: Boolean,
        default: false
      },
      initialAgentId: {
        type: Number,
        default: 0
      },
      imageScope: {
        type: String,
        default: ''
      }
    },
    computed: {
      hasGroups () {
        const vm = this
        return vm.activeScope!=='all' && vm.activeScope !== 'local'
      },
      agents () {
        return this.$store.getters.agents
      }
    },
    mounted () {
      const vm = this
      // vm.activeScope = vm.scopeOptions[0].value
      // vm.$nextTick(() => {
      //   console.log('mounted :: scopeOptions: ', vm.scopeOptions)
      //   console.log('mounted :: activeScope: ', vm.activeScope)
      //   vm.fetchImages()
      // })
      // vm.fetchImages()
    },
    model: {
      prop: 'value',
      event: 'input'
    },
    watch: {
      activeScope: function() {
        // alert('watch(activeScope)')
        const vm = this
        vm.fetchImages()
      },
      value: function () {
        // alert('watch(value)')
        const vm = this
        console.log('ImageSelectDialog :: watch(value)')
        // vm.fetchImages()
        vm.$nextTick(() => {
          vm.activeScope = vm.scopeOptions[0].value
        })
      }
    },
    data () {
      return {
        // upload
        files: [],
        accept: 'image/png,image/gif,image/jpeg,image/webp',
        extensions: 'gif,jpg,jpeg,png,webp',
        minSize: 1024,
        size: 1024 * 1024 * 10,
        multiple: false,
        directory: false,
        drop: true,
        dropDirectory: true,
        addIndex: false,
        thread: 3,
        name: 'file',
        postAction: '/upload/post',
        putAction: '/upload/put',
        headers: {},
        data: {
          '_csrf_token': 'xxxx'
        },
        autoCompress: 1024 * 1024,
        uploadAuto: false,
        isOption: false,

        addData: {
          show: false,
          name: '',
          type: '',
          content: '',
        },

        editFile: {
          show: false,
          name: ''
        },

        scopeOptions: [
          {name: 'Local', value: 'local'},
          {name: 'Vouchers', value: 'voucher'},
          {name: 'Agents', value: 'agent'},
          {name: 'All', value: 'all'}
        ],
        activeScope: '',
        objectFitMode: 'cover',
        loading: false,
        // selectedAgent: null,

        selectedImage: null,
        selectedGroup: null,
        groups: [],
        images: []
      }
    },
    // watch: {
    //   initialAgentId: function () {
    //     console.log('watch(initialAgentId)')
    //     this.setInitialAgent()
    //   },
    //   'selectedAgent.id': function (newValue) {
    //     const vm = this
    //     console.log('watch(selectedAgent) :: selectedAgent.id = ' + newValue)
    //     vm.selectedVoucher = null
    //     vm.fetchAgentVouchers()
    //   }
    // },
    methods: {
      closeDialog () {
        const vm = this
        vm.$emit('input',false)
        vm.$bvModal.hide('imageSelectDialog')
      },
      inputFilter(newFile, oldFile, prevent) {
        alert('inputFilter')
        if (newFile && !oldFile) {
          // Before adding a file
          // 添加文件前
          // Filter system files or hide files
          // 过滤系统文件 和隐藏文件
          if (/(\/|^)(Thumbs\.db|desktop\.ini|\..+)$/.test(newFile.name)) {
            return prevent()
          }
          // Filter php html js file
          // 过滤 php html js 文件
          if (/\.(php5?|html?|jsx?)$/i.test(newFile.name)) {
            return prevent()
          }
          // Automatic compression
          // 自动压缩
          if (newFile.file && newFile.type.substr(0, 6) === 'image/' && this.autoCompress > 0 && this.autoCompress < newFile.size) {
            newFile.error = 'compressing'
            const imageCompressor = new ImageCompressor(null, {
              convertSize: Infinity,
              maxWidth: 512,
              maxHeight: 512,
            })
            imageCompressor.compress(newFile.file)
              .then((file) => {
                this.$refs.upload.update(newFile, { error: '', file, size: file.size, type: file.type })
              })
              .catch((err) => {
                this.$refs.upload.update(newFile, { error: err.message || 'compress' })
              })
          }
        }
        if (newFile && (!oldFile || newFile.file !== oldFile.file)) {
          // Create a blob field
          // 创建 blob 字段
          newFile.blob = ''
          let URL = window.URL || window.webkitURL
          if (URL && URL.createObjectURL) {
            newFile.blob = URL.createObjectURL(newFile.file)
          }
          // Thumbnails
          // 缩略图
          newFile.thumb = ''
          if (newFile.blob && newFile.type.substr(0, 6) === 'image/') {
            newFile.thumb = newFile.blob
          }
        }
      },
      // add, update, remove File Event
      inputFile(newFile, oldFile) {
        alert('inputFile')
        if (newFile && oldFile) {
          // update
          if (newFile.active && !oldFile.active) {
            // beforeSend
            // min size
            if (newFile.size >= 0 && this.minSize > 0 && newFile.size < this.minSize) {
              this.$refs.upload.update(newFile, { error: 'size' })
            }
          }
          if (newFile.progress !== oldFile.progress) {
            // progress
          }
          if (newFile.error && !oldFile.error) {
            // error
          }
          if (newFile.success && !oldFile.success) {
            // success
          }
        }
        if (!newFile && oldFile) {
          // remove
          if (oldFile.success && oldFile.response.id) {
            // $.ajax({
            //   type: 'DELETE',
            //   url: '/upload/delete?id=' + oldFile.response.id,
            // })
          }
        }
        // Automatically activate upload
        if (Boolean(newFile) !== Boolean(oldFile) || oldFile.error !== newFile.error) {
          if (this.uploadAuto && !this.$refs.upload.active) {
            this.$refs.upload.active = true
          }
        }
      },
      fetchImages () {
        const vm = this
        vm.loading = true
        // const data = {
        //   urlCommand: '/medias',
        //   options: {
        //     params: {
        //       scope: vm.imageScope
        //     }
        //   }
        // }

        if (!vm.hasGroups) {
          vm.images = [
            {id: 1},
            {id: 2},
            {id: 3},
            {id: 4},
            {id: 5},
            {id: 6},
            {id: 7},
            {id: 8},
            {id: 9},
          ]
          vm.groups = []
        } else {
          vm.images = []
          vm.groups = [
            {
              id:1,
              name:'group 1',
              images:[
                {id: 1},
                {id: 2},
                {id: 3}
              ]
            },
            {
              id:2,
              name:'group 2',
              images:[
                {id: 1},
                {id: 2},
                {id: 3},
                {id: 4}
              ]
            },
            {
              id:3,
              name:'group 3',
              images:[
                {id: 1},
                {id: 2},
                {id: 3},
                {id: 4},
                {id: 5}
              ]
            },
            {
              id:4,
              name:'group 4',
              images:[
                {id: 1},
                {id: 2},
                {id: 3},
                {id: 4},
                {id: 5},
                {id: 6}
              ]
            }
          ]
        }
        vm.loading = false

        // vm.$store.dispatch('AUTH_GET', data).then(
        //   response => {
        //     if (vm.imageScope === 'all') {
        //       vm.images = response
        //     } else {
        //       vm.groups = response
        //     }
        //     vm.loading = false
        //   }
        // )
      },
      confirmSelectedImage () {
        const vm = this
        if (vm.selectedImage) {
          vm.$emit('onCommand', {
            command: 'selectImage',
            imageId: vm.selectedImage.id
          })
        }
      },
      onCommandHandler (payload) {
        const vm = this
        console.log('VoucherSelectDialog :; onCommandHandler :: payload: ', payload)
        const command = payload.command
        switch (command) {
          case 'onImageSelected':
            vm.selectedImage = payload.image
            break
          case 'ok':
            vm.confirmSelectedImage()
            break
        }
      }
      // setInitialAgent () {
      //   const vm = this
      //   console.log('setInitialAgent :: initialAGentId = ' + vm.initialAgentId)
      //   console.log('setInitialAgent :: agents.length = ' + vm.agents.length)
      //   if (vm.initialAgentId === 0) {
      //     vm.selectedAgent = null
      //   } else {
      //     for (let i = 0; i < vm.agents.length; i++) {
      //       if (vm.agents[i].id === vm.initialAgentId) {
      //         vm.selectedAgent = vm.agents[i]
      //         break
      //       }
      //     }
      //   }
      //   console.log('selectedAgent: ', vm.selectedAgent)
      // },
      // fetchAgentVouchers () {
      //   const vm = this
      //   if (vm.selectedAgent) {
      //     const data = {
      //       urlCommand: '/vouchers',
      //       options: {
      //         params: {
      //           agentId: vm.selectedAgent.id,
      //           type: 'selection'
      //         }
      //       }
      //     }
      //     vm.loading = true
      //     vm.$store.dispatch('AUTH_GET', data).then(
      //       response => {
      //         vm.loading = false
      //         vm.vouchers = response
      //         console.log('GET vouchers')
      //       },
      //       () => {
      //         vm.loading = false
      //         vm.showSessionExpired()
      //         // vm.$dialog.alert('Vouchers: ' + vm.$t('messages.error_during_loading'))
      //       }
      //     )
      //   }
      // }
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
  /*************************/
  /* Content Configuration */
  /*************************/
  #imageSelectDialog .left-pane {
    /*display: none;*/
    padding-right: 10px;
    width: 40%;
  }

  #imageSelectDialog .right-pane {
    width: 100%;
    display: flex;
    flex-direction: column;
  }

  #imageSelectDialog .left-pane .left-pane-scroll {
    overflow-y: scroll;
    height: 0;
    min-height: 100%;
  }

  #imageSelectDialog .right-pane .right-pane-scroll {
    overflow-y: scroll;
    flex-grow: 1;
    height: 0;
  }

  /************************/
  /* Dialog Configuration */
  /************************/
  #imageSelectDialog {
    display: flex !important;
    flex-direction: column;
  }

  #imageSelectDialog .modal-dialog {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    width: 100%;
  }

  #imageSelectDialog .modal-dialog [role=document] {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
  }

  #imageSelectDialog .modal-dialog [role=document] .modal-body {
    flex-grow: 1;
    display: flex;
    flex-direction: row;
  }

  #imageSelectDialog .list-group-item {
    cursor: pointer;
  }

  #imageSelectDialog .list-group-item.voucher-item {
    padding: 0.35rem 0.7rem;
  }

  #imageSelectDialog .list-group-item .voucher-note {
    color: rgba(0, 0, 0, .3);
  }

  #imageSelectDialog .list-group-item .voucher-note .note-value {
    color: black
  }

  #imageSelectDialog .list-group-item.active .voucher-note {
    color: rgba(255, 255, 255, .5);
  }

  #imageSelectDialog .list-group-item.active .voucher-note .note-value {
    color: white;
  }

  #imageSelectDialog .group-list li:hover {
    opacity: 0.8;
  }

  #imageSelectDialog .drop-active {
    top: 0;
    bottom: 0;
    right: 0;
    left: 0;
    position: fixed;
    z-index: 9999;
    opacity: .6;
    text-align: center;
    background: #000;
  }
  #imageSelectDialog .drop-active h3 {
    margin: -.5em 0 0;
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    -webkit-transform: translateY(-50%);
    -ms-transform: translateY(-50%);
    transform: translateY(-50%);
    font-size: 40px;
    color: #fff;
    padding: 0;
  }
</style>
