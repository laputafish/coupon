<template>
  <a href="#" class="nav-link">
    <i class="nav-icon" :class="item.icon_class"></i>
    <p>
      {{ $t(item.label_tag) }}
      <i v-if="item.type==='group'" class="fas fa-angle-left right"></i>
      <span v-if="item.badge" class="right badge"
            :class="getBadgeClass">
            {{ item.badge }}</span>
    </p>
  </a>
</template>

<script>
  export default {
    props: {
      item: {
        type: Object,
        default: null
      }
    },
    computed: {
      getBadgeClass () {
        const vm = this
        return vm.item.badge_class ? 'badge-' + vm.item.badge_class : 'badge-primary'
      },
      link () {
        let vm = this
        return vm.item.type === 'group' ?
          '#' : vm.item.link
      }
    }
  }
</script>
