var gulp = require('gulp');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var coffee = require('gulp-coffee');
var plumber = require('gulp-plumber');
var uglify = require('gulp-uglify');
var ngAnnotate = require('gulp-ng-annotate');

var paths = {
  sass: ['./scss/**/*.scss'],
  coffee: ['./www/**/*.coffee']
};

gulp.task('default', ['sass', 'coffee', 'watch']);

gulp.task('sass', function(done) {
  gulp.src('./scss/ionic.app.scss')
    .pipe(plumber())
    .pipe(sass())
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename("style.css"))
    .pipe(gulp.dest('./www/css'))
    .on('end', done);
});

gulp.task('coffee', function(done) {
  gulp.src(paths.coffee)
    .pipe(plumber())
    .pipe(coffee())
    .pipe(ngAnnotate({
      remove: true,
      add: true,
      single_quotes: true
    }))
    .pipe(uglify())
    .pipe(concat('app.js'))
    .pipe(gulp.dest('./www/js'))
    .on('end', done)
});

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.coffee, ['coffee']);
});