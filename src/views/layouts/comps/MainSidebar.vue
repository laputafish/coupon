<template>
  <!-- Main Sidebar Container -->
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <sidebar-brand-logo logoSrc="/static/img/AdminLTELogo.png"></sidebar-brand-logo>

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) -->
      <sidebar-user-panel avatarUrl="/static/img/user2-160x160.jpg"
        name="Digital Voucher"></sidebar-user-panel>

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
        mainMenu: []
      }
    },
    mounted () {
      let vm = this

      vm.$store.dispatch('COMMON_GET', 'menu').then(response => {
        vm.mainMenu = response
      })
    },
    components: {
      sidebarBrandLogo,
      sidebarUserPanel,
      sidebarMenu
    }
  }
</script>