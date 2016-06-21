import * as types from 'client/constants/ActionTypes';

export function setFitler(keyPath, value) {
  return {
    type: types.SET_FILTER,
    keyPath: keyPath,
    value: value
  };
}
