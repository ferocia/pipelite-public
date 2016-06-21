import React from 'react'
import {Router, IndexRoute, Route} from 'react-router'
import AppComponent from 'shared/components/AppComponent';
import dashboard from 'shared/handlers/dashboard';
import project from 'shared/handlers/project';
import issue from 'shared/handlers/issue';
import history from './history';

// <Route component={build.show} path="/projects/:projectSlug/:buildId"/>

export default (
  <Router history={history}>
    <Route component={AppComponent}>
      <Route component={dashboard.show} path="/"/>
      <Route component={project.index} path="/projects"/>
      <Route component={project.show} path="/projects/:projectSlug"/>
      <Route component={issue.index} path="/issues"/>
      <Route component={issue.show} path="/issues/:issueId"/>
    </Route>
  </Router>
);
