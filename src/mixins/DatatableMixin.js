import Vue from 'vue'
import dialogMixin from '@/mixins/DialogMixin'
import dtCommon from '@/views/comps/datatable'
import sectionHeader from '@/views/layouts/comps/SectionHeader'

const mixin = {
  template: `<template>
    <div>
      <section-header :title="$t(moduleNameTag)"
        :breadcrumb="breadcrumb"></section-header>
    
      <!-- Main content -->
      <section class="content">
        <div class="bg-module mx-2 p-2">
          <div v-if="mode==='list'" class="container-fluid">
            <div class="row">
              <div class="col-12">
                <div class="btn-toolbar mb-1 justify-content-end" role="toolbar" aria-label="Toolbar with buttons">
                  <button type="button"
                          @click="Record()"
                          class="btn btn-primary">
                    <i class="fas fa-plus"></i>
                  </button>
                </div>
              </div>
              <div class="col-12">
                <datatable v-cloak v-bind="$data"></datatable>
              </div>
              <!-- /.col -->
            </div>
          </div>
          <data-record v-else :recordId="selectedId"></data-record>
        </div>
        <!-- /.row -->
      </section>
    </div>
    </template>`,
  mixins: [dialogMixin],
  components: {
    sectionHeader,
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
      tblStyle: {color: '#777', fontWeight: 'normal'},
      HeaderSettings: false,
      searchInputTimer: 0
    }
  },
  mounted () {
    const vm = this
    console.log('DatatableMixin :: mounted')
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
    newRecord () {
      let vm = this
      vm.$router.push({name: vm.routeName, params: {id: 0}})
    },
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
      let url = '/' + vm.routeName + '/' + row.id
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

      console.log('DatatableMixin :: updateMode  route.params.id = [' + vm.$route.params.id + ']')
      console.log('typeof vm.$route.params.id = ' + (typeof vm.$route.params.id))
      console.log('vm.route.params.id: ' + (vm.$route.params.id ? 'yes' : 'no'))
      console.log('vm.route.params.id === 0: ' + (vm.$route.params.id === '0' ? 'yes' : 'no'))

      if (vm.$route.params.id || vm.$route.params.id === 0) {
        console.log('vm.route.params.id existes')
        if (vm.$route.params.id !== '') {
          console.log('vm.route.params.id not empty')
          vm.mode = 'record'
          vm.selectedId = parseInt(vm.$route.params.id)
        } else {
          vm.mode = 'list'
        }
      } else {
        vm.mode = 'list'
        console.log('vm.route.params.id not exists. id = ' + vm.$route.params.id)
      }
      // alert('vm.mode = ' + vm.mode)
    },
    refreshData (query) {
      const vm = this
      if (vm.mode === 'list') {
        vm.refreshDataList(query)
      }
      // else {
      //   vm.refreshDataRecord(vm.selectedId)
      // }
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
    // refreshDataRecord (id) {
    //   let vm = this
    //   if (vm.selectedId !== id) {
    //     vm.selectedId = id
    //   }
    //   const data = {
    //     urlCommand: vm.apiPath + '/' + id
    //   }
    //   vm.loading = true
    //   vm.$store.dispatch('COMMON_GET', data).then(function (response) {
    //     console.log('refreshDataRecord :: response: ', response)
    //     vm.record = response
    //   })
    // },
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
      vm.selectedId = newValue
      vm.updateMode()
      if (!newValue) {
        vm.refreshData()
      }
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
