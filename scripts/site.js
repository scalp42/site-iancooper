var find,load,markup,posts,routing,show,time_zones;posts=[],time_zones={"-1000":["HAST",!1],"-0900":["AKST","HADT"],"-0800":["PST","AKDT"],"-0700":["MST","PDT"],"-0600":["CST","MDT"],"-0500":["EST","CDT"],"-0400":["AST","EDT"],"-0330":["NST",!1],"-0300":[!1,"ADT"],"-0230":[!1,"NDT"]},moment.meridiem=function(t){return["a.m.","p.m."][Math.floor(t/12)]},markup=function(t){var e;return null==(e=window.Converter)&&(window.Converter=new Markdown.Converter),window.Converter.makeHtml(t)},load=function(t,e,n){return null==e&&(e=!1),$.ajax({url:t,dataType:e?"json":"text",error:function(){return console.dir(arguments)},success:function(t){return n(t)}})},find=function(t){return _.find(posts,function(e){return e.slug===t})},show=function(t){var e,n,o,r;return t.html?(console.dir("using cached html for "+t.slug),t=$("#post"),t.empty(),n=t.moment.format("MMMM D, YYYY"),o=t.moment.format("h:mm a"),r=time_zones[t.moment.format("ZZ")][t.moment.isDST()?1:0],r||(r=t.moment.format("ZZ")),e=$(document.createElement("article")),e.append("<header><h1>"+t.title+"</h1><h2>"+n+" @ "+o+" "+r+"</h2></header>"),e.append("<section>"+t.html+"</section>"),$("section > h1",e).first().remove(),t.append(e),$('img[alt^="stretch"]',t).each(function(){return convertimg(this)})):(console.dir("loading posts/"+t.file),load("posts/"+t.file,!1,function(e){var n;return n=_.indexOf(posts,t),posts[n].html=markup(e),console.dir("markdown -> html saved in cache"),show(posts[n])}))},routing=function(t){var e;return e=new Davis(function(){var e,n,o,r,s;for(this.configure(function(t){return t.generateRequestOnPageLoad=!0,t.handleRouteNotFound=!0}),this.bind("routeNotFound",function(t){return t.redirect("/")}),r=t.routes,s=[],n=0,o=r.length;o>n;n++)e=r[n],s.push(this.get(e.pattern,t.fn[e.fn]));return s})},$(function(){return $("body").bind("DOMNodeInsertedIntoDocument",function(t){return console.dir(t)}),load("posts/index.json",!0,function(t){var e,n,o,r,s,a,u,i;for(posts=[],i=t.posts,s=0,u=i.length;u>s;s++)r=i[s],r.moment=moment(r.date,"YYYY-MM-DDTHH:mmZZ"),r.date=r.moment.format("D MMM YYYY"),r.dateValue=r.moment.valueOf(),r.html=null,posts.push(r);for(posts.sort(function(t,e){return e.dateValue-t.dateValue}),o=$("#posts").attr("data-max-recent"),n=posts.length>o?o:posts.length,e=a=0;n>=0?n>a:a>n;e=n>=0?++a:--a)$("#posts").append('<li><a href="'+posts[e].slug+'">'+posts[e].title+' <span class="date">'+posts[e].date+"</span></a></li>");return routing({fn:{latest:function(t){return t.redirect("/"+posts[0].slug)},selected:function(t){return r=find(t.params.post),null!=r?show(r):t.redirect("/latest")}},routes:[{pattern:"/",fn:"latest"},{pattern:"/latest",fn:"latest"},{pattern:"latest",fn:"latest"},{pattern:"/:post",fn:"selected"},{pattern:":post",fn:"selected"}]})})});