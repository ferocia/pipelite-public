import React from 'react';
import Immutable from 'immutable';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import {createSelector} from 'reselect';
import {fetchProjects} from 'client/actions/projectActions';
import {fetchBuilds} from 'client/actions/buildActions';
import projectSelector from 'client/selectors/projectSelector';
import buildSelector from 'client/selectors/buildSelector';
import BuildList from 'client/components/common/BuildList';

class DashboardComponent extends React.Component {
  static propTypes = {
    projects: React.PropTypes.object.isRequired,
    builds: React.PropTypes.object.isRequired,
    dispatch: React.PropTypes.func.isRequired
  }

  static fetchData(dispatch) {
    return dispatch((dispatch, getState) => {
      return Promise.all([
        dispatch(fetchProjects()),
        dispatch(fetchBuilds({limit: 10, sort: 'desc'}))
      ]);
    });
  }

  componentDidMount() {
    DashboardComponent.fetchData(this.props.dispatch)
  }

  render() {
    return (
      <div>
        <h1>Dashboard</h1>
        <section>
          <h1>Recently Active Builds</h1>
          <BuildList builds={this.props.builds} projects={this.props.projects} />
        </section>
      </div>
    );
  }
}

const dashboardSelector = createSelector(
  projectSelector, buildSelector,
  (projects, builds) => {
    return {...projects, ...builds}
  }
)

export default connect(dashboardSelector)(DashboardComponent)
