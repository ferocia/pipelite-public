import React from 'react';
import Immutable from 'immutable';
import classNames from 'classnames';
import styles from './styles.css';

export default class SocketStatusInidcator extends React.Component {
  static propTypes = {
    className: React.PropTypes.string,
    socket: React.PropTypes.instanceOf(Immutable.Map).isRequired
  }

  shouldComponentUpdate(nextProps) {
    return !Immutable.is(this.props.socket, nextProps.socket)
  }

  render() {
    const className = classNames(styles.root, this.props.className, {
      [styles.isConnected]: this.props.socket.get('isConnected'),
      [styles.isDisConnected]: !this.props.socket.get('isConnected'),
      [styles.isConnecting]: this.props.socket.get('isConnecting')
    })

    return (
      <div className={className}>{this.renderStatus()}</div>
    )
  }

  renderStatus() {
    if (this.props.socket.get('isConnected')) {
      return 'connected';
    }
    if (this.props.socket.get('isConnecting')) {
      return 'connecting';
    }
    return 'disconnected';
  }
}
