<template>
  <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
    <li v-for="section in menu"
        :key="section.groupLabelTag" class="nav-item">
      <a :href="typepages/widgets.html" class="nav-link">
        <i class="nav-icon fas fa-th"></i>
        <p>
          Widgets
          <span class="right badge badge-danger">New</span>
        </p>
      </a>
    </li>
  </ul>
</template>

<script>
  export default {
    props: {
      menu: {
        type: Array,
        default () {
          return []
        }
      }
    }
  }
</script>