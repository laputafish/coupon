<template>
  <div class="image-item ml-1 m-0"
       @click="selectImage"
       :class="{'active':activeImage===imageItem}">
    <img :src="imageSrc"/>
    <div class="image-border d-flex flex-column justify-content-between">
      <div>
        <button class="btn btn-circle btn-danger float-right"
                @click.prevent.stop="deleteImage">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <copy-link class="copy-link"
                 cssClass="copy-link-class"
                 :label="'['+imageItem.id+']'"
                 :link="imageSrc"
                 @onCommand="onCommandHandler"
                 :downloadLink="downloadLink"></copy-link>
    </div>
  </div>
</template>

<script>
import copyLink from '@/views/comps/CopyLink'

export default {
  components: {
    copyLink
  },
  computed: {
    downloadLink () {
      const vm = this
      return vm.$store.getters.appHost + '/download/image/' + vm.imageItem.id
    },
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
    onCommandHandler (payload) {
      const vm = this
      switch (payload.command) {
        case 'onLinkClicked':
          window.open(payload.link, '_blank')
          break
      }
    },
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

.image-item:hover .image-border .copy-link {
  display: flex !important;
}

.image-item:hover .image-border .btn-danger {
  display: block !important;
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
  border-color: #0080ff;
}

.image-item img {
  width: 100%;
  height: auto;
  position: absolute;
  top: 50%;
  transform: translate(0, -50%);
}

.image-item .image-border .copy-link {
  bottom: 0;
  left: 0;
  width: 100%;
  display: none !important;
}

.image-item .copy-link-class {
  background-color: rgba(128, 128, 128, .5);
  padding: 0 3px;
  border-radius: 0.5rem;
}

.image-item .copy-link-class .link-icon {
  color: white;
}

.image-item .copy-link-class .link-label {
  background-color: rgba(	0, 123, 255, .5);
}
</style>