<template>
  <div class="wrapper">
    <app-navbar></app-navbar>
    <main-sidebar></main-sidebar>
    <!--&lt;!&ndash; Main Sidebar Container &ndash;&gt;-->
    <!--<aside class="main-sidebar sidebar-dark-primary elevation-4">-->
      <!--&lt;!&ndash; Brand Logo &ndash;&gt;-->
      <!--<a href="index3.html" class="brand-link">-->
        <!--<img src="dist/img/AdminLTELogo.png" alt="AdminLTE Logo" class="brand-image img-circle elevation-3"-->
             <!--style="opacity: .8">-->
        <!--<span class="brand-text font-weight-light">AdminLTE 3</span>-->
      <!--</a>-->

      <!--&lt;!&ndash; Sidebar &ndash;&gt;-->
      <!--<div class="sidebar">-->
        <!--&lt;!&ndash; Sidebar user panel (optional) &ndash;&gt;-->
        <!--<div class="user-panel mt-3 pb-3 mb-3 d-flex">-->
          <!--<div class="image">-->
            <!--<img src="dist/img/user2-160x160.jpg" class="img-circle elevation-2" alt="User Image">-->
          <!--</div>-->
          <!--<div class="info">-->
            <!--<a href="#" class="d-block">Alexander Pierce</a>-->
          <!--</div>-->
        <!--</div>-->

        <!--&lt;!&ndash; Sidebar Menu &ndash;&gt;-->
        <!--<nav class="mt-2">-->
          <!--<ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">-->
            <!--&lt;!&ndash; Add icons to the links using the .nav-icon class-->
                 <!--with font-awesome or any other icon font library &ndash;&gt;-->
            <!--<li class="nav-item has-treeview menu-open">-->
              <!--<a href="#" class="nav-link active">-->
                <!--<i class="nav-icon fas fa-tachometer-alt"></i>-->
                <!--<p>-->
                  <!--Starter Pages-->
                  <!--<i class="right fas fa-angle-left"></i>-->
                <!--</p>-->
              <!--</a>-->
              <!--<ul class="nav nav-treeview">-->
                <!--<li class="nav-item">-->
                  <!--<a href="#" class="nav-link active">-->
                    <!--<i class="far fa-circle nav-icon"></i>-->
                    <!--<p>Active Page</p>-->
                  <!--</a>-->
                <!--</li>-->
                <!--<li class="nav-item">-->
                  <!--<a href="#" class="nav-link">-->
                    <!--<i class="far fa-circle nav-icon"></i>-->
                    <!--<p>Inactive Page</p>-->
                  <!--</a>-->
                <!--</li>-->
              <!--</ul>-->
            <!--</li>-->
            <!--<li class="nav-item">-->
              <!--<a href="#" class="nav-link">-->
                <!--<i class="nav-icon fas fa-th"></i>-->
                <!--<p>-->
                  <!--Simple Link-->
                  <!--<span class="right badge badge-danger">New</span>-->
                <!--</p>-->
              <!--</a>-->
            <!--</li>-->
          <!--</ul>-->
        <!--</nav>-->
        <!--&lt;!&ndash; /.sidebar-menu &ndash;&gt;-->
      <!--</div>-->
      <!--&lt;!&ndash; /.sidebar &ndash;&gt;-->
    <!--</aside>-->

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper" style="min-height: 695px;">
      <!-- Content Header (Page header) -->
      <div class="content-header">
        <div class="container-fluid">
          <div class="row mb-2">
            <div class="col-sm-6">
              <h1 class="m-0 text-dark">Starter Page</h1>
            </div><!-- /.col -->
            <div class="col-sm-6">
              <ol class="breadcrumb float-sm-right">
                <li class="breadcrumb-item"><a href="#">Home</a></li>
                <li class="breadcrumb-item active">Starter Page</li>
              </ol>
            </div><!-- /.col -->
          </div><!-- /.row -->
        </div><!-- /.container-fluid -->
      </div>
      <!-- /.content-header -->

      <!-- Main content -->
      <div class="content">
        <div class="container-fluid">
          <div class="row">
            <div class="col-lg-6">
              <div class="card">
                <div class="card-body">
                  <h5 class="card-title">Card title</h5>

                  <p class="card-text">
                    Some quick example text to build on the card title and make up the bulk of the card's
                    content.
                  </p>

                  <a href="#" class="card-link">Card link</a>
                  <a href="#" class="card-link">Another link</a>
                </div>
              </div>

              <div class="card card-primary card-outline">
                <div class="card-body">
                  <h5 class="card-title">Card title</h5>

                  <p class="card-text">
                    Some quick example text to build on the card title and make up the bulk of the card's
                    content.
                  </p>
                  <a href="#" class="card-link">Card link</a>
                  <a href="#" class="card-link">Another link</a>
                </div>
              </div><!-- /.card -->
            </div>
            <!-- /.col-md-6 -->
            <div class="col-lg-6">
              <div class="card">
                <div class="card-header">
                  <h5 class="m-0">Featured</h5>
                </div>
                <div class="card-body">
                  <h6 class="card-title">Special title treatment</h6>

                  <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                  <a href="#" class="btn btn-primary">Go somewhere</a>
                </div>
              </div>

              <div class="card card-primary card-outline">
                <div class="card-header">
                  <h5 class="m-0">Featured</h5>
                </div>
                <div class="card-body">
                  <h6 class="card-title">Special title treatment</h6>

                  <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                  <a href="#" class="btn btn-primary">Go somewhere</a>
                </div>
              </div>
            </div>
            <!-- /.col-md-6 -->
          </div>
          <!-- /.row -->
        </div><!-- /.container-fluid -->
      </div>
      <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <control-sidebar></control-sidebar>
    <app-footer></app-footer>

    <div id="sidebar-overlay"></div>
  </div>
</template>

<script>
  import appNavbar from './xxcompsx/AppNavbar'
  import mainSidebar from './xxcompsx/MainSidebar'
  import controlSidebar from './xxcompsx/ControlSidebar'
  import appFooter from './xxcompsx/AppFooter'

  export default {
    components: {
      appNavbar,
      appFooter,
      controlSidebar,
      mainSidebar
    }
  }
</script>