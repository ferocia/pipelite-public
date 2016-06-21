import React from 'react';
import Immutable from 'immutable';
import {Link} from 'react-router';

export default class ProjectListComponent extends React.Component {
  static propTypes = {
    projects: React.PropTypes.instanceOf(Immutable.Map).isRequired
  }

  shouldComponentUpdate(nextProps) {
    return !Immutable.is(this.props.projects, nextProps.projects)
  }

  render() {
    return (
      <ol>
        {this.renderProjects()}
      </ol>
    );
  }

  renderProjects() {
    return this.props.projects ? (
      this.props.projects.map(this.renderProject).toArray()
    ) : null
  }

  renderProject(project, key) {
    return (
      <li key={key}>
        <Link to={`/projects/${project.get('slug')}`}>
          {project.get('name')}
        </Link>
      </li>
    );
  }
}
