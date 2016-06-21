import React from 'react';
import {createSelector} from 'reselect';
import Immutable from 'immutable';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import classNames from 'classnames';
import SocketStatusInidcator from 'client/components/common/SocketStatusInidcator';
import styles from './styles.css';

class HeaderComponent extends React.Component {
  static propTypes = {
    className: React.PropTypes.string,
    socket: React.PropTypes.instanceOf(Immutable.Map).isRequired
  }

  render() {
    return (
      <header className={classNames(styles.root, this.props.className)}>
        <Link className={styles.masthead} to="/">Pipelite</Link>
        <nav className={styles.nav}>
          <Link className={styles.navItem} to="/">
            Dashboard
          </Link>
          <Link className={styles.navItem} to="/projects">
            Projects
          </Link>
          <Link className={styles.navItem} to="/issues">
            Issues
          </Link>
        </nav>
        <SocketStatusInidcator className={styles.connectionStatus} socket={this.props.socket} />
      </header>
    );
  }
}

const stateSelector = (state) => state.socket
const connectionStatusSelector = createSelector(stateSelector, (socket) => ({socket}));
export default connect(connectionStatusSelector)(HeaderComponent)
