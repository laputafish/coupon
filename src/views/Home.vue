<template>
  <div class="home">
    <img alt="Vue logo" src="../assets/logo.png">

    <p>Have a cup of coffee: <i class="fas fa-coffee"></i></p>
    <p>have an user: <i class="fas fa-user"></i></p>
    <p>Have a module of JavaScript: <i class="fas fa-ad"></i></p>
    <p>Have a module of Vue.js: <i class="fas fa-address-book"></i> </p>
<hr/>
    <p>Have a cup of coffee: <font-awesome-icon icon="coffee" /></p>
    <p>Have a module of JavaScript: <font-awesome-icon icon="ad" /></p>
    <p>Have a module of Vue.js: <font-awesome-icon icon="address-book" /></p>

    <HelloWorld msg="Welcome to Your Vue.js App"/>
  </div>
</template>

<script>
// @ is an alias to /src
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'Home',
  components: {
    HelloWorld
  }
}
</script>
