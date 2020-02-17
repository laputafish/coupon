<template>
  <div id="app" ref="app">
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
    mounted () {
      const vm = this
      vm.$i18n.locale = 'en'

      console.log('App.vue :: vm.$route.meta: ', vm.$route.meta)
      // vm.checkAndSetBackgroundImage()
      // vm.$store.dispatch('FETCH_TOKEN').then(response => {
      //
      // })
    }
    // ,
    // watch: {
    //   '$route.meta': function(newValue) {
    //     // const vm = this
    //     console.log('App.vue :: watch($route.meta)')
    //     // vm.checkAndSetBackgroundImage()
    //   }
    // }
    // ,
    // methods: {
    //   checkAndSetBackgroundImage () {
    //     const vm = this
    //     if (vm.$route.meta && vm.$route.meta.auth) {
    //       vm.setBackgroundImage('w1.jpg')
    //     } else {
    //       vm.setBackgroundImage('')
    //     }
    //   },
    //  setBackgroundImage (imageFile) {
    //    const vm = this
    //    console.log('App.vue :: setBackgroundImage :: imageFile = ' + imageFile)
    //     if (imageFile === '') {
    //       vm.$refs['app'].style.backgroundImage = ''
    //     } else {
    //       vm.$refs['app'].style.backgroundImage = '/static/img/' + imageFile
    //       vm.$refs['app'].style.backgroundSize = 'cover'
    //     }
    //   }
    // }
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

  #app {
    width: 100%;
    height: 100%;
  }
</style>
