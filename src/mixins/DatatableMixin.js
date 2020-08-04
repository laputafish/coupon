import Vue from 'vue'
import dialogMixin from '@/mixins/DialogMixin'
import appMixin from '@/mixins/AppMixin'
import dtCommon from '@/views/comps/datatable'
import sectionHeader from '@/views/layouts/comps/SectionHeader'
import forceDeleteDialog from '@/views/comps/dialogs/ForceDeleteDialog'

const mixin = Vue.util.mergeOptions(appMixin, {
  template: `<div>
      <section-header :title="$t(moduleNameTag)"
        :breadcrumb="breadcrumb"></section-header>
    
      <!-- Main content -->
      <section class="content">
        <div class="bg-module mx-2 p-2">
          <div v-if="mode==='list'" class="container-fluid">
            <div class="row">
              <div v-if="tableFilters.length>0" class="col-12 text-center mb-2">
                <div class="btn-group">
                  <button class="btn min-width-80"
                    v-for="filter in tableFilters"
                    @click="selectedFilter=filter.value"
                    :key="filter.value"
                    :class="{'btn-primary':selectedFilter===filter.value,'btn-default':selectedFilter!==filter.value}">
                    {{ filter.caption }}
                  </button>
                </div>
              </div>
              <div class="col-12">
                <div class="btn-toolbar mb-1 justify-content-between align-items-center"
                 role="toolbar" 
                 aria-label="Toolbar with buttons">
                  <h4 class="d-inline-block mr-2 my-0">                
                     <font-awesome-icon icon="search" />
                  </h4>
                  <form @submit.prevent="search()">
                    <div class="form-group m-0 d-inline-block" style="max-width:300px;">
                      <div class="input-group">
                        <input class="form-control" v-model="searchValue">
                        <div class="input-group-append">
                          <button type="button" @click="setSearchValue('')"><i class="fas fa-fw fa-times"></i></button>
                        </div>
                      </div>                                      
                    </div>
                  </form>
                  <h3 v-if="loading" class="d-inline-block ml-3 my-0 mr-auto">                
                     <font-awesome-icon icon="spinner" class="fa-spin" />
                  </h3>
                  <button type="button"
                          @click="onCommandHandler({command: 'new'})"
                          class="btn btn-primary ml-auto">
                    <i class="fas fa-plus"></i>
                  </button>
                </div>
              </div>
              <div :id="tableId" class="col-12">
                <datatable v-cloak v-bind="$data"></datatable>
              </div>
              <!-- /.col -->
            </div>
          </div>
          <data-record v-else :recordId="selectedId"></data-record>
        </div>
        <!-- /.row -->
      </section>
      <force-delete-dialog id="forceDeleteDialog" :title="$t('general.confirmation')"
        :messages="forceDeleteMessage"
        @onCommand="onCommandHandler">     
      </force-delete-dialog>
    </div>`,
  mixins: [dialogMixin],
  components: {
    sectionHeader,
    ...dtCommon,
    forceDeleteDialog
  },
  data () {
    return {
      tableFilters: [],
      selectedFilter: 0,
      searchValue: '',
      searchable: false,
      loading: false,
      mode: 'list', // list or record

      data: [],
      total: 0,
      query: {
        filter: '',
        offset: 0,
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
      searchInputTimer: 0,

      // ForceDeleteDialog
      forceDeleteMessage: ''
    }
  },
  mounted () {
    const vm = this
    // console.log('DatatableMixin :: mounted')
    if (typeof vm.onMounting === 'function') {
      vm.onMounting()
    }
    // check if param id exists, and change to either list or record
    vm.updateMode()
  },
  created () {
    this.xprops.eventbus.$on('onRowCommand', this.onRowCommandHandler)
  },
  computed: {
    user () {
      return this.$store.getters.user
    }
  },
  destroyed () {
    this.xprops.eventbus.$off('onRowCommand')
  },
  methods: {
    // onProcessingRowCommand (payload) {
    //   const vm = this
    //   let result = false
    //   switch (payload.command) {
    //     case 'onClick':
    //       vm.editRow(payload.row)
    //       result = true
    //       break
    //   }
    //   return result
    // },
    newRecord () {
      const vm = this
      let data = {
        urlCommand: vm.apiPath + '/0',
        // urlCommand: '/vouchers/0',
      }
      vm.$store.dispatch('AUTH_GET', data).then(response => {
          if (typeof vm.onRecordCreated === 'function') {
            // console.log('newRecord :: onRecordCreated is function')
            vm.onRecordCreated(response)
          } else {
            console.log('newRecord :: onRecordCreated is not function')
            vm.$router.push({name: vm.routeName, params: {id: response.data.id}})
          }
        },
        error => {
          vm.$toaster.warning(error.message)
        }
      )
    },

    onCommandHandler (payload) {
      const vm = this
      const command = payload.command
      switch (command) {
        case 'new':
          vm.newRecord()
          break
        case 'deleteByForce':
          vm.doDeleteRow(vm.selectedRow, () => {
            vm.selectedRow = null
          })
          break
      }
    },

    onRowCommandHandler (payload) {
      const vm = this
      const command = payload.command
      let handled = false

      // console.log('onRowCommandHandler :: payload: ', payload)
      if (typeof vm.onProcessingRowCommand === 'function') {
        handled = vm.onProcessingRowCommand(payload)
      }

      if (!handled) {
        let row = payload.row
        switch (command) {
          case 'onClick':
            vm.editRow(row)
            break
          case 'edit':
            vm.editRow(row)
            break
          case 'duplicate':
            vm.duplicateRow(row)
            break
          case 'delete':
            vm.confirmDialog(row, () => {
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
    confirmDialog (row, callback) {
      const vm = this
      vm.confirmDelete(callback)
    },
    editRow (row) {
      const vm = this
      let url = '/' + vm.routeName + '/' + row.id
      vm.$router.push(url)
    },
    print (record) {
      alert('not defined yet')
    },
    // deleteRow (row) {
    //   const vm = this
    //   let handled = false
    //   if (typeof vm.deletionAllowed === 'function') {
    //     console.log('deletionAllowed is function')
    //     const allowed = vm.deletionAllowed(row)
    //     if (!allowed) {
    //       vm.selectedRow = row
    //       vm.forceDeleteMessage = vm.$t('messages.areYouSure')
    //       vm.$bvModal.show('forceDeleteDialog')
    //       handled = true
    //     }
    //   } else {
    //     console.log('deletionAllowed is not function')
    //   }
    //   if (!handled) {
    //     vm.$dialog.prompt({
    //       title: vm.$t('general.confirmation'),
    //       body: vm.$t('messages.areYouSure')
    //     }).then(
    //       () => {
    //         alert('delete')
    //         vm.doDeleteRow(row)
    //       }
    //     )
    //   }
    // },

    deleteRow (row) {
      const vm = this
      let data = {
        urlCommand: vm.apiPath + '/' + row.id
      }
      vm.loading = true
      vm.$store.dispatch('AUTH_DELETE', data).then(
        () => {
          vm.loading = false
          vm.selectedId = 0
          vm.onQueryChangedHandler()
          vm.$toaster.success(vm.$t('messages.successfully_deleted'))
          vm.refreshDataList()
        },
        error => {
          vm.loading = false
          vm.$toaster.error(vm.$t('messages.' + error.messageTag))
        }
      )
    },
    updateMode () {
      const vm = this

      // console.log('DatatableMixin :: updateMode  route.params.id = [' + vm.$route.params.id + ']')
      // console.log('typeof vm.$route.params.id = ' + (typeof vm.$route.params.id))
      // console.log('vm.route.params.id: ' + (vm.$route.params.id ? 'yes' : 'no'))
      // console.log('vm.route.params.id === 0: ' + (vm.$route.params.id === '0' ? 'yes' : 'no'))

      if (vm.$route.params.id || vm.$route.params.id === 0) {
        // console.log('vm.route.params.id existes')
        if (vm.$route.params.id !== '') {
          // console.log('vm.route.params.id not empty')
          vm.mode = 'record'
          vm.selectedId = parseInt(vm.$route.params.id)
        } else {
          vm.mode = 'list'
        }
      } else {
        vm.mode = 'list'
        // console.log('vm.route.params.id not exists. id = ' + vm.$route.params.id)
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
      const vm = this
      if (vm.apiPath === '') return

      if (typeof query === 'undefined') {
        query = vm.query
      }
      const data = {
        urlCommand: vm.apiPath,
        query: query
      }

      vm.loading = true
      // console.log('refreshDataList query: ', query)
      vm.$store.dispatch('AUTH_GET', data).then(response => {
        // console.log('refreshDataList :: response: ', response)
        vm.loading = false
        vm.data = response.data
        if (response.current_page) {
          vm.total = response.total
          vm.query.page = response.current_page
          vm.query.offset = (vm.query.page - 1) * vm.query.limit
        }
        if (typeof vm.onDataLoaded === 'function') {
          vm.data = vm.onDataLoaded(vm.data)
        }
      }, () => {
        vm.loading = false
        vm.showSessionExpired('module data')
      })
    },
    // refreshDataRecord (id) {
    //   const vm = this
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
    setSearchValue (search) {
      const vm = this
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
    search () {

    }
  },
  watch: {
    '$route.params.id': function (newValue) {
      const vm = this
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
          clearTimeout(vm.searchInputTimer)
        }
        vm.searchInputTimer = setTimeout(vm.setSearchValue, 2000)
      } else {
        vm.alert('No filter fields defined!')
      }
    },
    query: {
      handler (query) {
        const vm = this
        vm.onQueryChangedHandler(query)
      },
      deep: true
    }
  }
})

export default mixin
