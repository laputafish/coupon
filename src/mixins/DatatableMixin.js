import Vue from 'vue'
import dialogMixin from '@/mixins/DialogMixin'
import dtCommon from '@/views/comps/datatable'

const mixin = {
  mixins: [dialogMixin],
  components: {
    ...dtCommon
  },
  data () {
    return {
      searchValue: '',
      searchable: false,
      loading: false,
      mode: 'list', // list or record

      data: [],
      total: 0,
      query: {
        filter: '',
        sort: '',
        order: ''
      },
      filterFields: '*',
      xprops: {
        buttons: ['edit', 'delete'],
        eventbus: new Vue()
      },
      tblStyle: {color: '#AAA', fontWeight: 'normal'},
      HeaderSettings: false,
      searchInputTimer: 0
    }
  },
  mounted () {
    const vm = this
    if (typeof vm.onMounting === 'function') {
      vm.onMounting()
    }
    // check if param id exists, and change to either list or record
    vm.updateMode()
  },
  created () {
    this.xprops.eventbus.$on('onRowCommand', this.onRowCommandHandler)
  },
  destroyed () {
    this.xprops.eventbus.$off('onRowCommand')
  },
  methods: {
    onRowCommandHandler (payload) {
      const vm = this
      let command = payload.command
      let handled = false

      // console.log('onRowCommandHandler :: payload: ', payload)
      if (typeof vm.onProcessingRowCommand === 'function') {
        handled = vm.onProcessingRowCommand(payload)
      }

      if (!handled) {
        let row = payload.row
        switch (command) {
          case 'edit':
            vm.editRow(row)
            break
          case 'duplicate':
            vm.duplicateRow(row)
            break
          case 'delete':
            vm.confirmDelete(() => {
              vm.deleteRow(row)
            })
            break
          case 'download':
            vm.onProcessingCommand({
              command: 'download',
              row: row
            })
            break
          case 'print':
            vm.print(row)
            break
        }
      }
    },
    editRow (row) {
      const vm = this
      let url = vm.routePath + '/' + row.id
      vm.$router.push(url)
    },
    print (record) {
      alert('not defined yet')
    },
    deleteRow (row) {
      const vm = this
      let data = {
        urlCommand: vm.apiPath + '/' + row.id
      }
      vm.$store.dispatch('COMMON_DELETE', data).then(function (response) {
        vm.selectedId = 0
        vm.onQueryChangedHandler()
      })
    },
    updateMode () {
      const vm = this
      console.log('DatatableMixin :: updateMode  route.params.id = ' + vm.$route.params.id)

      if (vm.$route.params.id && vm.$route.params.id !== '') {
        vm.mode = 'record'
        vm.refreshSelectedId(parseInt(vm.$route.params.id))
      } else {
        vm.mode = 'list'
      }
      // alert('vm.mode = ' + vm.mode)
    },
    refreshSelectedId (id) {
      const vm = this
      vm.selectedId = id
    },
    refreshData (query) {
      const vm = this
      if (vm.mode === 'list') {
        vm.refreshDataList(query)
      } else {
        vm.refreshDataRecord(vm.selectedId)
      }
    },
    refreshDataList (query) {
      let vm = this
      if (vm.apiPath === '') return

      if (typeof query === 'undefined') {
        query = vm.query
      }
      const data = {
        urlCommand: vm.apiPath,
        query: query
      }

      vm.loading = true
      vm.$store.dispatch('COMMON_GET', data).then(function (response) {
        console.log('refreshDataList :: response: ', response)
        vm.data = response.data
        vm.total = response.total
        vm.loading = false
      })
    },
    refreshDataRecord (id) {
      let vm = this
      if (vm.selectedId !== id) {
        vm.selectedId = id
      }
      const data = {
        urlCommand: vm.apiPath + '/' + id
      }
      vm.loading = true
      vm.$store.dispatch('COMMON_GET', data).then(function (response) {
        console.log('refreshDataRecord :: response: ', response)
        vm.record = response
      })
    },
    onQueryChangedHandler (query) {
      this.refreshData(query)
    },
    setSearchValue () {
      const vm = this
      vm.query.filter = vm.filterFields + ':' + vm.searchValue
      vm.searchInputTimer = 0
    },
    clearSearch () {
      const vm = this
      vm.query.filter = vm.filterFields + ':'
      vm.onQueryChangedHandler(vm.query)
    }
  },
  watch: {
    '$route.params.id': function (newValue) {
      let vm = this
      vm.refreshDataRecord(parseInt(newValue))
      vm.updateMode()
    },
    searchValue: function () {
      const vm = this
      if (vm.filterFields && vm.filterFields !== null) {
        if (vm.searchInputTimer !== 0) {
          clearTimeout(vm.timerVar)
        }
        vm.searchInputTimer = setTimeout(vm.setSearchValue, 2000)
      } else {
        vm.alert('No filter fields defined!')
      }
    },
    query: {
      handler (query) {
        let vm = this
        vm.onQueryChangedHandler(query)
      },
      deep: true
    }
  }
}

export default mixin
