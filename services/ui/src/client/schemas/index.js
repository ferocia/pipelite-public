import {Schema, arrayOf} from 'normalizr';

const projectSchema = new Schema('projects');
const buildSchema = new Schema('builds');

projectSchema.define({
  builds: arrayOf(buildSchema)
});

buildSchema.define({
  project: projectSchema
});

export default {
  build: buildSchema,
  builds: arrayOf(buildSchema),
  project: projectSchema,
  projects: arrayOf(projectSchema)
};
