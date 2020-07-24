<template>
  <div>
    <validation-observer ref="redemptionPageObserver" v-slot="{ invalid }">
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
      <div class="row" v-if="record.redemption_method==='qrcode'">
        <div class="col-sm-12 position-relative">
          <div class="position-absolute" style="right:0;top:0;margin-top:-14px">
            <button class="btn btn-primary min-width mr-1">
              <font-awesome-icon class="mr-2" icon="check-circle"></font-awesome-icon>
              Use Default
            </button>
            <button class="btn btn-warning min-width mr-1"
              @click="exportLocationSummary">
              <font-awesome-icon class="mr-2" icon="download"></font-awesome-icon>
              Download
            </button>
          </div>
          <label>Locations</label>
          <!--<redemption-location-table-->
            <!--ref="redemptionLocationTable"-->
            <!--:pusherChannel="pusherChannel"-->
            <!--@onCommand="onCommandHandler"-->
            <!--:record="record"></redemption-location-table>-->
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
    </validation-observer>
  </div>
</template>

<script>
import copyToken from '@/views/comps/CopyToken'
import copyLink from '@/views/comps/CopyLink'
import formInputs from '@/views/comps/forms'
import vueRangeSlider from 'vue-range-slider'
import DataRadioToggle from "../../../../comps/forms/DataRadioToggle"
// import redemptionLocationTable from './page_redemption/RedemptionLocationTable'

export default {
  components: {
    DataRadioToggle,
    copyToken,
    copyLink,
    vueRangeSlider,
    ...formInputs
    // ,
    // redemptionLocationTable
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
        {name: 'QR Code', value: 'qrcode'}
      ]
    }
  },
  // watch: {
  //   'vm.$refs.infoPageObserver.flags.invalid': function(invalid) {
  //     alert('invalid = ' + (invalid ? 'yes' : 'no'))
  //   }
  // },
  methods: {
    exportLocationSummary () {

    },
    async validate () {
      const vm = this
      return vm.$refs.infoPageObserver.validate()
    }
  }
}
</script>