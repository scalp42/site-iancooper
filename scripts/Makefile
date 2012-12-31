site.js: site.coffee
	coffee -cbp site.coffee > temp.js
	uglifyjs temp.js -c -m > site.js
