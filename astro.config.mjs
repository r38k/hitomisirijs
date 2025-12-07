// @ts-check

import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';

import cloudflare from '@astrojs/cloudflare';

import preact from '@astrojs/preact';

// https://astro.build/config
export default defineConfig({
  site: 'https://r38k.dev',
  integrations: [mdx(), sitemap(), preact()],
  adapter: cloudflare({
    platformProxy: {
      enabled: true
    },
    imageService: "compile"
  }),
});
