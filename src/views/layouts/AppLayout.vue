<template>
<div class="wrapper">
  <app-navbar></app-navbar>
  <main-sidebar></main-sidebar>
  <div class="content-wrapper">
    <router-view></router-view>
  </div>
  <app-footer></app-footer>
  <control-sidebar></control-sidebar>
</div>
</template>

<script>
import appNavbar from './comps/AppNavbar'
import mainSidebar from './comps/MainSidebar'
import controlSidebar from './comps/ControlSidebar'
import appFooter from './comps/AppFooter'

export default {
  components: {
    appNavbar,
    mainSidebar,
    appFooter,
    controlSidebar
  }
}
</script>

<style>
  @import '/css/adminlte.css';
  
</style>
