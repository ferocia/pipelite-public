import thunkMiddleware from 'redux-thunk';
import createLogger from 'redux-logger';
import Immutable from 'immutable';
import {createStore, applyMiddleware} from 'redux';
import rootReducer from '../reducers';

const logger = createLogger({
  logger: global.console,
  duration: true,
  collapsed: true
});

function getMiddleware() {
  let middleware = [thunkMiddleware];
  if (!process.env.NODE_ENV && !__SERVER__) {
    middleware.push(logger)
  }
  return applyMiddleware.apply(null, middleware);
}

export default function configureStore(initialState = {}) {
  return getMiddleware()(createStore)(rootReducer, initialState);
}
