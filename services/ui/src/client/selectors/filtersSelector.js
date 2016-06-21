import {createSelector} from 'reselect';

const filtersSelector = (state) => state.filters;

export default createSelector(
  filtersSelector,
  (filters) => ({filters})
)
