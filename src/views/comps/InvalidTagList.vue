<template>
  <div class="invalid-tag-list">
    <button class="btn btn-outline-warning w-100"
            @click="$emit('onCommand', {command: 'checkTags'})">Check Validity</button>
    <div v-if="invalidTags">
      <h6 class="mt-2 text-center">Invalid Tag List</h6>
      <ul class="my-2 px-1">
        <li v-for="(count, tagName) in invalidTags"
            :key="tagName"><div class="badge badge-warning">{{ tagName }}</div>
        <span class="ml-1" v-if="count > 1">x {{ count }}</span></li>
      </ul>
    </div>
  </div>
</template>

<script>
  export default {
    props: {
      invalidTags: {
        type: Object,
        default () {
          return null
        }
      }
    }
  }
</script>

<style>
.invalid-tag-list ul {
  list-style: none;
}
</style>