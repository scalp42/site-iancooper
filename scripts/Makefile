all: site.min.js

site.js: site.coffee
	coffee -cbp site.coffee > site.js

highlight-vgl.js: highlight-vgl.coffee
	coffee -cbp highlight-vgl.coffee > highlight-vgl.js

site.min.js: site.js markdown.js highlight-vgl.js
	uglifyjs vglbrush.js markdown.js site.js -c -m > site.min.js

