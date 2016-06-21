import * as types from 'client/constants/ActionTypes';
import api from 'client/api';

export function requestBuilds() {
  return {
    type: types.FETCH_BUILDS_REQUEST
  };
}

export function requestBuildsFailed(error) {
  return {
    type: types.FETCH_BUILDS_FAILED,
    error
  };
}

export function requestBuildsSuccess(result) {
  return {
    type: types.FETCH_BUILDS_SUCCESS,
    receivedAt: Date.now(),
    ...result
  };
}

export function fetchBuilds(filters) {
  return (dispatch, getState) => {
    if (getState().builds.get('isFetching')) {
      return;
    }

    dispatch(requestBuilds());
    const query = {
      ...filters
    };

    return api.builds({query})
      .then(
        (result) => { dispatch(requestBuildsSuccess(result)) },
        (error)  => { dispatch(requestBuildsFailed(error)) }
      )
  };
}
