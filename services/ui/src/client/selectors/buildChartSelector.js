import moment from 'moment';
import {createSelector} from 'reselect';

function getStartDateForPeriod(period) {
  switch (period) {
    case '7days':
      return moment.utc().subtract(7, 'days');
    case '30days':
      return moment.utc().subtract(30, 'days');
    case '60days':
      return moment.utc().subtract(60, 'days');
  }
}

function selectBuildChartEntities(state) {
  return state.entities.get('buildChart');
}

function filtersSelector(state) {
  return state.filters.get('buildChart').filter(Boolean);
}

function buildChartFilter(filters, group) {
  const periodStart = getStartDateForPeriod(filters.get('period'));

  console.log(group.toJS())

  return filters.every((filterValue, key) => {
    switch (key) {
      case 'branch':
        return group.get('branch') === filterValue
      case 'period':
        return moment.utc(group.get('insertedAt')).isAfter(periodStart);
      case 'project':
        return group.get('projectId') === filterValue
    }
  })
}

const filteredBuilds = createSelector(
  filtersSelector,
  selectBuildChartEntities,
  function(filters, buildChart) {
    const filterFn = buildChartFilter.bind(this, filters);
    return buildChart.filter(filterFn).sortBy((_, k) => k);
  }
)

export default createSelector(
  filteredBuilds,
  function(buildChart) {
    return {buildChart};
  }
)
