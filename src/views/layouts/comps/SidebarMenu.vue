<template>
  <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
    <li v-for="section in menu"
        :key="section.id" class="nav-item">
      <template v-if="section.type==='group'">
        <sidebar-menu-item-title :item="section"></sidebar-menu-item-title>
        <ul v-if="section.type==='group'" class="nav nav-treeview">
          <li v-for="item in section.children"
              :key="item.label_tag"
              class="nav-item">
            <sidebar-menu-item-link :item="item"></sidebar-menu-item-link>
          </li>
        </ul>
      </template>
      <template v-else>
        <sidebar-menu-item-link :item="section"></sidebar-menu-item-link>
      </template>
    </li>
  </ul>
</template>

<script>
  import sidebarMenuItemTitle from '@/views/layouts/comps/SidebarMenuItemTitle.vue'
  import sidebarMenuItemLink from '@/views/layouts/comps/SidebarMenuItemLink.vue'

  export default {
    components: {
      sidebarMenuItemTitle,
      sidebarMenuItemLink
    },
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
