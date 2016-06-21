import React from 'react';
import styles from './styles';

import HeaderComponent from 'client/components/common/HeaderComponent';

export default class AppComponent extends React.Component {
  static propTypes = {
    children: React.PropTypes.node,
    location: React.PropTypes.object
  }

  static childContextTypes = {
    location: React.PropTypes.object
  }

  getChildContext() {
    return {
      location: this.props.location
    }
  }

  render() {
    return (
      <div className={styles.root}>
        <HeaderComponent className={styles.header} />
        <main className={styles.main}>
          {this.props.children}
        </main>
        <footer className={styles.footer}>
          Pipelite — <code>{process.env.NODE_ENV}{(process.env.GITREF) ? `@${process.env.GITREF}` : ''}</code>
        </footer>
      </div>
    );
  }
}
