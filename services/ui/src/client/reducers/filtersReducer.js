import Immutable from 'immutable'
import * as types from 'client/constants/ActionTypes';

const initialState = {
  builds: {
    branch: null,
    period: '60days',
    project: null
  }
};

export default function filtersReducer(state = initialState, action) {
  switch (action.type) {
    case types.SET_FILTER:
      return state.setIn(action.keyPath, action.value);
    default:
      return Immutable.fromJS(state);
  }
}
