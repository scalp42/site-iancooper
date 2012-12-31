var convertimg,find,load,markup,posts,routing,show,time_zones;posts=[],time_zones={"-1000":["HAST",!1],"-0900":["AKST","HADT"],"-0800":["PST","AKDT"],"-0700":["MST","PDT"],"-0600":["CST","MDT"],"-0500":["EST","CDT"],"-0400":["AST","EDT"],"-0330":["NST",!1],"-0300":[!1,"ADT"],"-0230":[!1,"NDT"]},moment.meridiem=function(t){return["a.m.","p.m."][Math.floor(t/12)]},convertimg=function(t){var e,n,o,r;return t=$(t),r=t.attr("src"),e=r.match(/\/w([0-9]+)-h([0-9]+)-/),null!=e?(console.dir(e),o=e[2]/e[1],console.log(o),n=$(document.createElement("div")),n.css({width:"100%",backgroundImage:"url("+r+")",backgroundSize:"cover",backgroundRepeat:"no-repeat",backgroundPosition:"50% 50%"}),t.replaceWith(n),$(window).resize(function(){return n.css("height",""+n.width()*o+"px")}),$(window).trigger("resize")):void 0},markup=function(t){var e;return null==(e=window.Converter)&&(window.Converter=new Markdown.Converter),window.Converter.makeHtml(t)},load=function(t,e,n){return null==e&&(e=!1),$.ajax({url:t,dataType:e?"json":"text",error:function(){return console.dir(arguments)},success:function(t){return n(t)}})},find=function(t){return _.find(posts,function(e){return e.slug===t})},show=function(t){var e,n,o,r,s;return t.html?(console.dir("using cached html for "+t.slug),n=$("#post"),n.empty(),o=t.moment.format("MMMM D, YYYY"),r=t.moment.format("h:mm a"),s=time_zones[t.moment.format("ZZ")][t.moment.isDST()?1:0],s||(s=t.moment.format("ZZ")),e=$(document.createElement("article")),e.append("<header><h1>"+t.title+"</h1><h2>"+o+" @ "+r+" "+s+"</h2></header>"),e.append("<section>"+t.html+"</section>"),$("section > h1",e).first().remove(),n.append(e),$('img[src$="#stretch-me"]',n).each(function(){return convertimg(this)})):(console.dir("loading posts/"+t.file),load("posts/"+t.file,!1,function(e){var n;return n=_.indexOf(posts,t),posts[n].html=markup(e),console.dir("markdown -> html saved in cache"),show(posts[n])}))},routing=function(t){var e;return e=new Davis(function(){var e,n,o,r,s;for(this.configure(function(t){return t.generateRequestOnPageLoad=!0,t.handleRouteNotFound=!0}),this.bind("routeNotFound",function(t){return t.redirect("/")}),r=t.routes,s=[],n=0,o=r.length;o>n;n++)e=r[n],s.push(this.get(e.pattern,t.fn[e.fn]));return s})},$(function(){return load("posts/index.json",!0,function(t){var e,n,o,r,s,a,i,u;for(posts=[],u=t.posts,s=0,i=u.length;i>s;s++)r=u[s],r.moment=moment(r.date,"YYYY-MM-DDTHH:mmZZ"),r.date=r.moment.format("D MMM YYYY"),r.dateValue=r.moment.valueOf(),r.html=null,posts.push(r);for(posts.sort(function(t,e){return e.dateValue-t.dateValue}),o=$("#posts").attr("data-max-recent"),n=posts.length>o?o:posts.length,e=a=0;n>=0?n>a:a>n;e=n>=0?++a:--a)"published"===posts[e].status?$("#posts").append('<li><a href="'+posts[e].slug+'">'+posts[e].title+' <span class="date">'+posts[e].date+"</span></a></li>"):e--;return routing({fn:{latest:function(t){var n,o,r;for(r=[],e=n=0,o=posts.length;o>=0?o>=n:n>=o;e=o>=0?++n:--n){if("published"===posts[e].status){t.redirect("/"+posts[0].slug);break}r.push(void 0)}return r},selected:function(t){return r=find(t.params.post),null!=r?show(r):t.redirect("/latest")}},routes:[{pattern:"/",fn:"latest"},{pattern:"/latest",fn:"latest"},{pattern:"latest",fn:"latest"},{pattern:"/:post",fn:"selected"},{pattern:":post",fn:"selected"}]})})});