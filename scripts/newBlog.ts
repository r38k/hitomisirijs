import { createInterface } from "node:readline/promises";
import { stdin, stdout } from "node:process";
import { existsSync, writeFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const PROJECT_ROOT = join(__dirname, "..");
const BLOG_DIR = join(PROJECT_ROOT, "src", "content", "blog");

interface BlogFrontmatter {
  title: string;
  description: string;
  pubDate: string;
  tags?: readonly string[];
}

function formatDate(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  return `${year}-${month}-${day} ${hours}:${minutes}`;
}

function generateFrontmatter(frontmatter: BlogFrontmatter): string {
  const tagsLine =
    frontmatter.tags !== undefined && frontmatter.tags.length > 0
      ? `tags: [${frontmatter.tags.map((tag) => `"${tag}"`).join(", ")}]\n`
      : "";

  return `---
title: '${frontmatter.title}'
pubDate: ${frontmatter.pubDate}
description: '${frontmatter.description}'
draft: true
${tagsLine}---

`;
}

function validateFilename(filename: string): boolean {
  const validPattern = /^[a-zA-Z0-9_-]+$/;
  return validPattern.test(filename);
}

function parseTags(input: string): readonly string[] {
  const rawTags = input.split(",");
  const trimmedTags = rawTags.map((tag) => tag.trim());
  const filteredTags = trimmedTags.filter((tag) => tag.length > 0);
  return Object.freeze(filteredTags);
}

async function main(): Promise<void> {
  const rl = createInterface({ input: stdin, output: stdout });

  try {
    console.log("\n新規ブログ記事を作成します\n");

    const filename = await rl.question("ファイル名 (拡張子なし): ");
    const trimmedFilename = filename.trim();

    if (trimmedFilename === "") {
      console.error("\nエラー: ファイル名を入力してください");
      process.exit(1);
    }

    if (!validateFilename(trimmedFilename)) {
      console.error(
        "\nエラー: ファイル名は英数字、ハイフン、アンダースコアのみ使用できます"
      );
      process.exit(1);
    }

    const filepath = join(BLOG_DIR, `${trimmedFilename}.md`);
    if (existsSync(filepath)) {
      console.error(`\nエラー: ${filepath} は既に存在します`);
      process.exit(1);
    }

    const title = await rl.question("タイトル: ");
    const trimmedTitle = title.trim();

    if (trimmedTitle === "") {
      console.error("\nエラー: タイトルを入力してください");
      process.exit(1);
    }

    const description = await rl.question("説明: ");
    const trimmedDescription = description.trim();

    if (trimmedDescription === "") {
      console.error("\nエラー: 説明を入力してください");
      process.exit(1);
    }

    const tagsInput = await rl.question("タグ (カンマ区切り、省略可): ");
    const tags = parseTags(tagsInput);

    const frontmatter: BlogFrontmatter = {
      title: trimmedTitle,
      description: trimmedDescription,
      pubDate: formatDate(new Date()),
      ...(tags.length > 0 && { tags }),
    };

    const content = generateFrontmatter(frontmatter);

    writeFileSync(filepath, content, "utf-8");

    console.log(`\n作成しました: ${filepath}`);
    console.log("\n--- 生成されたフロントマター ---");
    console.log(content);
  } finally {
    rl.close();
  }
}

main().catch((error) => {
  console.error("\nエラーが発生しました:", error);
  process.exit(1);
});
