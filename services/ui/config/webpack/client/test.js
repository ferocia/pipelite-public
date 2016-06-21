import developmentConfig from './development';

export default function test() {

  return Object.assign({}, developmentConfig.bind(this)(), {
    watch: false
  })
}
