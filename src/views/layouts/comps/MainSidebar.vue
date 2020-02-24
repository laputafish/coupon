<template>
  <!-- Main Sidebar Container -->
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <sidebar-brand-logo logoSrc="/img/brand_logo.png"></sidebar-brand-logo>

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) -->
      <sidebar-user-panel avatarUrl="/img/user.png"
        name="Admin"></sidebar-user-panel>

      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <h4 v-if="loading" class="mt-5 text-center text-light">
          <i class="fa fa-spinner fa-spin"></i>
        </h4>
        <sidebar-menu v-else :menu="mainMenu"></sidebar-menu>
      </nav>
      <div class="text-center mt-3">
        <a :href="sampleUrl" type="button" class="btn btn-danger">Download XLS Samples</a>
      </div>
      <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
  </aside>

</template>

<script>
  import sidebarBrandLogo from './SidebarBrandLogo'
  import sidebarUserPanel from './SidebarUserPanel'
  import sidebarMenu from './SidebarMenu'
  import appMixin from '@/mixins/AppMixin'

  export default {
    mixins: [appMixin],
    data () {
      return {
        loading: false,
        mainMenu: []
      }
    },
    computed: {
      sampleUrl () {
        const vm = this
        return vm.$store.getters.apiUrl + '/samples/download'
      }
    },
    mounted () {
      const vm = this
      vm.loading = true
      vm.$store.dispatch('AUTH_GET', '/menu')
        .then(response => {
          vm.loading = false
          vm.mainMenu = response
        })
        .catch(() => {
          vm.loading = false
          vm.showSessionExpired()
        })
    },
    components: {
      sidebarBrandLogo,
      sidebarUserPanel,
      sidebarMenu
    }
  }
</script>