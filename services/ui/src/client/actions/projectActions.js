import * as types from 'client/constants/ActionTypes';
import api from 'client/api';

export function requestProjects() {
  return {
    type: types.FETCH_PROJECTS_REQUEST
  };
}

export function requestProjectsFailed(error) {
  return {
    type: types.FETCH_PROJECTS_FAILED,
    error
  };
}

export function requestProjectsSuccess(result) {
  return {
    type: types.FETCH_PROJECTS_SUCCESS,
    receivedAt: Date.now(),
    ...result
  };
}

export function fetchProjects() {
  return (dispatch, getState) => {
    if (getState().projects.get('isFetching')) {
      return;
    }

    dispatch(requestProjects());

    return api.projects()
      .then(
        (result) => { dispatch(requestProjectsSuccess(result)) },
        (error)  => { dispatch(requestProjectsFailed(error)) }
      )
  };
}

export function requestProject() {
  return {
    type: types.FETCH_PROJECT_REQUEST
  };
}

export function requestProjectFailed(error) {
  return {
    type: types.FETCH_PROJECT_FAILED,
    error
  };
}

export function requestProjectSuccess(result) {
  return {
    type: types.FETCH_PROJECT_SUCCESS,
    receivedAt: Date.now(),
    ...result
  };
}

export function fetchProjectBySlug(slug) {
  return (dispatch, getState) => {
    if (getState().projects.get('isFetching')) {
      return;
    }

    dispatch(requestProject(slug));

    return api.project(slug)
      .then(
        (result) => { dispatch(requestProjectSuccess(result)) },
        (error)  => { dispatch(requestProjectFailed(error)) }
      )
  };
}
