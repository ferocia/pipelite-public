import webpack from 'webpack';
import path from 'path';
import mergeConfig from './mergeConfig';

const ROOT_PATH = path.resolve(path.join(__dirname, '..', '..'));
const CONTEXT_PATH = path.join(ROOT_PATH, 'src');
const OUTPUT_PATH = path.join(ROOT_PATH, '_build', process.env.NODE_ENV);

const BASE_CONFIG = {
  context: CONTEXT_PATH,
  devtool: 'source-map',
  plugins: [
    new webpack.PrefetchPlugin('react'),
    new webpack.PrefetchPlugin('immutable'),
    new webpack.PrefetchPlugin('redux')
  ],
  resolve: {
    extensions:  ['', '.js', '.jsx', '.json', '.css', '.scss'],
    alias: {
      shared: path.resolve(path.join(CONTEXT_PATH, 'shared')),
      client: path.resolve(path.join(CONTEXT_PATH, 'client')),
      server: path.resolve(path.join(CONTEXT_PATH, 'server')),
      vendor: path.resolve(path.join(ROOT_PATH, 'vendor'))
    }
  },
  output: {
    path: OUTPUT_PATH,
    filename: '[name].js',
    chunkFilename: '[name].[chunkhash].js',
    publicPath: '/static/'
  },
  module: {
    loaders: [
      {
        test: /\.png$/,
        include: CONTEXT_PATH,
        exclude: [/node_modules/],
        loaders: ['file']
      },
      {
        test: /\.json$/,
        include: CONTEXT_PATH,
        exclude: [/node_modules/],
        loaders: ['json']
      }
    ]
  },
  sassLoader: {
    includePaths: [
      path.join(CONTEXT_PATH, 'style')
    ]
  },
  postcss: [
    require('autoprefixer')({
      browsers: ['> 1%', 'IE > 9', 'iOS > 5', 'Safari > 7', 'Android > 2', 'last 2 versions']
    })
  ]
}

function makeConfig(configFn) {
  const configContext = {
    rootPath: ROOT_PATH,
    contextPath: CONTEXT_PATH,
    outputPath: OUTPUT_PATH,
    baseConfig: BASE_CONFIG
  }

  return mergeConfig(BASE_CONFIG, configFn.bind(configContext)());
}

export default makeConfig;
