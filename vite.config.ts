import path from 'path'
import { UserConfig } from 'vite'
import ViteComponents from 'vite-plugin-components'
import PurgeIcons from 'vite-plugin-purge-icons'
import { createMockServer } from 'vite-plugin-mock'

const alias = {
  '/@/': path.join(__dirname, 'src'),
}

const config: UserConfig = {
  alias,
  esbuildTarget: 'es2015',
  plugins: [
    ViteComponents({
      alias,
      // Relative paths to the directory to search for components.
      dirs: ['src/components'],
      // Valid file extensions for components.
      extensions: ['vue'],
      // Search for subdirectories
      deep: true,
    }),
    PurgeIcons(),
    createMockServer({
      mockPath: 'mock',
      watchFiles: true,
      localEnabled: process.env.NODE_ENV === 'development',
    }),
  ],
  optimizeDeps: {
    // exclode path and electron-window-state as we are using the node runtime inside the browser
    // and dont wont vite to complain. If you have any issues importing node packages and vite complains,
    // add them here
    exclude: ['path', 'electron-window-state'],
  },
}

export default config
