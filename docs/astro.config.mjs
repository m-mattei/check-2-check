import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://m-mattei.github.io',
	base: '/check-2-check',
	integrations: [
		starlight({
			title: 'Check-2-Check Docs',
			social: {
				github: 'https://github.com/m-mattei/check-2-check',
			},
			sidebar: [
				{
					label: 'Guides',
					autogenerate: { directory: 'guides' },
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
