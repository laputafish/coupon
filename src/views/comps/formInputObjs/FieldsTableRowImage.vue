<template>
  <tr>
    <td class="align-middle line-height-1 label-cell">
      <div>{{ label }}</div>
      <small class="field-notes" v-if="notes !== ''">{{ notes }}</small>
    </td>
    <td class="value-cell">
      <div ref="imageInput" class="input-group">
        <input :type="type"
               :value="value"
               class="form-control"
               @input="$event=>{updateField($event.target.value)}"/>
        <button class="input-group-append"
          @click="selectImage">
          <i class="fas fa-fw fa-images"></i>
        </button>
        <button class="input-group-append"
          @click="uploadImage">
          <i class="fas fa-fw fa-upload"></i>
        </button>
        <input ref="imageUploader" id="image-uploader" type="file"
               @change="$event=>uploadImageFile($event.target)"
               name="pic" accept="image/*" style="width:1px;">
      </div>
    </td>
  </tr>
</template>

<script>
export default {
  model: {
    prop: 'value',
    event: 'input'
  },
  props: {
    label: {
      type: String,
      value: ''
    },
    notes: {
      type: String,
      value: ''
    },
    value: {
      type: String,
      value: ''
    },
    type: {
      type: String,
      value: 'text'
    },
    fieldName: {
      type: String,
      value: ''
    }
  },
  methods: {
    updateField (fieldValue) {
      const vm = this
      vm.$emit('onCommand', {
        command: 'updateField',
        fieldName: vm.fieldName,
        fieldValue: fieldValue
      })
    },
    selectImage () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'selectImage',
        fieldName: 'question'
      })
    },
    uploadImage () {
      const vm = this
      vm.$refs.imageUploader.click()
    },
    uploadImageFile (obj) {
      const vm = this
      var input = obj
      var data = new FormData()
      data.append('file', input.files[0])
      data.append('scope', 'general')

      vm.$store.dispatch('AUTH_UPLOAD_IMAGE', data).then(response => {
        var imageUrl = response.result.imageUrl
        vm.$emit('onCommand', {
          command: 'updateField',
          fieldName: 'question',
          fieldValue: imageUrl
        })
      },
      error => {
        vm.$toaster.error(vm.$t('messages.' + error.messageTag))
      })
    }
  }
}
</script>

<style>
  .field-notes {
    color: rgb(160,160,160);
  }
</style>