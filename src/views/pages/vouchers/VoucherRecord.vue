<template>
  <div class="container-fluid">
    <div class="row">
      <div v-if="record" class="col-12 border-bottom border-2 mb-3">
        <div class="d-flex flex-row justify-content-between">
          <div class="record-title flex-grow-1">
            <h2 v-if="record && record.description.length>0" class="d-inline mr-2">{{ record.description }}</h2>
            <h2 class="d-inline">[{{ recordId===0 ? $t('general.new') : $t('general.edit') }}]</h2>
          </div>
          <div class="btn-toolbar mb-1 flex-grow-0" role="toolbar" aria-label="Toolbar with buttons">
            <button type="button"
                    @click="save()"
                    class="btn btn-primary">
              <i class="fas fa-save"></i>&nbsp;{{ $t('buttons.save') }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="row" v-if="record">
      <div class="col-sm-6">
        <div class="form-group">
          <label for="description">{{ $t('general.description') }}</label>
          <input class="form-control" id="description" name="description" type="text" v-model="record.description"/>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="form-group">
          <label for="activation_date">{{ $t('vouchers.activation_date') }}</label>
          <!--<input class="form-control" id="activation_date" name="activation_date"-->
                 <!--type="date"-->
                 <!--v-model="record.activation_date"/>-->
          <date-picker v-model="record.activation_date" valueType="format"></date-picker>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="form-group">
          <label for="expiry_date">{{ $t('vouchers.expiry_date') }}</label>
          <!--<input class="form-control" id="expiry_date" name="expiry_date"-->
                 <!--type="date"-->
                 <!--v-model="record.expiry_date"/>-->
          <date-picker v-model="record.expiry_date" valueType="format"></date-picker>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="form-group">
          <label for="created_at">{{ $t('vouchers.creation_date') }}</label>
          <!--<input readonly class="form-control" id="created_at" name="created_at"-->
                 <!--type="date"-->
                 <!--v-model="record.created_at"/>-->
          <date-picker v-model="record.created_at" valueType="format"></date-picker>
        </div>
      </div>
    </div>
    <div style="background-color:#EEEEEE;" class="p-2">
      <b-tabs content-class="py-2" class="bg-white">
        <b-tab title="Agent Codes & Emails">
          <div class="container-fluid">
            <div class="row">
              <div class="col-7">
                <agent-code-table :voucherId="recordId"></agent-code-table>
              </div>
              <div class="col-5">
                <email-table :voucherId="recordId"></email-table>
              </div>
            </div>
          </div>
        </b-tab>
        <b-tab title="Leaflet Template">
          <div class="container-fluid">
            <div class="row">
              <div class="col-12">
              </div>
            </div>
            <div class="row" v-if="record">
              <div class="col-12">
                <tinymce id="leaflet-template" v-model="record.template"></tinymce>
                HTML Code
                <textarea rows="16" v-model="record.template" class="w-100 mt-2"></textarea>
              </div>
            </div>
          </div>
        </b-tab>
      </b-tabs>
    </div>
  </div>
</template>

<script>
import agentCodeTable from './comps/AgentCodeTable'
import emailTable from './comps/EmailTable'
import tinymce from 'vue-tinymce-editor'
import datePicker from 'vue2-datepicker'
import 'vue2-datepicker/index.css';

export default {
  components: {
    agentCodeTable,
    emailTable,
    tinymce,
    datePicker
  },
  data () {
    return {
      apiPath: '/vouchers',
      record: null,
      content: '<table class="border bg-gray"><tr><td>sdfdsfdsfs<br/>sdlfksdlfjds</td></tr></table>sdlkfjsdklfjds'
    }
  },
  props: {
    recordId: {
      type: Number,
      default: 0
    }
  },
  watch: {
    recordId: function (newValue) {
      const vm = this
      vm.refreshDataRecord(newValue)
    }
  },
  mounted () {
    const vm = this
    vm.refreshDataRecord(vm.recordId)
  },
  methods: {
    refreshDataRecord (id) {
      const vm = this
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

    save () {
      alert('save')
    },

    // inputFile(newFile, oldFile, prevent) {

    // inputFile: function (newFile, oldFile) {
    //   if (newFile && oldFile && !newFile.active && oldFile.active) {
    //     // Get response data
    //     console.log('response', newFile.response)
    //     if (newFile.xhr) {
    //       //  Get the response status code
    //       console.log('status', newFile.xhr.status)
    //     }
    //   }
    // },
    /**
     * Pretreatment
     * @param  Object|undefined   newFile   Read and write
     * @param  Object|undefined   oldFile   Read only
     * @param  Function           prevent   Prevent changing
     * @return undefined
     */

  }
}
</script>

<style>
#email-table div[name=Datatable] table tbody tr td,
#code-table div[name=Datatable] table tbody tr td {
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
}

.nav-tabs .nav-item a.nav-link.active {
  background-color: lightseagreen;
  color: white;
}
div[name=Datatable] .pagination {
  justify-content: flex-end !important;
}
</style>
