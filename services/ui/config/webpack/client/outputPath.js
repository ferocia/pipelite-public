import path from 'path';

export default function outputPath(rootPath) {
  return (process.env.STATIC_PATH || path.join(rootPath, 'static'));
}
