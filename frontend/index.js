// Entry point for Vite
import init, { main } from './pkg/frontend.js';

init().then(() => {
  main();
});
