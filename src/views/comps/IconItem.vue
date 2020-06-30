<template>
  <div class="icon-wrapper"
       @click="$emit('click',item)"
       :class="{'active':selected, 'disabled':disabled}">
    <div class="icon-img-container">
      <img :src="imgSrc"/>
      <div v-if="hasFault" class="position-absolute question-mark text-danger d-flex flex-column justify-content-center">
        ?
      </div>
      <div v-if="tagText!==''" class="icon-tag position-absolute"
           style="left: 2px;top:2px;">
        <div class="badge"
             :class="{'badge-warning':!disabled,'badge-muted':disabled}">{{ tagText }}</div>
      </div>
    </div>
    <div class="icon-img-title">
      {{ description }}
    </div>
    <div class="icon-notes text-center">
      {{ notes }}
                  <!--<span v-if="server.voucher_count && server.voucher_count >0">-->
                    <!--{{ server.voucher_count }}&nbsp;x&nbsp;<i class="fas fa-file-alt"></i>-->
                  <!--</span>-->
    </div>
  </div>

</template>

<script>
export default {
  props: {

    // with question mark
    hasFault: {
      type: Boolean,
      default: false
    },
    item: {
      type: Object,
      default: null
    },
    notes: {
      type: String,
      default: ''
    },
    iconKey: {
      type: String,
      default: 'smtp-server'
    },
    description: {
      type: String,
      default: ''
    },

    // with lightgray background
    selected: {
      type: Boolean,
      default: false
    },

    // turn icons to disabled mode
    disabled: {
      type: Boolean,
      default: false
    },

    tag: {
      tyep: String,
      default: ''
    }
  },
  computed: {
    tagText () {
      const vm = this
      var result = ''
      if (vm.tag !== '') {
        result = vm.tag
      } else {
        if (vm.item) {
          result = vm.item.tag
        }
      }
      return result
    },
    imgSrc () {
      const vm = this
      var result = ''
      switch (vm.iconKey) {
        case 'smtp-server':
          result = vm.disabled ? '/img/smtp_server_disabled.png' : '/img/smtp_server.png'
          break
      }
      return result
    }
  }
}
</script>
<style>
  .icon-wrapper.active {
    background-color: lightgray;
  }

  .icon-wrapper.disabled img {
    opacity: 0.2;
  }

  .icon-wrapper {
    text-align: center;
    padding: 10px 20px;
    margin-bottom: 5px;
    display: inline-block;
    width: 180px;
    height: 140px;
    border-radius: 0.5rem;
    cursor: pointer;
  }

  .icon-img-container {
    padding: 5px 30px;
    position: relative;
  }

  .question-mark {
    top:0;
    left:0;
    width:100%;
    height:100%;
    font-size:72px;
    text-align:center;
    font-family: arial;
    font-weight: bold;
  }

  .icon-img-container img {
    width: 100%;

    height: auto;
    object-fit: contain;
  }

  .icon-img-title {
    line-height: 1;
    margin-bottom: 5px;
    padding: 0;
    margin:0;
  }

  .smtp-server-status {
  }
</style>