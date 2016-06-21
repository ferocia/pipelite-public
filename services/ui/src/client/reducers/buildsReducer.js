import Immutable from 'immutable'
import * as types from 'client/constants/ActionTypes';

const initialState = {
  isFetching: false
};

export default function buildsReducer(state = initialState, action) {
  switch (action.type) {
    case types.FETCH_BUILDS_REQUEST:
      return state.merge({isFetching: true});
    case types.FETCH_BUILDS_SUCCESS:
    case types.FETCH_BUILDS_FAILED:
      return state.merge({isFetching: false})
    default:
      return Immutable.fromJS(state);
  }
}
