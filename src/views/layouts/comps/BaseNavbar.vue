<template>
<nav class="home-page navbar fixed-top navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.html">
      {{ $t('login.digital_coupon') }}<br/>
      <span class="brand-notes">
        {{ $t('login._brandNotes_') }}
      </span>
    </a>
    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-nav class="ml-auto">
        <b-nav-item href="#" @click="$router.push({name: 'about'})">About</b-nav-item>
        <b-nav-item href="#" @click="$router.push({name: 'about'})">Service</b-nav-item>
        <b-nav-item href="#" @click="$router.push({name: 'about'})">Contact</b-nav-item>
      </b-navbar-nav>

      <b-navbar-nav v-if="user">
        <b-nav-item-dropdown :text="user.name" right>
          <b-dropdown-item href="#" @click="$router.push({'name':'vouchers'})">{{ $t('menu.vouchers') }}</b-dropdown-item>
          <b-dropdown-item href="#" @click="$router.push({'name':'Profile'})">{{ $t('user.profile') }}</b-dropdown-item>
          <b-dropdown-item href="#" @click="$router.push({'name':'Logout'})">{{ $t('auth.logout') }}</b-dropdown-item>
        </b-nav-item-dropdown>
      </b-navbar-nav>
      <b-navbar-nav v-else>
        <b-nav-item href="#" @click="$router.push({name:'Login'})">{{ $t('login.login') }}</b-nav-item>
        <b-nav-item href="#" @click="$router.push({name:'Register'})">{{ $t('login.register') }}</b-nav-item>
      </b-navbar-nav>
    </b-collapse>
  </div>
 </nav>
</template>

<script>
  export default {
    computed: {
      user () {
        const vm = this
        return vm.$store.getters.user
      }
    }
  }
</script>