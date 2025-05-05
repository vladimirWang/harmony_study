import axios, { AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'

const http = axios.create({
  // baseURL: 'https://jsonplaceholder.typicode.com'
  baseURL: 'http://192.168.3.134:3000/api'
})

http.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  console.log('interceptors request: ', config)
  return config
})

http.interceptors.response.use((resp: AxiosResponse) => {
  console.log('interceptors response: ', resp)
  return resp
}, (err: Error) => {
  console.log("interceptors error: ", err)
  return Promise.reject(err)
})

export default http