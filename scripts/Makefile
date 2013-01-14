all: site.min.js

site.js: site.coffee
	coffee -cbp site.coffee > site.js

vglbrush.js: vglbrush.coffee
	coffee -cbp vglbrush.coffee > vglbrush.js

site.min.js: site.js markdown.js vglbrush.js
	uglifyjs vglbrush.js markdown.js site.js -c -m > site.min.js

