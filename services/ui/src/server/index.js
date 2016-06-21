require('dotenv').load();

import Koa from 'koa';
import KoaLogger from 'koa-logger';
import KoaBodyParser from 'koa-bodyparser';
import KoaRoute from 'koa-route';
import {createServer} from 'http';
import reactMiddleware from './middleware/reactMiddleware';
import healthMiddleware from './middleware/healthMiddleware';

const application = new Koa();

application.name = 'pipelite';
application.proxy = true;
application.keys = [process.env.SECRET_KEY || 'NWFkZjE0YmE3YjA3MDIwYjY3YzdkOThhZGQ1MDlmYj'];

application.use(async (context, next) => {
  const start = new Date;
  await next();
  context.response.set('X-Response-Time', `${new Date - start}ms`);
});

application.use(KoaLogger());
application.use(KoaBodyParser());
application.use(KoaRoute.get('/health', healthMiddleware));
application.use(KoaRoute.get('/*', reactMiddleware));

if (process.env.NODE_ENV === 'production' && process.env.UI_SERVER_SENTRY_DSN) {
  const raven = require('raven');
  application.context.sentry = new raven.Client(process.env.UI_SERVER_SENTRY_DSN, {
    release: process.env.GITREF,
    serverName: process.env.HOSTNAME,
    tags: {
      stack: process.env.STACK
    }
  });
  application.context.sentry.patchGlobal();
  application.on('error', application.context.sentry.captureException);
}

const server = createServer(application.callback());

if (!module.parent) {
  server.listen(process.env.PORT || 5000);
  console.info(`Pipelite UI Server listening!`);
}
console.info(`* Port: ${process.env.PORT || 5000}`)
console.info(`* Env: ${process.env.NODE_ENV}`)

process.on('SIGTERM', () => {
  console.warn('Received SIGTERM, shutting down gracefully...');
  server.close();
  process.exit();
});

export default application;
