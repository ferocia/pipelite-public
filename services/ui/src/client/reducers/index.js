import {combineReducers} from 'redux';

import buildsReducer from './buildsReducer';
import entitiesReducer from './entitiesReducer';
import filtersReducer from './filtersReducer';
import projectsReducer from './projectsReducer';
import socketReducer from './socketReducer';

export default combineReducers({
  builds: buildsReducer,
  entities: entitiesReducer,
  filters: filtersReducer,
  projects: projectsReducer,
  socket: socketReducer
});
