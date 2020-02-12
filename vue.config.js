module.exports = {
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
