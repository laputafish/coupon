<template>
  <!-- Main Sidebar Container -->
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <sidebar-brand-logo logoSrc="/static/img/AdminLTELogo.png"></sidebar-brand-logo>

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) -->
      <sidebar-user-panel avatarUrl="/static/img/user2-160x160.jpg"
        name="Alexander Pierce"></sidebar-user-panel>

      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <sidebar-menu :menu="mainMenu"></sidebar-menu>
      </nav>
      <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
  </aside>

</template>

<script>
  import sidebarBrandLogo from './SidebarBrandLogo'
  import sidebarUserPanel from './SidebarUserPanel'
  import sidebarMenu from './SidebarMenu'

  export default {
    data () {
      return {
        mainMenu: [
          {
            labelTag: 'menu.coupon_codes',
            type: 'link',
            iconClass: 'fas fa-barcode',
            link: '/coupon_codes'
          },
          {
            labelTag: 'menu.dashboard',
            type: 'group',
            iconClass: 'fas fa-tachometer-alt',
            children: [
              {
                labelTag: 'menu.dashboard1',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/dashboard'
              },
              {
                labelTag: 'menu.dashboard2',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/dashboard2'
              },
              {
                labelTag: 'menu.dashboard3',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/dashboard3'
              },
            ]
          },
          {
            labelTag: 'menu.widgets',
            type: 'link',
            iconClass: 'fas fa-th',
            badge: 'New',
            badgeVariant: 'danger',
            link: '/widgets'
          },
          {
            labelTag: 'menu.layout_options',
            type: 'group',
            iconClass: 'fas fa-copy',
            badge: '6',
            badgeVariant: 'info',
            children: [
              {
                labelTag: 'menu.top_navigation',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/top_navigation'
              },
              {
                labelTag: 'menu.top_navigation_siebar',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/top_navigation_sidebar'
              },
              {
                labelTag: 'menu.boxed',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/boxed'
              },
              {
                labelTag: 'menu.fixed_sidebar',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/fixed_sidebar'
              },
              {
                labelTag: 'menu.fixed_navbar',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/fixed_navbar'
              },
              {
                labelTag: 'menu.fixed_footer',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/fixed_footer'
              },
              {
                labelTag: 'menu.collapsed_sidebar',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/collapsed_sidebar'
              }
            ]
          },
          {
            labelTag: 'menu.charts',
            type: 'group',
            iconClass: 'fas fa-chart-pie',
            children: [
              {
                labelTag: 'menu.charts_js',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/charts_js'
              },
              {
                labelTag: 'menu.flot',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/flot'
              },
              {
                labelTag: 'menu.inline',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/inline'
              }
            ]
          },
          {
            labelTag: 'menu.ui_elements',
            type: 'group',
            iconClass: 'fas fa-tree',
            children: [
              {
                labelTag: 'menu.general',
                type: 'link',
                iconClass: 'fas fa-circle',
                link: '/ui_general'
              },
              {
                labelTag: 'menu.icons',
                type: 'link',
                iconClass: 'fas fa-circle',
                link: '/ui_icons'
              },
              {
                labelTag: 'menu.buttons',
                type: 'link',
                iconClass: 'fas fa-circle',
                link: '/ui_buttons'
              },
              {
                labelTag: 'menu.sliders',
                type: 'link',
                iconClass: 'fas fa-circle',
                link: '/ui_sliders'
              },
              {
                labelTag: 'menu.modals_alerts',
                type: 'link',
                iconClass: 'fas fa-circle',
                link: '/ui_modals_alerts'
              },
              {
                labelTag: 'menu.navbar_tabs',
                type: 'link',
                iconClass: 'fas fa-circle',
                link: '/ui_navbar_tabs'
              },
              {
                labelTag: 'menu.timeline',
                type: 'link',
                iconClass: 'fas fa-circle',
                link: '/ui_timeline'
              },              {
                labelTag: 'menu.ribbons',
                type: 'link',
                iconClass: 'fas fa-circle',
                link: '/ui_ribbons'
              }
            ]
          },
          {
            labelTag: 'menu.forms',
            type: 'group',
            iconClass: 'far fa-circle',
            children: [
              {
                labelTag: 'menu.general',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/forms/general'
              },
              {
                labelTag: 'menu.advanced',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/forms/advanced'
              },
              {
                labelTag: 'menu.editors',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/forms/editors'
              },
              {
                labelTag: 'menu.validation',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/forms/validation'
              }
            ]
          },
          {
            labelTag: 'menu.tables',
            type: 'group',
            iconClass: 'fas fa-table',
            children: [
              {
                labelTag: 'menu.simple_table',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/tables/simple_table'
              },
              {
                labelTag: 'menu.simple_table',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/tables/simple_table'
              },
              {
                labelTag: 'menu.datatables',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/tables/datatables'
              },
              {
                labelTag: 'menu.js_grid',
                type: 'link',
                iconClass: 'far fa-circle',
                link: '/tables/js_grid'
              }
            ]
          }
        ]
      }
    },
    components: {
      sidebarBrandLogo,
      sidebarUserPanel,
      sidebarMenu
    }
  }
</script>