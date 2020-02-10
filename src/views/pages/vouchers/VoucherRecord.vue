<template>
<div class="container-fluid">
  <div class="row">
    <div class="col-12">
      <div class="btn-toolbar mb-1 justify-content-end" role="toolbar" aria-label="Toolbar with buttons">
        <button type="button"
                @click="save()"
                class="btn btn-primary">
          <i class="fas fa-save"></i>&nbsp;{{ $t('buttons.save') }}
        </button>
      </div>
    </div>
  </div>
</div>
</template>

<script>
  export default {
    props: {
      type: Object,
      default: null
    },
    methods: {
      save () {
        alert('save')
      }
    }
  }
</script>
