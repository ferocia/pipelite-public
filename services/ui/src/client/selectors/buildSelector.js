import Immutable from 'immutable';
import {createSelector} from 'reselect';

function selectBuildEntities(state) {
  return state.entities.get('builds', Immutable.Map());
}

function sortBuildEntities(builds, order) {
  switch (order) {
    case 'asc':
      return builds.sort((a, b) => {
        return (new Date(a.get('updatedAt')) - new Date(b.get('updatedAt')))
      });
    case 'desc':
      return builds.sort((a, b) => {
        return (new Date(b.get('updatedAt'))) - (new Date(a.get('updatedAt')))
      });
  }
}

function limitBuildEntities(builds, limit) {
  return builds.take(limit);
}

export default createSelector(
  selectBuildEntities,
  function(builds) {
    return {
      builds: limitBuildEntities(sortBuildEntities(builds, 'desc'), 10)
    };
  }
)
