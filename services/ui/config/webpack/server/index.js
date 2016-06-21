if (!global._babelPolyfill) {
  require('babel-core/register');
}

process.env.NODE_ENV = process.env.NODE_ENV || 'development';

var makeConfig = require('../makeConfig');
var envConfig = require('./' + process.env.NODE_ENV);

module.exports = makeConfig(envConfig);
