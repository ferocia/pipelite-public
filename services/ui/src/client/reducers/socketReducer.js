import Immutable from 'immutable';
import * as types from 'client/constants/ActionTypes';

const initialState = {
  isConnected: false,
  isConnecting: false
};

export default function socketReducer(state = initialState, action) {
  switch (action.type) {
    case types.SOCKET_CONNECT:
      return state.merge({isConnected: false, isConnecting: true});
    case types.SOCKET_CONNECT_SUCCESS:
      return state.merge({isConnected: true, isConnecting: false});
    case types.SOCKET_DISCONNECTED:
      return state.set('isConnected', false);
    default:
      return Immutable.fromJS(state);
  }
}
