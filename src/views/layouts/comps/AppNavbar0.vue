<template>
  <!-- Navbar -->
  <nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
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
    <app-navbar-search-form v-if="hasSearch"></app-navbar-search-form>


    <!-- Right navbar links -->
    <!--
    messageMenu = [
      {
        iconClass: 'far fa-comments', badgeVariant: 'danger', badgeValue: 3, children: [
          {
            type: 'media',
            imgSrc: '/static/img/user1-128x128.jpg',
            imgAlt: 'User Avatar',
            imgClass: 'img-size-50 mr-3 img-circle',


        ]
      },
      {
        iconClass: 'fas fa-bell', badgeVariant: 'warning', badgeValue: 15, children: [
        ]
      }
    ]
    -->
    <app-navbar-dropdown-menu id="messagesMenu" :iconClass="far fa-comments"></app-navbar-dropdown-menu>
  <b-dropdown id="dropdown-1" variant="link" dropleft toggle-class="text-decoration-none d-flex justify-content-start" no-caret>
    <template v-slot:button-content>
      <i class="far fa-comments"></i>
      <span class="badge badge-danger navbar-badge">3</span>
    </template>
    <b-dropdown-item> <div class="media">
        <img src="/static/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle"/>
        <div class="media-body">
          <h3 class="dropdown-item-title">
            Brad Diesel
            <span class="float-right text-sm text-danger"><i class="fas fa-star"></i></span>
          </h3>
          <p v-if="messageObj in messages"
             class="text-sm"
             :class="textVariant">{{ messageObj.message }}</p>
        </div>
      </div>
    </b-dropdown-item>
    <b-dropdown-item>Second Action</b-dropdown-item>
    <b-dropdown-item>Third Action</b-dropdown-item>
    <b-dropdown-divider></b-dropdown-divider>
    <b-dropdown-item active>Active action</b-dropdown-item>
    <b-dropdown-item disabled>Disabled action</b-dropdown-item>
  </b-dropdown>

    <ul class="navbar-nav ml-auto">

      <!-- Messages Dropdown Menu -->
      <li class="nav-item dropdown">
        <a class="nav-link" data-toggle="dropdown" href="#">
          <i class="far fa-comments"></i>
          <span class="badge badge-danger navbar-badge">3</span>
        </a>
        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
          <a href="#" class="dropdown-item">
            <!-- Message Start -->
            <div class="media">
              <img src="/static/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
              <div class="media-body">
                <h3 class="dropdown-item-title">
                  Brad Diesel
                  <span class="float-right text-sm text-danger"><i class="fas fa-star"></i></span>
                </h3>
                <p class="text-sm">Call me whenever you can...</p>
                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 4 Hours Ago</p>
              </div>
            </div>
            <!-- Message End -->
          </a>
          <div class="dropdown-divider"></div>
          <a href="#" class="dropdown-item">
            <!-- Message Start -->
            <div class="media">
              <img src="/static/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
              <div class="media-body">
                <h3 class="dropdown-item-title">
                  John Pierce
                  <span class="float-right text-sm text-muted"><i class="fas fa-star"></i></span>
                </h3>
                <p class="text-sm">I got your message bro</p>
                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 4 Hours Ago</p>
              </div>
            </div>
            <!-- Message End -->
          </a>
          <div class="dropdown-divider"></div>
          <a href="#" class="dropdown-item">
            <!-- Message Start -->
            <div class="media">
              <img src="/static/img/user3-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
              <div class="media-body">
                <h3 class="dropdown-item-title">
                  Nora Silvester
                  <span class="float-right text-sm text-warning"><i class="fas fa-star"></i></span>
                </h3>
                <p class="text-sm">The subject goes here</p>
                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 4 Hours Ago</p>
              </div>
            </div>
            <!-- Message End -->
          </a>
          <div class="dropdown-divider"></div>
          <a href="#" class="dropdown-item dropdown-footer">See All Messages</a>
        </div>
      </li>

      <!-- Notifications Dropdown Menu -->
      <li class="nav-item dropdown">
        <a class="nav-link" data-toggle="dropdown" href="#">
          <i class="fas fa-bell"></i>
          <span class="badge badge-warning navbar-badge">15</span>
        </a>

        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
          <span class="dropdown-item dropdown-header">15 Notifications</span>
          <div class="dropdown-divider"></div>

          <a href="#" class="dropdown-item">
            <i class="fas fa-envelope mr-2"></i> 4 new messages
            <span class="float-right text-muted text-sm">3 mins</span>
          </a>
          <div class="dropdown-divider"></div>

          <a href="#" class="dropdown-item">
            <i class="fas fa-users mr-2"></i> 8 friend requests
            <span class="float-right text-muted text-sm">12 hours</span>
          </a>
          <div class="dropdown-divider"></div>


          <a href="#" class="dropdown-item">
            <i class="fas fa-file mr-2"></i> 3 new reports
            <span class="float-right text-muted text-sm">2 days</span>
          </a>
          <div class="dropdown-divider"></div>


          <a href="#" class="dropdown-item dropdown-footer">See All Notifications</a>
        </div>

      </li>
      <li class="nav-item">
        <a class="nav-link" data-widget="control-sidebar" data-slide="true" href="#">
          <i class="fas fa-th-large"></i>
        </a>
      </li>
    </ul>
  </nav>
  <!-- /.navbar -->

</template>

<script>
  import appNavbarSearchForm from './appNavbar/SearchForm'

  export default {
    components: {
      appNavbarSearchForm
    },
    data () {
      return {
        messageMenu: [
          {
            iconClass: 'far fa-comments', badgeVariant: 'danger', badgeValue: 3, children: [
              {
                type: 'media',
                imgSrc: '/img/user1-128x128.jpg',
                imgAlt: 'User Avatar',
                title: 'Brad Diesel',
                rightIcon: {
                  iconVariant: 'text-danger',
                  iconClass: 'fas fa-star'
                },
                messages: [
                  {message: "Call me whenever you can...", textVariant: ''},
                  {message: '4 Hours ago', iconClass: 'far fa-clock mr-1', textVariant: 'text-muted'},
                ]
              },
              {type: 'divider'},
              {
                type: 'media',
                imgSrc: '/img/user8-128x128',
                imgAlt: 'User Avatar',
                title: 'John Pierce',
                rightIcon: {
                  iconVariant: 'text-muted',
                  iconClass: 'fas fa-star'
                },
                messages: [
                  {message: 'got your message bro', textVariant: ''},
                  {message: '4 Hours Ago', iconClass: 'fa fa-clock mr-1', textVariant: 'text-muted'}
                ]
              },
              {type: 'divider'},
              {
                type: 'media',
                imgSrc: '/img/user3-128x128.jpg',
                imgAlt: 'User Aavatar',
                title: 'Nora Silverster',
                rightIcon: {
                  iconVariant: 'text-warning',
                  iconClass: 'fas fa-star'
                },
                messages: [
                  {message: 'The subject goes here'},
                  {message: '4 Hours ago', iconClass: 'far fa-clock mr-1', textVariant: 'text-muted'}
                ]
              },
              {type: 'divider'},
              {
                type: 'footer',
                link: '#',
                labelTag: 'see_all_messages'
              }
            ]
          }
        ],
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