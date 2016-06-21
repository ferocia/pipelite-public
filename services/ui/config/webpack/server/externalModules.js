var fs = require('fs');

module.exports = function externalModules(nodePath) {
  return fs.readdirSync(nodePath)
    .filter(function(module) {
      return ['.bin'].indexOf(module) === -1
    })
    .reduce(function(modules, module) {
      modules[module] = `commonjs ${module}`;
      return modules;
    }, {});
};
