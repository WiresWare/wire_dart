import { fileURLToPath } from 'node:url';

export default {
  stories: [
    '../stories/**/*.stories.@(js|jsx|ts|tsx)',
  ],
  framework: {
    name: '@storybook/html-vite',
    options: {},
  },
  addons: [
    '@storybook/addon-links',
  ],
  viteFinal: (config) => {
    config.resolve = {
      ...config.resolve,
      alias: {
        '~~': fileURLToPath(new URL('../web/assets/templates', import.meta.url)),
        '~': fileURLToPath(new URL('../stories', import.meta.url)),
        ...config.resolve?.alias,
      },
    };
    return config;
  },
};
