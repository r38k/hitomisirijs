import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import cloudflare from '@astrojs/cloudflare';
import preact from '@astrojs/preact';
import { defineConfig } from 'astro/config';
import remarkLinkCard from 'remark-link-card-plus';
import rehypeSlug from 'rehype-slug';
import rehypeAutolinkHeadings, { type Build } from 'rehype-autolink-headings';
import remarkCustomHeaderId from 'remark-custom-header-id';

export default defineConfig({
  site: 'https://r38k.dev',
  trailingSlash: 'never',
  integrations: [mdx(), sitemap(), preact()],
  adapter: cloudflare({
    platformProxy: {
      enabled: true,
    },
    imageService: 'compile',
  }),
  markdown: {
    remarkPlugins: [
      [
        remarkLinkCard,
        {
          cache: true,
          shortenUrl: true,
          thumbnailPosition: 'right',
        },
      ],
        remarkCustomHeaderId,
    ],
    rehypePlugins: [
      rehypeSlug,
      [
        rehypeAutolinkHeadings,
        {
          behavior: 'prepend',
          content: ((heading) => ({
            type: 'text',
            value: '#'.repeat(Number(heading.tagName[1])) + ' ',
          })) satisfies Build,
          properties: {
            className: ['anchor-link'],
          }
        },
      ],
    ],
  },
});
