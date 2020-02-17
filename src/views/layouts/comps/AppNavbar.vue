<template>
  <!-- Navbar -->
  <nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <!-- Left navbar links -->
    <ul class="navbar-nav mr-auto">
      <li class="nav-item">
        <a class="nav-link" data-widget="pushmenu" href="#"><i class="fas fa-bars"></i></a>
      </li>
      <li v-for="(menu, index) in topMenu"
          class="nav-item d-none d-sm-inline-block"
          :key="index">
        <router-link :to="menu.link" class="nav-link">{{ $t('menu.' + menu.labelTag) }}</router-link>
      </li>
    </ul>

    <!-- SEARCH FORM -->
    <!--<app-navbar-search-form v-if="hasSearch"></app-navbar-search-form>-->
    <!--<app-navbar-dropdown-menu id="messageMenu" v-if="messageMenu" :menu="messageMenu"></app-navbar-dropdown-menu>-->
    <!--<app-navbar-dropdown-menu id="notificationMenu" v-if="notificationMenu" :menu="notificationMenu"></app-navbar-dropdown-menu>-->
    <!---->
    <!--&lt;!&ndash; Control Menu &ndash;&gt;-->
    <!--<ul class="navbar-nav">-->
      <!--<li class="nav-item">-->
        <!--<a class="nav-link" data-widget="control-sidebar" data-slide="true" href="#">-->
          <!--<i class="fas fa-th-large"></i>-->
        <!--</a>-->
      <!--</li>-->
    <!--</ul>-->

    <!-- Logout -->
    <ul class="navbar-nav">
      <i class="nav-item">
        <router-link to="/logout" class="nav-link"><i class="fas fa-sign-out-alt"></i></router-link>
      </i>
    </ul>
  </nav>

</template>

<script>
  import appNavbarSearchForm from './appNavbar/SearchForm'
  import appNavbarDropdownMenu from './appNavbar/AppNavbarDropdownMenu'

  export default {
    components: {
      appNavbarSearchForm,
      appNavbarDropdownMenu
    },
    data () {
      return {
        topMenu: [],
        // topMenu: [
        //   {labelTag: 'home', link: 'index3.html'},
        //   {la
        messageMenu: {
          iconClass: 'far fa-comments', badgeVariant: 'danger', badgeValue: 3, children: [
            {
              type: 'media',
              imgSrc: '/static/img/user1-128x128.jpg',
              imgAlt: 'User Avatar',
              imgClass: 'img-size-50 mr-3 img-circle',
              title: 'Brad Diesel',
              rightIcon: {
                iconVariant: 'text-danger',
                iconClass: 'fas fa-star'
              },
              messages: [
                {text: "Call me whenever you can...", textVariant: ''},
                {text: '4 Hours ago', iconClass: 'far fa-clock mr-1', textVariant: 'text-muted'},
              ]
            },
            {type: 'divider'},
            {
              type: 'media',
              imgSrc: '/static/img/user8-128x128.jpg',
              imgAlt: 'User Avatar',
              imgClass: 'img-size-50 mr-3 img-circle',
              title: 'John Pierce',
              rightIcon: {
                iconVariant: 'text-muted',
                iconClass: 'fas fa-star'
              },
              messages: [
                {text: 'got your message bro', textVariant: ''},
                {text: '4 Hours Ago', iconClass: 'fa fa-clock mr-1', textVariant: 'text-muted'}
              ]
            },
            {type: 'divider'},
            {
              type: 'media',
              imgSrc: '/static/img/user3-128x128.jpg',
              imgAlt: 'User Aavatar',
              imgClass: 'img-size-50 mr-3 img-circle',
              title: 'Nora Silverster',
              rightIcon: {
                iconVariant: 'text-warning',
                iconClass: 'fas fa-star'
              },
              messages: [
                {text: 'The subject goes here'},
                {text: '4 Hours ago', iconClass: 'far fa-clock mr-1', textVariant: 'text-muted'}
              ]
            },
            {type: 'divider'},
            {
              type: 'footer',
              link: '#',
              message: 'See All Messages'
            }
          ]
        },
        notificationMenu: {
          iconClass: 'fas fa-bell',
          badgeVaiant: 'warning',
          badgeValue: 15,
          children: [
            {
              type: 'header',
              message: '15 Notifications'
            },
            { type: 'divider' },

            { type: 'link',
              link: '#',
              iconClass: 'fas fa-envelope',
              message: '4 new messages',
              note: '3 mins'
            },
            { type: 'divider' },

            { type: 'link',
              link: '#',
              iconClass: 'fas fa-users',
              message: '8 friend requests',
              note: '12 hours'
            },
            { type: 'divider' },

            { type: 'link',
              link: '#',
              // iconClass: 'fas fa-file',
              iconClass: 'far fa-comments',
              message: '3 new reports',
              note: '2 days'
            },
            { type: 'divider' },

            { type: 'footer',
              link: '#',
              message: 'See All Notifications'
            }
          ]
        }
      } // return
    },
    props: {
      hasSearch: {
        type: Boolean,
        default: false
      }
    }
  }
</script>