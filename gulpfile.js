// Include Gulp Plugins
var gulp = require('gulp'),
	concat = require('gulp-concat'),
	uglify = require('gulp-uglify'),
	less = require('gulp-less'),
	minify = require('gulp-minify-css'),
	plumber = require('gulp-plumber'),
	imagemin = require('gulp-imagemin'),
	rename = require('gulp-rename'),
	gutil = require('gulp-util'),
	coffee = require('gulp-coffee');

// -----------------------Build client src----------------------------
// Setup Directories Names
var sourceDir = 'src/client/',
	imgSourceDir = sourceDir + 'img/',
	jsSourceDir = sourceDir + 'coffee/',
	cssSourceDir = sourceDir + 'less/';

var releaseDir = 'release/client/',
	imgBuildDir = releaseDir + 'img/',
	jsBuildDir = releaseDir + 'js/',
	cssBuildDir = releaseDir + 'css/';

// Build JS
gulp.task( 'js', function(){
	gulp.src(jsSourceDir + '*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe( plumber() )
		.pipe( concat('todolist.js') )
		.pipe( rename({suffix:'.min'}) )
		.pipe( uglify() )
		.pipe( gulp.dest( jsBuildDir ) );
});

//Build CSS
gulp.task( 'css', function(){
	gulp.src(cssSourceDir + 'todos.less')
		.pipe(less({ showStack: true}).on('error', function (err) {console.log(err);}))
		.pipe( rename({suffix:'.min'}) )
		.pipe( minify() )
		.pipe( gulp.dest( cssBuildDir ) );

});

// Optimize Images
gulp.task( 'img', function(){
	gulp.src(imgSourceDir + '*')
		.pipe( plumber() )
		.pipe( imagemin() )
		.pipe( gulp.dest( imgBuildDir ) );
});

// -----------------------Build server src----------------------------
// Setup Directories Names
var sourceDir_server = 'src/server/',
	jsSourceDir_server = sourceDir_server;

var releaseDir_server = 'release/server/',
	jsBuildDir_server = releaseDir_server + 'js/';

// Build JS
gulp.task( 'js_server', function(){
	gulp.src(jsSourceDir_server + '*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe( gulp.dest( jsBuildDir_server ) );
});


// Should keep watch at end of array, havent do that for time reason
gulp.task( 'default', [ 'js', 'css', 'img', 'js_server'] );