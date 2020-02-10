<template>
    <section class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h1>{{ title }}</h1>
        </div>
        <div class="col-sm-6">
          <breadcrumb :items="breadcrumb"></breadcrumb>
        </div>
      </div>
    </div><!-- /.container-fluid -->
  </section>
</template>

<script>
  import breadcrumb from '@/views/layouts/comps/Breadcrumb'

  export default {
    components: {
      breadcrumb
    },
    props: {
      title: {
        type: String,
        default: ''
      },
      breadcrumb: {
        type: Array,
        default () {
          return []
        }
      }
    }

  }
</script>