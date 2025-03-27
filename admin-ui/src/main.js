import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import App from './App.vue'
import router from './router'
import axios from 'axios'
import { ElMessage } from 'element-plus'

// 配置 axios
axios.defaults.baseURL = 'http://localhost:9000'

// 初始化时设置 token
const token = localStorage.getItem('token')
if (token) {
  axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
}

axios.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      // 确保 token 格式正确
      const tokenValue = token.startsWith('Bearer ') ? token : `Bearer ${token}`
      config.headers.Authorization = tokenValue
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
axios.interceptors.response.use(
  response => {
    return response
  },
  error => {
    if (error.response) {
      switch (error.response.status) {
        case 401:
          // token 过期或无效
          localStorage.removeItem('token')
          router.push('/login')
          break
        case 403:
          // 权限不足
          ElMessage.error('权限不足')
          break
        case 500:
          // 服务器错误
          ElMessage.error('服务器错误')
          break
        default:
          ElMessage.error('请求失败')
      }
    }
    return Promise.reject(error)
  }
)

const app = createApp(App)

// 注册所有图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(ElementPlus)
app.use(router)
app.mount('#app') 