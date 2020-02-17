<template>
<b-dropdown :id="menu.id" variant="link" dropleft toggle-class="text-decoration-none d-flex justify-content-start" no-caret>
  <template v-slot:button-content>
    <i :class="menu.iconClass"></i>
    <span v-if="menu.badgeValue!==''" class="badge navbar-badge"
      :class="badgeClass">{{ menu.badgeValue }}</span>
  </template>
  <template v-for="(item, index) in menu.children">

    <!-- Header -->
    <span v-if="item.type==='header'"
          :key="index"
      class="dropdown-item dropdown-header">
      {{ item.message }}
    </span>

    <!-- Footer -->
    <a v-else-if="item.type==='footer'"
       :key="index"
       href="#" class="dropdown-item dropdown-footer">
      {{ item.message }}</a>

    <!-- Dividier -->
    <b-dropdown-divider v-else-if="item.type==='divider'"
                        :key="index"></b-dropdown-divider>

    <!-- Media -->
    <app-navbar-dropdown-menu-item-media
      v-else-if="item.type==='media'"
      :item="item"
      :key="index">
    </app-navbar-dropdown-menu-item-media>

    <!-- Link -->
    <a v-else-if="item.type==='link'"
       :key="index"
       :href="item.link" class="dropdown-item">
      <i :class="item.iconClass" class="mr-2"></i>{{ item.message }}
      <span class="float-right text-muted text-sm">{{ item.note }}</span>
    </a>
  </template>
</b-dropdown>
</template>

<script>
  import appNavbarDropdownMenuItemMedia from './AppNavbarDropdownMenuItemMedia'

  export default {
    components: {
      appNavbarDropdownMenuItemMedia
    },
    computed: {
      badgeClass () {
        const vm = this
        return 'badge-' + vm.badgeVariant
      }
    },
    props: {
      menu: {
        type: Object,
        default () {
          return {
            id: '',
            iconClass: '',
            badgeVariant: 'info',
            badgeValue: '',
            children: []
          }
        }
      }
    }
  }
</script>