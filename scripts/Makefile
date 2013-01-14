all: site.js site.min.js

site.js: site.coffee
	coffee -cbp site.coffee > site.js

site.min.js: site.js markdown.js
	java -jar compiler.jar --js=markdown.js --js=site.js --js_output_file=site.min.js

