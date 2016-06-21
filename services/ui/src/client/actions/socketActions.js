import {Socket} from 'vendor/phoenix';
import {camelizeKeys} from 'humps';
import {normalize} from 'normalizr'
import schemas from 'client/schemas';
import * as types from 'client/constants/ActionTypes';
import reduce from 'lodash/reduce';

export function receiveState(state) {
  const reducedEntities = reduce(camelizeKeys(state), (memo, value, key) => {
    const schema = schemas[key];
    if (schema) {
      const {entities} = normalize(value, schema);
      memo = {...memo, ...entities};
    }
    return memo;
  }, {});

  return {
    type: types.SOCKET_RECEIVE_STATE,
    receivedAt: Date.now(),
    entities: reducedEntities
  };
}

export function connectSocket() {
  return (dispatch, getState) => {
    const state = getState().socket;

    if (state.get('isConnecting') || state.get('isConnected')) {
      return;
    }

    dispatch({type: types.SOCKET_CONNECT});

    return new Promise((resolve, reject) => {
      const socket = new Socket('/socket', {
        logger: ((kind, msg, data) => {
          console.info(`${kind}: ${msg}`, data)
        })
      });
      socket.connect();
      const channel = socket.channel('state', {});
      channel
        .join()
        .receive('ok', () => {
          dispatch({type: types.SOCKET_CONNECT_SUCCESS});
          resolve({socket, channel})
        })
        .receive('error', (reason) => {
          dispatch({type: types.SOCKET_CONNECT_FAILED});
          reject(reason)
        })
    })
  }
}
