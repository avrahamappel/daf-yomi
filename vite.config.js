import { defineConfig } from 'vite'

export default defineConfig({
    build: {
        outDir: "dist",
        rollupOptions: {
            input: 'index.html'
        }
    },
    server: {
        fs: {
            allow: ['.'], // allow serving files from project root
        },
    },
});
