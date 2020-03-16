<template>
  <div class="row">
    <div v-if="record" class="col-12 border-bottom border-2 mb-3">
      <div class="d-flex flex-row justify-content-between">
        <div class="record-title flex-grow-1">
          <h3 v-if="record && record[titleField].length>0" class="d-inline mr-2">{{ record[titleField] }}</h3>
          <h3 class="d-inline">[{{ record.id===0 ? $t('general.new') : $t('general.edit') }}]</h3>
        </div>
        <div class="btn-toolbar mb-1 flex-grow-0 justify-content-end" role="toolbar" aria-label="Toolbar with buttons">
          <title-row-button v-for="buttonInfo in buttonInfos"
                            :key="buttonInfo.command"
                            :loading="loading"
                            :buttonInfo="buttonInfo"
                            @onCommand="onCommandHandler"></title-row-button>
          <!--<button v-for="buttonInfo in buttonInfos"-->
          <!--:key="buttonInfo.command"-->
          <!--class="btn min-width-100"-->
          <!--type="button"-->
          <!--@click="onCommand(buttonInfo.command)"-->
          <!--:class="'btn-'+buttonInfo.variant">-->
          <!--<font-awesome-icon-->
          <!--:icon="currentIcon"-->
          <!--:class="currentIconClass"></font-awesome-icon>-->
          <!--&lt;!&ndash;<i v-else :class="buttonInfo.iconClass"></i>&ndash;&gt;-->

          <!--&lt;!&ndash;<font-awesome-icon&ndash;&gt;-->
          <!--&lt;!&ndash;v-if="loading"&ndash;&gt;-->
          <!--&lt;!&ndash;icon="spinner"></font-awesome-icon>&ndash;&gt;-->
          <!--&lt;!&ndash;<i v-else :class="buttonInfo.iconClass"></i>&ndash;&gt;-->
          <!--{{ $t(buttonInfo.captionTag) }}-->
          <!--</button>-->

          <!--<button type="button"-->
          <!--@click="onCommand('back')"-->
          <!--class="btn btn-outline-secondary min-width-80">-->
          <!--<i class="fas fa-reply"></i>&nbsp;{{ $t('buttons.back') }}-->
          <!--</button>-->
          <!--<button type="button"-->
          <!--@click="save()"-->
          <!--class="btn btn-primary min-width-80">-->
          <!--<i v-if="loading" class="fa fa-spinner fa-spin"></i>-->
          <!--<i v-else class="fas fa-save"></i>-->
          <!--{{ $t('buttons.save') }}-->
          <!--</button>-->
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import titleRowButton from './TitleRowButton'

  export default {
    components: {
      titleRowButton
    },
    props: {
      record: {
        type: Object,
        default: null
      },
      titleField: {
        type: String,
        default: ''
      },
      buttons: {
        type: Array,
        default () {
          return []
        }
      },
      loading: {
        type: Boolean,
        default: false
      },
      processingButtons: {
        type: Array,
        default () {
          return []
        }
      }
    },
    watch: {
      loading: function (newValue) {
        const vm = this
        // console.log('TitleRow :: watch(loading) : ' + newValue)
        if (newValue) {
          vm.currentIcon = 'spinner'
          vm.currentIconClass = 'spin'
        } else {
          vm.currentIcon = 'user',
            vm.currentIconClass = ''
        }
      }
    },
    data () {
      return {
        buttonInfos: [],
        currentIcon: 'user',
        currentIconClass: ''
      }
    },
    mounted () {
      const vm = this
      vm.updateButtonInfos()
    },
    methods: {
      isSpinnerActive (processingState) {
        const vm = this
        return vm.loading ||
          (
            processingState &&
            vm.processingButtons.indexOf(processingState) >= 0
          )
      },
      onCommandHandler (payload) {
        const command = payload.command
        // console.log('TitleRow :; onCommandHandler :; command = ' + command)
        const vm = this
        switch (command) {
          case 'save':
            vm.$emit('onCommand', {command: 'save'})
            break
          case 'back':
            vm.$router.go(-1)
            break
          default:
            vm.$emit('onCommand', {
              command: command
            })
        }
      },
      updateButtonInfos () {
        const vm = this
        vm.buttonInfos = []
        for (let i = 0; i < vm.buttons.length; i++) {
          switch (vm.buttons[i]) {
            case 'back':
              vm.buttonInfos.push({
                command: 'back',
                variant: 'outline-secondary',
                captionTag: 'buttons.back',
                // iconClass: 'fas fa-reply',
                iconClass: 'reply',
                toggleSpinner: false
              })
              break
            case 'save':
              vm.buttonInfos.push({
                command: 'save',
                variant: 'primary',
                captionTag: 'buttons.save',
                // iconClass: 'fas fa-save',
                iconClass: 'save',
                processingState: 'saving',
                toggleSpinner: true
              })
              break
            case 'save_and_back':
              vm.buttonInfos.push({
                command: 'save_and_back',
                variant: 'primary',
                captionTag: 'buttons.save_and_back',
                // iconClass: 'fas fa-save',
                iconClass: 'save',
                processingState: 'savingAndBack',
                toggleSpinner: true
              })
              break
          }
        }
      }
    }
  }
</script>