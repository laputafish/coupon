<template>
  <b-modal :id="id" :title="title"
    @ok="handleOk">
    <p>{{ messages }}</p>
    <input class="form-control text-capitalize" v-model="userMessage"/>
    <small>{{ $t('messages.type_delete_to_force_deletion') }}</small>
  </b-modal>
</template>

<script>
export default {
  props: {
    id: {
      type: String,
      default: ''
    },
    title: {
      type: String,
      default: ''
    },
    messages: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      userMessage: ''
    }
  },
  methods: {
    handleOk () {
      const vm = this
      if (vm.userMessage.toUpperCase() === 'DELETE') {
        vm.$emit('onCommand', {
          command: 'deleteByForce'
        })
      }
    }
  }
}
</script>