import React from 'react';
import Immutable from 'immutable';
import {connect} from 'react-redux';
import {fetchProjects} from 'client/actions/projectActions';
import projectSelector from 'client/selectors/projectSelector';
import ProjectsList from 'client/components/common/ProjectList';

class ProjectIndexComponnet extends React.Component {
  static propTypes = {
    projects: React.PropTypes.instanceOf(Immutable.Map).isRequired,
    dispatch: React.PropTypes.func.isRequired
  }

  static fetchData(dispatch) {
    return dispatch((dispatch, getState) => {
      return Promise.all([dispatch(fetchProjects())]);
    });
  }

  componentDidMount() {
    ProjectIndexComponnet.fetchData(this.props.dispatch)
  }

  render() {
    return (
      <div>
        <h1>Projects</h1>
        <ProjectsList projects={this.props.projects} />
      </div>
    );
  }
}

export default connect(projectSelector)(ProjectIndexComponnet);
