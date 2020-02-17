<template>
  <div class="container-fluid">
    <title-row :record="record"
               :titleField="titleField"
               :loading="loading"
               :buttons="['back','save']"
               @onCommand="onCommandHandler"></title-row>
    <div class="row" v-if="record">
      <data-input width="6" id="name" labelTag="general.name" v-model="record.name"></data-input>
      <data-input width="3" id="alias" labelTag="general.alias" v-model="record.alias"></data-input>
      <data-input width="3" id="contact" labelTag="general.contact" v-model="record.contact"></data-input>
      <data-input width="2" id="tel_no" labelTag="general.telNo" v-model="record.tel_no"></data-input>
      <data-input width="2" id="fax_no" labelTag="general.faxNo" v-model="record.fax_no"></data-input>
      <data-input width="4" id="web_url" labelTag="general.webUrl" v-model="record.web_url"></data-input>
      <data-input width="4" id="email" labelTag="general.email" v-model="record.email"></data-input>
      <!--<data-textarea></data-textarea>-->
    </div>

    <b-modal id="errorDialog"
             v-model="showErrorDialog"
             title="Errors">
      <div v-for="(errorGroup, index) in errorGroups"
        :key="index">
        <!--
        errorGroups: [
          {field: fieldName, errors: [...]}
          ...
        ]
        -->
        <div>{{ errorGroup.field }}</div>
        <div>
          <div class="text-gray pl-5" v-for="error in errorGroup.errors" :key="error">
            {{ error }}
          </div>
        </div>
      </div>
      <template v-slot:modal-footer>
        <div class="w-100 text-right">
          <div class="btn-toolbar justify-content-end">
            <b-button
                  variant="primary"
                  size="sm"
                  class="min-width-80"
                  @click="showErrorDialog=false">
              {{ $t('buttons.close') }}
            </b-button>
          </div>
        </div>
      </template>
    </b-modal>
  </div>
</template>

<script>
  import appMixin from '@/mixins/AppMixin'
  import titleRow from '@/views/comps/TitleRow'
  import formInputs from '@/views/comps/forms'

  import DataRecordMixin from '@/mixins/DataRecordMixin'
  // import helpers from '@/helpers'

  export default {
    mixins: [DataRecordMixin, appMixin],
    components: {
      titleRow,
      ...formInputs
    },
    data () {
      return {
        showErrorDialog: false,
        apiPath: '/agents',
        titleField: 'name',
        record: null,
        loading: false,
        content: '',
        errorGroups: []
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
        vm.refresh(newValue)
      }
    },
    mounted () {
      const vm = this

      vm.refresh(vm.recordId)
    },
    methods: {
      save () {
        const vm = this
        const data = {
          urlCommand: vm.apiPath + (vm.record.id === 0 ? '' : '/' + vm.record.id),
          data: vm.record
        }
        vm.loading = true
        const action = vm.record.id === 0 ? 'AUTH_POST' : 'AUTH_PUT'
        vm.$store.dispatch(action, data).then(
          response => {
            vm.loading = false
            vm.record.id = response.id
            vm.$router.go(-1);
          },
          error => {
            vm.loading = false
            vm.showErrors(error.data)
          })
      },
      showErrors (errorObj) {
        /*
        errorObj = {
          message: ...,
          errors: {
            field1: [
              '...',
              '...'
            ],
            field2: [
              '...',
              '...'
            ]
          }
         */
        const vm = this
        vm.errorGroups = []
        for (const field in errorObj.errors) {
          vm.errorGroups.push({
            field: field,
            errors: errorObj.errors[field]
          })
        }
        vm.showErrorDialog = true
      },
      onCommandHandler (payload) {
        const vm = this
        console.log('VoucherRecord :: onCommandHandler :: command = ' + payload.command)
        switch (payload.command) {
          case 'save':
            vm.save()
            break
        }
      },
    }
  }
</script>
