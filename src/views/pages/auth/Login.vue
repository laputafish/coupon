<template>
<div class="card">
  <div class="card-header">{{ $t(titleTag) }}</div>
  <div class="card-body">
    <div v-if="messageTag" class="text-center alert alert-danger">
      {{ $t('messages.' + messageTag) }}
    </div>

    <form @submit.prevent="login()" action="" method="">
      <!-- Email -->
      <auth-input-row id="email_address"
                      labelTag="login.email_address"
                      v-model="credentials.email"
                      rules="required|email"></auth-input-row>
      <!-- Password -->
      <auth-input-row-password id="password"
                      labelTag="login.password"
                      v-model="credentials.password"
                      rules="required"></auth-input-row-password>
      <!-- Remember -->
      <!--<div class="form-group row">-->
        <!--<div class="col-md-6 offset-md-4">-->
          <!--<div class="checkbox">-->
            <!--<label>-->
              <!--<input type="checkbox" name="remember"> {{ $t('login.remember_me') }}-->
            <!--</label>-->
          <!--</div>-->
        <!--</div>-->
      <!--</div>-->
      <!-- Submit button -->
      <div class="col-md-6 offset-md-4">
        <button type="submit" class="btn btn-primary min-width-80">
          <font-awesome-icon v-if="loading" icon="spinner" class="fa-spin" />
          {{ $t(titleTag) }}
        </button>
        <router-link :to="{name: 'ForgotPassword'}" class="btn btn-link">
          {{ $t('login.forgotYourPassword') }}
        </router-link>
      </div>
    </form>
  </div><!-- card body -->
</div><!-- card -->
</template>

<script>
  import authInputRow from './comps/AuthInputRow'
  import authInputRowPassword from './comps/AuthInputRowPassword'
  import authMixin from '@/mixins/AuthMixin'

  export default {
    mixins: [authMixin],
    components: {
      authInputRow,
      authInputRowPassword
    },
    data () {
      return {
        loading: false,
        titleTag: 'login.login',
        messageTag: '',
        credentials: {
          email: '',
          password: ''
        }
      }
    },
    mounted () {
      const vm = this
      // console.log('Login.vue :: mounted')
      if (vm.mode === 'development') {
        vm.credentials.email = 'yoovcoupon@gmail.com'
        vm.credentials.password = 'yoovYoov'
      }
      if (vm.$route.name === 'Logout') {
        // console.log('  is logout route')
        vm.logout()
      } else {
        // console.log('  not logout route')
      }
    },
    computed: {
      agents () {
        return this.$store.getters.agents
      }
    },
    methods: {
      logout () {
        const vm = this
        const postData = {
          urlCommand: '/auth/logout',
          data: vm.credentials
        }
        // vm.loading = true
        vm.$store.dispatch('AUTH_POST', postData).then(
          () => {
            // console.log('Logout :: AUTH_POST .then')
            vm.loading = false
            vm.resetAll()
          },
          () => {
            console.log('Logout :: AUTH_POST .catch')
            vm.loading = false
            vm.resetAll()
          }
            // vm.$store.dispatch('SET_TOKEN', '').then(()=> {
            //   vm.$router.replace({name: 'Login'})
            // }).catch(() => {
            //   vm.loading = false
            // })
            // vm.$store.dispatch('CLEAR_AGENTS').then(()=>{
            //   console.log('logout => AFTER AGENTS CLEAR_AGENTS')
            //   console.log('logout, agents: ', vm.agents)
            // }
        )
        vm.$router.replace('/login')

      },
      resetAll () {
        const vm = this
        console.log('resetAll')
        vm.$store.dispatch('SET_TOKEN', '').then(()=> {
          console.log('resetAll :: SET_TOKEN.then')
        }).catch(() => {
          vm.loading = false
          console.log('resetAll :: SET_TOKEN.catch')
        })
        vm.$store.dispatch('CLEAR_AGENTS').then(()=>{
          console.log('logout => AFTER AGENTS CLEAR_AGENTS')
          console.log('logout, agents: ', vm.agents)
          console.log('resetAll :: CLEAR_AGENTS.then')
        }).catch(() => {
          console.log('resetAll :: CLEAR_AGENTS.catch')
        })
      },
      login () {
        const vm = this
        const postData = {
          urlCommand: '/auth/login',
          data: vm.credentials
        }
        vm.loading = true
        vm.$store.dispatch('COMMON_POST', postData).then(
          response => {
            // console.log('login :: response: ', response)
            vm.loading = false
            vm.$store.dispatch('SET_TOKEN', response.access_token).then(()=> {
              vm.gotoNextUrl('/dashboard')
            }, () => {console.log('#3 setToken fails')}).catch(() => {
              // console.log('#3 caught')
            })
          },
          error => {
            console.log('logoin : error: ', error)
            vm.loading = false
            vm.messageTag = error.messageTag
          }
        )
      },
      gotoNextUrl (defaultUrl) {
        const vm = this
        let nextUrl = localStorage.getItem('nextUrl')
        if (!nextUrl) {
          nextUrl = defaultUrl
        }
        // console.log('gotoNextUrl :: nextUrl = ' + nextUrl)
        localStorage.removeItem('nextUrl');
        vm.$router.push(nextUrl);
      }
    }
  }
</script>
