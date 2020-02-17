<template>
  <b-dropdown-item>
    <div class="media">
      <img :src="item.imgSrc"
           :alt="item.imgAlt"
           :class="item.imgClass">
      <div class="media-body">
        <h3 class="dropdown-item-title">
          {{ item.title }}
          <span v-if="item.rightIcon" class="float-right text-sm"
                :class="item.rightIcon.iconVariant">
            <i :class="item.rightIcon.iconClass"></i>
          </span>
        </h3>
        <p class="text-sm" v-for="(message, index) in item.messages"
           :class="message.textVariant">
           <i v-if="message.iconClass" :iconClass="message.iconClass"></i>
          {{ message.text }}
        </p>
      </div>
    </div>
  </b-dropdown-item>
</template>

<script>
export default {
  computed: {
    iconCssClass () {
      const vm = this
      return 'text-' + vm.item.iconVariant
    }
  },
  props: {
    item: {
      type: Object,
      default () {
        return {
          type: 'media',
          imgSrc: '',
          imgAlt: '',
          title: '',
          rightIcon: null,
          messages: []
        }
      }
    }
  }
}
</script>
