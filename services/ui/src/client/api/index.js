import schemas from 'client/schemas';
import callApi from './callApi';

export function projects(options) {
  return callApi('/api/v1/projects', {
    ...options,
    schema: schemas.projects
  });
}

export function project(slug, options) {
  return callApi(`/api/v1/projects/${slug}`, {
    ...options,
    schema: schemas.project
  });
}

export function builds(options) {
  return callApi('/api/v1/builds', {
    ...options,
    schema: schemas.builds
  });
}

export function build(id, options) {
  return callApi(`/api/v1/builds/${id}`, {
    ...options,
    schema: schemas.build
  });
}

export function buildChart(options) {
  return callApi(`/api/v1/builds/chart`, {
    ...options,
    schema: schemas.build_chart
  });
}

export default {
  projects,
  project,
  builds,
  build,
  buildChart
};
