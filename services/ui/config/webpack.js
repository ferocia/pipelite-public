require('babel-core/register');

process.env.NODE_ENV = process.env.NODE_ENV || 'development';
module.exports = require('./webpack/makeConfig')(process.env.NODE_ENV);
