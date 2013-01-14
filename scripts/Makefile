all: site.js site.min.js

site.js: site.coffee
	coffee -cbp site.coffee > site.js

site.min.js: site.js markdown.js
	uglifyjs -c markdown.js site.js > site.min.js

