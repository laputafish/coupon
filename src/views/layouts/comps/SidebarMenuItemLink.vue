<template>
  <router-link ref="link" :to="{name: targetRoute}" class="nav-link d-flex flex-row line-height-1 align-items-center">
    <i class="nav-icon" :class="item.icon_class"></i>
    <div class="ml-2 d-inline">
      {{ $t(item.label_tag) }}
      <i v-if="item.type==='group'" class="fas fa-angle-left right"></i>
      <span v-if="item.badge" class="right badge"
            :class="getBadgeClass">
            {{ item.badge }}</span>
    </div>
  </router-link>
</template>

<script>
  export default {
    props: {
      item: {
        type: Object,
        default () {
          return {
            route_name: '',
            label_tag: '',
            type: 'group',
            icon_class: ''
          }
        }
      }
    },
    computed: {
      targetRoute () {
        const vm = this
        let result = ''
        if (vm.item) {
          result = vm.item.route_name ? vm.item.route_name : vm.item.label_tag
        }
        return result
      },
      getBadgeClass () {
        const vm = this
        return vm.item.badge_class ? 'badge-' + vm.item.badge_class : 'badge-primary'
      },
      link () {
        const vm = this
        return vm.item.type === 'group' ?
          '#' : vm.item.link
      }
    }
  }
</script>
