const { merge } = require('webpack-merge');
const commonConfig = require('./webpack.common.js');

module.exports = merge(commonConfig, {
  mode: 'development',
  // 'eval-*' devtools violate our strict CSP (no 'unsafe-eval'), so use standard source maps.
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.(woff|woff2|eot|ttf|ico)$/,
        type: 'asset/resource',
      },
    ],
  },
});
