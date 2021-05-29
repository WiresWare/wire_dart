const webpack = require('../webpack.config.js');

module.exports = {
  webpackFinal: (config) => {
    return { ...config, resolve: { ...webpack.resolve }};
  },
  stories: [
    "../stories/**/*.stories.mdx",
    "../stories/**/*.stories.@(js|jsx|ts|tsx)"
  ],
  addons: [
    "@storybook/addon-links",
    '@storybook/addon-viewport',
    // "@storybook/addon-essentials",
    // '@storybook/addon-storysource',
    '@whitespace/storybook-addon-html',
  ]
}
