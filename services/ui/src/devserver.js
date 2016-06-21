require('dotenv').load()

import chalk from 'chalk'
import nodemon from 'nodemon'
import webpack from 'webpack'
import prettyMs from 'pretty-ms'
import serverWebpackConfig from '../config/webpack/server'

class HotRebuildServer {
  constructor() {
    console.log('Starting devserver...');
    this.nodemon = null;
    this.compiler = webpack(serverWebpackConfig);
  }

  watch() {
    this.compiler.watch({}, this.onBuild(this.boot.bind(this)));
  }

  onBuild(done) {
    function handleError(error) {
      console.error(chalk.red(error));
    }

    return function onComplete(error, stats) {
      if (error) {
        handleError(error);
      }
      const statsJson = stats.toJson();
      if (statsJson.errors.length > 0) {
        console.log(chalk.red(statsJson.errors[0]));
      }
      if (statsJson.warnings.length > 0) {
        console.log(chalk.yellow(statsJson.warnings));
      }
      let duration = prettyMs(stats.endTime - stats.startTime);
      console.log(chalk.green(`successfully built "${stats.hash}" in ${duration}`));
      done();
    };
  }

  boot() {
    if (!this.nodemon) {
      this.nodemon = nodemon({
        verbosse: true,
        execMap: { js: 'node' },
        script: './_build/development/server.js',
        ignore: ['*'],
        ext: 'noop'
      });
      this.nodemon.on('restart', () => {
        console.log(chalk.yellow('devserver restarting after changes!'));
      });
      process.on('SIGTERM', () => {
        console.log(chalk.yellow('Received SIGTERM, exiting.'));
        nodemon.quit();
        process.exit();
      })
    }
    nodemon.restart();
  }
}

new HotRebuildServer().watch();
