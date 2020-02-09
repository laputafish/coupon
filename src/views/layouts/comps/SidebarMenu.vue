<template>
  <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
    <li v-for="section in menu"
        :key="section.groupLabelTag" class="nav-item">
      <sidebar-menu-item :item="section"></sidebar-menu-item>
      <ul v-if="section.type==='group'" class="nav nav-treeview">
        <li v-for="item in section.children"
            :key="item.labelTag"
            class="nav-item">
          <sidebar-menu-item :item="item"></sidebar-menu-item>
        </li>
      </ul>
    </li>
  </ul>
</template>

<script>
  import sidebarMenuItem from '@/views/layouts/comps/SidebarMenuItem.vue'

  export default {
    components: { sidebarMenuItem },
    props: {
      menu: {
        type: Array,
        default () {
          return []
        }
      }
    },
    methods: {
      badgeClass (value) {
        // let vm = this
        return value ? 'badge-' + value : 'badge-primary'
      }
    }
  }
</script>
