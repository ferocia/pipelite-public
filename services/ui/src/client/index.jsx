import React from 'react';
import ReactDOM from 'react-dom';
import {Provider} from 'react-redux';
import routes from 'shared/routes';
import configureStore from 'client/store/configureStore';
import {camelizeKeys} from 'humps';
import {connectSocket, receiveState} from 'client/actions/socketActions';
import styles from 'client/style/global';

const store = global.store = configureStore(global.__INITIALSTATE__ || {});

if (process.env.NODE_ENV === 'production' && process.env.UI_CLIENT_SENTRY_DSN) {
  const raven = require('raven-js');
  Raven.config(process.env.UI_CLIENT_SENTRY_DSN, {
    release: process.env.GITREF,
    serverName: process.env.HOSTNAME,
    tags: {
      stack: process.env.STACK
    },
    dataCallback: (data) => {
      return Object.assign({}, data, {state: store.getState()})
    }
  }).install()
}

function postInitialRenderCallback() {
  store.dispatch(connectSocket()).then(({socket, channel}) => {
    channel.on('state', (state) => {
      store.dispatch(receiveState(state))
    });
  })
}

ReactDOM.render(
  <Provider store={store}>{routes}</Provider>,
  document.getElementById('Application'),
  postInitialRenderCallback
);
