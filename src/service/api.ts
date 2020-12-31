import http from '../service'

export const helloGet = (params?: any, config?: any) => http.get('hello', { params, ...config })

export const helloPost = (params?: any, config?: any) => http.post('hello', params, config)
