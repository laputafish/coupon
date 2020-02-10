<template>
<ol class="breadcrumb float-sm-right">
  <template v-for="item in items">
  <li v-if="item.route_name!==''"
      class="breadcrumb-item">{{ $t(item.label_tag) }}
    :key="item.labelTag">
    <route-link :to="item.route_name">{{ $t(item.label_tag) }}</route-link></li>
  <li v-else
      class="breadcrumb-item active"
      :key="item.label_tag">DataTables</li>
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
