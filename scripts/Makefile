site.js: site.coffee
	coffee -cp site.coffee > temp.js
	uglifyjs temp.js -c -m > site.js
