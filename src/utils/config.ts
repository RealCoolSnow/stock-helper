import { formatTime } from './util'

// const isDev = process.env.NODE_ENV !== 'production'

class Config {
  static _instance: any
  store: any
  static getInstance() {
    if (!Config._instance)
      Config._instance = new Config()

    return Config._instance
  }

  constructor() {
    const schema = {
      debug: {
        type: 'boolean',
      },
      launch_time: {
        type: 'string',
      },
      cwd: {
        type: 'string',
      },
    }
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const _Store = require('electron-store')
    this.store = new _Store({
      schema,
    })
    this.store.set('launch_time', formatTime(new Date()))
    console.log('config path: ', this.store.path)
    this._init()
    console.log('config data: ', this.store.store)
  }

  private _init() {
    //
    this._setDefaultValue('debug', false)
    this._setDefaultValue2('cwd', process.cwd(), true)
  }

  private _setDefaultValue(key: string, value: any) {
    this._setDefaultValue2(key, value, false)
  }

  private _setDefaultValue2(key: string, value: any, resetFlag: boolean) {
    if (resetFlag || !this.has(key))
      this.set(key, value)
  }

  isDebug() {
    return this.get('debug', false)
  }

  set(key: string, value: any) {
    this.store.set(key, value)
  }

  get(key: string, defaultValue: any) {
    return this.store.get(key, defaultValue)
  }

  has(key: string) {
    return this.store.has(key)
  }

  delete(key: string) {
    this.store.delete(key)
  }

  clear() {
    this.store.clear()
  }
}
export {
  Config,
}
