import fetch from 'isomorphic-fetch'
import url from 'url';
import {camelizeKeys} from 'humps';
import {normalize} from 'normalizr'

function getUrlConfig() {
  if (__SERVER__) {
    return {
      protocol: 'http',
      hostname: process.env.API_1_PORT_4000_TCP_ADDR,
      port: process.env.API_1_PORT_4000_TCP_PORT
    };
  }
  return {
    protocol: global.location.protocol,
    hostname: global.location.hostname,
    port: global.location.port
  };
}

// Swiped from here;
// https://github.com/rackt/redux/blob/master/examples/real-world/middleware/api.js#L24
export default function callApi(endpoint, options={}) {
  const endpointUrl = url.format({
    ...getUrlConfig(),
    pathname: endpoint,
    query: options.query
  });

  return fetch(endpointUrl)
    .then((response) => {
      return response.json().then((json) => {
        return {json: camelizeKeys(json), response}
      })
    })
    .then(({json, response}) => {
      if (!response.ok) {
        return Promise.reject(json)
      }
      return options.schema ? normalize(json, options.schema) : json;
    })
}
