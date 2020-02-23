const webpack = require('webpack')

module.exports = {
  // configureWebpack: {
  //   plugins: [
  //     new webpack.ProvidePlugin({
  //       $: "jquery",
  //       jQuery: "jquery",
  //       "windows.jQuery": "jquery"
  //     })
  //   ]
  // },
  runtimeCompiler: true,
  lintOnSave: process.env.NODE_ENV !== 'test',
  pluginOptions: {
    i18n: {
      locale: 'en',
      fallbackLocale: 'en',
      localeDir: 'langs',
      enableInSFC: true
    }
  }
}
