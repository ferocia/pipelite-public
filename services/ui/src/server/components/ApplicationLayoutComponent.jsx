import React from 'react';
import {readFileSync} from 'fs';
import path from 'path';

const manifestPath = path.join(process.env.STATIC_PATH, 'manifest.json');
const assetManifest = JSON.parse(readFileSync(manifestPath, 'utf8'));

function getJSEntrypoint(entrypoint) {
  if (process.env.NODE_ENV === 'production') {
    return assetManifest[entrypoint].js;
  }
  return `//docker.local:5001/static/${entrypoint}.js`;
}

function getCSSEntrypoint(entrypoint) {
  if (process.env.NODE_ENV === 'production') {
    return assetManifest[entrypoint].css;
  }
}

export default class ApplicationLayoutComponent extends React.Component {
  static propTypes = {
    initialState: React.PropTypes.object,
    html: React.PropTypes.node.isRequired
  }

  constructor(props) {
    super(props);

    const jsEntrypoint = getJSEntrypoint('client');
    const cssEntrypoint = getCSSEntrypoint('client');
    this.state = {
      jsEntrypoint,
      cssEntrypoint
    }
  }

  render() {
    return (
      <html lang="en">
        <head>
          <meta charSet="UTF-8" />
          <title>Pipelite</title>
          <meta content="width=device-width, initial-scale=1" name="viewport" />
          <meta
            content="Pipelite"
            data-backend-host={process.env.HOSTNAME}
            data-gitref={process.env.GITREF}
            data-stack={process.env.STACK}
            name="application-name"
          />
          <link href="https://fonts.googleapis.com/css?family=Work+Sans:400,300,600" rel="stylesheet" type="text/css"/>
          { this.renderClientStyles() }
          { this.renderInitialState() }
        </head>
        <body>
          <div dangerouslySetInnerHTML={{__html: this.props.html}} id="Application" />
          { this.renderClientEntrypointScript() }
        </body>
      </html>
    );
  }

  renderInitialState() {
    const stateString = `window.__INITIALSTATE__ = ${JSON.stringify(this.props.initialState)};`;
    return <script dangerouslySetInnerHTML={{__html: stateString}}/>;
  }

  renderClientEntrypointScript() {
    return <script src={this.state.jsEntrypoint} />
  }

  renderClientStyles() {
    return (process.env.NODE_ENV === 'production' ?
      <link href={this.state.cssEntrypoint} rel="stylesheet" />
    : null)
  }
}
