<template>
  <div>
    <validation-observer ref="infoPageObserver" v-slot="{ invalid }">
      <div class="row pt-2">

        <!-- ********* -->
        <!-- Row #0 -->
        <!-- ********* -->
        <!--<data-input width="3" id="description" labelTag="vouchers.title"-->
        <!--v-model="record.description"></data-input>-->
        <!--<data-input width="3" id="notes" labelTag="vouchers.sub_title"-->
        <!--v-model="record.notes"></data-input>-->
        <div class="col-sm-6">
          <div class="form-group mb-1">
            <label for="description">{{ $t('vouchers.title') }}</label>
            <validation-provider rules="required" :immediate="true" v-slot="{errors}">
            <input class="form-control"
                   :class="{'has-error': errors.length>0}"
                   id="description"
                   name="description"
                   type="text"
                   v-model="record.description"/>
            </validation-provider>

            <input class="form-control mt-1"
                   :placeholder="$t('vouchers.sub_title')"
                   id="notes"
                   name="notes"
                   type="text"
                   style="padding: 0.25rem 0.75rem;line-height: 1.2;height:1.4rem;"
                   v-model="record.notes"/>
          </div>
        </div>

        <!--<data-input width="4" id="description" labelTag="general.description" v-model="record.description"></data-input>-->
        <data-input-date width="2" id="activate_date" labelTag="vouchers.activation_date"
                         v-model="record.activation_date"></data-input-date>
        <data-input-date width="2" id="expiry_date" labelTag="vouchers.expiry_date"
                         v-model="record.expiry_date"></data-input-date>
        <data-input-readonly width="2" id="status" labelTag="general.status"
                             :value="$t('status.'+record.status)"></data-input-readonly>
      </div>
      <div class="row pt-3">
        <!-- ********* -->
        <!-- Row #1 -->
        <!-- ********* -->
        <data-input-select width="2" id="agent_id" labelTag="agents.agent" v-model="record.agent_id"
                           :options="agents"
                           optionLabelField="name"></data-input-select>
        <!--<data-input-readonly width="2" id="created_at" labelTag="vouchers.creation_date"-->
        <!--v-model="record.created_at"></data-input-readonly>-->

        <div class="col-sm-2">
          <div class="d-flex flex-row justify-content-between">
            <label>QR Code
              <copy-token token="qrcode"></copy-token>
            </label>
            <!--<toggle-black-white-->
            <!--v-model="qrcodeConfig.code_color"></toggle-black-white>-->
          </div>
          <input class="form-control" v-model="qrcodeConfig.composition">
          <div class="d-flex flex-row align-items-center">
            <small class="line-height-1 d-inline mr-1">Size</small>
            <vue-range-slider :min="5" :max="20" ref="slider" style="width:100%;" v-model="qrcodeConfig.width">
              <div class="diy-tooltip" slot="tooltip" slot-scope="{ value }">
                {{ value }}
              </div>
            </vue-range-slider>
            <div class="line-height-1 text-nowrap">{{ qrcodeConfig.width }} px</div>
          </div>
        </div>
        <div class="col-sm-2">
          <div class="d-flex flex-row justify-content-between">
            <label>Barcode
              <copy-token token="barcode"></copy-token>
            </label>
            <!--<toggle-black-white-->
            <!--v-model="barcodeConfig.code_color"></toggle-black-white>-->
            <!--<select v-model="record.barcodeType">-->
            <!--<option value="C39">Code 39</option>-->
            <!--<option value="C128">Code 128</option>-->
            <!--</select>-->
          </div>
          <input class="form-control" v-model="barcodeConfig.composition">
          <div class="d-flex flex-row align-items-center">
            <small class="text-nowrap line-height-1 d-inline mr-1">Width/bar</small>
            <vue-range-slider :min="1" :max="5" ref="slider" style="width:100%;" v-model="barcodeConfig.width">
              <div class="diy-tooltip" slot="tooltip" slot-scope="{ value }">
                {{ value }}
              </div>
            </vue-range-slider>
            <div class="line-height-1 text-nowrap">{{ barcodeConfig.width }}</div>
          </div>
          <div class="d-flex flex-row align-items-center">
            <small class="text-nowrap line-height-1 d-inline mr-1">Height</small>
            <vue-range-slider :min="30" :max="99" ref="slider" style="width:100%;" v-model="barcodeConfig.height">
              <div class="diy-tooltip" slot="tooltip" slot-scope="{ value }">
                {{ value }}
              </div>
            </vue-range-slider>
            <div class="line-height-1 text-nowrap">{{ barcodeConfig.height }}</div>
          </div>
        </div>

        <div class="col-sm-6">
          <div class="d-flex flex-row">
            <label>Voucher Type</label>
          </div>
          <div class="d-flex flex-row justify-content-between align-items-start voucher-type-selection">
            <div class="flex-grow-1">
              <!--:class="{'active':record.voucher_type=='voucher'}"-->
              <button type="button"
                      :class="{'btn-primary':record.voucher_type==='voucher','btn-light':record.voucher_type!=='voucher'}"
                      @click="record.voucher_type='voucher'"
                      class="btn w-100 mr-1">
                <img class="voucher-type-icon" data-toggle="tooltip" title="Voucher" src="/img/voucher.png"/>
                <img class="voucher-type-icon white-icon" data-toggle="tooltip" title="Voucher" src="/img/voucher-w.png"/>
              </button>
            </div>
            <div class="flex-grow-1 p-l-1">
              <!--:class="{'active':record.voucher_type==='form'}"-->
              <button type="button"
                      :class="{'btn-success':record.voucher_type==='form','btn-light':record.voucher_type!=='form'}"
                      @click="record.voucher_type='form'"
                      class="btn w-100 ml-1">
                <div class="d-flex flex-row justify-content-center align-items-center">
                  <img class="voucher-type-icon flex-grow-1"
                       data-toggle="tooltip"
                       title="Form Filling"
                       src="/img/form.png"/>
                  <img class="voucher-type-icon flex-grow-1 white-icon"
                       data-toggle="tooltip"
                       title="Form Filling"
                       src="/img/form-w.png"/>
                  <i class="fa fa-play"></i>
                  <img class="voucher-type-icon flex-grow-1"
                       data-toggle="tooltip"
                       title="Voucher"
                       src="/img/voucher.png"/>
                  <img class="voucher-type-icon flex-grow-1 white-icon"
                       data-toggle="tooltip"
                       title="Voucher"
                       src="/img/voucher-w.png"/>
                </div>
              </button>
            </div>
          </div>
          <!--<div v-if="record.voucher_type==='form'"-->
               <!--class="position-absolute d-flex flex-row justify-content-center align-items-center"-->
               <!--style="left:0;right:0;">-->
            <!--<small class="mr-1">Form Link</small>-->
            <!--<copy-link :link="customLink" variant="danger"></copy-link>-->
          <!--</div>-->
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

export default {
  components: {
    copyToken,
    copyLink,
    vueRangeSlider,
    ...formInputs
  },
  props: {
    record: {
      type: Object,
      default: null
    },
    qrcodeConfig: {
      type: Object,
      default: null
    },
    barcodeConfig: {
      type: Object,
      default: null
    }
  },
  computed: {
    customLink () {
      const vm = this
      return vm.$store.getters.appHost + '/q/' + vm.record.custom_link_key
    },
    agents () {
      return this.$store.getters.agents
    }
  },
  data () {
    return {
    }
  },
  // watch: {
  //   'vm.$refs.infoPageObserver.flags.invalid': function(invalid) {
  //     alert('invalid = ' + (invalid ? 'yes' : 'no'))
  //   }
  // },
  methods: {
    async validate () {
      const vm = this
      return vm.$refs.infoPageObserver.validate()
    }
  }
}
</script>