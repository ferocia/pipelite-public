import url from 'url';
import superagent from 'superagent';

const SERVICE_PORT_REGEX = /^PIPELITE.*_((API)_[0-9]{1,})_PORT$/i;

function checkService(service) {
  const {name, hostname, port} = service;
  const path = url.format({protocol: 'http', hostname, port, pathname: '/health'});
  return new Promise((resolve, reject) => {
    superagent.get(path).end((error, response) => {
      if (error) {
        return reject(error);
      }

      resolve({
        name,
        path,
        status: response.status,
        response: response.text
      })
    })
  })
}

async function checkLinkedServices() {
  return Promise.all(
    Object.keys(process.env)
      .filter(k => SERVICE_PORT_REGEX.test(k))
      .reduce((previous, next) => {
        const [, name] = next.match(SERVICE_PORT_REGEX);
        const {hostname, port} = url.parse(process.env[next]);
        previous.push({name, hostname, port});
        return previous;
      }, [])
      .map(service => checkService(service)));
}

export default async function healthMiddleware(context) {
  const services = await checkLinkedServices();
  const allServicesOK = services.map(x => x.status).every(x => x === 200);
  const state = (allServicesOK ? 'OK' : 'ERRROR');

  context.response.status = (allServicesOK ? 200 : 502);
  context.response.type = 'json';
  context.response.body = JSON.stringify({
    host: process.env.HOSTNAME,
    gitref: process.env.GITREF,
    stack: process.env.STACK,
    state,
    services
  });
}
