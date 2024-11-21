import legacy from '@vitejs/plugin-legacy'
import { defineConfig } from 'vite'
import { plugin } from 'vite-plugin-elm'

export default defineConfig({
    plugins: [
        plugin(),
        legacy({ targets: ['kaios >= 48'] }),
    ],
});
