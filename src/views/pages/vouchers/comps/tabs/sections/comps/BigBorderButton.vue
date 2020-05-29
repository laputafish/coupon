<template>
  <div class="btn-container" :class="'border-' + variant">
    <button type="button"
            class="btn btn-xlg min-width-200"
            :class="'btn-' + variant"
            @click="$emit('onCommand', {command: command})">
      {{ caption }}
    </button>
  </div>
</template>

<script>
export default {
  props: {
    variant: {
      type: String,
      default: 'primary'
    },
    command: {
      type: String,
      default: ''
    },
    caption: {
      type: String,
      default: ''
    }
  }
}
</script>
<style>

.btn-container {
  padding: 5px;
  border-width: 2px;
  border-style: solid;
  border-radius: 0.5rem;
}
</style>