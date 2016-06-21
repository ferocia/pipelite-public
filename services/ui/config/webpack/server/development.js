import webpack from 'webpack';
import path from 'path';
import externalModules from './externalModules';

export default function development() {
  return Object.assign({}, {
    debug: true,
    cache: true,
    target: 'node',
    externals: externalModules(process.env.NODE_PATH || path.join(this.rootPath, 'node_modules')),

    entry: {
      server: './server'
    },

    node: {
      __dirname: true,
      __filename: true
    },

    module: {
      loaders: [
        {
          test: /\.(js|jsx)$/,
          include: [this.contextPath, path.join(this.rootPath, 'vendor')],
          exclude: [/node_modules/],
          loader: 'babel',
          query: {
            cacheDirectory: '/tmp'
          }
        },
        {
          test: /\.(css|scss)$/,
          include: this.contextPath,
          exclude: [/node_modules/],
          loaders: [
            'css-loader/locals?modules&importLoaders=2&localIdentName=[local]__[hash:base64:10]',
            'postcss',
            'sass'
          ]
        }
      ]
    },

    plugins: [
      // https://github.com/visionmedia/superagent/wiki/Superagent-for-Webpack
      new webpack.DefinePlugin({
        'global.GENTLY': false,
        '__SERVER__': true,
        '__CLIENT__': false
      }),

      // Include sourcemaps.
      new webpack.BannerPlugin('require("source-map-support").install();', {
        raw: true,
        entryOnly: false
      }),
      new webpack.NoErrorsPlugin()
    ]
  });
}
