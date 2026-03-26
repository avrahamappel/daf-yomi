import legacyPlugin from '@vitejs/plugin-legacy'
import { defineConfig } from 'vite'
import { plugin as elmPlugin } from 'vite-plugin-elm'
import versionInfoPlugin from './hooks/versionInfoPlugin'

export default defineConfig({
  clearScreen: false,
  strictPort: true,
  watch: {
    ignored: ['**/src-tauri/**'],
  },
  envPrefix: ['VITE_', 'TAURI_ENV_*'],
  minify: !process.env.TAURI_ENV_DEBUG ? 'esbuild' : false,
  sourcemap: !!process.env.TAURI_ENV_DEBUG,
  plugins: [
    versionInfoPlugin(),
    elmPlugin(),
    legacyPlugin({ targets: ['kaios >= 48'] }),
  ],
});
