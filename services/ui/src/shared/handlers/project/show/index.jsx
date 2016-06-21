import React from 'react';
import Immutable from 'immutable';
import {connect} from 'react-redux';
import {createSelector} from 'reselect';
import {fetchProjectBySlug} from 'client/actions/projectActions';
import projectSelector from 'client/selectors/projectSelector';
import BuildList from 'client/components/common/BuildList';

class ProjectShowComponnet extends React.Component {
  static propTypes = {
    project: React.PropTypes.object.isRequired,
    dispatch: React.PropTypes.func.isRequired
  }

  static fetchData(dispatch, {params}) {
    return dispatch((dispatch, getState) => {
      return Promise.all([
        dispatch(fetchProjectBySlug(params.projectSlug))
      ]);
    });
  }

  componentDidMount() {
    ProjectShowComponnet.fetchData(this.props.dispatch, this.props);
  }

  render() {
    return (
      <div>
        <h1>Projects</h1>

        <section>
          <h1>{this.props.project.get('name')}</h1>
          <code>
            <pre>
              {JSON.stringify(this.props.project.toJS(), null, 2)}
            </pre>
          </code>
          <section>
            <h2>Recently Active Builds</h2>
            <code>BuildList here</code>
          </section>
        </section>
      </div>
    );
  }
}

const projectBySlugSelector = createSelector(
  (state, {params}) => {
    return state.entities.get('projects', Immutable.Map()).find(p => {
      return p.get('slug') === params.projectSlug;
    })
  },
  (project) => { return {project} }
);

export default connect(projectBySlugSelector)(ProjectShowComponnet);
