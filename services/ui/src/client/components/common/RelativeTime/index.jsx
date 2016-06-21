import React from 'react';
import moment from 'moment';

export default class RelativeTimeComponent extends React.Component {
  static propTypes = {
    date: React.PropTypes.string.isRequired,
    className: React.PropTypes.string
  }

  componentDidMount() {
    this.refreshTimer = setInterval(this.forceUpdate.bind(this), 1000 * 10);
  }

  componentWillUnmount() {
    clearTimeout(this.refreshTimer);
  }

  shouldComponentUpdate(nextProps) {
    return this.props.date !== nextProps.date;
  }

  render() {
    return (
      <span className={this.props.className}>
        {moment(this.props.date).fromNow()}
      </span>
    );
  }
}
