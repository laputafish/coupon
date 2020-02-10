<template>
<ol class="breadcrumb float-sm-right">
  <template v-for="item in items">
  <li v-if="item.routeName!==''"
      class="breadcrumb-item"
      :key="item.labelTag">
    <router-link :to="{name: item.routeName}">{{ $t(item.labelTag) }}</router-link></li>
  <li v-else
      class="breadcrumb-item active"
      :key="item.labelTag">{{ $t(item.labelTag) }}</li>
  </template>
</ol>
</template>

<script>
export default {
  props: {
    items: {
      type: Array,
      default () {
        return []
      }
    }
  }
}
</script>
