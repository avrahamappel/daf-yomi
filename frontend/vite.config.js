import { defineConfig } from 'vite';

export default defineConfig({
  root: '.', // assumes vite runs from frontend/
  publicDir: 'public', // static files (if any)
  build: {
    outDir: 'dist',
    emptyOutDir: true,
  },
  server: {
    fs: {
      allow: ['.'], // so Vite can serve pkg/
    },
  },
});
