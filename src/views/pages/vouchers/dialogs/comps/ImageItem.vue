<template>
  <div class="image-item ml-1 m-0"
       @click="selectImage"
      :class="{'active':activeImage===imageItem}">
    <img :src="imageSrc"/>
    <div class="image-border">
      <button class="btn btn-circle btn-danger"
              @click.prevent.stop="deleteImage"
        style="position:absolute;top:5px; right:5px;">
        <i class="fas fa-times"></i>
      </button>
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    imageSrc () {
      const vm = this
      return vm.$store.getters.appHost + '/media/image/' + vm.imageItem.id
    }
  },
  props: {
    imageItem: {
      type: Object,
      default: null
    },
    activeImage: {
      type: Object,
      default: null
    },
    objectFitMode: {
      type: String,
      default: 'cover'
    }
  },
  methods: {
    deleteImage () {
      const vm = this
      vm.$emit('onCommand', {
        command: 'onDeleteImage',
        image: vm.imageItem
      })
    },
    selectImage () {
      const vm = this
      console.log('ImageItem :: selectImage')
      vm.$emit('onCommand', {
        command: 'onImageSelected',
        image: vm.imageItem
      })
    }
  }
}
</script>

<style>
.image-item {
  width: 240px;
  height: 180px;
  display: inline-block;
  position: relative;
  overflow: hidden;
  margin: 0;
  padding: 0;
  border: none;
  cursor: pointer;
}
.image-item:hover .image-border .btn-danger {
  display: block;
}
.image-item .image-border .btn-danger {
  display: none;
}
.image-item:hover .image-border {
  border-color: #f6f6f6;
}

.image-item.active:hover .image-border {
  border-color: #3299ff;
}
.image-item .image-border {
  border: 5px solid transparent;
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}

.image-item.active .image-border {
  border-color:  #0080ff;
}
.image-item img {
  width: 100%;
  height: auto;
  position: absolute;
  top: 50%;
  transform: translate(0, -50%);
}
</style>