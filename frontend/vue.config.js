module.exports = {
  publicPath: process.env.NODE_ENV === 'production'
    ? '/test-teaching-platform/'
    : '/',
  devServer: {
    port: 3000,
    host: '0.0.0.0',
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      '/uploads': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  },
  lintOnSave: false
}
