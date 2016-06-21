import webpack from 'webpack';
import path from 'path';
import AssetsPlugin from 'assets-webpack-plugin';
import ExtractTextPlugin from 'extract-text-webpack-plugin';
import CompressionPlugin from 'compression-webpack-plugin';
import outputPath from './outputPath';

export default function production() {
  return Object.assign({}, {
    watch: false,
    debug: false,
    target: 'web',

    entry: {
      client: './client'
    },

    output: {
      path: outputPath(this.rootPath),
      filename: '[name].[id].[hash].bundle.js'
    },

    // Client CSS bundle with prerendering and separate CSS output
    module: {
      loaders: [
        {
          test: /\.(js|jsx)$/,
          include: [this.contextPath, path.join(this.rootPath, 'vendor')],
          exclude: [/node_modules/],
          loader: 'babel',
          query: {
            cacheDirectory: true
          }
        },
        {
          test: /\.(css|scss)$/,
          include: this.contextPath,
          exclude: [/node_modules/],
          loader: ExtractTextPlugin.extract(
            'style-loader',
            'css-loader?modules&importLoaders=2&localIdentName=[local]__[hash:base64:10]&sourceMap!sass-loader?sourceMap',
          )
        }
      ]
    },

    plugins: [
      // css files from the extract-text-plugin loader
      new ExtractTextPlugin('[name].[id].[hash].css', {allChunks: true}),

      // Optimisation stuff
      new webpack.optimize.OccurenceOrderPlugin(),
      new webpack.optimize.DedupePlugin(),
      new CompressionPlugin(),
      new webpack.optimize.UglifyJsPlugin({
        compress: {
          warnings: false
        }
      }),

      new webpack.DefinePlugin({
        '__SERVER__': false,
        '__CLIENT__': true,
        'process.env': {
          HOSTNAME: JSON.stringify(process.env.HOSTNAME),
          GITREF: JSON.stringify(process.env.GITREF),
          STACK: JSON.stringify(process.env.STACK),
          NODE_ENV: JSON.stringify(process.env.NODE_ENV),
          UI_CLIENT_SENTRY_DSN: JSON.stringify(process.env.UI_CLIENT_SENTRY_DSN)
        }
      }),

      // Write out an asset manifest.
      new AssetsPlugin({
        path: outputPath(this.rootPath),
        filename: 'manifest.json'
      }),
      new webpack.NoErrorsPlugin()
    ]
  });
}
