var deepMerge = require('deep-merge');

var merge = deepMerge(function(target, source, key) {
  if(target instanceof Array) {
    return [].concat(target, source);
  }
  return source;
});

module.exports = function mergeConfig(configA, configB) {
  return merge(configA, configB);
}
