import { getCollection } from 'astro:content';
import type { APIRoute, GetStaticPaths, InferGetStaticPropsType } from 'astro';

export const getStaticPaths = (async () => {
	const posts = await getCollection('blog');
	return posts.map((post) => ({
		params: { slug: post.id },
		props: { post },
	}));
}) satisfies GetStaticPaths;

type Props = InferGetStaticPropsType<typeof getStaticPaths>;

export const GET: APIRoute<Props> = async ({ props }) => {
	const { post } = props;

	// TODO: Object.entriesによる動的処理から、スキーマに基づく型安全な実装への書き換えを検討
	const frontmatter = Object.entries(post.data)
		.map(([key, value]) => {
			if (value instanceof Date) {
				return `${key}: ${value.toISOString().split('T')[0]}`;
			}
			if (typeof value === 'string') {
				return `${key}: '${value}'`;
			}
			if (Array.isArray(value)) {
				return `${key}: [${value.map(v => typeof v === 'string' ? `'${v}'` : v).join(', ')}]`;
			}
			return `${key}: ${value}`;
		})
		.join('\n');

	const markdownContent = `---\n${frontmatter}\n---\n\n${post.body}`;

	return new Response(markdownContent, {
		status: 200,
		headers: {
			'Content-Type': 'text/plain; charset=utf-8',
		},
	});
};
