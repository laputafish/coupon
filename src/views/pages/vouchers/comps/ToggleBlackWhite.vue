<template>
  <div class="btn-group py-1 toggle-black-white">
    <button type="button"
      class="btn btn-xs"
            @click="selectColor('0,0,0')"
    :class="{'btn-success':value===''||value==='0,0,0','btn-light':value==='255,255,255'}">
      Black
    </button>
    <button type="button"
      class="btn btn-xs"
            @click="selectColor('255,255,255')"
    :class="{'btn-success':value==='255,255,255','btn-light':value===''||value==='0,0,0'}">
      White
    </button>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: ''
    }
  },
  model: {
    prop: 'value',
    event: 'input'
  },
  methods: {
    selectColor (sColor) {
      const vm = this
      vm.$emit('input', sColor)
    }
  }
}
</script>

<style>
  .toggle-black-white .btn {
    padding: 0.05rem 0.15rem;
  }
</style>