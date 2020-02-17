<template>
<div class="col-sm-3">
  <div class="form-group">
    <label>{{ $t(labelTag) }}</label>
    <div class="form-control d-flex flex-row">
      <vue-range-slider :min="min" :max="max" ref="slider" style="width:100%;"
                        :value="value"
                        @input="value=>$emit('input',value)">
                        <!--v-model="record.qr_code_size">-->
        <div class="diy-tooltip" slot="tooltip" slot-scope="{ value }">
          {{ value }}
        </div>
      </vue-range-slider>
      <div class="line-height-1 text-nowrap">{{ value }} px</div>
    </div>
  </div>
</div>
</template>

<script>
import vueRangeSlider from 'vue-range-slider'

export default {
  component: {
    vueRangeSlider
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  props: {
    labelTag: {
      type: String,
      default: ''
    },
    id: {
      type: String,
      default: ''
    },
    min: {
      type: Number,
      default: 100
    },
    max: {
      type: Number,
      default: 300
    },
    value: {
      type: Number,
      default: 100
    }
  }
}
</script>

<style lang="scss">
@import 'vue-range-slider/dist/vue-range-slider.scss';
</style>
