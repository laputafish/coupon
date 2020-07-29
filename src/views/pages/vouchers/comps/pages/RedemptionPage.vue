<template>
  <div>
      <div class="row pt-2">
        <div class="col-sm-12">
          <div class="form-group mb-3">
            <label>Redemption Method</label>
            <div class="form-control p-0 border-0">
              <data-radio-toggle
                  :options="redemptionOptions"
                  btnClass="min-width-80"
                  v-model="record.redemption_method"></data-radio-toggle>
            </div>
          </div>
        </div>
      </div>
      <div class="row" v-if="['qrcode','qrcode_password'].indexOf(record.redemption_method)>=0">
        <div class="col-sm-12 position-relative d-flex flex-row justify-content-between align-items-end">
          <label>Locations</label>
          <div class="position-absolute" style="right:0;">
            <button class="btn btn-outline-primary min-width mr-1"
              @click="refresh">
              <font-awesome-icon class="mr-2" icon="sync"></font-awesome-icon>
              Refresh
            </button>
            <button class="btn btn-info min-width mr-1"
              @click="useDefault">
              <font-awesome-icon class="mr-2" icon="check-circle"></font-awesome-icon>
              Use Default
            </button>
            <button class="btn btn-warning min-width mr-1"
              @click="exportLocationSummary">
              <font-awesome-icon class="mr-2" icon="download"></font-awesome-icon>
              Download
            </button>
            <button class="btn btn-primary min-width mr-1"
                    @click="newRecord">
              <font-awesome-icon icon="plus"></font-awesome-icon>
            </button>
          </div>
        </div>

        <div class="col-sm-12">
          <redemption-location-table
            ref="redemptionLocationTable"
            :pusherChannel="pusherChannel"
            :redemptionMethod="record.redemption_method"
            @onCommand="onCommandHandler"
            :record="record"></redemption-location-table>
        </div>
      </div>
      <div class="row" v-if="record.redemption_method==='password'">
        <div class="col-sm-4 col-md-3 col-lg-2">
          <label>Password</label>
          <div class="input-group">
            <input class="form-control "
                   id="redemptionCode"
                   name="redemptionCode"
                   autocomplete="new-password"
                   :type="showRedemptionCode ? 'text' : 'password'"
                   v-model="record.redemption_code">
            <!--<input class="form-control "-->
                   <!--id="redemptionCode"-->
                   <!--name="redemptionCode"-->
                   <!--autocomplete="new-password"-->
                   <!--:type="showRedemptionCode ? 'text' : 'password'"-->
                   <!--style="padding: 0.25rem 0.75rem;line-height: 1.2;height:1.4rem;"-->
                   <!--v-model="record.redemption_code">-->
              <button class="input-group-append">
                <font-awesome-icon
                                 class="position-absolute"
                                 @click="showRedemptionCode=!showRedemptionCode"
                                 :icon="showRedemptionCode ? 'eye' : 'eye-slash'"></font-awesome-icon>
              </button>
            </div>
        </div>
      </div>
  </div>
</template>

<script>
import copyToken from '@/views/comps/CopyToken'
import copyLink from '@/views/comps/CopyLink'
import formInputs from '@/views/comps/forms'
import vueRangeSlider from 'vue-range-slider'
import DataRadioToggle from "../../../../comps/forms/DataRadioToggle"
import redemptionLocationTable from './page_redemption/RedemptionLocationTable'

export default {
  components: {
    DataRadioToggle,
    copyToken,
    copyLink,
    vueRangeSlider,
    ...formInputs,
    redemptionLocationTable
  },
  props: {
    record: {
      type: Object,
      default: null
    },
    pusherChannel: {
      type: Object,
      default: null
    }
  },
  computed: {
    agents () {
      return this.$store.getters.agents
    }
  },
  data () {
    return {
      showRedemptionCode: false,
      redemptionOptions: [
        {name: 'None', value: 'none'},
        {name: 'Password', value: 'password'},
        {name: 'QR Code', value: 'qrcode'},
        {name: 'QR Code/Password', value: 'qrcode_password'}
      ]
    }
  },
  // watch: {
  //   'vm.$refs.infoPageObserver.flags.invalid': function(invalid) {
  //     alert('invalid = ' + (invalid ? 'yes' : 'no'))
  //   }
  // },
  methods: {
    newRecord () {
      const vm = this
      console.log('RedemptionPage :: newRecord :: vm.$refs.redemptionLocationTable : ', vm.$refs.redemptionLocationTable)
      vm.$refs.redemptionLocationTable.newRecord()
    },
    refresh () {
      const vm = this
      vm.$refs.redemptionLocationTable.reloadAll()
    },
    useDefault () {

    },
    exportLocationSummary () {

    },
    async validate () {
      const vm = this
      return vm.$refs.infoPageObserver.validate()
    },
    onCommandHandler (payload) {

    }
  }
}
</script>