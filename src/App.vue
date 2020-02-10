<template>
  <div id="app">
    <!--class="wrapper">-->
    <!--<div>-->
    <!--<b-jumbotron header="Bootstrap Vue" lead="Bootstrap 4 Components for Vue.js 2">-->
    <!--<p>For more information, visit website</p>-->
    <!--<b-button variant="primary" class="mr-1" href="#">More Info</b-button>-->
    <!--<b-button variant="secondary" class="mr-1" href="#">More Info</b-button>-->
    <!--<b-button variant="info" class="mr-1" href="#">More Info</b-button>-->
    <!--<b-button variant="warning" class="mr-1" href="#">More Info</b-button>-->
    <!--<b-button variant="danger" class="mr-1" href="#">More Info</b-button>-->
    <!--</b-jumbotron>-->
    <!--<router-link to="/">Home</router-link> |-->
    <!--<router-link to="/about">About</router-link>-->
    <!--</div>-->
    <router-view/>
  </div>
</template>

<script>
  export default {
    created () {
      const vm = this
      vm.$store.dispatch('FETCH_CONSTANTS')
    },
    mounted () {
      const vm = this
      vm.$i18n.locale = 'en'
    }
  }
</script>

<style lang="scss">
  @import 'node_modules/bootstrap/scss/bootstrap';
  @import 'node_modules/bootstrap-vue/src/index.scss';
  @import '@/assets/scss/custom.scss';

  /*#app {*/
    /*font-family: Avenir, Helvetica, Arial, sans-serif;*/
    /*-webkit-font-smoothing: antialiased;*/
    /*-moz-osx-font-smoothing: grayscale;*/
    /*text-align: center;*/
    /*color: #2c3e50;*/
  /*}*/

  #nav {
    padding: 30px;

    a {
      font-weight: bold;
      color: #2c3e50;

      &.router-link-exact-active {
        color: #42b983;
      }
    }
  }
</style>
