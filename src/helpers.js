const getToday = () => {
  const dateObj = new Date()
  const month = dateObj.getUTCMonth() + 1
  const day = dateObj.getUTCDate()
  const year = dateObj.getUTCFullYear()

  const monthStr = month < 10 ? '0' + month.toString() : month.toString()
  const dayStr = day < 10 ? '0' + day.toString() : day.toString()
  const yearStr = year.toString()

  return yearStr + '-' + monthStr + '-' + dayStr
}

const str2token = (prefix, str) => {
  return '{' + prefix + str.toLowerCase().replace(' ', '_').replace(/[^a-z0-9_]/gi,'') + '}'
}

const getKeyPairArray = (str, pairSeparator, keyValueSeparator) => {
  if (typeof pairSeparator === 'undefined') {
    pairSeparator = '|'
  }
  if (typeof keyValueSeparator === 'undefined') {
    keyValueSeparator = ':'
  }
  console.log('getKeyPairArray :: str = ' + str)
  console.log('getKeyPairArray :: pairSeparator = ' + pairSeparator)
  console.log('getKeyPairArray :: keyValueSeparator = ' + keyValueSeparator)

  const pairs = str.split(pairSeparator)
  console.log('getKeyPairArray :: pairs: ', pairs)

  let result = []
  for (let i = 0; i < pairs.length; i++) {
    const keyValue = pairs[i].split(keyValueSeparator)
    console.log('i=' + i + ': pairs[i]: ', pairs[i])
    console.log('i=' + i + ': keyValue: ', keyValue)

    result.push(keyValue)
    console.log('getKeyPairArray :: result: ', result)
  }
  console.log('getKeyPairArray :: result: ', result)
  return result
}

// const unSubscribe = (vm) => {
//   if (vm.pusher) {
//     vm.pusher.disconnect()
//   }
// }
//
// const subscribe = (vm, teamId, channelHandlers) => {
//   const constants = vm.$store.getters.constants
//   if (vm.pusherSubscribed) {
//     unSubscribe(vm)
//   }
//   if (teamId) {
//     vm.pusher = new Pusher(constants.PUSHER_APP_KEY, {cluster: constants.PUSHER_CLUSTER})
//     // console.log('helpers: subscribe: created pusher')
//     vm.pusher.subscribe('team_' + teamId)
//
//     for (var i = 0; i < channelHandlers.length; i++) {
//       const channelHandler = channelHandlers[i]
//       // console.log('helpers: subscribe: added channel: ' + channelHandler.channel)
//       vm.pusher.bind(channelHandler.channel, data => channelHandler.handler(data))
//     }
//
//     vm.pusherSubscribed = true
//   }
// }

const addPagination = (query, config) => {
  if (query) {
    const page = Math.floor(query.offset / query.limit) + 1
    if (typeof config === 'undefined') {
      config = {}
    }
    config = {
      ...config,
      params: {
        ...query,
        page: page
      }
    }
  }
  return config
}

const array2str = (ar) => {
  const items = []
  for (let i = 0; i < ar.length; i++) {
    if (ar[i] !== '') {
      items.push(ar[i].trim())
    }
  }
  return items.length > 0 ? items.join(' ') : ''
}

const showWarning = (vm, message, options) => {
  if (typeof message === 'undefined') {
    message = vm.$t('messages.unexpected_errors')
  }
  if (typeof options === 'undefined') {
    options = {
      okText: vm.$t('buttons.ok'),
      cancelText: vm.$t('buttons.cancel'),
      animation: 'bounce'
    }
  }
  vm.$dialog.alert({
    title: vm.$t('general.warning'),
    body: message.toString()
  }, options).then(function () {
  // }, options).then(function (dialogRef) {
    alert('alert')
  })
}

const showConfirmDialog = (vm, callback, data, message, options) => {
  if (typeof message === 'undefined') {
    message = vm.$t('messages.are_you_sure')
  }
  if (typeof options === 'undefined') {
    options = {
      okText: vm.$t('buttons.ok'),
      cancelText: vm.$t('buttons.cancel'),
      animation: 'bounce'
    }
  }
  vm.$dialog.confirm({
    title: vm.$t('general.confirmation'),
    body: message
  }, options).then(function () {
    if (typeof callback === 'function') {
      callback(data)
    }
  })
}

export default {
  getKeyPairArray,
  str2token,
  getToday,
  // subscribe,
  // unSubscribe,
  addPagination,
  showWarning,
  showConfirmDialog,
  array2str
}
