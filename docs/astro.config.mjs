import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'Check-2-Check Docs',
			social: {
				github: 'https://github.com/withastro/starlight',
			},
			sidebar: [
				{
					label: 'Guides',
					items: [
						// Each item here is a relative path to a docs file.
						{ label: 'Agent Rules', slug: 'guides/agent-rules' },
					],
				},
				{
					label: 'Architecture',
					autogenerate: { directory: 'architecture' },
				},
				{
					label: 'Features',
					autogenerate: { directory: 'features' },
				},
			],
		}),
	],
});
