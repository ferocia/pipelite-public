import Immutable from 'immutable'
import * as types from 'client/constants/ActionTypes';

const initialState = {
  isFetching: false
};

export default function projectsReducer(state = initialState, action) {
  switch (action.type) {
    case types.FETCH_PROJECTS_REQUEST:
      return state.merge({isFetching: true});
    case types.FETCH_PROJECTS_SUCCESS:
    case types.FETCH_PROJECTS_FAILED:
      return state.merge({isFetching: false})
    default:
      return Immutable.fromJS(state);
  }
}
