import legacyPlugin from '@vitejs/plugin-legacy'
import rustWasmpackLoader from 'rust-wasmpack-loader'
import { defineConfig } from 'vite'
import { plugin as elmPlugin } from 'vite-plugin-elm'
import versionInfoPlugin from './hooks/versionInfoPlugin.js'

export default defineConfig({
  plugins: [
    versionInfoPlugin(),
    elmPlugin(),
    legacyPlugin({ targets: ['kaios >= 48'] }),
    // Rollup plugin always inlines wasm build
    rustWasmpackLoader.rollup(),
  ],
});
