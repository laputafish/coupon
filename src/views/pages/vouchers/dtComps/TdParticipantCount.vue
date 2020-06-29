<template>
  <div class="text-center line-height-1">
    {{ value }}
    <div v-if="row['has_one_code']" class="badge badge-success">AUTO</div>
    <div v-else class="badge badge-success">
      {{ row['participant_assigned'] }} assigned
    </div>
  </div>
</template>


<script>
export default {
  props: ['row','value','field','xprops']
}
</script>
