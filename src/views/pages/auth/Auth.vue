<template>
<div id="auth">
  <div id="bkgd" :style="{backgroundImage: 'url(/static/img/wallpapers/w1.jpg)'}"></div>
  <auth-navbar></auth-navbar>
  <main class="login-form position-fixed w-100 h-100">
    <div class="container h-100">
      <div class="row justify-content-center h-100">
        <div class="col-md-8 h-100 d-flex flex-column justify-content-center">
          <router-view></router-view>
        </div><!-- col -->
      </div><!-- row -->
    </div><!-- container -->
  </main>
</div>
</template>

<script>
import authNavbar from './comps/AuthNavbar'

export default {
  components: {
    authNavbar
  }
  // ,
  // mounted () {
  //   const vm = this
  //   vm.setBackgroundImage('w1.jpg')
  // },
  // methods: {
  //   checkAndSetBackgroundImage () {
  //     const vm = this
  //     if (vm.$route.meta && vm.$route.meta.auth) {
  //       vm.setBackgroundImage('w1.jpg')
  //     } else {
  //       vm.setBackgroundImage('')
  //     }
  //   },
  //   setBackgroundImage (imageFile) {
  //     const vm = this
  //     console.log('App.vue :: setBackgroundImage :: imageFile = ' + imageFile)
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

<style>
/*#auth {*/
  /*width: 100%;*/
  /*height: 100%;*/
/*}*/

#bkgd {
  position: fixed;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  background-color: url('/static/img/wallpapers/w1.jpg') cover;
}
</style>