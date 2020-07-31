<template>
  <div class="authorization-page">
      <div class="row pt-2">
        <div class="col-sm-12">
          <div class="form-group mb-3">
            <label>Authorized Users</label>
          </div>
        </div>
        <div class="col-sm-12 mb-2">
          <div class="input-group" style="max-width:320px;">
            <input v-model="email"
                   placeholder="Type in the email"
                   class="form-control"/>
            <button class="input-group-append"
              type="button"
                    :class="{'btn-primary':email!=='', 'btn-muted':email===''}"
              :disabled="email===''"
              @click="addUser">
              <font-awesome-icon icon="plus"></font-awesome-icon>
            </button>
          </div>
        </div>
      </div>
      <hr/>
      <div class="container-fluid">
        <!--<draggable :value="authorizedUsers"-->
                   <!--@input="value=>updateAuthorizedUsers(value)"-->
                   <!--v-bind="dragOptions"-->
                   <!--:move="onMove"-->
                   <!--class="row"-->
                   <!--@start="isDragging=true"-->
                   <!--@end="isDragging=false">-->
          <authorized-user-item
              v-for="user in authorizedUsers"
              :key="user.id"
              class="col-sm-6 col-lg-4"
              @onCommand="onCommandHandler"
              :selected="selectedUser=user"
              :user="user"></authorized-user-item>
        <!--</draggable>-->
      </div>
  </div>
</template>

<script>
  import draggable from "vuedraggable"
  import authorizedUserItem from './page_authorization/AuthorizedUserItem'

export default {
  components: {
    draggable,
    authorizedUserItem
  },
  props: {
    record: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      email: '',
      authorizedUsers: [],
      isDragging: false
    }
  },
  computed: {
    dragOptions () {
      return {
        animation: 0,
        group: "description",
        disabled: !this.editable,
        ghostClass: "ghost"
      };
    }
  },
  mounted () {
    const vm = this
    vm.refresh()
  },
  methods: {
    onMove ({relatedContext, draggedContext}) {
      const relatedElement = relatedContext.element;
      const draggedElement = draggedContext.element;
      return (
        (!relatedElement || !relatedElement.fixed) && !draggedElement.fixed
      );
    },

    newRecord () {
      const vm = this
      console.log('RedemptionPage :: newRecord :: vm.$refs.redemptionLocationTable : ', vm.$refs.redemptionLocationTable)
      vm.$refs.redemptionLocationTable.newRecord()
    },
    refresh () {
      const vm = this
      const getData = {
        urlCommand: '/vouchers/' + vm.record.id + '/authorized_users'
      }
      vm.$store.dispatch('AUTH_GET', getData).then(
        response => {
          vm.authorizedUsers = response
        }
      )
    },
    useDefault () {

    },
    exportLocationSummary () {

    },
    async validate () {
      const vm = this
      return vm.$refs.infoPageObserver.validate()
    },
    onCommandHandler (payload) {
      const vm = this
      console.log('onCommandHandler :: payload: ', payload)
      switch (payload.command) {
        case 'deleteUser':
          vm.deleteUser(payload.row)
          break
      }
    },
    addUser () {
      const vm = this
      const postData = {
        urlCommand: '/vouchers/' + vm.record.id + '/authorized_users',
        data: {
          email: vm.email
        }
      }
      vm.$store.dispatch('AUTH_POST', postData).then(
        response => {
          vm.refresh()
        },
        error => {
          vm.$dialog.alert(error.message)
        }
      )
    },
    deleteUser (row) {
      const vm = this
      console.log('AuthorizationPage :: deleteUser')
      console.log('AuthorizationPage :: deleteUser :: vm.record: ', vm.record)
      const deleteData = {
        urlCommand: '/vouchers/' + vm.record.id + '/authorized_users/' + row.id
      }
      vm.$store.dispatch('AUTH_DELETE', deleteData).then(
        response => {
          vm.refresh()
        }
      )
    }
  }
}
</script>

<style>
.authorization-page button.btn-muted:hover {
  background-color: rgba(239, 239, 239, 0.3);
}

.authorization-page button.btn-primary:hover {
  background-color: #0069d9;
}
</style>