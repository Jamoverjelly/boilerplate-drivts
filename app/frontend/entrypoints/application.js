import { createInertiaApp } from '@inertiajs/svelte';
import '../stylesheets/main.css'
import layout from '../layouts/layout.svelte';

// append CSRF token to axios requests
import axios from 'axios'
const csrfToken = document.querySelector('meta[name=csrf-token]').content
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

// import all svelte components under /pages
const pages = import.meta.glob('../pages/**/*.svelte', { eager: true });

createInertiaApp({
  resolve: name => {
    const page =  pages[`../pages/${name}.svelte`]
    return { default: page.default, layout: page.layout || layout }
  },
  setup({ el, App, props }) {
    new App({ target: el, props })
  },
})
