module.exports = function (grunt) {

	var pkg = require('./package.json');

	grunt.registerTask('default', ['clean', 'jshint', 'uglify']);
	grunt.registerTask('doc', ['jsdoc']);

	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-jsdoc');
	grunt.loadNpmTasks('grunt-contrib-uglify');

	grunt.initConfig({
		clean: {
			all: ['dist']
		},
		jshint: {
			all: ['Gruntfile.js', 'src/js/*.js']
		},
		jsdoc: {
			dist: {
				src: ['src/js/*.js'],
				options: {
					destination: 'doc'
				}
			}
		},
		uglify: {
			js: {
				files: [{
					expand: true,
					cwd: 'src/js',
					src: '**/*.js',
					dest: 'dist/js'
				}]
			}
		}
	});

};