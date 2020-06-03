<template>
<div class="template-tag-list d-flex flex-column align-items-stretch">
  <!--<b-button @click="showCopyTemplateDialog"-->
            <!--class="btn btn-primary mb-3 w-100">-->
    <!--{{ $t('vouchers.copyTemplateFrom') }}-->
  <!--</b-button>-->
  <h6 v-if="templateTagGroups.length>0">Token List</h6>
  <div v-for="tagGroup in templateTagGroups"
       :key="tagGroup['name']">
    {{ $t('vouchers.' + tagGroup['name']) }}
    <ul class="token-list list-unstyled px-2 mb-1">
      <li v-for="templateTag in tagGroup.tags"
          :key="templateTag">
        <div @click="insertTag(templateTag)"
             class="badge badge-warning"><i class="fas fa-plus"></i>&nbsp;{{ '{'+templateTag+'}' }}
        </div>
      </li>
    </ul>
  </div>

</div>
</template>

<script>
export default {
  props: {
    templateTagGroups: {
      type: Array,
      default () {
        return []
      }
    }
  },
  methods: {
    insertTag (tag) {
      this.$emit('onCommand', {
        command: 'insertTag',
        value: tag
      })
    },
  }
}
</script>

<style>
  .template-tag-list {
    width: 242px;
  }
</style>