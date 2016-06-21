import React from 'react';
import Immutable from 'immutable';
import {Link} from 'react-router';
import path from 'path';
import classNames from 'classnames';
import RelativeTime from 'client/components/common/RelativeTime'
import styles from './styles';

export default class BuildListComponent extends React.Component {
  static propTypes = {
    builds: React.PropTypes.instanceOf(Immutable.Map).isRequired,
    projects: React.PropTypes.instanceOf(Immutable.Map).isRequired
  }

  shouldComponentUpdate(nextProps) {
    return (
      !Immutable.is(this.props.builds, nextProps.builds) ||
      !Immutable.is(this.props.projects, nextProps.projects)
    )
  }

  render() {
    return this.props.builds ? (
      <table className={styles.root}>
        {this.renderBuilds()}
      </table>
    ) : (
      <div>
        No Builds.
      </div>
    );
  }

  renderBuilds() {
    return (
      <tbody>
        {this.props.builds.map(this.renderBuild, this).toArray()}
      </tbody>
    );
  }

  renderBuildStatus(build) {
    const className = classNames(styles.buildStatus, {
      [styles.isPassed]: build.get('state') === 'passed',
      [styles.isFailed]: build.get('state') === 'failed',
      [styles.isRunning]: build.get('state') === 'running'
    });

    return (
      <strong className={className}>
        {build.get('state')}
      </strong>
    );
  }

  renderBuild(build, key) {
    const project = this.props.projects.get(build.get('project').toString());  // this should be an action, `loadProject(id)` or something.
    const buildPath = path.join('projects', project.get('slug'), 'build', build.get('id').toString());

    return (
      <tr className={styles.build} key={key}>
        <td className={styles.buildIdColumn}>
          <Link className={styles.buildId} to={buildPath}>
            <code>{build.get('id')}</code>
          </Link>
        </td>
        <td className={styles.avatarCol}>
          <img
            className={styles.avatar}
            src={build.getIn(['creator', 'avatarUrl'])}
            title={build.getIn(['creator', 'name'])}
          />
        </td>
        <td>
          <code>{build.get('branch')}<span className={styles.ref}>@{build.get('commitShort')}</span></code>
          <Link className={styles.project} to={path.join('projects', project.get('slug'))}>
            <code>{project.get('name')}</code>
          </Link>
        </td>
        <td>
          <RelativeTime className={styles.timeSince} date={build.get('updatedAt')} />
          <code className={styles.timestamp}>{build.get('updatedAt')}</code>
        </td>
        <td>
          {this.renderBuildStatus(build)}
        </td>
      </tr>
    );
  }
}
