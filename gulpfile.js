var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var coffee = require('gulp-coffee');
var plumber = require('gulp-plumber');

var paths = {
  sass: ['./www/assets/scss/**/*.scss'],
  coffee: ['./www/**/*.coffee']
};

gulp.task('default', ['sass', 'coffee', 'watch']);

gulp.task('sass', function(done) {
  gulp.src('./www/assets/scss/ionic.app.scss')
    .pipe(plumber())
    .pipe(sass())
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./www/public/'))
    .on('end', done);
});

gulp.task('coffee', function(done) {
  gulp.src(paths.coffee)
    .pipe(plumber())
    .pipe(coffee())
    .pipe(concat('application.js'))
    .pipe(gulp.dest('./www/public/'))
    .on('end', done)
});

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.coffee, ['coffee']);
});