<template>
  <div class="toolbar-button-wrapper"
       :class="{'selected':selected}"
    @click="onClicked">
    <div class="toolbar-button-icon text-center">
      <img :src="button.imgSrc">
    </div>
    <div class="toolbar-button-title text-center">
      {{ button.caption }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    button: {
      type: Object,
      default: null
    },
    selected: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onClicked () {
      const vm = this
      vm.$emit('click')
    }
  }
}
</script>

<style>
  .toolbar-button-wrapper.selected:hover {
    background-color: #7fa4cc;
  }
  .toolbar-button-wrapper.selected {
    background-color: #9fcdff;
  }
  .toolbar-button-wrapper:hover {
    background-color: rgba(127,127,127,.2);

  }
  .toolbar-button-wrapper {
    display: inline-block;
    padding: 5px 20px 2px 20px;
    margin: 2px;
    margin-bottom: 0;
    border-top-left-radius: 0.5rem;
    border-top-right-radius: 0.5rem;
  }
  .toolbar-button-icon img {
    width: 64px;
    height: 64px;
    object-fit: contain;
  }
</style>