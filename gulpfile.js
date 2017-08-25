'use strict';

const gulp = require('gulp');
const runSequence = require('run-sequence');
const browserify = require('browserify');
const babelify = require('babelify');
const vinyl_source_stream = require('vinyl-source-stream');
const rename = require('gulp-rename');
const fs = require('fs');

const source = ['./http_server/**/*.js'];
const gulpfile = ['./gulpfile.js'];
const all = [].concat(source).concat(gulpfile);


gulp.task('remove-files', () => {
  fs.unlink('./http_server/static/bundle.js',(error) =>{
    if(error && !error.code == 'ENOENT') {
      console.log(error);
    }
  });
});

gulp.task('build', () => {
  const entryFile = './http_server/MainView.jsx';
  const bundler = browserify(entryFile, {
    extensions: ['.js', '.jsx']
  });

  bundler.transform(babelify.configure({
    presets: ['es2015', 'react']
  }));

  const stream = bundler.bundle();
  stream.on('error', (error) => {
    console.error(error.message);
    console.error(error.codeFrame);
    process.exit(1);
  });

  stream
    .pipe(vinyl_source_stream(entryFile))
    .pipe(rename('bundle.js'))
    .pipe(gulp.dest('http_server/static/'));
});

gulp.task('default', () => {
  runSequence('test');
});
