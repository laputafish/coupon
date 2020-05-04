<template>
<div class="d-flex flex-row justify-content-end align-items-center">
  <h4 class="d-inline-block mr-2 my-0">
     <font-awesome-icon icon="search" />
  </h4>
  <form @submit.prevent="dummy()">
    <div class="form-group m-0 d-inline-block" style="">
      <div class="input-group">
        <input class="form-control"
               :value="searchValue"
               @input="$event=>search($event.target.value)"/>
        <div class="input-group-append">
          <button type="button" @click="search('')">
            <i class="fas fa-fw fa-times"></i>
          </button>
        </div>
      </div>
    </div>
  </form>
  <h3 v-if="appLoading" class="d-inline-block ml-3 my-0 mr-auto">
     <font-awesome-icon icon="spinner" class="fa-spin"/>
  </h3>
  <!--<div v-if="codeInfos.length>0" class="badge badge-warning">{{ codeInfos.length }}</div>-->
</div>
</template>

<script>
export default {
  props: {
    searchValue: {
      type: String,
      default: ''
    },
    appLoading: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    dummy () {},
    search (value) {
      const vm = this
      vm.$emit('onCommand', {
        'command': 'search',
        'searchValue': value
      })
    }
  }
}
</script>