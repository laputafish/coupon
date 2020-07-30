<template>
  <div :class="'col-sm-' + width">
    <validation-provider ref="provider" v-slot="{errors,invalid}">
      <div class="form-group">
        <label :for="id">{{ inputLabel }}</label>
        <div class="input-group">
          <input class="form-control"
                 :class="{'border-danger':errors.length>0}"
                 :id="id"
                 :name="id"
                 :type="inputType"
                 autocomplete="new-password"
                 :value="value"
                 @input="$event=>$emit('input',$event.target.value)"/>
          <button class="input-group-append" @click="toggleShowingPassword">
            <font-awesome-icon v-if="showingPassword" icon="eye" class="fa-fw"></font-awesome-icon>
            <font-awesome-icon v-else icon="eye-slash" class="fa-fw"></font-awesome-icon>
          </button>
        </div>

      </div>
    </validation-provider>
  </div>
</template>

<script>
  export default {
    data () {
      return {
        inputType: 'password',
        showingPassword: false,
      }
    },
    model: {
      prop: 'value',
      event: 'input'
    },
    props: {
      rules: {
        type: String,
        default: ''
      },
      id: {
        type: String,
        default: ''
      },
      label: {
        type: String,
        default: ''
      },
      labelTag: {
        type: String,
        default: ''
      },
      value: {
        type: [String, Number],
        default: ''
      },
      width: {
        type: String,
        default: ''
      }
    },
    computed: {
      inputLabel () {
        const vm = this
        var result = vm.label
        if (vm.labelTag !== '') {
          result = vm.$t(vm.labelTag)
        }
        return result
      }
    },
    methods: {
      toggleShowingPassword () {
        const vm = this
        vm.showingPassword = !vm.showingPassword

        if (vm.showingPassword) {
          vm.inputType = 'text'
        } else {
          vm.inputType = 'password'
        }
      }
    }
  }
</script>