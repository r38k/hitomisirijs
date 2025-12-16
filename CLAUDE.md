# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

An Astro blog application deployed to Cloudflare Pages.

## Development Commands

```bash
pnpm install      # Install dependencies
pnpm dev          # Start dev server (localhost:4321)
pnpm build        # Build for production
pnpm preview      # Preview locally with Wrangler
pnpm deploy       # Deploy to Cloudflare Pages
pnpm cf-typegen   # Generate Cloudflare Workers types
pnpm new          # Create new blog post
```

## Project Structure

```
src/
├── pages/           # File-based routing
│   ├── index.astro
│   ├── about.astro
│   ├── blog/
│   │   ├── index.astro
│   │   └── [...slug].astro
│   └── rss.xml.js
├── content/
│   └── blog/        # Markdown/MDX blog posts
├── layouts/
│   ├── BaseLayout.astro
│   └── BlogPost.astro
├── components/
│   ├── BaseHead.astro
│   ├── FormattedDate.astro
│   ├── Header/
│   ├── Footer/
│   ├── Card/
│   ├── Button/
│   └── Icons/
├── styles/
│   └── global.css
├── consts.ts        # Site metadata constants
├── content.config.ts
└── env.d.ts
scripts/
└── newBlog.ts       # New post creation script
public/
└── rss-styles.xsl   # RSS stylesheet
```

## Blog Post Management

### Creating a New Post

```bash
pnpm new
```

Interactive prompt for filename, title, description, and tags. Creates a new Markdown file in `src/content/blog/`.

### Frontmatter Schema

```yaml
---
title: 'Post title'
description: 'Post description'
pubDate: 2024-01-01 12:00
tags: ["tag1", "tag2"]  # optional
updatedDate: 2024-01-02 # optional
draft: true             # optional, defaults to false
---
```

### Draft Posts

Posts with `draft: true` are treated as drafts.

- **Development (`pnpm dev`)**: Draft posts are visible
- **Production build (`pnpm build`)**: Draft posts are excluded

## Tech Stack

- **Framework**: Astro 5
- **UI**: Preact
- **Deployment**: Cloudflare Pages (`@astrojs/cloudflare`)
- **Integrations**: MDX, RSS, Sitemap

## Git Conventions

- Write commit messages in Japanese
- Do not include "Generated with Claude Code" or "Co-Authored-By" lines
