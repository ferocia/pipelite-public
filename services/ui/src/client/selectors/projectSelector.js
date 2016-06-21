import Immutable from 'immutable';
import {createSelector} from 'reselect';

function selectProjectEntities(state) {
  return state.entities.get('projects', Immutable.Map());
}

function selectProjectEntityBySlug(state, {params}) {
  return selectProjectEntities(state).find((p) => {
    return p.get('slug') === params.projectSlug;
  }, null, Immutable.Map());
}

function sortProjectEntities(order, projects) {
  switch (order) {
    case 'oldest':
      return projects.sort((a, b) => {
        return (new Date(a.get('updatedAt')) - new Date(b.get('updatedAt')))
      });
    case 'newest':
      return projects.sort((a, b) => {
        return (new Date(b.get('updatedAt'))) - (new Date(a.get('updatedAt')))
      });
  }
}

export default createSelector(
  selectProjectEntities,
  (projects) => {
    return {
      projects: sortProjectEntities('newest', projects)
    };
  }
);
