<template>
<div class="py-2 px-3 form-participants-table">
  <div class="toolbar d-flex justify-content-between mb-1">
    <search-field
        :searchValue="searchValue"
        :appLoading="appLoading"></search-field>
    <div>
      <button type="button"
              :disabled="data.length===0"
              class="btn btn-warning min-width-100 mr-1"
              @click="exportExcel()">
        <i class="fas fa-download"></i>
        <span class="ml-2">{{ $t('buttons.export') }}</span>
      </button>
    </div>
  </div>
  <div id="participant-table">
    <datatable v-cloak v-bind="$data"
               :columns="columns"></datatable>
  </div>
  <!--<div v-if="data.length>0" id="participant-table">-->
  <!--<datatable v-cloak v-bind="$data"-->
  <!--:columns="columns"></datatable>-->
  <!--</div>-->
</div>
</template>

<script>
import Vue from 'vue'
import dtCommon from '@/views/comps/datatable'
import dtComps from './dtComps'
import searchField from './comps/SearchField'

export default {
  components: {
    ...dtCommon,
    ...dtComps,
    searchField
  },
  data () {
    return {
      appLoading: false,
      columns: [],
      allData: [],
      data: [],
      total: 0,
      query: {
        filter: '',
        sort: '',
        order: '',
        page: 0
      },
      xprops: {
        buttons: ['delete', 'update'],
        eventbus: new Vue(),
        actionButtonSize: 'xs',
        optionalChoices: []
      },
      HeaderSettings: false,
      selectedRow: null,
      searchValue: '',
      searchInputTimer: 3000,
      filterFields: '*'
    }
  },
  computed: {
    userInputObjs () {
      const vm = this
      var result = []
      for (var i = 0; i < vm.inputObjs.length; i++) {
        var inputObj = vm.inputObjs[i]
        var inputType = inputObj['inputType']
        switch (inputType) {
          case 'output-image':
          case 'output-remark':
          case 'output-submit':
          case 'system-page':
            continue;
          default:
            result.push(inputObj)
        }
      }
      return result
    }
  },
  props: {
    voucherId: {
      type: Number,
      default: 0
    },
    inputObjs: {
      type: Array,
      default () {
        return []
      }
    },
  },
  watch: {
    userInputObjs: {
      handler: function(newVal) {
        const vm = this
        console.log('watch(inputObjs)')
        // alert('FormParticipantsTab :: watch(inputObjs): inputOBjs.length = ' + vm.inputObjs.length)
        vm.setColumns(newVal)
        vm.query.page = 1
      },
      deep: true
    },
    voucherId: {
      handler: function (newValue) {
        const vm = this
        if (vm.voucherId !== 0) {
          console.log('watch(voucherId) :: voucherId = ' + newValue)
          vm.onQueryChangedHandler(newValue)
        }
      }
    },
    query: {
      handler: function (newValue) {
        const vm = this
        if (vm.voucherId !== 0) {
          vm.onQueryChangedHandler(newValue)
        }
      },
      deep: true
    },
    searchValue: function () {
      const vm = this
      // console.log('AgentCodeTable :: searchValue = ' + newValue)
      if (vm.filterFields && vm.filterFields !== null) {
        if (vm.searchInputTimer !== 0) {
          clearTimeout(vm.searchInputTimer)
        }
        vm.searchInputTimer = setTimeout(vm.setSearchValue, 2000)
        // console.log('AgentCodeTable :: searchInputTimer: ', vm.searchInputTimer)
      } else {
        vm.alert('No filter fields defined!')
      }
    }
  },
  mounted () {
    const vm = this
    vm.setColumns(vm.userInputObjs)
    vm.query.page = 1
  },
  created () {
    const vm = this
    vm.xprops.eventbus.$on('onRowCommand', vm.onRowCommandHandler)
  },
  destroyed () {
    const vm = this
    vm.xprops.eventbus.$off('onRowCommand')
  },
  methods: {
    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      switch (command) {
        case 'search':
          vm.searchValue = payload.searchValue
          break
      }
    },
    exportExcel () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'exportParticipants'
      })
    },
    deleteAll () {
      const vm = this
      vm.$dialog.confirm(vm.$t('messages.areYouSure')).then(
        () => {
          vm.doDeleteAll()
          vm.$emit('onCommand', {
            command: 'setRecordField',
            fieldName: 'code_count',
            fieldValue: 0
          })

          // vm.$emit('onCommand', {
          //   command: 'clear_all_code_info',
          //   callback: () => {
          //     vm.$toaster.success('All codes are deleted.')
          //   }
          // })
        })
    },
    doDeleteAll () {
      const vm = this
      const data = {
        urlCommand: '/vouchers/' + vm.voucherId + '/codes'
      }
      vm.$store.dispatch('AUTH_DELETE', data).then(() => {
        vm.$toaster.success(vm.$t('messages.all_codes_are_removed'))
        vm.$emit('onCommand', {
          command: 'setQrCodeComposition',
          data: ''
        })
        vm.$emit('onCommand', {
          command: 'setCodeFields',
          value: ''
        })
        vm.onQueryChangedHandler(vm.query)
      })
    },
    setSearchValue (search) {
      const vm = this

      // console.log('setSearchValue : search: ', search)
      if (typeof search === 'undefined') {
        search = vm.searchValue
      } else {
        vm.searchValue = search
      }
      if (search) {
        vm.query.filter = vm.filterFields + ':' + search
      } else {
        vm.query.filter = ''
      }
      vm.searchInputTimer = 0
    },
    clearSearch () {
      const vm = this
      vm.query.filter = vm.filterFields + ':'
      vm.onQueryChangedHandler(vm.query)
    },
    onQueryChangedHandler (query) {
      this.reloadData(query)
    },
    reloadData (query) {
      const vm = this
      if (typeof query === 'undefined') {
        query = vm.query
      }
      if (vm.voucherId === 0) {
        return
      }
      const data = {
        urlCommand: '/vouchers/' + vm.voucherId + '/participants',
        query: query
      }
      vm.$store.dispatch('AUTH_GET', data).then(response => {
        vm.total = response.total
        vm.data = response.data
        vm.$forceUpdate()
      })
      // console.log('reloadData :: query: ', query)
      // this.data = [
      //   {
      //     id:1,
      //     field2_0:'first name',
      //     field2_1:'last name',
      //     field3: 'peter@yahoo.com',
      //     field4_0:'852',
      //     field4_1:'12345678',
      //     field5: 'address line 1',
      //     field6: 'address line 2',
      //     field8: 'know or not',
      //     field9: 'used or not',
      //     field10: 'seen in shops'
      //   }
      // ]
      // this.total = this.data.length
    },
    onRowCommandHandler (payload) {
      const vm = this
      console.log('AgentCodeTable :: onRowCommandHandler :: payload: ', payload)
      switch (payload.command) {
        case 'edit':
          alert('onRowCommandHandler :; edit')
          break
        case 'view':
          vm.$emit('onCommand', {
            command: 'view_leaflet',
            row: payload.row
          })
          break
        case 'delete':
          vm.$dialog.confirm(vm.$t('messages.areYouSure'))
            .then( () => {
              vm.$emit('onCommand', {
                command: 'delete_code_info',
                index: payload.index
              })
            })
          break
        case 'update': // = save
          vm.saveCodeInfo(payload.row);
          break
        case 'updateField':
          console.log('AgentCodeTable :: onRowCommandHandler :: updateField: payload: ', payload)
          // vm.$emit('onCommand', {
          vm.setCodeFieldValue(
            payload.row,
            // vm.row2CodeInfo(payload.row),
            payload.fieldName,
            payload.fieldValue
          )
          // )
          //   command: 'update_code_info_field',
          //   row: vm.row2CodeInfo(payload.row),
          //   fieldName: payload.fieldName,
          //   fieldValue: payload.fieldValue
          // })
          break
      }
    },
    setColumns (userInputObjs) {
      const vm = this
      vm.xprops['optionalChoices'] = {}
      console.log('setColumns :: userInputObjs: ', userInputObjs)
      vm.columns = [{
        title: vm.$t('general.number'),
        thComp: 'ThSimpleHeader',
        tdComp: 'TdCommonIndex',
        tdClass: 'text-center',
        thClass: 'text-center',
        field: 'id'
      }];

      for (var i = 0; i < userInputObjs.length; i++) {
        var userInputObj = userInputObjs[i]
        var inputType = userInputObj['inputType'];
        var fieldName = 'field' + i;
        console.log('i = ' + i + ': userInputObj: ', userInputObj)
        switch (inputType) {
          case 'simple-text':
            vm.columns.push({
              title: userInputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName
            });
            break
          case 'number':
            vm.columns.push({
              title: userInputObj.name,
              tdClass: 'text-center',
              thClass: 'text-center',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName
            })
            break
          case 'email':
            vm.columns.push({
              title: userInputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName
            });
            break
          case 'text':
            vm.columns.push({
              title: userInputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName
            });
            break
          case 'name':
            vm.columns.push({
              title: 'First Name',
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName + '_0'
            })
            vm.columns.push({
              title: 'Last Name',
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName + '_1'
            })
            break
          case 'phone':
            vm.columns.push({
              title: 'Region Code',
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName + '_0'
            });
            vm.columns.push({
              title: 'Phone No.',
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName + '_1'
            });
            break
          case 'single-choice':
            vm.columns.push({
              title: userInputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdSingleChoice',
              field: fieldName
            });
            console.log('setColumns :: fieldName = ' + fieldName)
            console.log('setColumns :: userInputObjs: ', userInputObj.options)

            vm.xprops['optionalChoices'][fieldName] = userInputObj.options

            console.log('setColumns :: xprops: ', vm.xprops)

            break
          case 'multiple-choice':
            vm.columns.push({
              title: userInputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdMultipleChoice',
              field: fieldName
            });
            vm.xprops['optionalChoices'][fieldName] = userInputObj.options
            break
        }
      }
      // vm.columns = JSON.parse(JSON.stringify(vm.columns))
      // console.log('setColumns finished :: vm.columns.length = ' + vm.columns.length)
      // console.log('setColumns finished :: vm.columns: ', vm.columns)
    },
    setColumnsxxx (inputObjs) {
      const vm = this
      vm.xprops['inputObjs'] = inputObjs;
      console.log('setColumns :: inputObjs: ', inputObjs)
      vm.columns = [{
        title: vm.$t('general.number'),
        thComp: 'ThSimpleHeader',
        tdComp: 'TdCommonIndex',
        tdClass: 'text-center',
        thClass: 'text-center',
        field: 'id'
      }];

      var index = 0;
      for (var i = 0; i < inputObjs.length; i++) {
        var inputObj = inputObjs[i]
        var inputType = inputObj['inputType'];
        if (inputType==='output-remark' || inputType==='output-image' || inputType==='output-submit' || inputType==='system-page') {
          continue;
        }

        var fieldName = 'field' + index;
        console.log('index = ' + index + ': inputObj: ', inputObj)
        switch (inputObj.inputType) {
          case 'simple-text':
            vm.columns.push({
              title: inputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName
            });
            break
          case 'number':
            vm.columns.push({
              title: inputObj.name,
              tdClass: 'text-center',
              thClass: 'text-center',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName
            })
            break
          case 'email':
            vm.columns.push({
              title: inputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName
            });
            break
          case 'text':
            vm.columns.push({
              title: inputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName
            });
            break
          case 'name':
            vm.columns.push({
              title: 'First Name',
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName + '_0'
            })
            vm.columns.push({
              title: 'Last Name',
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName + '_1'
            })
            break
          case 'phone':
            vm.columns.push({
              title: 'Region Code',
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName + '_0'
            });
            vm.columns.push({
              title: 'Phone No.',
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdCommon',
              field: fieldName + '_1'
            });
            break
          case 'single-choice':
            vm.columns.push({
              title: inputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdSingleChoice',
              field: fieldName
            });
            break
          case 'multiple-choice':
            vm.columns.push({
              title: inputObj.name,
              tdClass: 'text-left',
              thClass: 'text-left',
              thComp: 'ThSimpleHeader',
              tdComp: 'TdMultipleChoice',
              field: fieldName
            });
            break
        }
        index++
      }
      // vm.columns = JSON.parse(JSON.stringify(vm.columns))
      // console.log('setColumns finished :: vm.columns.length = ' + vm.columns.length)
      // console.log('setColumns finished :: vm.columns: ', vm.columns)

    }
  }
}
</script>
