<template>
  <div class="row">
    <div v-if="record" class="col-12 border-bottom border-2 mb-3">
      <div class="d-flex flex-row justify-content-between">
        <div class="record-title flex-grow-1">
          <h3 v-if="record && record[titleField].length>0" class="d-inline mr-2">{{ record[titleField] }}</h3>
          <h3 class="d-inline">[{{ record.id===0 ? $t('general.new') : $t('general.edit') }}]</h3>
        </div>
        <div class="btn-toolbar mb-1 flex-grow-0" role="toolbar" aria-label="Toolbar with buttons">
          <button v-for="buttonInfo in buttonInfos"
                  :key="buttonInfo.command"
                  class="btn min-width-80"
            type="button"
            @click="onCommand(buttonInfo.command)"
            :class="'btn-'+buttonInfo.variant">
            <template v-if="buttonInfo.toggleSpinner">
              <i v-if="loading" class="fa fa-spinner fa-spin"></i>
              <i v-else :class="buttonInfo.iconClass"></i>
            </template>
            <template v-else>
              <i :class="buttonInfo.iconClass"></i>
            </template>
            {{ $t(buttonInfo.captionTag) }}
          </button>

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
  export default {
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
      }
    },
    data () {
      return {
        buttonInfos: []
      }
    },
    mounted () {
      const vm = this
      vm.updateButtonInfos()
    },
    methods: {
      onCommand (command) {
        const vm = this
        switch(command) {
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
        for(let i = 0; i < vm.buttons.length; i++) {
          switch (vm.buttons[i]) {
            case 'back':
              vm.buttonInfos.push({
                command: 'back',
                variant: 'outline-secondary',
                captionTag: 'buttons.back',
                iconClass: 'fas fa-reply',
                toggleSpinner: false
              })
              break
            case 'save':
              vm.buttonInfos.push({
                command: 'save',
                variant: 'primary',
                captionTag: 'buttons.save',
                iconClass: 'fas fa-save',
                toggleSpinner: true
              })
              break
          }
        }
      }
    }
  }
</script>