import axios from 'axios'
import { Message } from 'element-ui'
import router from '@/router'

const request = axios.create({
  baseURL: process.env.VUE_APP_API_BASE_URL || '/api',
  timeout: 30000
})

// 请求拦截器 - 自动添加Authorization头
request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers['Authorization'] = 'Bearer ' + token
  }
  // 对于FormData请求，不设置Content-Type，让浏览器自动设置boundary
  if (config.data instanceof FormData) {
    delete config.headers['Content-Type']
  }
  return config
}, error => {
  console.error('[请求错误]', error)
  return Promise.reject(error)
})

// 响应拦截器 - 统一处理错误
request.interceptors.response.use(response => {
  const res = response.data
  // 处理blob下载响应
  if (response.config.responseType === 'blob') {
    return response
  }
  // 401未登录或Token过期
  if (res.code === 401) {
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
    if (router.currentRoute.path !== '/login') {
      router.push('/login')
    }
    Message.error(res.message || '登录已过期，请重新登录')
    return Promise.reject(new Error(res.message || '登录已过期'))
  }
  // 非200的业务错误
  if (res.code !== 200 && res.code !== undefined) {
    Message.error(res.message || '请求失败')
    return Promise.reject(new Error(res.message || '请求失败'))
  }
  return res
}, error => {
  // 网络错误或服务端5xx
  if (error.response) {
    const status = error.response.status
    if (status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
      if (router.currentRoute.path !== '/login') {
        router.push('/login')
      }
      Message.error('登录已过期，请重新登录')
    } else if (status === 403) {
      Message.error('没有访问权限')
    } else if (status >= 500) {
      Message.error('服务器错误，请稍后重试')
    } else {
      const data = error.response.data
      if (data && data.message) {
        Message.error(data.message)
      } else {
        Message.error('请求失败: ' + status)
      }
    }
  } else if (error.message && error.message.includes('timeout')) {
    Message.error('请求超时，请稍后重试')
  } else {
    Message.error('网络错误，请检查网络连接')
  }
  console.error('[响应错误]', error.message || error)
  return Promise.reject(error)
})

export default request
