<template>
  <div class="container-fluid">
    <title-row :record="record"
               :titleField="titleField"
               :loading="loading"
               :buttons="['back','save']"
               @onCommand="onCommandHandler"></title-row>
    <div class="row" v-if="record">

    </div>
  </div>
</template>

<script>
  import titleRow from '@/views/comps/TitleRow'

  export default {
    components: {
      titleRow
    },
    data () {
      return {
        apiPath: '/agents',
        titleField: 'name',
        record: null,
        loading: false,
        content: ''
      }
    },
    props: {
      recordId: {
        type: Number,
        default: 0
      }
    },
    watch: {
      recordId: function (newValue) {
        const vm = this
        vm.refresh(newValue)
      }
    },
    mounted () {
      const vm = this

      vm.refresh(vm.recordId)
    },
    methods: {
      save () {
        alert('save not implemented')
      },
      refresh (id) {
        const vm = this
        const data = {
          urlCommand: vm.apiPath + '/' + id
        }
      }
    }
  }
</script>
