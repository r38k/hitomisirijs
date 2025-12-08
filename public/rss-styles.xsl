<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="ja">
      <head>
        <title><xsl:value-of select="/rss/channel/title"/> - RSS Feed</title>
        <meta charset="utf-8"/>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <style type="text/css">
          /* テーマカラー */
          :root {
            --bg-primary: #0a0a0b;
            --bg-secondary: #12121a;
            --bg-tertiary: #1a1a24;
            --bg-accent-dark: #2a2a3a;
            --ceramic-light: #d4a574;
            --ceramic-medium: #c4956a;
            --ceramic-dark: #8b7355;
            --text-primary: #e8e8f0;
            --text-secondary: #5a5a6a;
            --text-muted: #4a4a5a;
          }

          * {
            box-sizing: border-box;
          }

          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(180deg, var(--bg-primary) 0%, var(--bg-secondary) 50%, var(--bg-tertiary) 100%);
            background-attachment: fixed;
            color: var(--text-primary);
            min-height: 100vh;
            line-height: 1.7;
          }

          .container {
            max-width: 720px;
            margin: 0 auto;
            padding: 3rem 1rem;
          }

          .header {
            text-align: center;
            margin-bottom: 3rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid var(--bg-accent-dark);
          }

          .rss-icon {
            display: inline-block;
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--ceramic-light) 0%, var(--ceramic-medium) 50%, var(--ceramic-dark) 100%);
            border-radius: 12px;
            margin-bottom: 1rem;
            position: relative;
          }

          .rss-icon::after {
            content: "";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 24px;
            height: 24px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230a0a0b'%3E%3Ccircle cx='6.18' cy='17.82' r='2.18'/%3E%3Cpath d='M4 4.44v2.83c7.03 0 12.73 5.7 12.73 12.73h2.83c0-8.59-6.97-15.56-15.56-15.56zm0 5.66v2.83c3.9 0 7.07 3.17 7.07 7.07h2.83c0-5.47-4.43-9.9-9.9-9.9z'/%3E%3C/svg%3E");
            background-size: contain;
            background-repeat: no-repeat;
          }

          h1 {
            font-size: 2rem;
            margin: 0 0 0.5rem 0;
            color: var(--text-primary);
            letter-spacing: 0.05em;
          }

          .description {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin: 0;
          }

          .notice {
            background: var(--bg-accent-dark);
            border-radius: 8px;
            padding: 1rem 1.25rem;
            margin-bottom: 2rem;
            font-size: 0.9rem;
            color: var(--text-secondary);
          }

          .notice strong {
            color: var(--ceramic-light);
          }

          .notice code {
            background: var(--bg-secondary);
            padding: 0.15rem 0.4rem;
            border-radius: 4px;
            font-family: "Courier New", monospace;
            font-size: 0.85em;
            color: var(--text-primary);
          }

          .url-wrapper {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
          }

          .copy-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            background: var(--bg-secondary);
            border: 1px solid var(--bg-accent-dark);
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 0;
          }

          .copy-btn:hover {
            border-color: var(--ceramic-dark);
            background: var(--bg-tertiary);
          }

          .copy-btn svg {
            width: 14px;
            height: 14px;
            fill: var(--text-secondary);
            transition: fill 0.3s ease;
          }

          .copy-btn:hover svg {
            fill: var(--ceramic-light);
          }

          .copy-btn.copied {
            border-color: var(--ceramic-light);
          }

          .copy-btn.copied svg {
            fill: var(--ceramic-light);
          }

          .feed-list {
            list-style: none;
            padding: 0;
            margin: 0;
          }

          .feed-item {
            background: var(--bg-secondary);
            border: 1px solid var(--bg-accent-dark);
            border-radius: 8px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
          }

          .feed-item:hover {
            border-color: var(--ceramic-dark);
            box-shadow: 0 0 16px rgba(212, 165, 116, 0.1);
          }

          .feed-item-title {
            margin: 0 0 0.5rem 0;
            font-size: 1.1rem;
          }

          .feed-item-title a {
            color: var(--text-primary);
            text-decoration: none;
            transition: color 0.3s ease;
          }

          .feed-item-title a:hover {
            color: var(--ceramic-light);
          }

          .feed-item-meta {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-bottom: 0.75rem;
            letter-spacing: 0.1em;
          }

          .feed-item-description {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin: 0;
            line-height: 1.6;
          }

          .footer {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid var(--bg-accent-dark);
            color: var(--text-muted);
            font-size: 0.85rem;
          }

          .footer a {
            color: var(--ceramic-light);
            text-decoration: none;
          }

          .footer a:hover {
            text-decoration: underline;
          }

          @media (max-width: 720px) {
            .container {
              padding: 1.5rem 1rem;
            }

            h1 {
              font-size: 1.5rem;
            }

            .feed-item {
              padding: 1rem;
            }
          }
        </style>
      </head>
      <body>
        <div class="container">
          <header class="header">
            <div class="rss-icon"></div>
            <h1><xsl:value-of select="/rss/channel/title"/></h1>
            <p class="description"><xsl:value-of select="/rss/channel/description"/></p>
            <div class="url-wrapper">
              <code id="rss-url"><xsl:value-of select="/rss/channel/link"/>/rss.xml</code>
              <button class="copy-btn" onclick="copyUrl()" title="URLをコピー">
                <svg id="copy-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/>
                </svg>
                <svg id="check-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" style="display:none">
                  <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                </svg>
              </button>
            </div>
          </header>

          <div class="notice">
            <strong>RSS Feed</strong> - このページはRSSフィードのプレビューです。
            RSSリーダーでこのURLを購読すると、新しい記事が公開されたときに通知を受け取れます。
          </div>

          <script>
            function copyUrl() {
              var url = document.getElementById('rss-url').textContent;
              navigator.clipboard.writeText(url).then(function() {
                var btn = document.querySelector('.copy-btn');
                var copyIcon = document.getElementById('copy-icon');
                var checkIcon = document.getElementById('check-icon');
                btn.classList.add('copied');
                copyIcon.style.display = 'none';
                checkIcon.style.display = 'block';
                setTimeout(function() {
                  btn.classList.remove('copied');
                  copyIcon.style.display = 'block';
                  checkIcon.style.display = 'none';
                }, 2000);
              });
            }
          </script>

          <ul class="feed-list">
            <xsl:for-each select="/rss/channel/item">
              <li class="feed-item">
                <h2 class="feed-item-title">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="link"/>
                    </xsl:attribute>
                    <xsl:value-of select="title"/>
                  </a>
                </h2>
                <p class="feed-item-meta">
                  <xsl:value-of select="pubDate"/>
                </p>
                <xsl:if test="description">
                  <p class="feed-item-description">
                    <xsl:value-of select="description"/>
                  </p>
                </xsl:if>
              </li>
            </xsl:for-each>
          </ul>

          <footer class="footer">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="/rss/channel/link"/>
              </xsl:attribute>
              <xsl:value-of select="/rss/channel/title"/>
            </a>
            に戻る
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
