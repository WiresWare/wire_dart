const resolve = require('path').resolve; // eslint-disable-line

module.exports = {
  resolve: {
    modules: ['node_modules'],
    extensions: ['.js', '.ts'],
    alias: {
      '~': resolve(__dirname, './stories'),
      '~~': resolve(__dirname, './web/assets/templates'),
    },
  },
  // module: {
  //   rules: [
  //     { test: /\.js$/, loader: 'babel-loader', exclude: /node_modules/ },
  //   ],
  // },
};
