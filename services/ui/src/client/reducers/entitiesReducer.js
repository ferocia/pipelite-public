import Immutable from 'immutable'

const initialState = Immutable.Map({});

function mergeEntities(state, entities) {
  if (Array.isArray(entities)) {
    return entities.reduce((memo, x) => {
      return state.mergeDeep(x)
    }, state);
  } else {
    return state.mergeDeep(entities);
  }
}

export default function entitiesReducer(state = initialState, action) {
  if (action.entities) {
    return mergeEntities(state, action.entities);
  }
  return Immutable.fromJS(state);
}
