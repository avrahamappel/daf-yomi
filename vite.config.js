import legacyPlugin from '@vitejs/plugin-legacy'
import { defineConfig } from 'vite'
import { plugin as elmPlugin } from 'vite-plugin-elm'
import versionInfoPlugin from './hooks/versionInfoPlugin'

export default defineConfig({
  plugins: [
    versionInfoPlugin(),
    elmPlugin(),
    legacyPlugin({ targets: ['kaios >= 48'] }),
  ],
});
