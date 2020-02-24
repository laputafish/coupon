<template>
  <base-dialog
      id="voucherSelectDialog"
      :title="title"
      modalType="confirmation"
      :okButtonState="selectedVoucher!==null"
      size="xl"
      :value="value"
      @onCommand="onCommandHandler"
      @input="value=>$emit('input',value)">
    <template v-slot:dialogBody>
      <div class="left-pane">
        {{ $t('menu.agents') }}
        <div class="left-pane-scroll">
          <b-list-group style="line-height:1;">
            <b-list-group-item v-for="agent in agents"
                               @click="selectedAgent=agent"
                               :class="{'active': selectedAgent && selectedAgent.id===agent.id}"
                               :key="agent.id">
              {{ agent.name }}&nbsp;<div class="badge badge-info">{{ agent.voucher_count }}</div>
            </b-list-group-item>
          </b-list-group>
        </div><!-- left-pane-scroll -->
      </div><!-- left-pane -->
      <div class="right-pane">
        {{ $t('menu.vouchers') }}
        <div class="right-pane-scroll">
          <b-list-group style="line-height:1;">
            <h3 v-if="loading" class="text-center pt-5">
              <font-awesome-icon v-if="loading" icon="spinner" class="fa-spin" />
            </h3>
            <b-list-group-item v-else v-for="voucher in vouchers"
                               @click="selectedVoucher=voucher"
                               :class="{'active': selectedVoucher==voucher}"
                               class="voucher-item"
                               :key="voucher.id">
              <h5 class="p-0 m-0">{{ voucher.description }}</h5>
              <small class="voucher-note d-flex flex-row justify-content-between">
                <div class="mr-auto d-inline-block">
                  Coupon Count: <div class="d-inline note-value">{{ voucher.code_count }}</div>
                </div>
                <div class="d-inline-block">
                  Created at: <div class="d-inline note-value">{{ voucher.created_at }}</div>
                </div>
              </small>
            </b-list-group-item>
          </b-list-group>
        </div><!-- right-pane-scroll -->
      </div><!-- right-pane -->

    </template>
  </base-dialog>
</template>

<script>
  import baseDialog from '@/views/comps/BaseDialog'
  import appMixin from '@/mixins/AppMixin'

  export default {
    mixins: [appMixin],
    components: {
      baseDialog
    },
    props: {
      id: {
        type: String,
        default: ''
      },
      title: {
        type: String,
        default: ''
      },
      value: {
        type: Boolean,
        default: false
      },
      initialAgentId: {
        type: Number,
        default: 0
      }
    },
    computed: {
      agents () {
        return this.$store.getters.agents
      }
    },
    model: {
      prop: 'value',
      event: 'input'
    },
    data () {
      return {
        loading: false,
        selectedAgent: null,
        selectedVoucher: null,
        vouchers: []
      }
    },
    watch: {
      initialAgentId: function () {
        console.log('watch(initialAgentId)')
        this.setInitialAgent()
      },
      'selectedAgent.id': function (newValue) {
        const vm = this
        console.log('watch(selectedAgent) :: selectedAgent.id = ' + newValue)
        vm.selectedVoucher = null
        vm.fetchAgentVouchers()
      }
    },
    mounted () {
      const vm = this
      vm.setInitialAgent()
      vm.fetchAgentVouchers()
    },
    methods: {
      onCommandHandler (payload) {
        const vm = this
        console.log('VoucherSelectDialog :; onCommandHandler :: payload: ', payload)
        const command = payload.command
        switch (command) {
          case 'ok':
            if (vm.selectedVoucher) {
              vm.$emit('onCommand', {
                command: 'copyTemplate',
                voucher: vm.selectedVoucher
              })
            }
            break
        }
      },
      setInitialAgent () {
        const vm = this
        console.log('setInitialAgent :: initialAGentId = ' + vm.initialAgentId)
        console.log('setInitialAgent :: agents.length = ' + vm.agents.length)
        if (vm.initialAgentId === 0) {
          vm.selectedAgent = null
        } else {
          for (let i = 0; i < vm.agents.length; i++) {
            if (vm.agents[i].id === vm.initialAgentId) {
              vm.selectedAgent = vm.agents[i]
              break
            }
          }
        }
        console.log('selectedAgent: ', vm.selectedAgent)
      },
      fetchAgentVouchers () {
        const vm = this
        if (vm.selectedAgent) {
          const data = {
            urlCommand: '/vouchers',
            options: {
              params: {
                agentId: vm.selectedAgent.id,
                type: 'selection'
              }
            }
          }
          vm.loading = true
          vm.$store.dispatch('AUTH_GET', data).then(
            response => {
              vm.loading = false
              vm.vouchers = response
              console.log('GET vouchers')
            },
            () => {
              vm.loading = false
              vm.showSessionExpired()
              // vm.$dialog.alert('Vouchers: ' + vm.$t('messages.error_during_loading'))
            }
          )
        }
      }
      // fetchAgents () {
      //   const vm = this
      //   vm.$store.dispatch('AUTH_GET', '/agents').then(
      //     response => {
      //       // console.log('fetchAgents: redsponse: ', response)
      //       vm.agents = response
      //     },
      //     error => {
      //       vm.$dialog.alert('Agents: ' + vm.$t('messages.error_during_loading'))
      //     }
      //   )
      // }
    }
  }
</script>

<style>
  .left-pane {
    padding-right: 10px;
    width: 40%;
  }

  .right-pane {
    width: 60%;
  }

  .left-pane-scroll {
    overflow-y: scroll;
    height: 0;
    min-height: 100%;
  }

  .right-pane-scroll {
    overflow-y: scroll;
    height: 0;
    min-height: 100%;
  }

  #voucherSelectDialog {
    display: flex !important;
    flex-direction: column;
  }

  #voucherSelectDialog .modal-dialog {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    width: 100%;
  }

  #voucherSelectDialog .modal-dialog [role=document] {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
  }

  #voucherSelectDialog .modal-dialog [role=document] .modal-body {
    flex-grow: 1;
    display: flex;
    flex-direction: row;
  }

  #voucherSelectDialog .list-group-item {
    cursor: pointer;
  }

  #voucherSelectDialog .list-group-item.voucher-item {
    padding: 0.35rem 0.7rem;
  }

  #voucherSelectDialog .list-group-item .voucher-note {
    color: rgba(0,0,0,.3);
  }

  #voucherSelectDialog .list-group-item .voucher-note .note-value {
    color: black
  }

  #voucherSelectDialog .list-group-item.active .voucher-note {
    color: rgba(255,255,255,.5);
  }

  #voucherSelectDialog .list-group-item.active .voucher-note .note-value {
    color: white;
  }

</style>