<template>
  <div class="image-item mr-1 mb-1"
       @click="selectImage"
      :class="{'active':(activeImage && (activeImage.id===imageItem.id))}">
    <img :src="imageSrc"/>
    <div class="image-border">

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
.image-item .image-border {
  border: 5px solid transparent;
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}

.image-item.active .image-border {
  border-color: rgba(0, 123, 255, 1);
}
.image-item img {
  width: 100%;
  height: 100%;
}
</style>