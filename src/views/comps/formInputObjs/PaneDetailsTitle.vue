<template>
  <div class="p-2 border bg-primary">
    <input-obj-title :inputObj="inputObj"></input-obj-title>
  </div>
</template>

<script>
import inputObjTitle from './InputObjTitle'

export default {
  components: {
    inputObjTitle
  },
  props: {
    inputObj: {
      type: Object,
      default: null
    }
  }
}
</script>