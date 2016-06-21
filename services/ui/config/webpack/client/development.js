import webpack from 'webpack';
import ProgressPlugin from 'webpack/lib/ProgressPlugin';
import path from 'path';
import {tmpdir} from 'os';
import outputPath from './outputPath';

function webpackProgressLogger() {
  return function(percentage, _messsage) {
    if (percentage === 1) {
      process.stdout.write('successfully built new client bundle!\n');
    }
  };
}

function hotEntrypoints(entrypoints) {
  return Object.keys(entrypoints).reduce((memo, entrypoint) => {
    // Ensure console polyfill is loaded before the eventsource polyfill as that uses console.
    memo[entrypoint] = [
      'webpack-dev-server/client?http://docker.local:5001',
      'webpack/hot/dev-server',
      entrypoint
    ];
    return memo;
  }, {});
}

export default function development() {
  return Object.assign({}, {
    watch: true,
    debug: true,
    cache: true,
    devtool: null,
    // devtool: '#cheap-module-eval-source-map',
    target: 'web',

    entry: hotEntrypoints({
      client: './client'
    }),

    output: {
      path: outputPath(this.rootPath),
      publicPath: '//docker.local:5001/static/',
      filename: '[name].js'
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
            cacheDirectory: '/tmp',
            plugins: [
              [
                'react-transform',
                {
                  transforms: [
                    {
                      transform: 'react-transform-hmr',
                      imports: ['react'],
                      locals: ['module']
                    }, {
                      transform: 'react-transform-catch-errors',
                      imports: ['react', 'redbox-react']
                    }
                  ]
                }
              ]
            ]
          }
        },
        {
          test: /\.(css|scss)$/,
          include: this.contextPath,
          exclude: [/node_modules/],
          loaders: [
            'style',
            'css?modules&importLoaders=2&localIdentName=[local]__[hash:base64:10]',
            'postcss',
            'sass'
          ]
        }
      ]
    },

    plugins: [
      new ProgressPlugin(webpackProgressLogger()),
      new webpack.DefinePlugin({
        'process.env': {
          NODE_ENV: JSON.stringify(process.env.NODE_ENV)
        },
        '__SERVER__': false,
        '__CLIENT__': true
      }),
      new webpack.HotModuleReplacementPlugin(),
      new webpack.NoErrorsPlugin()
    ],

    devServer: {
      quiet: true,
      noInfo: false,
      hot: true,
      publicPath: '/static/',
      contentBase: '/static/',
      stats: {
        colors: true
      }
    }
  });
}
