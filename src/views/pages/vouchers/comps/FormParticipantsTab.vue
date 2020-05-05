<template>
  <b-tab class="bg-white py-2">
    <template v-slot:title>
      {{ title }}
      <div v-if="participantCount>0"
           class="badge badge-warning">
        {{ participantCount }}
      </div>
    </template>
    <div class="container-fluid">
      <div class="row">
        <div class="col-12">
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
            <div v-if="data.length>0" id="participant-table">
              <datatable v-cloak v-bind="$data"
                         :columns="columns"></datatable>
            </div>
          </div>
        </div>
      </div>
    </div>
  </b-tab>
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
  computed: {
    participantCount () {
      const vm = this
      var result = 0
      if (vm.record && vm.record.participantCount > 0) {
        result = vm.record.participantCount
      }
      return result
    },
    inputObjs () {
      const vm = this
      var result = []
      if (vm.record && vm.form_configs && vm.form_configs['input_objs']) {
        result = vm.form_configs['input_objs']
      }
      return result
    }
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
        actionButtonSize: 'xs'
      },
      HeaderSettings: false,
      selectedRow: null
    }
  },
  watch: {
    inputObjs: function(newVal) {
      const vm = this
      vm.setColumns(newVal)
    }
  },
  mounted () {
    const vm = this
    vm.setColumns(vm.inputObjs)
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
    onRowCommandHandler (payload) {
      const vm = this
      const command = payload.command
      const row = payload.row
    },
    setColumns (inputObjs) {
      const vm = this
      vm.columns = [{
        title: vm.$t('general.number'),
        tdClass: 'text-center',
        thClass: 'text-center',
        tdComp: 'TdCommonIndex',
        field: 'id'
      }];

      for (var i = 0; i < inputObjs.length; i++) {
        var inputObj = inputObjs[i]
        switch (inputObj.inputType) {
        }
      }
    }
  },
  props: {
    title: {
      type: String,
      default: 'No Title'
    },
    record: {
      type: Object,
      default: null
    },
    appLoading: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style>

</style>
