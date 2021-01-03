/* eslint-disable @typescript-eslint/no-var-requires */
import { Config } from './utils/config.ts'
const { app, BrowserWindow, globalShortcut, protocol, Tray, nativeImage } = require('electron')
const WindowStateKeeper = require('electron-window-state')
const stock = require('./utils/stock.js')
const isMac = process.platform === 'darwin'
const loadTryTimes = 10
let isDev = !app.isPackaged
let isDevTools = isDev
let mainWindow

// Scheme must be registered before the app is ready
protocol.registerSchemesAsPrivileged([
  { scheme: 'app', privileges: { secure: true, standard: true } },
])

function createWindow(windowName = 'main', options = {}) {
  const winOptions = {
    minWidth: 400,
    minHeight: 600,
    titleBarStyle: 'hidden',
    autoHideMenuBar: true,
    // trafficLightPosition: {
    //   x: 20,
    //   y: 32,
    // },
    ...options,
    webPreferences: {
      devTools: isDevTools,
      spellcheck: false,
      nodeIntegration: true,
      ...(options.webPreferences || {}),
    },
  }

  const windowState = WindowStateKeeper({
    defaultWidth: winOptions.minWidth,
    defaultHeight: winOptions.minHeight,
  })

  const win = new BrowserWindow({
    ...winOptions,
    x: windowState.x,
    y: windowState.y,
    width: windowState.width,
    height: windowState.height,
  })
  windowState.manage(win)

  win.once('ready-to-show', () => {
    win.show()
    win.focus()
  })
  return win
}

async function createMainWindow() {
  loadConfig()
  mainWindow = createWindow('main', {
    icon: 'public/icon.ico',
    webPreferences: {
      // 取消跨域限制
      webSecurity: false,
      enableRemoteModule: true,
    },
    // backgroundColor: fullTailwindConfig.theme.colors.primary[800],
  })
  mainWindow.once('close', () => {
    mainWindow = null
  })
  const port = process.env.PORT || 3000
  const url = isDev
    ? `http://localhost:${port}`
    : `file://${__dirname}/../dist/index.html`

  let t = loadTryTimes
  const loadUrl = () => {
    mainWindow.loadURL(url).catch(() => {
      if (isDev && t-- > 0) setTimeout(loadUrl, 500)
    })
  }
  loadUrl()

  if (isDevTools)
    mainWindow.webContents.openDevTools()
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', () => {
  createMainWindow()
  createTray()
})

// On macOS it's common to re-create a window in the app when the
// dock icon is clicked and there are no other windows open.
app.on('activate', () => {
  if (!mainWindow) createMainWindow()
  if (isDevTools) {
    globalShortcut.register('CommandOrControl+Shift+i', () => {
      mainWindow.webContents.openDevTools()
    })
  }
})

// Quit when all windows are closed.
app.on('window-all-closed', () => {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (!isMac) app.quit()
})

// Exit cleanly on request from parent process in development mode.
if (isDev) {
  if (process.platform === 'win32') {
    process.on('message', (data) => {
      if (data === 'graceful-exit') app.quit()
    })
  }
  else {
    process.on('SIGTERM', () => {
      app.quit()
    })
  }
}

/** functions */

let tray = null
const trayIconPath = 'public/tray/icon.png'
const createTray = () => {
  const image = nativeImage.createFromPath(trayIconPath)
  tray = new Tray(image)
  tray.on('click', () => {
    if (mainWindow)
      mainWindow.show()
  })
  if (isMac)
    tray.setTitle('hello tray')
  // 开启定时器
  startTimer()
}

const startTimer = () => {
  stock.getStockInfo('sh600360')
}

const loadConfig = () => {
  const debug = Config.getInstance().isDebug()
  if (debug) {
    isDev = true
    isDevTools = true
  }
}
