import React from 'react'
import ReactDOM from 'react-dom/server'
import {match, RouterContext} from 'react-router'
import routes from 'shared/routes'
import {Provider} from 'react-redux'
import configureStore from 'client/store/configureStore';
import ApplicationLayoutComponent from 'server/components/ApplicationLayoutComponent'

function renderApplicationLayout(body, initialState) {
  const html = ReactDOM.renderToStaticMarkup(<ApplicationLayoutComponent html={body} initialState={initialState} />);
  return `<!doctype html>${html}`;
}

function fetchRoutesData(store, components, props) {
  return Promise.all(components
    .filter(component => component && component.fetchData)
    .map(component => component.fetchData(store.dispatch, props)));
}

function renderRoute(store, props) {
  return fetchRoutesData(store, props.components, props).then(() => {
    const provider = React.createElement(Provider, {store},
      React.createElement(RouterContext, props)
    );

    return renderApplicationLayout(ReactDOM.renderToString(provider), store.getState());
  });
}

function handleError(context, error) {
  context.response.status = 500;
  context.response.type = 'html';
  context.response.body = error.message;
  return context;
}

function handleRedirect(context, redirect) {
  context.response.redirect(redirect.pathname + redirect.search)
  return context;
}

function handleNotFound(context) {
  context.response.status = 404;
  context.response.body = 'Not Found';
}

export default async function reactMiddleware(context) {
  await new Promise((resolve, reject) => {
    match({routes, location: context.request.url}, (error, redirect, props) => {

      // Handle errors
      if (error) {
        handleError(context, error)
        reject();

      // Handle redirects
      } else if (redirect) {
        handleRedirect(context, redirect)
        resolve();

      // Handle not found
      } else if (!props) {
        handleNotFound(context)
        reject();

      // Everything is fine! :D
      } else {
        const render = renderRoute(configureStore(), props)
          .then((body) => {
            context.response.status = 200;
            context.response.body = body;
            context.response.type = 'html';
          })
        render.then(resolve)
        render.catch(reject)
      }
    });
  });
}
